/*1. Add new books*/
/*To add a new book, the user enters the properties of the new book along 
with a threshold (the minimum quantity in stock to be maintained for that book).*/

delimiter $$
CREATE PROCEDURE Add_Book(ISBN int, Title varchar(45), Publication_Year int, Price int,
 Category set('Science','Art','Religion','History','Geography'), Threshold int, PUBLISHER_Name varchar(45), Copies int) /*Insert*/
BEGIN
	Insert into BOOK values (ISBN,Title, Publication_Year, Price, Category, Threshold, PUBLISHER_Name, Copies);
END$$
delimiter ;


/*****************************************************************************************/
/*2. Modify existing books*/
/*For updating an existing book, the user first searches for the book then he does the required update.
 For a given book, the user can update the quantity in stock when a copy or more of the book is sold. 
 The user cannot update the quantity of a book if this update will cause the quantity of a book in stock to be negative.*/
 
delimiter $$
CREATE PROCEDURE Modify_Book (ISBN int, Title varchar(45), Publication_Year int, Price int,
 Category set('Science','Art','Religion','History','Geography'), Threshold int, PUBLISHER_Name varchar(45), Copies int)  /*Update*/
BEGIN
    IF (Copies is null) THEN
		set Copies = 0; 
	END IF ;
    update BOOK as B
    set B.Title=COALESCE (Title, B.Title),
    B.Publication_Year=COALESCE (Publication_Year, B.Publication_Year),
    B.Price=COALESCE (Price, B.Price),
    B.Category=COALESCE (Category, B.Category),
    B.Threshold=COALESCE (Threshold, B.Threshold),
    B.PUBLISHER_Name=COALESCE (PUBLISHER_Name, B.PUBLISHER_Name),
    B.Copies=B.Copies + Copies   /*assume that Copies = the number of sold or bought books*/
	where B.ISBN=ISBN;

END$$
 delimiter ;
 
 /****************************************
 *******************************************/
 delimiter $$
CREATE PROCEDURE ADD_ORDER (BOOK_ISBN int, Quantity int)
BEGIN
	Insert into ORDERS values (BOOK_ISBN, Quantity);
END$$
delimiter ;

/*****************************************************************************************/
/*4. Confirm orders*/
/*The user can confirm an order when receiving the ordered quantity from the book’s publisher;
 the quantity of the book in store automatically increases with the quantity specified in the order.
 Assume that deleting the order means that the order is received from publisher.*/
 
 delimiter $$
CREATE PROCEDURE CONFIRM_ORDER (BOOK_ISBN int)
BEGIN
	declare CNT int;
	set CNT := (select Quantity
    from ORDERS as O
    where O.BOOK_ISBN = BOOK_ISBN);
	CALL Modify_Book(BOOK_ISBN,null,null,null,null,null,null,CNT);
END$$

delimiter ;

/********************************************************************************/
/********************************************************************************/
 delimiter $$
CREATE PROCEDURE DELETE_ORDER (BOOK_ISBN int)
BEGIN
	delete from ORDERS as O where O.BOOK_ISBN =BOOK_ISBN;
END$$
delimiter ;
/********************************************************************************/
/********************************************************************************/
/*5. Search for books*/
/*The user can search for a book by ISBN, and title.
 The user can search for books of a specific Category, author or publisher.*/
-- insert into book_authors values('NOUR',1);
-- insert into book_authors values('NOUR',2);
-- SELECT * FROM BOOK_AUTHORS;
-- SELECT * FROM USER_CART ;
-- CALL SEARCH_ON_BOOK (0 , NULL , 'Art', NULL , NULL);

delimiter $$
CREATE PROCEDURE SEARCH_ON_BOOK (ISBN int, Title varchar(45),
 Category set('Science','Art','Religion','History','Geography'), PUBLISHER_Name varchar(45),Authorname varchar(45))
BEGIN
	IF(ISBN = 0) THEN 
	SET ISBN = NULL;
	END IF ;
	select B.ISBN,B.Title,B.Publication_Year,B.Price,B.Category,B.PUBLISHER_Name,BA.Authorname
    from BOOK as B natural join BOOK_AUTHORS as BA
    WHERE (((ISBN is null) XOR find_in_set(B.ISBN , ISBN)) 
    AND  ((Title is null) XOR FIND_IN_SET( Title , B.Title )))
	OR ((Category is null) XOR FIND_IN_SET( Category , B.Category ) )
    OR  ((PUBLISHER_Name is null) XOR FIND_IN_SET( PUBLISHER_Name, B.PUBLISHER_Name ) )
	OR  ((Authorname is null) XOR FIND_IN_SET( Authorname , BA.Authorname ) );
END$$
delimiter ;

-- -----------------------------------------
 -- add item to the cart
 -- pass book id & coressponding user
 -- ------------------------------------------
delimiter $$
CREATE PROCEDURE ADD_ITEM (USER_ID INT, BOOK_ID INT,QUANTITY INT)
BEGIN
	INSERT INTO USER_CART VALUES (USER_ID , BOOK_ID , QUANTITY);
END$$
delimiter ;
 -- ------------------------------------------
 -- remove item from the cart
 -- pass book id & coressponding user
 -- ------------------------------------------

delimiter $$
CREATE PROCEDURE REMOVE_ITEM (USER_ID INT, BOOK_ID INT)
BEGIN
	delete from USER_CART as C where C.ISBN =BOOK_ID AND C.ID = USER_ID;
END$$

delimiter ;
 -- ------------------------------------------
 -- user log out
 -- pass user id
 -- ------------------------------------------

delimiter $$
CREATE PROCEDURE REMOVE_ALL_ITEMS (USER_ID INT)
BEGIN
	delete from USER_CART as C where C.ID = USER_ID;
END$$

delimiter ;

 -- ------------------------------------------
 -- show the cart
 -- pass user id
 -- ------------------------------------------
delimiter $$
CREATE PROCEDURE VIEW_ITEMS (USER_ID INT)
BEGIN
	SELECT *
    FROM BOOK  NATURAL JOIN USER_CART
    WHERE USER_CART.ID = USER_ID;
END$$

DELIMITER ;
CALL VIEW_ITEMS(1);
 -- ------------------------------------------
 -- show the books' prices
 -- pass user id
 -- ------------------------------------------

DELIMITER $$
CREATE PROCEDURE GET_PRICES (USER_ID INT)
BEGIN
	SELECT  Title, Price*QUANTITY
    FROM BOOK  NATURAL JOIN USER_CART
    WHERE USER_CART.ID = USER_ID;
END$$
delimiter ;

 -- ------------------------------------------
 -- show the total price
 -- pass user id
 -- ------------------------------------------
delimiter $$
CREATE PROCEDURE TOTAL_PRICE (USER_ID INT)
BEGIN
	SELECT  SUM(Price) AS TOTAL
    FROM BOOK  NATURAL JOIN USER_CART
    WHERE USER_CART.ID = USER_ID;
END$$
delimiter ;

-- ------------------------------------------
-- check out transaction
-- -------------------------------------------
DROP PROCEDURE CHECKOUT;
DELIMITER $$
CREATE PROCEDURE CHECKOUT(USER_ID INT)
BEGIN
	START TRANSACTION;
    -- temporary table to hold books info
	DROP TEMPORARY TABLE IF EXISTS TEMP;
	CREATE TEMPORARY TABLE TEMP 
	SELECT ISBN , QUANTITY, Copies - QUANTITY AS N
    
    -- remove quantities from Books
	FROM USER_CART NATURAL JOIN BOOK
	WHERE ID = USER_ID;
	SELECT * FROM TEMP;
	UPDATE BOOK NATURAL JOIN TEMP
	SET BOOK.Copies = TEMP.N
	WHERE BOOK.ISBN > -1;
    
    -- add to sold books
    INSERT INTO SALED_BOOKS (BOOK_ISBN, customer_id)
    SELECT ISBN, ID FROM USER_CART WHERE ID = USER_ID;
    
    -- make the cart empty
	CALL REMOVE_ALL_ITEMS(USER_ID);
	COMMIT;
END$$
DELIMITER ;


/*
View the following reports on sales
a. The total sales for books in the previous month
*/

delimiter $$
CREATE PROCEDURE sales_for_month () 
BEGIN
	select BOOK_ISBN, Title, Price, count(SALED_BOOKS.BOOK_ISBN) as Copies from  bookstore.SALED_BOOKS join  bookstore.BOOK on  BOOK_ISBN =  ISBN
    where YEAR( sale_date) = YEAR(CURRENT_DATE)
	AND MONTH(sale_date) = MONTH(CURRENT_DATE - INTERVAL 1 MONTH)
	group by BOOK_ISBN;
END$$
delimiter ;
/************************************************************/
/*
b. The top 5 customers who purchase the most purchase amount in descending order
for the last three months
*/

delimiter $$
CREATE PROCEDURE topCustomers() 
BEGIN
	select FIRST_NAME, LAST_NAME, sum(Price) as total_price from  (SALED_BOOKS join USERS on  customer_id =  ID)
    join BOOK on BOOK_ISBN = ISBN
    where sale_date >= DATE_ADD(current_date, interval -3 MONTH)
	group by customer_id
    order by total_price desc limit 5; 
END$$
delimiter ;
/***************************************************************/
 
/*
c. The top 10 selling books for the last three months
*/
delimiter $$
CREATE PROCEDURE topBooks() 
BEGIN
	select BOOK_ISBN, Title, count(saled_books.BOOK_ISBN) as Sales_copies from  bookstore.saled_books join  bookstore.book on  BOOK_ISBN =  ISBN
    where sale_date >= DATE_ADD(current_date, interval -3 MONTH)
	group by BOOK_ISBN
    order by Sales_copies desc limit 10; 
END$$
delimiter ;
/***************************************************************/
 

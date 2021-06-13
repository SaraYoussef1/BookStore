-- MySQL Workbench Forward Engineering
-- -----------------------------------------------------
-- Schema bookstore
-- ------------------------------bookbook_authors-----------------------

-- ------------------------PUBLISHER-----------------------------
-- Schema bookstore
-- -----------------------------------------------------
Drop schema if exists bookstore;
CREATE SCHEMA IF NOT EXISTS bookstore ;/*DEFAULT CHARACTER SET utf8 ;*/
USE bookstore ;


-- -----------------------------------------------------
-- log in tables

-- -----------------------------------------------------
-- Table `bookstore`.`USERS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS bookstore.USERS (
   ID INT NOT NULL,
   FIRST_NAME VARCHAR(10) NOT NULL,
   LAST_NAME VARCHAR(10) NOT NULL,
   EMAIL_ADDRESS VARCHAR(20) NOT NULL,
   PHONE VARCHAR(15),
   SHIPPING_ADDRESS VARCHAR(50) NOT NULL,
   USERNAME VARCHAR(10) NOT NULL,
   PASSWRD VARCHAR(20) NOT NULL,
  PRIMARY KEY (ID))
ENGINE = InnoDB;

-- Table `bookstore`.`MANAGER`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS bookstore.MANAGERS (
   ID INT NOT NULL,
   FIRST_NAME VARCHAR(10) NOT NULL,
   LAST_NAME VARCHAR(10) NOT NULL,
   EMAIL_ADDRESS VARCHAR(20) NOT NULL,
   PHONE varchar(11) NOT NULL,
   SHIPPING_ADDRESS VARCHAR(50) NOT NULL,
   USERNAME VARCHAR(10) NOT NULL,
   PASSWRD VARCHAR(20) NOT NULL,
   PRIMARY KEY (ID))
ENGINE = InnoDB;

INSERT INTO MANAGERS VALUES (3,'ahmed','shehata','ahmed@gmail.com','01203405925','35_sabaBasha_street','ahmed','ah');
SELECT * FROM MANAGERS;
-- -------------------------------------------------------
-- -----------------------------------------------------
-- Table `bookstore`.`PUBLISHER`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS bookstore.PUBLISHER (
   Name_Publisher VARCHAR(45) NOT NULL,
   Address VARCHAR(45) NULL,
   Phone VARCHAR(45) NOT NULL,
  PRIMARY KEY (Name_Publisher))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bookstore`.`BOOK`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS bookstore.BOOK (
   ISBN INT NOT NULL,
   Title VARCHAR(45) NOT NULL,
   Publication_Year INT NOT NULL,
   Price INT NOT NULL,
   Category SET('Science', 'Art', 'Religion', 'History', 'Geography') NOT NULL,
   Threshold INT NOT NULL,
   PUBLISHER_Name  VARCHAR(45) NOT NULL,
   Copies INT NOT NULL,
  PRIMARY KEY (ISBN),
  INDEX fk_BOOK_PUBLISHER1_idx (PUBLISHER_Name ASC) VISIBLE,
  CONSTRAINT fk_BOOK_PUBLISHER1
    FOREIGN KEY (PUBLISHER_Name)
    REFERENCES bookstore.PUBLISHER (Name_Publisher)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bookstore`.`BOOK_AUTHORS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS bookstore.BOOK_AUTHORS (
  Authorname VARCHAR(45) NOT NULL,
  ISBN INT NOT NULL,
  PRIMARY KEY (Authorname, ISBN),
  INDEX fk_BOOK_AUTHORS_BOOK_idx (ISBN ASC) VISIBLE,
  CONSTRAINT fk_BOOK_AUTHORS_BOOK
    FOREIGN KEY (ISBN)
    REFERENCES bookstore.BOOK (ISBN)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `bookstore`.`ORDERS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS bookstore.ORDERS (
   BOOK_ISBN INT NOT NULL,
   Quantity INT NOT NULL,
  INDEX  fk_ORDERS_BOOK1_idx (BOOK_ISBN ASC) VISIBLE,
  PRIMARY KEY (BOOK_ISBN),
  CONSTRAINT fk_ORDERS_BOOK1
    FOREIGN KEY (BOOK_ISBN)
    REFERENCES bookstore.BOOK (ISBN)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;



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
 /********************************************************************/
 


/*****************************************************************************************/

DELIMITER $$
CREATE trigger NEGATIVE_BEFORE_UPDATE
	BEFORE UPDATE 
	ON BOOK FOR EACH ROW
BEGIN
     IF (NEW.Copies < 0) THEN
		signal sqlstate '45000' set message_text = 'The quantity of a book in stock can\'t be negative!'; 
     END IF ;
   
END$$ ;

DELIMITER ;

/*****************************************************************************************/


/*3. Place orders on books*/
/*An order with constant quantity is placed only when the quantity of a book drops from 
above a given threshold (the minimum quantity in stock) to below the given threshold*/

DELIMITER $$
CREATE trigger ORDER_AFTER_UPDATE
	AFTER UPDATE 
	ON BOOK FOR EACH ROW
BEGIN
     IF (NEW.Copies < NEW.Threshold) THEN
		signal sqlstate '01000' set message_text = 'WARRNING! Minimum quantity in stock to below the given threshold!, Please order sufficient quantity'; 
     END IF ;
   
END$$ ;

DELIMITER ;



delimiter $$
CREATE PROCEDURE Add_Order (BOOK_ISBN int, Quantity int)
BEGIN

	Insert into orders values (BOOK_ISBN, Quantity);

END$$

delimiter ;

/*****************************************************************************************/


/*4. Confirm orders*/
/*The user can confirm an order when receiving the ordered quantity from the book’s publisher;
 the quantity of the book in store automatically increases with the quantity specified in the order.
 Assume that deleting the order means that the order is received from publisher.*/
 
 
 delimiter $$
CREATE PROCEDURE Confirm_Order (BOOK_ISBN int)
BEGIN
	declare CNT int;
	set CNT := (select Quantity
    from orders as O
    where O.BOOK_ISBN = BOOK_ISBN);
	CALL Modify_Book(BOOK_ISBN,null,null,null,null,null,null,CNT);
END$$

delimiter ;

/*****************************************************************************************/


/*****************************************************************************************/

DELIMITER $$
CREATE trigger BEFORE_DELETE_ORDER
	BEFORE DELETE 
	ON ORDERS FOR EACH ROW
BEGIN
     declare Re_Copies int;
     declare Re_Threshold int;
	 select Copies, Threshold INTO Re_Copies, Re_Threshold
     from BOOK
     where ISBN = OLD.BOOK_ISBN;
     
     IF (Re_Copies < Re_Threshold) THEN
		signal sqlstate '45000' set message_text = 'Can\'t delete the order before Confirming it!'; 
     END IF ;
   
END$$ ;

DELIMITER ;

/*****************************************************************************************/

 delimiter $$
CREATE PROCEDURE Delete_Order (BOOK_ISBN int)
BEGIN
	delete from orders as O where O.BOOK_ISBN =BOOK_ISBN;
END$$

delimiter ;


/*5. Search for books*/
/*The user can search for a book by ISBN, and title.
 The user can search for books of a specific Category, author or publisher.*/
 
delimiter $$
CREATE PROCEDURE Search_On_Book (ISBN int, Title varchar(45),
 Category set('Science','Art','Religion','History','Geography'), PUBLISHER_Name varchar(45),Authorname varchar(45))
BEGIN
	select *
    from Book as B natural join book_authors as BA
    WHERE (((ISBN is null) XOR find_in_set(B.ISBN , ISBN )) 
    AND  ((Title is null) XOR FIND_IN_SET( Title , B.Title )))
	OR ((Category is null) XOR FIND_IN_SET( Category , B.Category ) )
    OR  ((PUBLISHER_Name is null) XOR FIND_IN_SET( PUBLISHER_Name , B.PUBLISHER_Name ) )
	OR  ((Authorname is null) XOR FIND_IN_SET( Authorname , BA.Authorname ) );
    
END$$

delimiter ;


-- ----------------------------------------
-- Shopping cart
-- ----------------------------------------

CREATE TABLE IF NOT EXISTS bookstore.USER_CART(
ID INT NOT NULL,
ISBN INT NOT NULL,
QUANTITY INT NOT NULL,
PRIMARY KEY (ID, ISBN),
FOREIGN KEY (ISBN) REFERENCES bookstore.BOOK(ISBN) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (ID) REFERENCES bookstore.USERS(ID) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ------------------------------------------
-- essential insertions
-- -----------------------------------------

-- ---publisher
INSERT INTO `bookstore`.`PUBLISHER` (`Name_Publisher`, `Address`, `Phone`) VALUES ('NOUR', '35Abust', '012345');
-- ---book
INSERT INTO `bookstore`.`BOOK` (`ISBN`, `Title`, `Publication_Year`, `Price`, `Category`, `Threshold`, `PUBLISHER_Name`, `Copies`) VALUES ('1', 'AnimalFarm', '1960', '20', 'Art', '5', 'NOUR', '7');
INSERT INTO `bookstore`.`BOOK` (`ISBN`, `Title`, `Publication_Year`, `Price`, `Category`, `Threshold`, `PUBLISHER_Name`, `Copies`) VALUES ('2', 'SECRETCRIME', '1980', '98', 'Art', '5', 'NOUR', '9');
-- ---user
INSERT INTO `bookstore`.`USERS` (`ID`, `FIRST_NAME`, `LAST_NAME`, `EMAIL_ADDRESS`, `PHONE`, `SHIPPING_ADDRESS`, `USERNAME`, `PASSWRD`) VALUES ('1', 'Enas', 'Morsy', 'asdf', '0123', 'dslkjf', 'Enmo2sh', '123');
-- ---cart
INSERT INTO `bookstore`.`USER_CART` (`ID`, `ISBN`, `QUANTITY`) VALUES ('1', '1','2');
INSERT INTO `bookstore`.`USER_CART` (`ID`, `ISBN`,`QUANTITY`) VALUES ('1', '2', '75');


 -- ------------------------------------------
 -- add item to the cart
 -- pass book id & coressponding user
 -- ------------------------------------------

delimiter $$
CREATE PROCEDURE ADD_ITEM (USER_ID INT, BOOK_ID INT)
BEGIN
	INSERT INTO USER_CART VALUES (USER_ID, BOOK_ID);
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

delimiter ;

 -- ------------------------------------------
 -- show the books' prices
 -- pass user id
 -- ------------------------------------------

delimiter $$
CREATE PROCEDURE GET_PRICES (USER_ID INT)
BEGIN
	SELECT  Title, Price
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
	SELECT  SUM(Price)
    FROM BOOK  NATURAL JOIN USER_CART
    WHERE USER_CART.ID = USER_ID;
END$$
delimiter ;
 
-- -------------------------------
-- TRANSACTION
-- --------------------------------

DELIMITER $$
CREATE trigger INSERT_INTO_CART
BEFORE INSERT 
ON USER_CART FOR EACH ROW
BEGIN
     IF (NEW.QUANTITY > ALL(SELECT Copies FROM BOOK WHERE (ISBN = NEW.ISBN))) THEN
		signal sqlstate '45000' set message_text = 'ERROR! required quantity is greater than currently available'; 
     END IF ;
END$$ ;

DELIMITER ;

delimiter $$
CREATE PROCEDURE CHECKOUT(USER_ID INT)
BEGIN
START TRANSACTION;
 
SELECT * FROM BOOK;   
COMMIT;
END$$
delimiter ;
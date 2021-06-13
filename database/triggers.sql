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

/********************************************************************************************/
/*********************************************************************************************/

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
Drop schema if exists bookstore;
CREATE SCHEMA IF NOT EXISTS bookstore ;/*DEFAULT CHARACTER SET utf8 ;*/
USE bookstore ;
-- -----------------------------------------------------
-- Table `bookstore`.`USERS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS USERS (
   ID INT NOT NULL,
   FIRST_NAME VARCHAR(10) NOT NULL,
   LAST_NAME VARCHAR(10) NOT NULL,
   EMAIL_ADDRESS VARCHAR(20) NOT NULL,
   PHONE VARCHAR(15),
   SHIPPING_ADDRESS VARCHAR(50) NOT NULL,
   USERNAME VARCHAR(10) NOT NULL,
   PASSWRD VARCHAR(20) NOT NULL,
   IS_MANAGER BOOL DEFAULT FALSE,
  PRIMARY KEY (ID))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `bookstore`.`PUBLISHER`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS PUBLISHER (
   Name_Publisher VARCHAR(45) NOT NULL,
   Address VARCHAR(45) NULL,
   Phone VARCHAR(45) NOT NULL,
  PRIMARY KEY (Name_Publisher))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `bookstore`.`BOOK`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS BOOK (
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
CREATE TABLE IF NOT EXISTS BOOK_AUTHORS (
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
CREATE TABLE IF NOT EXISTS ORDERS (
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

-- -----------------------------------------------------
-- Table `bookstore`.`SALED_BOOKS`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS SALED_BOOKS (
   BOOK_ISBN INT NOT NULL,
   customer_id INT NOT NULL,
   sale_date TIMESTAMP DEFAULT current_timestamp,
  INDEX  fk_ORDERS_BOOK1_idx (BOOK_ISBN ASC) VISIBLE,
  PRIMARY KEY (BOOK_ISBN, customer_id),
  CONSTRAINT fk_user_BOOK1 FOREIGN KEY (BOOK_ISBN) REFERENCES bookstore.BOOK (ISBN) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT fk_book_users FOREIGN KEY ( customer_id) REFERENCES bookstore.USERS (ID) ON DELETE NO ACTION ON UPDATE NO ACTION
);

-- ----------------------------------------
-- -- Table `bookstore`.`USER_CART`
-- ----------------------------------------

CREATE TABLE IF NOT EXISTS USER_CART(
	ID INT NOT NULL,
	ISBN INT NOT NULL,
	QUANTITY INT NOT NULL,
	PRIMARY KEY (ID, ISBN),
	FOREIGN KEY (ISBN) REFERENCES bookstore.BOOK(ISBN) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (ID) REFERENCES bookstore.USERS(ID) ON DELETE CASCADE ON UPDATE CASCADE
);
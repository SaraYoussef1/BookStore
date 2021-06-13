
INSERT INTO USERS VALUES (2,'ahmed','shehata','ahmed@gmail.com','01203405925','35_sabaBasha_street','ahmed','ah',TRUE);
SELECT * FROM USERS;
INSERT INTO USERS VALUES (3,'afnan','mousaa','ahmed@gmail.com','01203405925','35_sabaBasha_street','afnan','am',FALSE);
SELECT * FROM BOOK;
SELECT ID,IS_MANAGER FROM USERS WHERE USERNAME = 'afnan' AND PASSWRD = 'am';
CALL VIEW_ITEMS('2');
SELECT * FROM SALED_BOOKS;

CALL ADD_ITEM(5, 1, 1);
CALL ADD_ITEM(5, 2, 1);
CALL VIEW_ITEMS(5);
SELECT * FROM  SALED_BOOKS;
CALL CHECKOUT(5);


select *
from BOOK;
call sales_for_month;
call topCustomers;

-- ------------------------------------------------------------------------------------------------------------------
-- EMPLOYEE TABLE
-- ------------------------------------------------------------------------------------------------------------------
CREATE TABLE EMPLOYEE_R (
 EMPID VARCHAR(10) PRIMARY KEY NOT NULL,
 FIRSTNAME VARCHAR(25) NOT NULL,
 MINIT CHAR NULL,
 LASTNAME VARCHAR(25) NOT NULL,
 BIRTHDATE DATE NOT NULL,
 SEX CHAR NOT NULL,
 SALARY NUMERIC(5) NOT NULL,
 SSN NUMERIC(9) UNIQUE NOT NULL,
 JOBTYPE VARCHAR(15) NOT NULL)
 ;
 describe EMPLOYEE_R;
 
INSERT INTO EMPLOYEE_R VALUES('000001','John','N','Smith','1965-09-01','M',4500,123456789,'Chef');
INSERT INTO EMPLOYEE_R VALUES('000002','Franklin','T','Wong','1955-12-08','M',4000,333445555,'Waiter');
INSERT INTO EMPLOYEE_R VALUES('000003','Alicia','J','Zelaya','1968-01-19','F',2500,999887777,'Cleaning Staff');
INSERT INTO EMPLOYEE_R VALUES('000004','Jennifer','S','Wallace','1941-06-20','F',4300,987654321,'Waiter');
INSERT INTO EMPLOYEE_R VALUES('000005','Ramesh','K','Narayan','1962-09-15','M',3800,666884444,'Waiter');
INSERT INTO EMPLOYEE_R VALUES('000006','Joyce','A','English','1972-07-31','F',2500,453453453,'Cleaning Staff');
INSERT INTO EMPLOYEE_R VALUES('000007','Ahmad','V','Jabbar','1969-03-29','M',2500,987987987,'Cleaning Staff');
INSERT INTO EMPLOYEE_R VALUES('000008','James','E','Borg','1937-11-10','M',5500,888665555,'Manager');

-- ------------------------------------------------------------------------------------------------------------------
-- STUDENT TABLE
-- ------------------------------------------------------------------------------------------------------------------
CREATE TABLE STUDENT (
 S_ID VARCHAR(10) PRIMARY KEY NOT NULL,
 S_NAME VARCHAR(25) NOT NULL,
 S_AGE NUMERIC(2) NULL);
 
 
-- ------------------------------------------------------------------------------------------------------------------
-- MENU TABLE
-- ------------------------------------------------------------------------------------------------------------------

CREATE TABLE MENU_R (
 MENU_ITEM_ID NUMERIC(10) PRIMARY KEY  NOT NULL,
 MENU_ITEM_NAME VARCHAR(25) NOT NULL,
 PRICE DECIMAL(4,2) NOT NULL,
 MENU_ITEM_CATEGORY VARCHAR(25) NOT NULL)
 ;
 
 ALTER TABLE MENU_R
 ADD CONSTRAINT Unique_Menu_item UNIQUE (MENU_ITEM_NAME,PRICE);
 
 describe MENU_R;
 
INSERT INTO MENU_R VALUES(1,'Veg. Masala Puff',3.49,'Puff');
INSERT INTO MENU_R VALUES(2,'Paneer Puff',4.99,'Puff');
INSERT INTO MENU_R VALUES(3,'Ratlami Sev Puff',4.99,'Puff');
INSERT INTO MENU_R VALUES(4,'Veg. Mayonnaise Puff',4.99,'Puff');
INSERT INTO MENU_R VALUES(5,'Veg. Cheese Puff',4.99,'Puff');
INSERT INTO MENU_R VALUES(6,'Jalapeno Peppers',5.99,'Snack');
INSERT INTO MENU_R VALUES(7,'Mozzarella Sticks',5.99,'Snack');
INSERT INTO MENU_R VALUES(8,'French Fries',6.99,'Snack');
INSERT INTO MENU_R VALUES(9,'Vada Pav',8.99,'Snack');
INSERT INTO MENU_R VALUES(10,'Veggie Burger',9.99,'Snack');

select * from menu_r;
-- ------------------------------------------------------------------------------------------------------------------
-- ORDER TABLE
-- ------------------------------------------------------------------------------------------------------------------

CREATE TABLE ORDER_R (
 ORDER_ID NUMERIC(5) NOT NULL,
 CUST_ID NUMERIC(6) NOT NULL,
 MENU_ITEM_ID NUMERIC(10) NOT NULL,
 QUANTITY NUMERIC(2) DEFAULT 1,
 PRIMARY KEY(ORDER_ID, MENU_ITEM_ID))
 ;
 
 ALTER TABLE ORDER_R
 ADD FOREIGN KEY (MENU_ITEM_ID) REFERENCES MENU_R(MENU_ITEM_ID),
 ADD FOREIGN KEY (CUST_ID) REFERENCES CUSTOMER_R(CUST_ID);
 
 
 -- TO CHECK THE VALID QUANTITY
-- CREATE TRIGGER check_trigger
--  BEFORE INSERT
 -- ON ORDER_R
 -- FOR EACH ROW
-- BEGIN
--  IF NEW.QUANTITY>0 AND NEW.QUANTITY <= 2 THEN
--    CALL 'Error: Wrong values for QUANTITY';
--  END
-- END;

 DROP TABLE ORDER_R;

 
 INSERT INTO ORDER_R VALUES(1,000001,1,2);
 INSERT INTO ORDER_R VALUES(2,000002,5,2);
 INSERT INTO ORDER_R VALUES(2,000002,16,1);
 INSERT INTO ORDER_R VALUES(3,000003,1,2);
 INSERT INTO ORDER_R VALUES(3,000003,17,3);
 
 INSERT INTO ORDER_R VALUES(1,000004,1,2);
 -- THE ABOVE STATEMENT DOESNT WORK AS WE ALREADY INSERTED ORDER_ID 1 IN ORDER_R TABLE.
 
 INSERT INTO ORDER_R VALUES(4,143456,1,2);
 -- THE ABOVE STATEMENT DOESNT WORK AS IT VIOLATES REFERENTIAL INTEGRITY CONSTRAINT WITH CUSTOMERS TABLE.
 
 
 
 -- ------------------------------------------------------------------------------------------------------------------
 -- FEEDBACK TABLE - THIS IS A WEAK ENTITY(HAVING A STRONG RELATIONSHIP WITH THE CUSTOMERS TABLE)
 -- ------------------------------------------------------------------------------------------------------------------
 CREATE TABLE FEEDBACK_R (
 CUST_ID NUMERIC(6) UNIQUE NOT NULL,
 CUST_FEEDBACK VARCHAR(80),
 RATING ENUM('1','2','3','4','5') DEFAULT 5,
 PHONE NUMERIC(10)
 );
 
 -- REMOVING THE PHONE COLUMN AS IT IS REDUNDANT AND CAN DIRECTLY BE FOUND FROM THE CUSTOMERS TABLE.
 ALTER TABLE FEEDBACK_R
 DROP COLUMN PHONE;
 
 ALTER TABLE FEEDBACK_R
 ADD FOREIGN KEY (CUST_ID) REFERENCES CUSTOMER_R(CUST_ID);
 
 INSERT INTO FEEDBACK_R VALUES(000001,'Nice Food',5);
 INSERT INTO FEEDBACK_R VALUES(000002,'Ambience is good',4);
 INSERT INTO FEEDBACK_R VALUES(000003,'The food is not so good',3);
 
 SELECT * FROM FEEDBACK_R;
 -- ------------------------------------------------------------------------------------------------------------------
 -- SERVES TABLE
 -- ------------------------------------------------------------------------------------------------------------------
 
 CREATE TABLE SERVES_R(
 EMP_ID VARCHAR(10) NOT NULL,
 CUST_ID NUMERIC(6) NOT NULL,
 JOBTYPE VARCHAR(15) NOT NULL,
 CONSTRAINT Serving UNIQUE(EMP_ID,CUST_ID,JOBTYPE),
 FOREIGN KEY (EMP_ID) REFERENCES EMPLOYEE_R(EMP_ID),
 FOREIGN KEY (CUST_ID) REFERENCES EMPLOYEE_R(CUST_ID)
 );
 
 -- ------------------------------------------------------------------------------------------------------------------
 -- PAYMENTS TABLE
 -- ------------------------------------------------------------------------------------------------------------------
 
 CREATE TABLE PAYMENTS_R (
 PAYMENT_ID NUMERIC(3) PRIMARY KEY NOT NULL,
 CUST_ID NUMERIC(6) NOT NULL,
 ORDER_ID NUMERIC(5) NOT NULL,
 PAY_TYPE ENUM('offline','online') DEFAULT 'offline',
 TOTAL_AMOUNT DECIMAL(5,2) NOT NULL DEFAULT 0
 );

ALTER TABLE PAYMENTS_R
ADD FOREIGN KEY (CUST_ID) REFERENCES CUSTOMER_R(CUST_ID),
ADD FOREIGN KEY (ORDER_ID) REFERENCES ORDER_R(ORDER_ID);

-- DROP TABLE PAYMENTS_R;

INSERT INTO PAYMENTS_R values(001,000002,2,'online',0);
INSERT INTO PAYMENTS_R values(002,000003,1,'online',0);
INSERT INTO PAYMENTS_R values(003,000001,3,'offline',0);

-- THE BELOW QUERY DOESNT WORK, BECAUSE THERE IS NO 
-- CUSTOMER 123456 IN THE DATABASE. SO WE WONT HAVE A 
-- CORRESPONDING RECORD IN THE ORDER_R TABLE. 

-- HENCE, THE TRIGGER FOR THIS INSERT STATEMENT DOESNT WORK AND WILL
-- GIVE AN ERROR OF NULL VALUE FOR TOTAL_AMOUNT AS IT 
-- DOESNT HAVE ANY VALUE.
INSERT INTO PAYMENTS_R VALUES(004,123456,4,'online',0);

select E.JOBTYPE, avg(salary) as avgs
from EMPLOYEE_R E
group by E.JOBTYPE
HAVING avgs > 4000;


-- DROP TRIGGER Calc_Total_Amount;
describe order_r;
describe menu_r;

CREATE TRIGGER Calc_Total_Amount 
BEFORE INSERT ON PAYMENTS_R
FOR EACH ROW
  SET NEW.TOTAL_AMOUNT = 
  (
	SELECT SUM(amt) from 
		(SELECT M.PRICE * O.QUANTITY as amt
		FROM ORDER_R O JOIN MENU_R M ON (O.MENU_ITEM_ID = M.MENU_ITEM_ID)
		WHERE ORDER_ID = NEW.ORDER_ID)TBL 
        LIMIT 1
  );
 
  select * from payments_r;
 -- ------------------------------------------------------------------------------------------------------------------
 -- CUSTOMER TABLE
 -- ------------------------------------------------------------------------------------------------------------------
 
 CREATE TABLE CUSTOMER_R (
 CUST_ID NUMERIC(6) PRIMARY KEY NOT NULL,
 ORDER_ID NUMERIC(5) NOT NULL,
 PHONE NUMERIC(10),
 EMAIL VARCHAR(35))
 ;
 

 select * from customer_r;
 INSERT INTO CUSTOMER_R VALUES(000001,1,1234567890,'CSGDRHTFJYU@GMAIL.COM');
 INSERT INTO CUSTOMER_R VALUES(000002,2,9876543234,'oijhgfdee@GMAIL.COM');
 INSERT INTO CUSTOMER_R VALUES(000003,3,0987654321,'KUYUFTDWEFFW@GMAIL.COM');
 INSERT INTO CUSTOMER_R VALUES(000004,4,4567809123,'VCFRTYUJSDF@GMAIL.COM');
 INSERT INTO CUSTOMER_R VALUES(000005,5,1234567890,'OIUYFDWERTHJ@GMAIL.COM');
 INSERT INTO CUSTOMER_R VALUES(000006,6,4352617890,'XSDERTYHJNB@GMAIL.COM');
 INSERT INTO CUSTOMER_R VALUES(000007,7,8765439201,'KIUYTDSWERFG@GMAIL.COM');
 INSERT INTO CUSTOMER_R VALUES(000008,8,5367813214,'OIJHBVCDSWERGH@GMAIL.COM');
 INSERT INTO CUSTOMER_R VALUES(000009,9,1234567891,'CFGHYU@GMAIL.COM');
 INSERT INTO CUSTOMER_R VALUES(000010,11,1234567430,'OIUHGFDSERTYH@GMAIL.COM');
 
select concat(E.firstname,' ', E.minit,' ', E.Lastname),E.jobtype
from Employee_R E 
where Jobtype = (select Jobtype 
				from Employee_R E 
				Where salary = (select max(salary) 
								from Employee_R E
                                where jobtype not in ('Manager')));



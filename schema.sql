CREATE DATABASE CENTRAL;
SHOW DATABASES;
USE CENTRAL;

CREATE TABLE REGION
(
   REGION_ID INT(4) NOT NULL,
   REGION_NAME VARCHAR(20) NOT NULL,
   REGIONAL_MANAGER_ID INT(4),
   PRIMARY KEY (REGION_ID),
   INDEX(REGIONAL_MANAGER_ID)
)ENGINE=InnoDB;


CREATE TABLE DEPARTMENT
(
    DEPT_ID INT(4) NOT NULL,
    DEPARTMENT_NAME VARCHAR(20) NOT NULL,
    REG_ID INT(4) NOT NULL,
    primary key(DEPT_ID,REG_ID),
	CONSTRAINT FK_REG_ID FOREIGN KEY(REG_ID) REFERENCES Region (REGION_ID) 
    ON UPDATE CASCADE
)ENGINE=InnoDB;

CREATE TABLE JOB
(
	JOB_ID INT(4) NOT NULL,
	JOB_TITLE VARCHAR(30) UNIQUE,
	MIN_SAL DOUBLE,
	MAX_SAL DOUBLE,
	GRADE VARCHAR(20) UNIQUE,
    PRIMARY KEY (JOB_ID)
)ENGINE=InnoDB;

CREATE TABLE EMPLOYEE
(
	EMP_ID INT(4) NOT NULL, 
	FIRST_NAME VARCHAR(30) NOT NULL,
	LAST_NAME VARCHAR(20) NOT NULL,
	EMAIL VARCHAR(30) UNIQUE,
	PHONE_NO INT (10) UNIQUE,
	START_DATE DATE NOT NULL,
	EMP_DEPT_ID INT(4) NOT NULL,
	EMP_JOB_ID INT(4) NOT NULL,
    EMP_REG_ID int(4) NOT null,
	SALARY DOUBLE,
	IS_MANAGER BOOLEAN NOT NULL DEFAULT FALSE,
	ACTIVE_IND BOOLEAN NOT NULL DEFAULT TRUE, 
    LAST_MODIFIED_DATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(EMP_ID),
    INDEX(EMP_DEPT_ID),
    CONSTRAINT FK_JOB_ID FOREIGN KEY (EMP_JOB_ID) REFERENCES JOB (JOB_ID)
	ON UPDATE CASCADE,
    CONSTRAINT FK_DEPT_ID FOREIGN KEY (EMP_DEPT_ID) REFERENCES DEPARTMENT (DEPT_ID)
	ON UPDATE CASCADE,
    constraint FK_EMP_REG_ID foreign key(EMP_REG_ID) references Region (REGION_ID) 
    on update cascade
)ENGINE=InnoDB;

/*to be executed after employee table creation*/
alter table region add constraint FK_MGR_ID_REGION foreign key(REGIONAL_MANAGER_ID) references employee(emp_id) on update cascade;


CREATE TABLE JOB_HISTORY 
(
	EMPLOYEE_ID INT(4) NOT NULL,
	START_DATE DATE NOT NULL,
	END_DATE DATE,
	DEPTARTMENT_ID INT(4) NOT NULL,
	EMPLOYEE_JOB_ID INT(4) NOT NULL,
    REG_ID INT(4) NOT NULL,
	PREV_SALARY DOUBLE,
    CURR_SALARY DOUBLE NOT NULL,
    LAST_MODIFIED_DATE TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (EMPLOYEE_ID, START_DATE),
    CONSTRAINT FK_JOBHIST_DEPT_ID FOREIGN KEY (DEPTARTMENT_ID) REFERENCES DEPARTMENT (DEPT_ID)
	ON UPDATE CASCADE,
    CONSTRAINT FK_JOBHIST_JOB_ID FOREIGN KEY (EMPLOYEE_JOB_ID) REFERENCES JOB (JOB_ID)    
	ON UPDATE CASCADE,
	CONSTRAINT FK_JOBHIST_REG_ID FOREIGN KEY (REG_ID) REFERENCES REGION (REGION_ID)    
	ON UPDATE CASCADE
)ENGINE=InnoDB;


CREATE TABLE CUSTOMER 
(
  CUST_ID INT(4) NOT NULL,
  FIRST_NAME VARCHAR(30) NOT NULL,
  LAST_NAME VARCHAR(20) NOT NULL,
  EMAIL VARCHAR(30) UNIQUE,
  ADDRESS VARCHAR(50) UNIQUE,
  CITY VARCHAR(20),
  PRIMARY KEY (CUST_ID)
)ENGINE=InnoDB;


CREATE TABLE SALES
(
  SALES_ID INT(4) NOT NULL,
  CUSTOMER_ID INT(4) NOT NULL,
  DEPARTMENT_ID INT(4) NOT NULL,
  REG_ID INT(4) NOT NULL,
  BILL_AMOUNT DOUBLE NOT NULL DEFAULT 0.00,
  BILL_DATE varchar(10) NOT NULL,
  CUST_SATISFIED BOOLEAN NOT NULL DEFAULT FALSE,
  MODIFIED_DATE TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (SALES_ID),
  INDEX(CUSTOMER_ID),
  INDEX(DEPARTMENT_ID),
  INDEX(REG_ID),
  CONSTRAINT FK_SALES_CUST_ID FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMER (CUST_ID)
  ON UPDATE CASCADE,
  CONSTRAINT FK_SALES_DEPT_ID FOREIGN KEY (DEPARTMENT_ID) REFERENCES DEPARTMENT (DEPT_ID)
  ON UPDATE CASCADE,
  CONSTRAINT FK_SALES_REG_ID FOREIGN KEY (REG_ID) REFERENCES REGION (REGION_ID)
  ON UPDATE CASCADE
)ENGINE=InnoDB;

create table customer_discount(
    SALES_ID int(4) not null,
    BILL_DATE varchar(10) not null,
    BILL_AMOUNT double not null,
	DISCOUNT double NOT NULL DEFAULT 0.00,
	PAID DOUBLE NOT NULL DEFAULT 0.00,
	MODIFIED_DATE TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    primary key(sales_id, bill_date),
	CONSTRAINT FK_SALES_ID FOREIGN KEY (SALES_ID) REFERENCES SALES (SALES_ID)
	ON UPDATE CASCADE
)ENGINE=InnoDB;



/*Please run the triggers.sql file before inserting the data because there are triggers that runs for before insert event condition*/
/*Refer data.sql file for the insert SQL statements with sample data*/
/* INSERT STATEMENTS --------------------------------------------------*/



/*
INSERT INTO REGION VALUES(1002, 'Galway', NULL);
INSERT INTO REGION VALUES(1001, 'Dublin', NULL); 
INSERT INTO REGION VALUES(1003, 'Limerick', NULL);


insert into department values(2000, 'Ops&Administration',1001);
insert into department values(2001, 'Retail',1001);
insert into department values(2002, 'Apparels',1001);
insert into department values(2003, 'Electronics',1001);
insert into department values(2001, 'Retail',1002);
insert into department values(2002, 'Apparels',1002);
insert into department values(2003, 'Electronics',1002);
insert into department values(2001, 'Retail',1003);
insert into department values(2002, 'Apparels',1003);
insert into department values(2003, 'Electronics',1003);


insert into job values(3004,'SALES_STAFF',20000.00,30000.00,'GRADE_4');
insert into job values(3003,'MANAGER',50000.00,60000.00,'GRADE_3');
insert into job values(3001,'CEO',80000.00,100000.00,'GRADE_1');
insert into job values(3002,'CFO',80000.00,90000.00,'GRADE_2');
insert into job values(3005,'SECURTY',10000.00,15000.00,'GRADE_5');


insert into employee values(4000,'Tiara','Quinonez','tiara@gmail.com','0899111536','2018-01-01',2000,3001,1001,89200.82,false,TRUE,NOW());
insert into employee values(4001,'Crysta','Bush','crysta@gmail.com','0899098456','2018-01-02',2000,3002,1001,81200.32,false,True,NOW());

insert into employee values(4004,'Chris','Kennely','chris@gmail.com','0899122123','2018-01-21',2000,3003,1001,54200.82,TRUE,TRUE,NOW());
insert into employee values(4002,'Kate','Meade','kate@gmail.com','0899102103','2018-01-04',2000,3003,1002,56500.32,TRUE,True,NOW());
insert into employee values(4003,'Robert','Shril','robert@gmail.com','0899562193','2018-01-04',2000,3003,1003,58000.32,TRUE,True,NOW());

insert into employee values(4005,'Kina','Loya','kina@gmail.com','0899111888','2018-02-15',2002,3004,1001,24500.62,False,True,NOW());
insert into employee values(4006,'Andy','Tomczak','andy@gmail.com','0899102153','2018-03-04',2003,3004,1001,25100.32,False,True,NOW());
insert into employee values(4007,'Veta','Maher','veta@gmail.com','0899102112','2018-03-04',2001,3004,1001,28000.32,False,True,NOW());

insert into employee values(4008,'Pandora','Schauer','pandora@gmail.com','0899756432','2018-01-21',2001,3004,1002,24200.82,False,TRUE,NOW());
insert into employee values(4009,'Elois','Chivers','elois@gmail.com','0898760988','2018-02-04',2002,3004,1002,27200.12,False,True,NOW());
insert into employee values(4010,'Nicki','Wainwright','nicki@gmail.com','0899543711','2018-01-04',2003,3004,1002,27200.12,False,True,NOW());
insert into employee values(4011,'Janey','Witts','janey@gmail.com','0899100989','2018-04-22',2002,3004,1002,28200.00,False,True,NOW());

insert into employee values(4012,'Keith','Hambly','keith@gmail.com','0898222947','2018-01-04',2001,3004,1003,26200.32,False,True,NOW());
insert into employee values(4013,'Karri','Pesqueira','karri@gmail.com','0899697212','2018-10-21',2002,3004,1003,25380.00,False,TRUE,NOW());
insert into employee values(4014,'Tanja','Hiltner','tanja@gmail.com','0899843781','2018-02-04',2003,3004,1003,27200.32,False,True,NOW());
insert into employee values(4015,'Elouise','Brendel','elouise@gmail.com','0899098296','2018-02-04',2003,3004,1003,27200.32,False,True,NOW());
insert into employee values(4017,'Shreyas','Thakur','shreyas@gmail.com','0898356112','2018-06-26',2001,3004,1002,23540.06,False,TRUE, NOW());
insert into employee values(4016,'Pavan','Suresh','pavan@gmail.com','0899912767','2018-02-04',2001,3004,1001,24200.82,False,TRUE,NOW());

insert into employee values(4018,'Burl','Youngberg','burl@gmail.com','0898456213','2018-01-04',2001,3005,1001,12000.32,false,True,NOW());
insert into employee values(4019,'Thuy','Sandefur','thuy@gmail.com','0898435767','2018-01-14',2002,3005,1002,14000.32,false,True,NOW());
insert into employee values(4020,'Marchelle','Sizemore','marchelle@gmail.com','0898444876','2018-01-07',2003,3005,1003,13000.32,false,True,NOW());


update employee set active_ind = false where emp_id = 4017;
update employee set emp_job_id=3004 where emp_id=4020 and start_date = '2018-01-07';

update employee set salary = 22980.00 where emp_id = 4020 and start_date= '2018-01-07';
insert into employee values(4021,'Lewis','Rugg','lewis@gmail.com','0899777222','2018-12-14',2003,3005,1003,12540.06,False,TRUE, NOW());


insert into customer values(5001, 'James','Serragh','james@gmail.com','10, castletroy','Limerick');
insert into customer values(5002, 'Sarah','Marc','sarah@gmail.com','36, raheen','Limerick');
insert into customer values(5003, 'Sagar','Kumar','sagar@gmail.com','24, Greenhills','Dublin');
insert into customer values(5004, 'Henry','Pit','henry@gmail.com','21, Bruree','Limerick');
insert into customer values(5005, 'Sebastian','Corg','seb@gmail.com','16, Athenry','Galway');
insert into customer values(5006, 'Karen','Kumar','karen@gmail.com','22, Artane','Dublin');
insert into customer values(5007, 'Sean','Deassy','sean@gmail.com','17, balcartie','Dublin');
insert into customer values(5008, 'Maggie','Klin','maggie@gmail.com','78,  Adare','Limerick');
insert into customer values(5009, 'Alisha','Farakh','alisha@gmail.com','34  Citywest','Dublin');
insert into customer values(5010, 'Tom','Sand','tom@gmail.com','9, finglas','Dublin');
insert into customer values(5011, 'Samar','Hallet','samar@gmail.com','74, Ballymoe ','Galway');
insert into customer values(5012, 'Peter','Tregg','peter@gmail.com','14, Newcastle','Dublin');
insert into customer values(5013, 'Sandra','Harris','sandra@gmail.com','6, cleggan ','Galway');
insert into customer values(5014, 'Vibha','Vyas','vibha@gmail.com','12, Bishops town ','Cork');
insert into customer values(5015, 'Aishwarya','Inamdar','aish@gmail.com','44, derry city ','Londonderry');



insert into sales values(6001,5001,2001,1003,445.45,'2018-01-15',true,now());
insert into sales values(6002,5002,2002,1003,222.11,'2018-01-15',true,now());
insert into sales values(6003,5003,2003,1001,845.51,'2018-01-16',true,now());
insert into sales values(6004,5004,2001,1003,12.29,'2018-02-13',false,now());
insert into sales values(6005,5005,2002,1002,45.76,'2018-03-11',false,now());
insert into sales values(6006,5006,2003,1001,622.28,'2018-04-18',true,now());
insert into sales values(6007,5007,2003,1001,178.53,'2018-01-15',false,now());
insert into sales values(6008,5008,2002,1003,892.11,'2018-01-01',true,now());
insert into sales values(6009,5009,2002,1001,905.65,'2018-01-08',true,now());
insert into sales values(6010,5010,2001,1001,612.22,'2018-01-15',true,now());
insert into sales values(6011,5011,2001,1002,945.25,'2018-01-16',true,now());
insert into sales values(6012,5012,2003,1001,82.42,'2018-01-22',false,now());
insert into sales values(6013,5013,2001,1002,15.15,'2018-01-25',false,now());
insert into sales values(6014,5002,2003,1003,242.62,'2018-01-30',true,now());
insert into sales values(6015,5009,2002,1001,945.25,'2018-01-12',true,now());
insert into sales values(6016,5003,2001,1001,60.92,'2018-01-13',true,now());
insert into sales values(6017,5008,2001,1003,492.55,'2018-01-19',true,now());
insert into sales values(6018,5010,2003,1001,92.82,'2018-01-21',true,now());
insert into sales values(6019,5011,2002,1002,445.15,'2018-01-27',true,now());
insert into sales values(6020,5008,2002,1003,342.19,'2018-01-04',true,now());
insert into sales values(6021,5009,2003,1001,1245.45,'2018-01-09',true,now());
insert into sales values(6022,5006,2001,1001,189.02,'2018-01-18',true,now());
insert into sales values(6023,5005,2001,1002,252.16,'2018-01-25',true,now());
insert into sales values(6024,5001,2002,1003,812.14,'2018-01-28',true,now());
insert into sales values(6025,5009,2003,1001,792.12,'2018-01-28',true,now());
insert into sales values(6026,5014,2002,1003,1012.14,'2018-12-28',true,now());
insert into sales values(6027,5015,2003,1001,901.12,'2018-12-27',true,now());
insert into sales values(6028,5011,2002,1002,95.15,'2018-02-21',true,now());
insert into sales values(6029,5009,2003,1001,35.15,'2018-02-21',true,now());
insert into sales values(6030,5011,2002,1002,95.15,'2018-02-21',true,now()); */
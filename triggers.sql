/* creating a trigger to set the manager for a department   */
delimiter //
CREATE TRIGGER AssignManagerToRegion
AFTER INSERT ON Employee
FOR EACH ROW BEGIN
  IF NEW.IS_MANAGER = TRUE THEN
    UPDATE REGION SET REGION.REGIONAL_MANAGER_ID=NEW.EMP_ID where REGION.REGION_ID = NEW.EMP_REG_ID;
  END IF;
END;//

/* creating a trigger to insert values to job history table as and when employee is inserted to emp table  */
delimiter //
CREATE TRIGGER InsertToJobHistory
BEFORE INSERT ON Employee
FOR EACH ROW BEGIN
  insert into job_history values(new.emp_id, new.start_date, null, new.emp_dept_id, new.emp_job_id, new.emp_reg_id, null, new.salary,now());
END;//

/*function to return old salary*/
delimiter //
CREATE FUNCTION getSal(id int(4)) 
RETURNS double
BEGIN
	declare sal double;
	SELECT salary INTO sal from employee where emp_id = id ;
	return sal;
END; //


/*function to extract latest start date*/
delimiter //
CREATE FUNCTION getLatestStartDate(id int(4)) 
RETURNS date
BEGIN
	declare latest_start_date date;
	SELECT MAX(start_date) INTO latest_start_date FROM job_history where employee_id = id;
	return latest_start_date;
END; //


/*to update employee details job history table*/
delimiter //
CREATE TRIGGER UpdateJobHistory
BEFORE UPDATE ON Employee
FOR EACH ROW BEGIN
	if new.ACTIVE_IND is true and new.salary <> old.salary then
		update job_history set prev_salary = getSal(new.emp_id), curr_salary = new.salary, last_modified_date=now() where employee_id=new.emp_id and start_date = getLatestStartDate(new.emp_id);
	END IF;
    if new.ACTIVE_IND is FALSE then
		update job_history set end_date = CURDATE(), last_modified_date=now() where employee_id=new.emp_id and start_date = new.start_date;
    END IF;
    if new.ACTIVE_IND is true and new.EMP_JOB_ID <> old.EMP_JOB_ID then
		update job_history set end_date = CURDATE(), last_modified_date=now() where employee_id=old.emp_id and start_date = new.start_date and employee_job_id = old.emp_job_id;
		insert into job_history values(new.emp_id, curdate(), null, new.emp_dept_id, new.emp_job_id, new.emp_reg_id, getSal(new.emp_id), new.salary,now());
	END IF;
END; //


/*stored procedure to calculate discount for customer based on the total bill value*/
DELIMITER //
CREATE PROCEDURE calculateDiscount(IN bill double, OUT discount double) 
BEGIN
	set discount = 0.00;
	IF (bill > 300.00 and bill <= 800.00) THEN 
		set discount = (5/100)*(bill);
	ELSEIF (bill > 800.00 and bill <= 1500.00) THEN 
		set discount = (10/100)*(bill);
	ELSEIF (bill > 1500.00) THEN 
		set discount = (20/100)*(bill);
	END IF;
END; //

/*to calculate discount using the above procedure and inserts data to customer_discount table*/
delimiter //
CREATE TRIGGER customerDiscount
AFTER INSERT ON Sales
FOR EACH ROW BEGIN
	declare discount double;
    call calculateDiscount(new.bill_amount, discount);
    insert into customer_discount values(new.sales_id, new.bill_date, new.bill_amount, discount, (new.bill_amount - discount), now());
END;//
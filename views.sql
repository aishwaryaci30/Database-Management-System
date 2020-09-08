/*view 1 : Determine which region is doing better w.r.t sales*/
Create view sales_view as SELECT region_name, cast(sum(sales.bill_amount) as decimal(10,2)) as 'Total_Sales' from region join sales on region.REGION_ID = sales.REG_ID group by sales.REG_ID having sum(sales.bill_amount)>= 10.00 order by sum(sales.bill_amount) DESC;
/*Query the topmost region*/
select region_name from sales_view order by Total_Sales desc limit 1;

/*view 2: Determine which region is doing better w.r.t service*/
create view service_view as SELECT region_name ,count(sales.CUST_SATISFIED) as 'Best_Service' from region join sales on region.REGION_ID = sales.REG_ID where sales.CUST_SATISFIED = 1 group by sales.REG_ID having count(sales.cust_satisfied) >= 2 order by count(sales.cust_satisfied) DESC;
/*Query the topmost region*/
select region_name from service_View order by Best_Service desc limit 1;

/*view 3: finding prime customers grouped by region*/
create view Frequently_Visited_Customers as (select sales.reg_id, customer.cust_id, first_name, count(sales.customer_id) as 'Times_Visited', cast(sum(sales.bill_amount) as decimal(10,2)) as 'Purchases' from customer join sales on customer.cust_id = sales.customer_id where bill_date between '2018-01-01' and '2018-12-31' group by sales.customer_id order by count(sales.customer_id) DESC);
/*now use the above view to group by region to find prime customers*/
 SELECT r.region_name, fvc.reg_id, fvc.cust_id, fvc.first_name, fvc.times_visited FROM frequently_visited_customers fvc join (SELECT MAX(f2.times_visited) As Highest,f2.reg_id FROM frequently_visited_customers f2 
 GROUP BY f2.reg_id) tv ON fvc.reg_id = tv.reg_id && fvc.times_visited = tv.Highest INNER JOIN region r on fvc.reg_id = r.region_id;



/*More queries for business usecases*/

/*1. the query mentioned below gives details of the customers and their native city and the store region from where they have made the purchase*/
select DISTINCT cust_id, FIRST_NAME, LAST_NAME, city from customer 
join sales on customer.CUST_ID=sales.CUSTOMER_ID where customer.city not in 
(SELECT DISTINCT region_name from Region);

/*2.list of employees who have received a hike*/
SELECT emp_id, first_name, last_name from employee where ACTIVE_IND=1 and EMP_ID in (select employee_id from job_history 
where job_history.PREV_SALARY < job_history.CURR_SALARY and start_date >= 2018-01-01);

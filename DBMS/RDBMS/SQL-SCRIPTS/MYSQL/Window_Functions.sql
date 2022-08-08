/* Resources :
https://youtu.be/Ww71knvhQ-s
https://youtu.be/zAmJPdZu8Rg
*/
show databases;
use classicmodels;
show tables;

select * from customers;
select * from employees;
select * from offices;
select * from orderdetails;
select * from orders;
select * from payments;
select * from productlines;
select * from products;

-- Number/Count of Tables in a Table_Schema:
SELECT count(*)
   FROM INFORMATION_SCHEMA.TABLES
   WHERE TABLE_SCHEMA = 'classicmodels';
   
-- Table name , count of rows in each table in a table schema:
SELECT table_name, table_rows
   FROM INFORMATION_SCHEMA.TABLES
   WHERE TABLE_SCHEMA = 'classicmodels';

select * from products;

create table productlinemsrp as
select sum(msrp) as MSRP_SUM, productline from products group by productline;

drop table productlinemsrp;

/*
   Window Functions --> aggregation_functions over(partition by) / over(order by), row number(), rank(), first_value() 
   more you can find at 
   https://www.mysqltutorial.org/mysql-window-functions/
   https://www.javatpoint.com/mysql-window-functions 
*/

/*

Types of Window Function
We can categorize the window functions mainly in three types that are given below:

Aggregate Functions
It is a function that operates on multiple rows and produces the result in a single row. Some of the important aggregate functions are:

COUNT, SUM, AVG, MIN, MAX, and many more.

Ranking Functions
It is a function that allows us to rank each row of a partition in a given table. Some of the important ranking functions are:

RANK, DENSE_RANK, PERCENT_RANK, ROW_NUMBER, CUME_DIST, etc.

Analytical Functions
It is a function, which is locally represented by a power series. Some of the important analytical functions are:

NTILE, LEAD, LAG, NTH, FIRST_VALUE, LAST_VALUE, etc.

*/

/* some more window functions in MYSQL :-

	-CUME_DIST		: Calculates the cumulative distribution of a value in a set of values - VALUES RANGES BETWEEN 0 TO 1 . Formula is CURRENT_ROW_NUMBER / TOTAL_NUMBER_OF_ROWS , if any duplicates are there last row among all those duplicate rows is considered for calculation and same value is represented for all duplicate rows
	-DENSE_RANK		: Assigns a rank to every row within its partition based on the ORDER BY clause. It assigns the same rank to the rows with equal values. If two or more rows have the same rank, then there will be no gaps in the sequence of ranked values.
	-FIRST_VALUE	: Returns the value of the specified expression with respect to the first row in the window frame.
	-LAG			: Returns the value of the Nth row before the current row in a partition. It returns NULL if no preceding row exists.
	-LAST_VALUE		: Returns the value of the specified expression with respect to the last row in the window frame.
	-LEAD			: Returns the value of the Nth row after the current row in a partition. It returns NULL if no subsequent row exists.
	-NTH_VALUE		: Returns value of argument from Nth row of the window frame, incase if it is not present then prints return null value.
	-NTILE			: Distributes the rows for each window partition into a specified number of ranked groups. used for segreating or splitting the data according to levels or categories/buckets/groups.
	-PERCENT_RANK	: Calculates the percentile rank of a row in a partition or result set - VALUES RANGES BETWEEN 0 TO 1. Formula is (row_number-1)/(total_rows-1), we can use this to find how much percentage a product more expensive than others.
	-RANK			: here rank will be skipped if two or more rows have same values where as in DENSE_RANK() function the rank values are not skipped - except that there are gaps in the sequence of ranked values when two or more rows have the same rank.
	-ROW_NUMBER		: Assigns a sequential integer to every row within its partition

*/

-- Aggregate function wrt window functions
select p.productline, p.*, sum(p.msrp) over (partition by p.productline) as Total_MSRP from products p;

-- Rank function wrt window functions
select row_number() over (partition by Productline) as Row_Num,productname, Productline, msrp from products;
select * from (select row_number() over (partition by Productline) as Row_Num,productname, Productline, msrp from products) as x where x.Row_Num < 3;

select productname, productline, 

ROW_NUMBER() OVER (order by quantityinstock desc) as Row_num, 
RANK() over (order by quantityinstock desc) as Rank_High_Quantiy,
DENSE_RANK() OVER (order by quantityinstock desc) as DENSE_Rank_High_Quantiy,
PERCENT_RANK() OVER (order by quantityinstock desc) as PERCENT_Rank_High_Quantiy,
CUME_DIST() OVER (order by quantityinstock desc) as CUMMULATIVE_DISTANCE,

quantityinstock  from products order by Rank_High_Quantiy asc;

select x1.* from (select productname, productline, rank() over (partition by productline order by quantityinstock desc) as Rank_High_Quantiy, quantityinstock  from products order by Rank_High_Quantiy asc) as x1 where x1.Rank_High_Quantiy <3;


select * from customers;

-- Analytical Functions wrt window functions

SELECT productname, productline, msrp,
	row_number() over w as Row_ID,
	First_Value(productname) over w as Highest_MSRP_Product_Name_WRT_Department,
    Last_Value(productname) over w as Least_MSRP_Product_Name_WRT_Department,
    nth_value(productname, 2) over w as Second_Highest_MSRP_Product_Name_WRT_Department
FROM products
window w as (partition by productline order by MSRP desc RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING);

select *, first_value(customerName) over(order by creditlimit DESC) as Highest_credit_limit_holder from customers;
-- in last_value instead of RANGE we can also put ROWS but difference is if we put current row in place of unbounded following and here incase of duplicate values same value will be printed for ROWS and last value among duplicates is printed if we use range.
/* 
UNBOUNDED PRECEDING -> first row
UNBOUNDED FOLLOWING -> last rows
we can also keep numerical values instead of above two to define row numbers
*/
select *, last_value(customerName) over(  order by creditlimit desc RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) as lowest_credit_limit_holder from customers;
select customername, country, creditlimit from customers group by country having creditlimit = min(creditlimit);

select customername,country,creditlimit, 
lag(creditlimit) over(partition by country order by creditlimit DESC) as previous_row_LAG_credit_limit_holder,
lag(creditlimit, 2, 0) over(partition by country order by creditlimit DESC) as previous_row_LAG_With_Step_credit_limit_holder,
lead(creditlimit) over(partition by country order by creditlimit DESC) as Next_row_LEAD_credit_limit_holder,
lead(creditlimit, 2, 0) over(partition by country order by creditlimit DESC) as Next_row_LEAD_With_Step_credit_limit_holder
 from customers;

-- Alternate way to write above query in case of using same over functions all windows functions
select customername,country,creditlimit, 
lag(creditlimit) over w as previous_row_LAG_credit_limit_holder,
lag(creditlimit, 2, 0) over w as previous_row_LAG_With_Step_credit_limit_holder,
lead(creditlimit) over w as Next_row_LEAD_credit_limit_holder,
lead(creditlimit, 2, 0) over w as  Next_row_LEAD_With_Step_credit_limit_holder
 from customers 
 window w as (partition by country order by creditlimit DESC) ;

select customername,country,creditlimit, 
lag(creditlimit) over(partition by country order by creditlimit DESC) as previous_row_LAG_credit_limit_holder,
CASE 
	WHEN c.creditlimit > lag(creditlimit) over(partition by country) THEN 'Higher than Previous Customer'
    WHEN c.creditlimit < lag(creditlimit) over(partition by country) THEN 'Lower than Previous Customer'
    WHEN c.creditlimit = lag(creditlimit) over(partition by country) THEN 'Same as Previous Customer'
end credit_range
from customers c;

select *, ntile(10) over (order by msrp desc) as 'Buckets or Groups' from products where productline = 'Classic Cars';

select x.productname, MSRP,
	CASE 
		WHEN x.Buckets = 1 THEN 'MOST EXPENSIVE PRODUCTS'
        WHEN x.Buckets = 2 THEN 'MID RANGE'
        WHEN x.Buckets = 3 THEN 'CHEAP PRODUCTS'
	END CLASSIC_CARS_TYPE 
FROM
(select *, ntile(3) over (order by msrp desc) as 'Buckets' from products where productline = 'Classic Cars') as x ;

    
-- Query to fetch all products which are constituting the first 30 % of the data in products table bae on msrp

select productname, CONCAT(x.Cume_DIST_in_percentage , ' %') as Cume_DIST_in_percentage FROM
	(select productname, msrp, 
	cume_dist() over (order by msrp desc) as Cume_Distribution,
	round( cume_dist() over (order by msrp desc)*100, 2 ) as Cume_DIST_in_percentage
	 from products) as x
 where x.Cume_DIST_in_percentage <=30 ; 
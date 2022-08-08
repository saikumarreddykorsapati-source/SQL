use classicmodels;

select * from customers;
select * from employees;
select * from offices;
select * from orderdetails;
select * from orders;
select * from payments;
select * from productlines;
select * from products;

/*
	-- -- -- JOINS -- -- --
    https://youtu.be/0OQJDd3QqQM - PART-1
    https://youtu.be/RehbnzKHS28 - PART-2
    
*/
-- INNER JOIN / JOIN / SIMPLE JOIN
-- selects records that have matching values in both tables

SELECT 

-- LEFT JOIN / LEFT OUTER JOIN
--  = inner join + any additional records in the left table

-- RIGHT JOIN / RIGHT OUTER JOIN
--  = inner join + any additional records in the right table

-- FULL JOIN / FULL OUTER JOIN => A full join is essentially a union of a left join with a right join.
/* MySQL does not support FULL JOIN, so you have to combine JOIN, UNION and LEFT JOIN to get an equivalent. It gives the results of A union B. It returns all records from both tables. Those columns which exist in only one table will contain NULL in the opposite table.
   MariaDB does not support the FULL JOIN/FULL OUTER JOIN keywords at all. we do a left join and a right join and then use the UNION keyword in between them? According to that statement, if we do this operation, we should get a full join even in MariaDB.
	eg : 
		SELECT * FROM Students s LEFT OUTER JOIN Marks m ON s.ID=m.StudentID 
		UNION
		SELECT * FROM Students s RIGHT OUTER JOIN Marks m ON s.ID=m.StudentID;

ie.,
	inner join
	+ all remaining records from left table (returns null value)
	+ all remaining records from right table
*/
-- CROSS JOIN - returns CARTESIAN PRODUCT

-- NATURAL JOIN
-- if there are columns sharing same name in two table then it performs inner join otherwise it will perform cross join

-- SELF JOIN --> join a table to itself

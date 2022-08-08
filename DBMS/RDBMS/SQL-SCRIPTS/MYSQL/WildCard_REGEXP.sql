use classicmodels;

select * from customers where customername like 'S%';

select * from customers where customername REGEXP '^A';
select * from customers where customername REGEXP '^AB';
select * from customers where customername REGEXP '^[AB]';
-- If we want to get the student information whose name ends with s
select * from customers where customername REGEXP 's$';
select * from customers where customername REGEXP '.SP';
select * from customers where customername REGEXP '[ABC]';
select * from customers where customername REGEXP '[y-z]';
select * from customers where customername REGEXP '[^ZY]';
-- If we want to get the student information whose name contains exactly six characters,
select * from customers where customername REGEXP '^.{10}$'; 
-- If we want to get the student info whose subjects contains 'i' characters,
select * from customers where customername REGEXP 'i';
  


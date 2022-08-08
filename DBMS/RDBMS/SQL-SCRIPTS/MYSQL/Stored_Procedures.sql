use classicmodels;

delimiter &&
create procedure count_rows()
begin
select * from customers;
end && 
delimiter ;

call count_rows();

delimiter &&
create procedure top_msrp(IN var1 int)
begin
select productname,msrp from products where msrp > var1;
end && 
delimiter ;

call top_msrp(95.70);


delimiter &&
create  procedure count_msrp(OUT var1 int)
begin
select productline, count(msrp) from products group by productline;
end && 
delimiter ;

call count_msrp(@cm);
select productline, count(msrp) from products group by productline;


select @cm as Count_OF_MSRP;


select * from products;
select productname,msrp from products where msrp = 95.70;



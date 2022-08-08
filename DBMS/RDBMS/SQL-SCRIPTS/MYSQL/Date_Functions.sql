use classicmodels;
select * from orders;

-- DATEDIFF()
select orderdate, requireddate, shippeddate,datediff(sysdate(), orderdate) as 'Diiference Till today', datediff(shippeddate, orderdate) as Diff_or_sp  from orders;
-- DATE_FORMAT()
select orderdate, requireddate, shippeddate,date_format(orderdate, '%Y') as 'year'  from orders;
-- DAY(), MONTH(), YEAR(), QUARTER()
-- ADDDATE()
select adddate('2022-06-28', interval 10 day);

select adddate('2022-06-28', interval -10 day);
-- or
SELECT SUBDATE('2022-06-28', interval 10 day);
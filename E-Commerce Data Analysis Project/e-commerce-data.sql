

--DAwSQL Session -8 

--E-Commerce Project Solution

create database eCommerceData;

use eCommerceData;

create table cust_dimen(
	Customer_Name varchar(100),
	Province varchar(50) ,
	Region varchar(50) ,
	Customer_Segment varchar(50),
	Cust_id varchar(50) 
);
 
bulk insert cust_dimen
from 'C:\Users\iremg\Desktop\irem\SQL\sql-project\cust_dimen.csv'
with (
	format='csv',
	firstrow = 2,
	fieldterminator=','
);


create table orders_dimen(
	Order_Date date,
	Order_Priority varchar(50) ,
	Ord_id varchar(50) 
);
 
bulk insert orders_dimen
from 'C:\Users\iremg\Desktop\irem\SQL\sql-project\orders_dimen.csv'
with (
	format='csv',
	firstrow = 2,
	fieldterminator=','
);


create table shipping_dimen(
	Order_ID varchar(100),
	Ship_mode varchar(50) ,
	Ship_date varchar(50) ,
	Ship_id varchar(50)
)
 
bulk insert shipping_dimen
from '/Users/levent/Downloads/shipping_dimen.csv'
with (
	format='csv',
	firstrow = 2,
	fieldterminator=','
);

select *
from dbo.cust_dimen


select *
from dbo.orders_dimen;

select *
from dbo.shipping_dimen;

select * 
from dbo.market_fact;

select *
from dbo.prod_dimen;



--1. Join all the tables and create a new table called combined_table. (market_fact, cust_dimen, orders_dimen, prod_dimen, shipping_dimen)

select	a.ord_id, 
		a.prod_id, 
		a.ship_id, 
		a.cust_id, 
		a.sales, 
		a.discount, 
		a.order_quantity, 
		a.product_base_margin, 
		b.Customer_Name, 
		b.Province, 
		b.Region, 
		b.Customer_Segment,
		c.Order_Date,
		c.Order_Priority,
		d.Order_ID,
		d.Ship_date,
		d.Ship_mode,
		e.product_category,
		e.product_sub_category  into combined_table
from dbo.market_fact a
join dbo.cust_dimen b
	on b.Cust_id=a.cust_id
join dbo.orders_dimen c
	on c.Ord_id=a.Ord_id
join dbo.shipping_dimen d
	on d.Ship_id=a.ship_id
join dbo.prod_dimen e
	on e.prod_id=a.prod_id




select * 
from combined_table

--2. Find the top 3 customers who have the maximum count of orders.

select top 3 cust_id, count(distinct ord_id) order_count
from combined_table
group by cust_id
order by order_count desc

--3.Create a new column at combined_table as DaysTakenForDelivery that contains the date difference of Order_Date and Ship_Date.
--Use "ALTER TABLE", "UPDATE" etc.

alter table combined_table add DaysTakenForDelivery integer ;

select DATEDIFF(day, Order_Date, Ship_date)
from combined_table



--first way
SELECT Order_Date, Ship_Date, DATEDIFF(day, Order_Date, Ship_Date) FROM combined_table
UPDATE combined_table
SET DaysTakenForDelivery = DATEDIFF(day, Order_Date, Ship_Date)

--second way
--update a 
--set a.DaysTakenForDelivery=b.DaysTakenForDelivery
--from combined_table a
--inner join (	select order_id, DATEDIFF(day, Order_Date, Ship_date) DaysTakenForDelivery
--		from combined_table ) as b
--on a.order_id=b.order_id




--////////////////////////////////////


--4. Find the customer whose order took the maximum time to get delivered.
--Use "MAX" or "TOP"
--first way
select Cust_id, DaysTakenForDelivery
from combined_table
where DaysTakenForDelivery = 
(select max(DaysTakenForDelivery)
from combined_table)
--second way
select top 1 Cust_id, max(DaysTakenForDelivery) 
from combined_table
group by cust_id
order by max(DaysTakenForDelivery) desc


--////////////////////////////////



--5. Count the total number of unique customers in January and how many of them came back every month over the entire year in 2011
--You can use date functions and subqueries

select count(distinct cust_id) distinct_january
from combined_table
where month(order_date)='1'
and year(order_date) = '2011'

select month(order_date) month_num, count(distinct cust_id) cust_returned
from combined_table 
where cust_id in (select distinct cust_id
from combined_table
where month(order_date)='1'
and year(order_date) = '2011'
)
group by month(order_date)



--////////////////////////////////////////////


--6. write a query to return for each user acording to the time elapsed between the first purchasing and the third purchasing, 
--in ascending order by Customer ID
--Use "MIN" with Window Functions



select Cust_id
from combined_table
group by cust_id
having count(distinct Order_ID) >= 3
order by cust_id desc


select distinct cust_id, 
DENSE_RANK() OVER (PARTITION BY cust_id ORDER BY order_ID ASC) +
DENSE_RANK() OVER (PARTITION BY cust_id ORDER BY order_ID DESC) - 1 as s
from combined_table

select distinct cust_id 
from (select distinct cust_id, 
DENSE_RANK() OVER (PARTITION BY cust_id ORDER BY order_ID ASC) +
DENSE_RANK() OVER (PARTITION BY cust_id ORDER BY order_ID DESC) - 1 as s
from combined_table) a
where a.s >= 3
order by cust_id desc


create table elapse(
	cust_id varchar(50),
	order_id int,
	order_date date
)

insert into elapse
select a.cust_id, a.order_id, a.Order_Date
from combined_table a
join (select distinct cust_id 
from (select distinct cust_id, 
DENSE_RANK() OVER (PARTITION BY cust_id ORDER BY order_ID ASC) +
DENSE_RANK() OVER (PARTITION BY cust_id ORDER BY order_ID DESC) - 1 as s
from combined_table) a
where a.s >= 3
) b 
on b.cust_id = a.cust_id
group by a.cust_id, a.order_id, a.Order_Date
order by a.cust_id, a.Order_Date

select *
from elapse


select cust_id,elapse
from
(select cust_id, order_date,rank() over(PARTITION by cust_id order by  order_date) as ranks, 
DATEDIFF(day, Order_Date, lead(Order_Date,2) over(partition by cust_id order by order_date)) as elapse
from elapse) k
where k.ranks = 1


--//////////////////////////////////////

--7. Write a query that returns customers who purchased both product 11 and product 14, 
--as well as the ratio of these products to the total number of products purchased by all customers.
--Use CASE Expression, CTE, CAST and/or Aggregate Functions

select cust_id
from combined_table
where prod_id = 'Prod_14'
INTERSECT
select cust_id
from combined_table
where prod_id = 'Prod_11'

select ((select count(*)
from combined_table
where prod_id = 'Prod_11') + (select count(*)
from combined_table
where prod_id = 'Prod_14')) / ((select count(*) from combined_table) * 1.0)







--/////////////////



--CUSTOMER SEGMENTATION



--1. Create a view that keeps visit logs of customers on a monthly basis. (For each log, three field is kept: Cust_id, Year, Month)
--Use such date functions. Don't forget to call up columns you might need later.
create view monthly_logs as

SELECT cust_id,
          year(order_date) as Years,
		  MONTH(Order_Date) as Months,
		  Order_Date
		  --DAY(Order_Date) as day_s
FROM dbo.combined_table

--//////////////////////////////////



  --2.Create a �view� that keeps the number of monthly visits by users. (Show separately all months from the beginning  business)
--Don't forget to call up columns you might need later.
CREATE VIEW month_visits AS

SELECT cust_id ,Years,Months,count(*) num

From dbo.monthly_logs
GROUP BY cust_id,Years,Months



--//////////////////////////////////


--3. For each visit of customers, create the next month of the visit as a separate column.
--You can order the months using "DENSE_RANK" function.
--then create a new column for each month showing the next month using the order you have made above. (use "LEAD" function.)
--Don't forget to call up columns you might need later.
SELECT cust_id ,Years,Months,count(*) num,
lead(count(*)) over(PARTITION BY months order by months) as num_1,
dense_rank() over( order by months, years) ranks
From dbo.monthly_logs
GROUP BY cust_id,Years,Months
order by years,months


--/////////////////////////////////



--4. Calculate monthly time gap between two consecutive visits by each customer.
--Don't forget to call up columns you might need later.

SELECT cust_id ,Years,Months,
datediff(month, Order_Date,lead(Order_Date) over(order by cust_id)) as month_diff

From dbo.monthly_logs
GROUP BY cust_id,Years,Months,Order_Date
order by cust_id





--///////////////////////////////////


--5.Categorise customers using average time gaps. Choose the most fitted labeling model for you.
--For example: 
--Labeled as �churn� if the customer hasn't made another purchase for the months since they made their first purchase.
--Labeled as �regular� if the customer has made a purchase every month.
--Etc.

select distinct cust_id,avg(day_diff) over(PARTITION by cust_id) as avg_diff,
case 
	when  avg(day_diff) over(PARTITION by cust_id) < avg(day_diff) over() then 'regular'
	else 'churn'
end as cust_status
from
(SELECT cust_id,order_date,
datediff(day,Order_Date,lead(Order_Date) over(PARTITION by cust_id order by cust_id,order_date)) day_diff
From dbo.monthly_logs
) a
order by cust_id





--/////////////////////////////////////




--MONTH-WISE RETENT�ON RATE


--Find month-by-month customer retention rate  since the start of the business.


--1. Find the number of customers retained month-wise. (You can use time gaps)
--Use Time Gaps

select *
from monthly_logs


select month(order_date) month_num, count(distinct cust_id) cust_returned
from combined_table 
where cust_id in (select distinct cust_id
from combined_table
where month(order_date) = '1' 
)
group by month(order_date)
having month(Order_Date) = '2'
union
select month(order_date) month_num, count(distinct cust_id) cust_returned
from combined_table 
where cust_id in (select distinct cust_id
from combined_table
where month(order_date) = '2' 
)
group by month(order_date)
having month(Order_Date) = '3'
union
select month(order_date) month_num, count(distinct cust_id) cust_returned
from combined_table 
where cust_id in (select distinct cust_id
from combined_table
where month(order_date) = '3' 
)
group by month(order_date)
having month(Order_Date) = '4'
union
select month(order_date) month_num, count(distinct cust_id) cust_returned
from combined_table 
where cust_id in (select distinct cust_id
from combined_table
where month(order_date) = '4' 
)
group by month(order_date)
having month(Order_Date) = '5'
union
select month(order_date) month_num, count(distinct cust_id) cust_returned
from combined_table 
where cust_id in (select distinct cust_id
from combined_table
where month(order_date) = '5' 
)
group by month(order_date)
having month(Order_Date) = '6'
union
select month(order_date) month_num, count(distinct cust_id) cust_returned
from combined_table 
where cust_id in (select distinct cust_id
from combined_table
where month(order_date) = '6' 
)
group by month(order_date)
having month(Order_Date) = '7'
union
select month(order_date) month_num, count(distinct cust_id) cust_returned
from combined_table 
where cust_id in (select distinct cust_id
from combined_table
where month(order_date) = '7' 
)
group by month(order_date)
having month(Order_Date) = '8'
union
select month(order_date) month_num, count(distinct cust_id) cust_returned
from combined_table 
where cust_id in (select distinct cust_id
from combined_table
where month(order_date) = '8' 
)
group by month(order_date)
having month(Order_Date) = '9'
union
select month(order_date) month_num, count(distinct cust_id) cust_returned
from combined_table 
where cust_id in (select distinct cust_id
from combined_table
where month(order_date) = '9' 
)
group by month(order_date)
having month(Order_Date) = '10'
union
select month(order_date) month_num, count(distinct cust_id) cust_returned
from combined_table 
where cust_id in (select distinct cust_id
from combined_table
where month(order_date) = '10' 
)
group by month(order_date)
having month(Order_Date) = '11'
union
select month(order_date) month_num, count(distinct cust_id) cust_returned
from combined_table 
where cust_id in (select distinct cust_id
from combined_table
where month(order_date) = '11' 
)
group by month(order_date)
having month(Order_Date) = '12'



--//////////////////////


--2. Calculate the month-wise retention rate.

--Basic formula: o	Month-Wise Retention Rate = 1.0 * Number of Customers Retained in The Current Month / Total Number of Customers in the Current Month

--It is easier to divide the operations into parts rather than in a single ad-hoc query. It is recommended to use View. 
--You can also use CTE or Subquery if you want.

--You should pay attention to the join type and join columns between your views or tables.

select month(order_date) month_num, (count(distinct cust_id) * 1.0)/(select count(distinct cust_id) cust
from combined_table 
where month(order_date) = '2'
) Retention_Rate
from combined_table 
where cust_id in (select distinct cust_id
from combined_table
where month(order_date) = '1' 
)
group by month(order_date)
having month(Order_Date) = '2'

(select count(distinct cust_id) cust
from combined_table 
where month(order_date) = '2'
)


select month(order_date) month_num, (count(distinct cust_id) * 1.0)/(select count(distinct cust_id) cust
from combined_table 
where month(order_date) = '2'
) Retention_Rate
from combined_table 
where cust_id in (select distinct cust_id
from combined_table
where month(order_date) = '1' 
)
group by month(order_date)
having month(Order_Date) = '2'
union
select month(order_date) month_num, (count(distinct cust_id) * 1.0)/(select count(distinct cust_id) cust
from combined_table 
where month(order_date) = '3'
) Retention_Rate
from combined_table 
where cust_id in (select distinct cust_id
from combined_table
where month(order_date) = '2' 
)
group by month(order_date)
having month(Order_Date) = '3'
union
select month(order_date) month_num, (count(distinct cust_id) * 1.0)/(select count(distinct cust_id) cust
from combined_table 
where month(order_date) = '4'
) Retention_Rate
from combined_table 
where cust_id in (select distinct cust_id
from combined_table
where month(order_date) = '3' 
)
group by month(order_date)
having month(Order_Date) = '4'
union
select month(order_date) month_num, (count(distinct cust_id) * 1.0)/(select count(distinct cust_id) cust
from combined_table 
where month(order_date) = '5'
) Retention_Rate
from combined_table 
where cust_id in (select distinct cust_id
from combined_table
where month(order_date) = '4' 
)
group by month(order_date)
having month(Order_Date) = '5'
union
select month(order_date) month_num, (count(distinct cust_id) * 1.0)/(select count(distinct cust_id) cust
from combined_table 
where month(order_date) = '6'
) Retention_Rate
from combined_table 
where cust_id in (select distinct cust_id
from combined_table
where month(order_date) = '5' 
)
group by month(order_date)
having month(Order_Date) = '6'
union
select month(order_date) month_num, (count(distinct cust_id) * 1.0)/(select count(distinct cust_id) cust
from combined_table 
where month(order_date) = '7'
) Retention_Rate
from combined_table 
where cust_id in (select distinct cust_id
from combined_table
where month(order_date) = '6' 
)
group by month(order_date)
having month(Order_Date) = '7'
union
select month(order_date) month_num, (count(distinct cust_id) * 1.0)/(select count(distinct cust_id) cust
from combined_table 
where month(order_date) = '8'
) Retention_Rate
from combined_table 
where cust_id in (select distinct cust_id
from combined_table
where month(order_date) = '7' 
)
group by month(order_date)
having month(Order_Date) = '8'
union
select month(order_date) month_num, (count(distinct cust_id) * 1.0)/(select count(distinct cust_id) cust
from combined_table 
where month(order_date) = '9'
) Retention_Rate
from combined_table 
where cust_id in (select distinct cust_id
from combined_table
where month(order_date) = '8' 
)
group by month(order_date)
having month(Order_Date) = '9'
union
select month(order_date) month_num, (count(distinct cust_id) * 1.0)/(select count(distinct cust_id) cust
from combined_table 
where month(order_date) = '10'
) Retention_Rate
from combined_table 
where cust_id in (select distinct cust_id
from combined_table
where month(order_date) = '9' 
)
group by month(order_date)
having month(Order_Date) = '10'
union
select month(order_date) month_num, (count(distinct cust_id) * 1.0)/(select count(distinct cust_id) cust
from combined_table 
where month(order_date) = '11'
) Retention_Rate
from combined_table 
where cust_id in (select distinct cust_id
from combined_table
where month(order_date) = '10' 
)
group by month(order_date)
having month(Order_Date) = '11'
union
select month(order_date) month_num, (count(distinct cust_id) * 1.0)/(select count(distinct cust_id) cust
from combined_table 
where month(order_date) = '12'
) Retention_Rate
from combined_table 
where cust_id in (select distinct cust_id
from combined_table
where month(order_date) = '11' 
)
group by month(order_date)
having month(Order_Date) = '12'





---///////////////////////////////////
--Good luck!
--Below you see a table of the actions of customers visiting the website by clicking on 
--two different types of advertisements given by an E-Commerce company. Write a query to 
--return the conversion rate for each Advertisement type.

create database assignments;
use assignments;

--a.	Create above table (Actions) and insert values,
create table actions(
	visitor_ID INT IDENTITY (1, 1) PRIMARY KEY,
	adv_type char,
	action varchar(10)
)

SET IDENTITY_INSERT dbo.actions ON ;

INSERT dbo.actions (visitor_ID, adv_type, action) VALUES (1, 'A', 'Left')
INSERT dbo.actions (visitor_ID, adv_type, action) VALUES (2, 'A', 'Order')
INSERT dbo.actions (visitor_ID, adv_type, action) VALUES (3, 'B', 'Left')
INSERT dbo.actions (visitor_ID, adv_type, action) VALUES (4, 'A', 'Order')
INSERT dbo.actions (visitor_ID, adv_type, action) VALUES (5, 'A', 'Review')
INSERT dbo.actions (visitor_ID, adv_type, action) VALUES (6, 'A', 'Left')
INSERT dbo.actions (visitor_ID, adv_type, action) VALUES (7, 'B', 'Left')
INSERT dbo.actions (visitor_ID, adv_type, action) VALUES (8, 'B', 'Order')
INSERT dbo.actions (visitor_ID, adv_type, action) VALUES (9, 'B', 'Review')
INSERT dbo.actions (visitor_ID, adv_type, action) VALUES (10, 'A', 'Review')

select * from dbo.actions

--b.	Retrieve count of total Actions, and Orders for each Advertisement Type

select adv_type, count(*) total_actions
from dbo.actions
group by adv_type


select  adv_type, count(*) total
from dbo.actions
where action = 'Order'
group by adv_type

--c.	Calculate Orders (Conversion) rates for each Advertisement Type by dividing 
--		by total count of actions casting as float by multiplying by 1.0.



select distinct a.adv_type, format(b.total/(c.total_actions*1.0), 'N2') conversion_rate
from actions a
right join (select adv_type, count(*) total
	from dbo.actions
	where [action] = 'Order'
	group by adv_type) b
on a.adv_type=b.adv_type
right join (select adv_type, count(*) total_actions
	from dbo.actions
	group by adv_type) c
on a.adv_type=c.adv_type


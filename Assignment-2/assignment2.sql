--You need to create a report on whether customers who purchased the product
--named '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD' buy the products 
--below or not.



--1. 'Polk Audio - 50 W Woofer - Black' -- (first_product)

--2. 'SB-2000 12 500W Subwoofer (Piano Gloss Black)' -- (second_product)

--3. 'Virtually Invisible 891 In-Wall Speakers (Pair)' -- (third_product)



--To generate this report, you are required to use the appropriate SQL Server 
--Built-in string functions (ISNULL(), NULLIF(), etc.) and Joins, as well as 
--basic SQL knowledge. As a result, a report exactly like the attached file 
--is expected from you.
on D.product_id = C.product_id
where d.product_name = 'Polk Audio - 50 W Woofer - Black'
order by a.customer_id 

select 
on D.product_id = C.product_id
where d.product_name = 'SB-2000 12 500W Subwoofer (Piano Gloss Black)'
order by a.customer_id 

select 
on D.product_id = C.product_id
where d.product_name = 'Virtually Invisible 891 In-Wall Speakers (Pair)'
order by a.customer_id 

	on D.product_id = C.product_id
	where d.product_name = 'Polk Audio - 50 W Woofer - Black' ) E
	on D.product_id = C.product_id
	where d.product_name = 'SB-2000 12 500W Subwoofer (Piano Gloss Black)') F
	on D.product_id = C.product_id
	where d.product_name = 'Virtually Invisible 891 In-Wall Speakers (Pair)') G
order by customer_id
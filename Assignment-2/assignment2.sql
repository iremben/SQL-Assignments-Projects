--You need to create a report on whether customers who purchased the product
--named '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD' buy the products 
--below or not.



--1. 'Polk Audio - 50 W Woofer - Black' -- (first_product)

--2. 'SB-2000 12 500W Subwoofer (Piano Gloss Black)' -- (second_product)

--3. 'Virtually Invisible 891 In-Wall Speakers (Pair)' -- (third_product)



--To generate this report, you are required to use the appropriate SQL Server 
--Built-in string functions (ISNULL(), NULLIF(), etc.) and Joins, as well as 
--basic SQL knowledge. As a result, a report exactly like the attached file 
--is expected from you.select 	distinct A.customer_id,	D.product_namefrom sale.customer Ainner join sale.orders B on A.customer_id = B.customer_idinner join sale.order_item C on C.order_id = B.order_idinner join product.product D 
on D.product_id = C.product_id
where d.product_name = 'Polk Audio - 50 W Woofer - Black'
order by a.customer_id 

select 	distinct A.customer_id,	D.product_namefrom sale.customer Ainner join sale.orders B on A.customer_id = B.customer_idinner join sale.order_item C on C.order_id = B.order_idinner join product.product D 
on D.product_id = C.product_id
where d.product_name = 'SB-2000 12 500W Subwoofer (Piano Gloss Black)'
order by a.customer_id 

select 	distinct A.customer_id,	D.product_namefrom sale.customer Ainner join sale.orders B on A.customer_id = B.customer_idinner join sale.order_item C on C.order_id = B.order_idinner join product.product D 
on D.product_id = C.product_id
where d.product_name = 'Virtually Invisible 891 In-Wall Speakers (Pair)'
order by a.customer_id 
select 	distinct A.customer_id, 	A.first_name, 	A.last_name,	replace(isnull(nullif('Polk Audio - 50 W Woofer - Black', e.product_name), 'yes'), 	'Polk Audio - 50 W Woofer - Black', 'no') first_product,	replace(isnull(nullif('SB-2000 12 500W Subwoofer (Piano Gloss Black)', f.product_name), 'yes'), 	'SB-2000 12 500W Subwoofer (Piano Gloss Black)', 'no') second_product,	replace(isnull(nullif('Virtually Invisible 891 In-Wall Speakers (Pair)', g.product_name), 'yes'), 	'Virtually Invisible 891 In-Wall Speakers (Pair)', 'no') third_productfrom sale.customer Ainner join sale.orders B on A.customer_id = B.customer_idinner join sale.order_item C on C.order_id = B.order_idinner join product.product D on D.product_id = C.product_idleft join (	select 		distinct A.customer_id,		D.product_name	from sale.customer A	inner join sale.orders B 	on A.customer_id = B.customer_id	inner join sale.order_item C 	on C.order_id = B.order_id	inner join product.product D 
	on D.product_id = C.product_id
	where d.product_name = 'Polk Audio - 50 W Woofer - Black' ) Eon a.customer_id=e.customer_idleft join (	select 		distinct A.customer_id,		D.product_name	from sale.customer A	inner join sale.orders B 	on A.customer_id = B.customer_id	inner join sale.order_item C 	on C.order_id = B.order_id	inner join product.product D 
	on D.product_id = C.product_id
	where d.product_name = 'SB-2000 12 500W Subwoofer (Piano Gloss Black)') Fon a.customer_id = f.customer_idleft join (	select 		distinct A.customer_id,		D.product_name	from sale.customer A	inner join sale.orders B 	on A.customer_id = B.customer_id	inner join sale.order_item C 	on C.order_id = B.order_id	inner join product.product D 
	on D.product_id = C.product_id
	where d.product_name = 'Virtually Invisible 891 In-Wall Speakers (Pair)') Gon a.customer_id = g.customer_idwhere D.product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'
order by customer_id
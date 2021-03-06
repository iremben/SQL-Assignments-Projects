## <a href=https://github.com/iremben/SQL-Assignments-Exercises/blob/main/Assignment-1/assignment-1.sql>Assignment 1</a>
Charlie's Chocolate Factory company produces chocolates.

Do the following exercises, using the data model.

* Create a database named "Manufacturer"

* Create the tables in the database.

* Define table constraints.



<pre><code>
CREATE DATABASE Manufacturer;



USE Manufacturer;


);
</code></pre>



* The following product information is stored: product name, 

* product ID, and quantity on hand. 



<pre><code>
CREATE TABLE product(

	product_id INT NOT NULL PRIMARY KEY,

	product_name VARCHAR(50) NOT NULL,

	quantity INT NOT NULL

);
</code></pre>



* These chocolates are made up of many components. Each component

* can be supplied by one or more suppliers. The following component 

* information is kept:

* component ID, name, description, quantity on hand, suppliers 

* who supply them, when and how much they supplied, and products

* in which they are used. 



<pre><code>
CREATE TABLE prod_comp(

	component_id INT NOT NULL,

	product_id INT NOT NULL,

	quantity INT NOT NULL,

	PRIMARY KEY(product_id,component_id)

);



ALTER TABLE dbo.prod_comp 

ADD CONSTRAINT FK_product 

FOREIGN KEY (product_id) 

REFERENCES dbo.product (product_id);





CREATE TABLE components(

	component_id INT NOT NULL PRIMARY KEY,

	name VARCHAR(50) NOT NULL UNIQUE,

	description VARCHAR(50) ,

	quantity INT NOT NULL

);



ALTER TABLE dbo.prod_comp

ADD CONSTRAINT FK_lksdföl

FOREIGN KEY (component_id)

REFERENCES dbo.components (component_id);



CREATE TABLE comp_supp(

	component_id INT NOT NULL,

	supplier_id INT NOT NULL,

	order_date DATE,

	supply_quantity INT NULL

	PRIMARY KEY (component_id, supplier_id)

);



ALTER TABLE dbo.comp_supp 

ADD CONSTRAINT FK_components 

FOREIGN KEY (component_id) 

REFERENCES dbo.components (component_id)

</code></pre>

* On the other hand following supplier information is stored: 

* supplier ID, name, and activation status.


<pre><code>
 CREATE TABLE supplier(

	supplier_id INT NOT NULL PRIMARY KEY,

	supplier_name VARCHAR(50) NOT NULL,

	supplier_location varchar(50),

	country varchar(50),

	activation_status BIT,

 );



ALTER TABLE dbo.comp_supp 

ADD CONSTRAINT FK_supplier 

FOREIGN KEY (supplier_id) 

REFERENCES dbo.supplier (supplier_id)

</code></pre>



## Assumptions


* A supplier can exist without providing components.     

* A component does not have to be associated with a supplier. 

* It may already have been in the inventory.

* A component does not have to be associated with a product. 

* Not all components are used in products.

* A product cannot exist without components.     






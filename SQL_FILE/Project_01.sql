-- CREATE THE TABLE NAME : retail_sales

create table retail_sales
	(
		transactions_id INT,
		sale_date DATE,
		sale_time TIME,
		customer_id INT,
		gender VARCHAR(15),
		age INT,	
		category VARCHAR(15),
		quantity INT, 
		price_per_unit NUMERIC(10,2),
    	cogs NUMERIC(10,2),
    	total_sale NUMERIC(10,2),

	CONSTRAINT pk_retail_sales PRIMARY KEY (transactions_id) 
);

-- 
select * from retail_sales;

select count(*)
 from retail_Sales;

select * from retail_sales limit 10;
-- 

select * from retail_sales where transactions_id is null;

select * from retail_sales where sale_date is null;

select * from retail_sales where sale_time is null;

-- DATA CLEANING

select * from retail_sales where transactions_id is null 
or sale_date is null
or sale_time is null 
or customer_id is null 
or gender is null 
or age is null 
or category is null
or quantity is null 
or price_per_unit is null 
or cogs is null 
or total_sale is null;

delete from retail_sales where 
quantity is null or price_per_unit is null or cogs is null or total_sale is null;

-- DATA EXPLORATION
-- HOW MANY SALES WE HAVE?

select count(*) from retail_sales;

-- HOW MANY CUSTOMERS WE HAVE
select count(distinct(customer_id)) from retail_sales;
-- or
select count(customer_id) from retail_sales;

-- HOW MANY CATEGORIES WE HAVE
SELECT COUNT(DISTINCT category) FROM retail_sales;

-- some business related questions
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 2 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning < 12, Afternoon Between 12 & 17, Evening >17)

-- Answer -> 01
select * from retail_sales where sale_date = '2022-11-05;'
			-- Another finding 
select count(*) from retail_sales where sale_date = '2022-11-05;'


-- Answer >- 02
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
and quantity > 2
and extract(YEAR from sale_date) = 2022
and Extract(month from sale_date) = 11;


select sale_date , extract(YEAR from sale_date) as year, extract(MONTH from sale_date) as month from retail_sales;

-- Answer -> 03

select category ,sum(total_sale) as net_sale , count(*) as total_order from retail_sales group by 1;


-- Answer -> 04
select category , round(avg(age),2) from retail_sales where category = 'Beauty' group by category;

-- Answer ->05
select * from retail_sales where total_sale > 1000;

-- answer -> 06
select count(transactions_id) , gender, category from retail_sales  group by gender, category;

-- Answer -> 07
select * from(
select 
	extract(YEAR from sale_date) as year,
	extract(MONTH from sale_date) as month,
	round(avg(total_sale) , 3) as avg_sale,
	rank() over(partition by extract(YEAR from sale_date) order by round(avg(total_sale) , 3) desc) as rank
from retail_sales
group by year, month
)as t1
where rank = 1

select * from retail_sales;
-- Answer -> 08
select customer_id as customers,  sum(total_sale) as sale from retail_sales group by customers order by sale DESC;

-- answer -> 09
select count(distinct customer_id), category from retail_sales group by category;



-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning < 12, Afternoon Between 12 & 17, Evening >17)
-- Answer -> 10
select extract(HOUR FROM CURRENT_TIME);
-- CTE : comman table expression

with Hourly_sale
as(
SELECT *,
	CASE
		WHEN extract(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN extract(HOUR FROM sale_time) < 17 THEN 'AFternoon'
		else 'Evening'
	END AS Shift
from retail_sales
)select shift,
count(*) as total_orders
from Hourly_sale
group by shift

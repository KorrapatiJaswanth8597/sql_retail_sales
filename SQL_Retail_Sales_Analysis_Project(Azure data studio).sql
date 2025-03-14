
-- SQL Retail Sales Analysis..

-- Create database
CREATE DATABASE sql_project;

-- Use database
USE sql_project;

 

-- CREATE table

DROP TABLE IF EXISTS Retail_Sales;

CREATE TABLE Retail_Sales(
    transactions_id	INT PRIMARY KEY,
    sale_date	DATE,
    sale_time	TIME,
    customer_id	INT,
    gender	VARCHAR(15),
    age	INT,
    category VARCHAR(15),
    quantiy	INT,
    price_per_unit FLOAT,
    cogs	FLOAT,
    total_sale FLOAT
);

-- Fetch Top - 5 rows from the dataset
SELECT TOP 5 * FROM Retail_Sales;

 -- Check all the columns having Null or not
SELECT * FROM Retail_Sales
WHERE transactions_id IS NULL
      OR
      sale_date IS NULL
      OR
      sale_time IS NULL
      OR
      customer_id IS NULL
      OR 
      gender IS NULL
      OR
      age IS NULL
      OR 
      category IS NULL
      OR 
      quantiy IS NULL
      OR 
      price_per_unit IS NULL
      OR 
      cogs IS NULL
      OR
      total_sale IS NULL;


DELETE FROM Retail_Sales
WHERE transactions_id IS NULL
      OR
      sale_date IS NULL
      OR
      sale_time IS NULL
      OR
      customer_id IS NULL
      OR 
      gender IS NULL
      OR
      age IS NULL
      OR 
      category IS NULL
      OR 
      quantiy IS NULL
      OR 
      price_per_unit IS NULL
      OR 
      cogs IS NULL
      OR
      total_sale IS NULL;

------------------------------------------------------------------------------------------------------------

--- Data Exploration

--- How Many Sales we have?
SELECT COUNT(1) FROM Retail_Sales;

-- How many customers we have?
SELECT COUNT(DISTINCT customer_id) AS count_of_customers
FROM Retail_Sales;

--- How many category we have?
SELECT DISTINCT category AS count_of_category
FROM Retail_Sales;

----------------------------------------------------------------------------------------------------------

-- Data Analysis & Findings

-- Q.1 Write a SQL Query to retrive all columns for sales made on "2022-11-05"..
SELECT * FROM Retail_Sales
WHERE sale_date = '2022-11-05';

----------------------------------------------------------------------------------------------------

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing'
-- and the quantity sold is more than equal to 4 in the month of Nov-2022:

SELECT * FROM Retail_Sales
WHERE category = 'clothing'
 AND FORMAT(sale_date,'MM-yyyy') = '11-2022'
 AND quantiy=4;
 
 --------------------------------------------------------------------------------------------------------

-- Q.3 Write a SQL query to calculate the total_sales for each category.. order by in DESC order..
SELECT category , SUM(total_sale) AS total_sales 
FROM Retail_Sales
GROUP BY category
ORDER BY total_sales DESC;

--------------------------------------------------------------------------------------------------------

-- Q.4 Write a SQL query to find the average age of customers who purchased iteam from the "beauty" category..

SELECT AVG(age) AS avg_age
FROM Retail_Sales
WHERE category = 'beauty'; 

--------------------------------------------------------------------------------------------------

-- Q.5 Write a SQL query to find all transactions where the total sales is greater than the 1000.
SELECT *
FROM Retail_Sales
WHERE total_sale>1000;

-----------------------------------------------------------------------------------------------------

-- Q.6. Write a SQL query to find the total number of transactions (transaction_id) made 
--by each gender in each category.

SELECT category, gender, COUNT(transactions_id) AS number_of_transactions
FROM Retail_Sales
GROUP BY gender, category
ORDER BY category;

---------------------------------------------------------------------------------------------------------------

-- Q.7. Write a SQL query to calculate the average sale for each month. Find out best selling month 
--in each year:

WITH cte AS (
SELECT MONTH(sale_date) AS month_, AVG(total_sale) AS avg_sal, YEAR(sale_date) AS year_,
DENSE_RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS rnk
FROM Retail_Sales
GROUP BY MONTH(sale_date), YEAR(sale_date) 
)

SELECT month_, avg_sal, year_
FROM cte
WHERE rnk = 1;

---------------------------------------------------------------------------------------------------------

-- Q.8. Write a SQL query to find the top 5 customers based on the highest total sales

SELECT TOP 5 customer_id, SUM(total_sale) AS total_sales
FROM Retail_Sales
GROUP BY customer_id
ORDER BY total_sales DESC;

------------------------------------------------------------------------------------------------------

-- Q.9. Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT category, COUNT(DISTINCT customer_id) AS number_of_unique_customers
FROM Retail_Sales
GROUP BY category
ORDER BY number_of_unique_customers DESC;

------------------------------------------------------------------------------------------------------

-- Q.10. Write a SQL query to create each shift and number of orders 
-- (Example Morning <12, Afternoon Between 12 & 17, Evening >17)..

WITH hourly_sale AS (
SELECT *,
CASE WHEN FORMAT(sale_time, 'hh')<12 THEN 'Morning'
WHEN  FORMAT(sale_time, 'hh') BETWEEN 12 AND 17 THEN 'Afternoon'
ELSE  'Evening' 
END AS time_shift
FROM Retail_Sales )

SELECT time_shift, COUNT(transactions_id) AS cnt_of_orders
FROM hourly_sale
GROUP BY time_shift;

--------------------------------------END OF PROJECT-----------------------------------------------------------------------------
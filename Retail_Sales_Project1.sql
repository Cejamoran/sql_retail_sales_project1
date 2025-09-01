-- ===================================
-- DATA CLEANING & EXPLORATION
-- ===================================

-- Open database
USE sql_project_p2;

-- Select all data from a table named 'retail_sales'
USE sql_project_p2;
SELECT * FROM retail_sales;

-- Verify data integrity by checking for NULL values in the cogs column.
SELECT * FROM retail_sales
WHERE cogs IS NULL;

-- Find the total number of transactions.
SELECT COUNT(*) AS total_sale FROM retail_sales;

-- Count the number of unique customers.
SELECT COUNT(DISTINCT customer_id) AS total_unique_customers FROM retail_sales;

-- List all distinct product categories.
SELECT DISTINCT category FROM retail_sales;


-- ===================================
-- DATA ANALYSIS
-- ===================================

-- 1. Retrieve all sales on a specific date.
SELECT *
FROM retail_sales 
WHERE sale_date = '2022-11-05';

-- 2. Find transactions for a specific category within a date range and quantity threshold.
SELECT *
FROM retail_sales
WHERE category = 'Clothing' 
    AND EXTRACT(YEAR_MONTH FROM sale_date) = 202211
    AND quantity >= 4;

-- 3. Calculate total sales for each product category.
SELECT 
    category,
    SUM(total_sale) AS net_sale
FROM retail_sales
GROUP BY category
ORDER BY net_sale DESC;

-- 4. Calculate the average age of customers purchasing from the 'Beauty' category.
SELECT 
    AVG(age) AS average_age
FROM retail_sales 
WHERE category = 'Beauty';
    
-- 5. Find all transactions with a total sale amount over 1000.
SELECT * FROM retail_sales
WHERE total_sale > 1000;
 
-- 6. Count the number of transactions by category and gender.
SELECT
    category,
    gender,
    COUNT(transactions_id) AS total_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY category, gender;
      
-- 7. Find the best-selling month for each year based on average sale.
WITH MonthlySales AS (
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale
    FROM retail_sales
    GROUP BY 1, 2
)
SELECT 
    t1.year,
    t1.month,
    t1.avg_sale
FROM (
    SELECT 
        year,
        month,
        avg_sale,
        RANK() OVER(PARTITION BY year ORDER BY avg_sale DESC) AS ranking
    FROM MonthlySales
) AS t1
WHERE ranking = 1
ORDER BY t1.year, t1.month;

-- 8. Identify the top 5 customers by total sales.
SELECT
    customer_id,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

-- 9. Count the number of unique customers per category.
SELECT
    category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category
ORDER BY unique_customers DESC;

-- 10. Analyze sales volume by time of day (shifts).
WITH hourly_sale AS (
    SELECT 
        *,
        CASE
            WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) AS total_orders    
FROM hourly_sale
GROUP BY shift
ORDER BY total_orders DESC;


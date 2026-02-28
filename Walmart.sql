USE walmart;
SHOW TABLES;
SELECT * FROM walmart;
SELECT COUNT(*) FROM walmart;
select distinct payment_method from walmart;
select payment_method, 
COUNT(*) from walmart 
group by payment_method;

select count(distinct branch) from walmart;

select max(quantity) from walmart;

-- What are the different payment methods, and how many transactions anditems were sold with each method.
select payment_method, 
COUNT(*) as no_of_payments,
sum(quantity) as no_qty_sold
 from walmart 
group by payment_method;


-- Calculate the total quantity of items sold per payment method
SELECT 
    payment_method,
    SUM(quantity) AS no_qty_sold
FROM walmart
GROUP BY payment_method;

--  Determine the average, minimum, and maximum rating of categories for each city
SELECT 
    city,
    category,
    MIN(rating) AS min_rating,
    MAX(rating) AS max_rating,
    AVG(rating) AS avg_rating
FROM walmart
GROUP BY city,category;


-- Calculate the total profit for each category
SELECT 
    category,
    SUM(unit_price * quantity * profit_margin) AS total_profit
FROM walmart
GROUP BY category
ORDER BY total_profit DESC;

-- Categorize sales into Morning, Afternoon, and Evening shifts
SELECT
    branch,
    CASE 
        WHEN HOUR(TIME(time)) < 12 THEN 'Morning'
        WHEN HOUR(TIME(time)) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(*) AS num_invoices
FROM walmart
GROUP BY branch, shift
ORDER BY branch, num_invoices DESC;

-- Identify the 5 branches with the highest revenue increase ratio from last year to current year

WITH revenue_2022 AS(
	SELECT 
		branch,
        SUM(total) as revenue
	FROM walmart
    WHERE YEAR(str_to_date(date,'%d/%m/%Y'))= 2022
    GROUP BY branch
),
 revenue_2023 AS(
	SELECT 
		branch,
        SUM(total) as revenue
	FROM walmart
    WHERE YEAR(str_to_date(date,'%d/%m/%Y'))= 2023
    GROUP BY branch
)
SELECT 
	r2022.branch,
    r2022.revenue AS last_year_revenue,
    r2023.revenue AS current_year_revenue,
	ROUND(((r2023.revenue - r2022.revenue) / r2022.revenue) * 100, 2) AS revenue_increase_ratio
FROM revenue_2022 AS r2022
JOIN revenue_2023 AS r2023  ON r2022.branch=r2023.branch
WHERE  r2023.revenue > r2022.revenue
ORDER BY revenue_increase_ratio DESC
LIMIT 5;


SELECT * FROM walmart;

SELECT category, sum(unit_price*quantity) as sales
 FROM walmart
 group by category;
 
 select category ,avg(rating) as Avg_Rating
 from walmart
 group by category;
 
 SELECT category, sum(unit_price*quantity) as sales
 FROM walmart
WHERE YEAR(STR_TO_DATE(date, '%d/%m/%Y')) = 2023
 group by category;
 
 -- What were the total sales and total profit for each product category per month
SELECT 
    category,
    SUM(total) AS Total_sales,
    SUM(profit) AS total_profit
FROM walmart
WHERE MONTH(STR_TO_DATE(date, '%d/%m/%Y')) = 1
GROUP BY category;

-- What are the total sales and total profit for each year
select year(str_to_date(date, '%d/%m/%Y')) as year,
sum(total) as Total_sales,
sum(profit) as Total_profit
from walmart
group by year
order by year;

-- What is the total sales per category per year
SELECT 
    category,
    YEAR(str_to_date(date,'%d/%m/%Y')) AS year,
    SUM(total) AS total_sales
FROM walmart
GROUP BY category, year
ORDER BY category, year;

-- What were Walmart’s total monthly sales by year?
SELECT 
	YEAR(str_to_date(date,'%d/%m/%Y')) as year,
    MONTH(str_to_date(date,'%d/%m/%Y')) as month,
    sum(total) as Total_sales
FROM walmart
GROUP BY year,month
ORDER BY year,month;

-- What are the monthly total sales by category
SELECT
	category,
    sum(total) as Total_sales,
    YEAR(str_to_date(date,'%d/%m/%Y')) as year,
    MONTH(str_to_date(date,'%d/%m/%Y')) as month
FROM walmart
GROUP BY category,year,month
ORDER BY category,year,month;



ALTER TABLE walmart
RENAME COLUMN `ï»¿invoice_id` to `invoice_id`;

-- What is the number of transactions made using each payment method
SELECT
	payment_method,
    COUNT(invoice_id) as Transactions
FROM walmart
GROUP BY payment_method;

-- How many transactions occurred each year by payment method
SELECT
	YEAR(str_to_date(date,'%d/%m/%Y')) as year,
	payment_method,
    COUNT(invoice_id) as Transactions
FROM walmart
GROUP BY year,payment_method
ORDER BY year,Transactions;

-- Which cities have the highest total Walmart sales, and what are the top 10 based on summed sales amounts
SELECT 
	city,
    SUM(total) as total_sales
FROM walmart
GROUP BY city
ORDER BY total_sales DESC
LIMIT 10;


SELECT 
	city,
    SUM(total) as total_sales
FROM walmart
WHERE YEAR(str_to_date(date,'%d/%m/%Y'))=2020
GROUP BY city
ORDER BY total_sales DESC
LIMIT 10;


-- Which cities have the highest total Walmart sales, and what are the bottom 10 based on summed sales amounts
SELECT 
	city,
    SUM(total) as total_sales
FROM walmart
GROUP BY city
ORDER BY total_sales ASC
LIMIT 10;

SELECT 
	city,
    SUM(total) as total_sales
FROM walmart
WHERE YEAR(str_to_date(date,'%d/%m/%Y'))=2020
GROUP BY city
ORDER BY total_sales ASC
LIMIT 10;

SELECT 
	category,
    SUM(quantity) as quantity
FROM walmart
WHERE YEAR(str_to_date(date,'%d/%m/%Y'))=2020
GROUP BY category
ORDER BY quantity DESC;


SELECT 
	category,
    ROUND(AVG(rating),2) as Avg_rating
FROM walmart
-- WHERE YEAR(str_to_date(date,'%d/%m/%Y'))= 2023
GROUP BY category
ORDER BY Avg_rating DESC;

SELECT 
	branch,
	category,
    ROUND(AVG(rating),2) as Avg_rating
FROM walmart
-- WHERE YEAR(str_to_date(date,'%d/%m/%Y'))= 2023
GROUP BY category,branch
ORDER BY Avg_rating DESC
LIMIT 5;

SELECT
	year,
    total_sales,
    LAG(total_sales, 1) OVER (ORDER BY year) AS prev_year_sales,
    ROUND(
        (total_sales - LAG(total_sales, 1) OVER (ORDER BY year)) 
        / LAG(total_sales, 1) OVER (ORDER BY year) * 100, 2
    ) AS YoY_Growth_Percent
FROM (
    SELECT 
        YEAR(STR_TO_DATE(date, '%d/%m/%Y')) AS year,
        SUM(total) AS total_sales
    FROM walmart
    GROUP BY YEAR(STR_TO_DATE(date, '%d/%m/%Y'))
) AS t;

-- What is the year-over-year sales growth percent for each Walmart product category
SELECT
	category,
    year,
    total_sales,
    LAG(total_sales,1) OVER(PARTITION BY category ORDER BY year) as prev_year_sales,
    ROUND(
    (total_sales-LAG(total_sales,1) OVER (PARTITION BY category ORDER  BY year))/
    LAG(total_sales,1)OVER (PARTITION BY category ORDER BY year)*100,2
    ) AS YoY_growth_percent
FROM (
SELECT
	category,
    YEAR(str_to_date(date,'%d/%m/%Y')) as year,
    SUM(total) as total_sales
FROM walmart
GROUP BY category, YEAR(str_to_date(date,'%d/%m/%Y'))
)as t
ORDER BY category,year;


-- What is the year-over-year sales growth for each Walmart product categor
SELECT
	month,
    total_sales,
    LAG(total_sales, 1) OVER (ORDER BY month) AS prev_month_sales,
    ROUND(
        (total_sales - LAG(total_sales, 1) OVER (ORDER BY month)) 
        / LAG(total_sales, 1) OVER (ORDER BY month) * 100, 2
    ) AS MoM_Growth_Percent
FROM (
    SELECT 
        MONTH(STR_TO_DATE(date, '%d/%m/%Y')) AS month,
        SUM(total) AS total_sales
    FROM walmart
    WHERE YEAR(STR_TO_DATE(date, '%d/%m/%Y')) = 2020
    GROUP BY MONTH(STR_TO_DATE(date, '%d/%m/%Y'))
) AS t;

-- Determine the most common payment method for each branch
WITH cte AS (
    SELECT 
        branch,
        payment_method,
        COUNT(*) AS total_trans,
        RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS rnk
    FROM walmart
    GROUP BY branch, payment_method
)
SELECT branch, payment_method AS preferred_payment_method
FROM cte
WHERE rnk = 1;

-- Which category received the highest average rating in each branch?
SELECT branch, category, avg_rating
FROM (
    SELECT 
        branch,
        category,
        AVG(rating) AS avg_rating,
        RANK() OVER(PARTITION BY branch ORDER BY AVG(rating) DESC) AS rnk
    FROM walmart
    GROUP BY branch, category
) AS ranked
WHERE rnk = 1;

-- What is the busiest day of the week for each branch based on transaction volume?
SELECT branch, day_name, no_transactions
FROM (
    SELECT 
        branch,
        DAYNAME(STR_TO_DATE(date, '%d/%m/%Y')) AS day_name,
        COUNT(*) AS no_transactions,
        RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS rnk
    FROM walmart
    GROUP BY branch, day_name
) AS ranked
WHERE rnk = 1;

-- Identify the 5 branches with the highest revenue decrease ratio from last year to current year (e.g., 2022 to 2023)
WITH revenue_2022 AS (
    SELECT 
        branch,
        SUM(total) AS revenue
    FROM walmart
    WHERE YEAR(STR_TO_DATE(date, '%d/%m/%Y')) = 2022
    GROUP BY branch
),
revenue_2023 AS (
    SELECT 
        branch,
        SUM(total) AS revenue
    FROM walmart
    WHERE YEAR(STR_TO_DATE(date, '%d/%m/%Y')) = 2023
    GROUP BY branch
)
SELECT 
    r2022.branch,
    r2022.revenue AS last_year_revenue,
    r2023.revenue AS current_year_revenue,
    ROUND(((r2022.revenue - r2023.revenue) / r2022.revenue) * 100, 2) AS revenue_decrease_ratio
FROM revenue_2022 AS r2022
JOIN revenue_2023 AS r2023 ON r2022.branch = r2023.branch
WHERE r2022.revenue > r2023.revenue
ORDER BY revenue_decrease_ratio DESC
LIMIT 5;




	
    
    














create schema project;

use project;

SELECT * FROM customers_data;
SELECT * FROM inventory_movements_data;
SELECT * FROM products_data;
SELECT * FROM sales_data;


-- Module 1: Sales Performance Analysis

--  1.Total Sales per Month:
--  Calculate the total sales amount per month, including the number of units sold and the total revenue generated.

select * from sales;

select date_format("2017-06-15", "%Y");

select date_format("2017-06-15", "%m");

SELECT 
	date_format(sale_date,'%Y' '-' "%m") as per_month,
    round(sum(total_amount),2) as Total_sales,
    sum(quantity_sold) as Number_of_unit_sold,
    round(sum(total_amount*(1-discount_applied/100)),2) as Total_revenue_generated
FROM sales_data
GROUP BY per_month
ORDER BY per_month;

--  2.Top 10 Best-Selling Products:
--  Write a query to identify the top 10 best-selling products by quantity sold and total revenue generated.

SELECT
	product_id,
	sum(quantity_sold) as Number_of_unit_sold,
    round(sum(total_amount*(1-discount_applied/100)),2) as Total_revenue_generated
FROM sales_data
GROUP BY product_id
ORDER BY Number_of_unit_sold desc, Total_revenue_generated desc
LIMIT 10;

--  3.Most Profitable Product Categories: 
--  Use SQL to find which product categories generate the highest revenue and profit margins.

SELECT 
	category,
    round(sum(price*stock_quantity),2) as Total_Revenue,
    round(sum(price),2) as Profit_Margin 
FROM products_data
GROUP BY category
ORDER BY Total_Revenue DESC, Profit_Margin DESC;


-- 4.Average Discount per Month:
-- Calculate the average discount applied to sales in each month and assess how discounting strategies impact total sales.

SELECT 
	date_format(sale_date,"%Y" '-' "%m") as month,
    round(avg(discount_applied),1) as Average_Discount,
    round(sum(total_amount),2) as Total_sales,
    sum(quantity_sold) as No_of_units_sold,
    round(sum(total_amount*(1-discount_applied/100)),2) as Total_revenue_generated
FROM sales_data 
GROUP BY month
ORDER BY month;

--  Module 2: Customer Behavior and Insights

-- 1. Identify high-value customers: Which customers have spent the most on their purchases? Show their details

-- Derived Tables Joins
SELECT customer_id, round(sum(s.total_amount),2) as Total_sales
FROM sales_data;

SELECT c.*, s.Total_sales
FROM customers_data c
JOIN (SELECT customer_id, round(sum(total_amount),2) as Total_sales
	  FROM sales_data
      GROUP BY customer_id
      ORDER BY Total_sales desc) s
ON c.customer_id = s.customer_id
ORDER BY s.Total_sales desc;

-- Co-related Subquery
SELECT *,
(
	SELECT round(sum(total_amount),2) as Total_sales
	FROM sales_data s
    WHERE c.customer_id = s.customer_id
) AS Sales_Data
FROM customers_data c
ORDER BY Sales_Data desc;
 


SELECT 
	c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.gender,
    c.date_of_birth,
    c.registration_date,
    c.last_purchase_date,
    round(sum(s.total_amount),2) as Total_sales
FROM customers_data c
JOIN sales_data s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email, c.gender, c.date_of_birth, c.registration_date, c.last_purchase_date
ORDER BY Total_sales;

-- 2. Identify the oldest Customer: Find the details of customers born in the 1990s, including their total spending and specific order details.
 
WITH Total_sales AS
(
	SELECT customer_id, product_id, round(sum(total_amount),2) as Total_sale
	FROM sales_data
    GROUP BY customer_id, 2
)

SELECT c.*,date_format(c.date_of_birth, "%Y") as date_of_birth,ts.Total_sale, p.product_name, p.category
FROM customers_data c
JOIN sales_data s ON c.customer_id = s.customer_id
JOIN products_data p ON p.product_id = s.product_id
JOIN Total_sales ts ON ts.customer_id = s.customer_id
WHERE date_of_birth BETWEEN '1990' AND '1999'
ORDER BY c.customer_id;

 
 
 
SELECT 
	c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.gender,
    date_format(c.date_of_birth, "%Y") as date_of_birth,
    round(sum(s.total_amount),2) as Total_sales
FROM customers_data c
JOIN sales_data s ON c.customer_id = s.customer_id
WHERE date_of_birth BETWEEN '1990' AND '1999'
GROUP BY c.customer_id, c.first_name, c.last_name, c.email, c.gender, c.date_of_birth
ORDER BY c.date_of_birth;

-- 3. Customer Segmentation: Use SQL to create customer segments based on their total spending (e.g., Low Spenders, High Spenders).

SELECT 
	c.customer_id,
    c.first_name,
    c.last_name,
    s.total_amount,
    CASE
    WHEN s.total_amount < 500 THEN "Low Spenders"
    WHEN s.total_amount BETWEEN 500 AND 2000 THEN "Medium Spenders"
    ELSE "High Spenders"
    END AS category_spending
FROM customers_data c
JOIN sales_data s ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, s.total_amount
ORDER BY s.total_amount DESC;

--  4. Customer Lifetime Value: For each customer, calculate their lifetime value (total money spent since their registration).

SELECT c.customer_id, c.first_name, c.last_name, round(sum(s.total_amount),2) as Lifetime_value
FROM customers_data c 
JOIN sales_data s ON c.customer_id = s.customer_id
WHERE s.sale_date >= c.registration_date
GROUP BY c.customer_id, c.first_name, c.last_name;


--  5. New vs. Returning Customers: Compare sales generated from new customers (first-time buyers) and returning customers in the last 12 months.

-- Understanding date_add function and curdate() functions

select date_add("2017-06-15", interval -1 year);

select curdate();

-- We need to categories the sales and customer data for new customers and returning customers

-- A new customer is someone who has a registration date is within 12 months or 1 year that is new customer

-- A returning customer is someone who registered before the last 12 months or 1 year and has also made a purchase in this period


SELECT distinct c.customer_id,
	CASE WHEN c.registration_date >= date_add(curdate(), INTERVAL -1 YEAR) THEN "New"
		 ELSE "Returning"
         END AS customer_category,
         round(sum(s.total_amount)) as Total_sale
FROM customers_data c
JOIN sales_data s on c.customer_id = s.customer_id
WHERE s.sale_date >= date_add(curdate(), INTERVAL -1 YEAR)
GROUP BY c.customer_id, customer_category
ORDER BY c.customer_id;


--  Churn Prediction: Identify customers who have not made a purchase in over 6 months and calculate their potential impact on sales.

SELECT c.customer_id as Churned_customers, round(sum(s.total_amount),2) as Potential_impact
FROM customers_data c
JOIN sales_data s ON c.customer_id = s.customer_id
WHERE s.sale_date < date_add(curdate(), INTERVAL -6 MONTH)
GROUP BY c.customer_id
ORDER BY c.customer_id;


--  Module 3: Inventory and Product Management

-- 6. Stock Management: Write a query to find products that are running low in stock (below a threshold like 10 units) and recommend restocking amounts based on past sales performance.

WITH Recent_Sales AS 
(
	SELECT product_id, 
    AVG(quantity_sold) AS Avg_daily_sale
    FROM sales_data
    WHERE sale_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
    GROUP BY product_id

)

SELECT p.product_id, p.stock_quantity, Avg_daily_sale * 30 AS Restock_quantity
FROM products_data p
JOIN Recent_Sales r ON p.product_id = r.product_id
WHERE p.stock_quantity < 10;

-- Product16 has 34 items sold so it should be restocked on priority by around 35 items, Product 41 has 27 items sold so should be stocked by 25 items.
-- Product12 only sold 17 items and is among the bottom 5 products based on items sold, so only restock it slightly by 10-15 items


--  7. Inventory Movements Overview: Create a report showing the daily inventory movements (restock vs. sales) for each product over a given period.

-- Method 1
SELECT p.product_id, i.movement_date,
	sum(CASE WHEN movement_type = 'IN' THEN quantity_moved
    ELSE 0
    END )AS Product_restocked,
	sum(CASE WHEN movement_type = 'OUT' THEN quantity_moved
    ELSE 0
    END) AS Product_sold
FROM products_data p
JOIN inventory_movements_data i ON p.product_id = i.product_id
WHERE i.movement_date BETWEEN '2024-01-01' AND '2024-09-31'
GROUP BY p.product_id, i.movement_date
ORDER BY p.product_id, i.movement_date ASC;

-- Method 2
SELECT product_id, movement_date,
sum(CASE WHEN movement_type = 'IN' THEN quantity_moved
    ELSE 0
    END )AS Product_restocked,
sum(CASE WHEN movement_type = 'OUT' THEN quantity_moved
    ELSE 0
    END) AS Product_sold
FROM inventory_movements_data
GROUP BY product_id, movement_date
ORDER BY product_id;

-- 8. Rank Products: Rank products in each category by their prices.

SELECT *,
DENSE_RANK() OVER(PARTITION BY category ORDER BY price) as Ranking
FROM products_data
ORDER BY category;

-- Module 4: Advanced Analytics

--  9. Average order size: What is the average order size in terms of quantity sold for each product?

SELECT product_id, product_name, category, stock_quantity as Average_Order_Size 
FROM products_data
ORDER BY product_id, Average_Order_Size;

--  10. Recent Restock Product: Which products have seen the most recent restocks

SELECT i.product_id, i.movement_type, sum(i.quantity_moved) AS Stock_status, p.product_name, p.category, p.stock_quantity
FROM inventory_movements_data i
JOIN    (SELECT product_id, product_name, category, stock_quantity
		 FROM products_data
         GROUP BY product_id, product_name, category, stock_quantity) p
ON i.product_id = p.product_id
WHERE i.movement_type = "IN"
GROUP BY i.product_id, i.movement_type, p.product_name, p.category, p.stock_quantity
ORDER BY i.product_id, Stock_status DESC;



SELECT i.product_id, sum(i.quantity_moved), i.movement_type
FROM inventory_movements_data i
JOIN products_data p ON i.product_id = i.product_id
WHERE movement_type = 'IN'
ORDER BY product_id;


-- Advanced Challenges

--  Dynamic Pricing Simulation: Challenge students to analyze how price changes for products impact sales volume, revenue, and customer behavior.

SELECT p.product_id, p.product_name, round(AVG(s.total_amount),1) AS avg_price_last_12_months,
round(SUM(s.quantity_sold),1) AS total_quantity_sold
FROM products_data p
JOIN sales_data s ON p.product_id = s.product_id
WHERE s.sale_date BETWEEN CURDATE() - INTERVAL 12 MONTH AND CURDATE()
GROUP BY p.product_id, p.product_name;

SELECT p.product_name, round(SUM(s.total_amount),1) AS total_revenue_last_12_months
FROM products_data p
JOIN sales_data s ON p.product_id = s.product_id
WHERE s.sale_date BETWEEN CURDATE() - INTERVAL 12 MONTH AND CURDATE()
GROUP BY p.product_name;

SELECT * FROM customers_data;

SELECT c.customer_id, p.product_name, round(SUM(s.quantity_sold),1) AS quantity_purchased
FROM customers_data c
JOIN sales_data s ON c.customer_id = s.customer_id
JOIN products_data p ON s.product_id = p.product_id
WHERE s.sale_date BETWEEN CURDATE() - INTERVAL 12 MONTH AND CURDATE()
GROUP BY c.customer_id, p.product_name;

SELECT * FROM sales_data;

SELECT c.customer_id, COUNT(DISTINCT p.product_id) AS products_purchased, 
round(AVG(s.total_amount),1) AS avg_revenue_per_customer
FROM customers_data c
JOIN sales_data s ON c.customer_id = s.customer_id
JOIN products_data p ON s.product_id = p.product_id
WHERE s.sale_date BETWEEN CURDATE() - INTERVAL 12 MONTH AND CURDATE()
GROUP BY c.customer_id;


-- Customer Purchase Patterns: Analyze purchase patterns using time-series data and window functions to find high-frequency buying behavior.

-- The query will tell us about the customer data
SELECT customer_id, first_name, last_name
FROM customers_data;

-- This query will give us the sale data for each customer
SELECT sale_id, customer_id, sale_date, quantity_sold, total_amount
FROM sales_data;

-- Now I need to measure the sale interval by calculating the number of days between the purchasing dates
SELECT customer_id, sale_date as current_set, 
LAG(sale_date) OVER(PARTITION BY customer_id ORDER BY sale_date) AS previous_set,
DATEDIFF(sale_date, LAG(sale_date) OVER(PARTITION BY customer_id ORDER BY sale_date)) AS Difference_of_days
FROM sales_data;

-- We need to aggregate data to calculate the Customer Behaviour on Sales
SELECT customer_id, count(*), round(sum(total_amount),2), AVG(DATEDIFF(sale_date, LAG(sale_date) OVER(PARTITION BY customer_id ORDER BY sale_date))) 
FROM sales_data
GROUP BY 1;

-- Now we'll write the final query

WITH Purchase_Intervals AS 
(
	SELECT customer_id, sale_date, total_amount,
    DATEDIFF(sale_date, LAG(sale_date) OVER(PARTITION BY customer_id ORDER BY sale_date)) AS Difference_of_days
    FROM sales_data

),

Purchase_Patterns AS 
(
	SELECT customer_id, ROUND(SUM(total_amount),2) AS Total_Spent,
    COUNT(*) AS Total_purchasing,
    ROUND(AVG(Difference_of_days),2) AS Average_day_of_purchase
    FROM Purchase_Intervals
    GROUP BY customer_id
)

SELECT c.customer_id, pi.Difference_of_days, pp.Total_Spent, pp.Total_purchasing, pp.Average_day_of_purchase 
FROM customers_data c
JOIN Purchase_Intervals pi ON c.customer_id = pi.customer_id
JOIN Purchase_Patterns pp ON c.customer_id = pp.customer_id
ORDER BY pi.Difference_of_days, pp.Total_purchasing DESC, pp.Average_day_of_purchase DESC;

-- Predictive Analytics: Use past data to predict which customers are most likely to churn and recommend strategies to retain them.

select timestampdiff(year, '2021-12-13','2024-12-24');


SELECT 
	customer_id,
    MAX(sale_date) AS Last_Order_Purchased,
    TIMESTAMPDIFF(MONTH, MAX(sale_date), CURDATE()) AS Month_Since_Last_Order
FROM sales_data
GROUP BY customer_id
HAVING Month_Since_Last_Order >= 6
ORDER BY customer_id;

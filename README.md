# SQL-Portfolio-Project
Project Title: Retail Sales and Customer Insights Analysis
Project Overview:
This SQL project focuses on analyzing sales, customer, and product data for a fictional retail company. By using advanced SQL techniques, the goal is to uncover valuable insights such as sales trends, customer segmentation, product profitability, and inventory management efficiency.

Dataset Description:
1. Customers Table

customer_id (Primary Key)
first_name
last_name
email
gender
date_of_birth
registration_date
last_purchase_date
2. Products Table

product_id (Primary Key)
product_name
category
price
stock_quantity (How many items are left in inventory)
date_added
3. Sales Table

sale_id (Primary Key)
customer_id (Foreign Key)
product_id (Foreign Key)
quantity_sold
sale_date
discount_applied (Percentage Discount)
total_amount (Price * quantity_sold * discount_applied)
4. Inventory Movements Table

movement_id (Primary Key)
product_id (Foreign Key)
movement_type ('IN' for restock, 'OUT' for sales)
quantity_moved
movement_date
Key Objectives and Questions:
Module 1: Sales Performance Analysis
Total Sales per Month:

Calculate the total sales amount per month, including the number of units sold and the total revenue generated.
Average Discount per Month:

Calculate the average discount applied to sales in each month and assess how discounting strategies impact total sales.
Module 2: Customer Behavior and Insights
Identify High-Value Customers:

Identify customers who have spent the most on their purchases and display their details.
Identify the Oldest Customer:

Find the details of customers born in the 1990s, including their total spending and specific order details.
Customer Segmentation:

Use SQL to create customer segments based on total spending (e.g., Low Spenders, High Spenders).
Module 3: Inventory and Product Management
Stock Management:

Write a query to find products that are running low in stock (below a threshold like 10 units) and recommend restocking amounts based on past sales performance.
Inventory Movements Overview:

Create a report showing the daily inventory movements (restock vs. sales) for each product over a given period.
Rank Products:

Rank products in each category by their prices.
Module 4: Advanced Analytics
Average Order Size:

Determine the average order size in terms of quantity sold for each product.
Recent Restock Product:

Identify products that have seen the most recent restocks.
Advanced Features to Challenge Students:
Dynamic Pricing Simulation: Analyze how price changes for products impact sales volume, revenue, and customer behavior.
Customer Purchase Patterns: Use time-series data and window functions to analyze purchase patterns and identify high-frequency buying behavior.
Predictive Analytics: Use past data to predict which customers are most likely to churn and recommend strategies for retention.
Final Project Deliverable:
Deliver a comprehensive report that answers the key business questions, utilizing advanced SQL features such as:
CTEs (Common Table Expressions)
Window Functions
Subqueries
JOINs
Aggregation (SUM, AVG, COUNT)
GROUP BY and HAVING

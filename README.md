# SQL-Portfolio-Project
# Project Title: Retail Sales and Customer Insights Analysis

# Project Overview:
This SQL project focuses on analyzing sales, customer, and product data for a fictional retail company. By using advanced SQL techniques, the goal is to uncover valuable insights such as sales trends, customer segmentation, product profitability, and inventory management efficiency.

Dataset Description

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

Key Objectives and Questions

Module 1: Sales Performance Analysis

1. Total Sales per Month

Calculate the total sales amount per month, including the number of units sold and the total revenue generated.

2. Average Discount per Month

Calculate the average discount applied to sales in each month and assess how discounting strategies impact total sales.

Module 2: Customer Behavior and Insights

3. Identify High-Value Customers

Which customers have spent the most on their purchases? Show their details.

4. Identify the Oldest Customers

Find the details of customers born in the 1990s, including their total spending and specific order details.

5. Customer Segmentation

Use SQL to create customer segments based on their total spending (e.g., Low Spenders, High Spenders).

Module 3: Inventory and Product Management

6. Stock Management

Write a query to find products that are running low in stock (below a threshold like 10 units) and recommend restocking amounts based on past sales performance.

7. Inventory Movements Overview

Create a report showing the daily inventory movements (restock vs. sales) for each product over a given period.

8. Rank Products

Rank products in each category by their prices.

Module 4: Advanced Analytics

9. Average Order Size

What is the average order size in terms of quantity sold for each product?

10. Recent Restock Product

Which products have seen the most recent restocks?

Advanced Features to Challenge Students

Dynamic Pricing Simulation: Analyze how price changes for products impact sales volume, revenue, and customer behavior.

Customer Purchase Patterns: Use time-series data and window functions to analyze high-frequency buying behavior.

Predictive Analytics: Use past data to predict which customers are most likely to churn and recommend retention strategies.

Final Project Deliverable

Deliver a comprehensive report that answers the key business questions using advanced SQL features such as:

CTEs

Window Functions

Subqueries

JOINs

Aggregation (SUM, AVG, COUNT)

GROUP BY and HAVING


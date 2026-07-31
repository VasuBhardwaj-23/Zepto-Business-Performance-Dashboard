/*
======================================================================
MODULE 1: PRODUCT ANALYTICS

Description:
This module focuses on analyzing Zepto's product catalog to understand
product availability, brand distribution, category performance, and
pricing trends. These insights help the Product Management team make
better assortment and pricing decisions.

Business Stakeholders:
• Product Manager
• Category Manager
• Merchandising Team

======================================================================
*/

USE Zepto_DB;

/*
======================================================================
Business Question 1

Department:
Product Analytics

Business Requirement:

The Product Management team wants to know the total
number of products currently available on the platform.

======================================================================
*/

SELECT COUNT(*) AS Total_Products
FROM Products;

/*
======================================================================
Business Question 2

Department:
Product Analytics

Business Requirement:

The Product Management team wants to know the total
number of active brands available on the platform.

======================================================================
*/

SELECT COUNT(*) AS Total_Active_Brands
FROM Brands
WHERE is_active = 1;

/*
======================================================================
Business Question 3

Department:
Product Analytics

Business Requirement:

The Product Management team wants to know the total
number of active product categories available on the
platform.

======================================================================
*/

SELECT COUNT(*) AS Total_Active_Categories
FROM Categories
WHERE is_active = 1;

/*
======================================================================
Business Question 4

Department:
Product Analytics

Business Requirement:

The Product Management team wants to analyze the
number of products available in each category.

======================================================================
*/

SELECT
    c.category_name,
    COUNT(p.product_id) AS Total_Products
FROM Products AS p
INNER JOIN Categories AS c
    ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY Total_Products DESC;

/*
======================================================================
Business Question 5

Department:
Product Analytics

Business Requirement:

The Product Management team wants to identify the
top 5 product categories with the highest number of
products available on the platform.

======================================================================
*/

SELECT TOP 5
    c.category_name,
    COUNT(p.product_id) AS Total_Products
FROM Products AS p
INNER JOIN Categories AS c
    ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY Total_Products DESC;

/*
======================================================================
Business Question 6

Department:
Product Analytics

Business Requirement:

The Product Management team wants to analyze the
number of products available under each brand.

======================================================================
*/

SELECT
    b.brand_name,
    COUNT(p.product_id) AS Total_Products
FROM Products AS p
INNER JOIN Brands AS b
    ON p.brand_id = b.brand_id
GROUP BY b.brand_name
ORDER BY Total_Products DESC;

/*
======================================================================
Business Question 7

Department:
Product Analytics

Business Requirement:

The Product Management team wants to identify the
top 10 most expensive products based on MRP.

======================================================================
*/

SELECT TOP 10
    p.product_name,
    b.brand_name,
    c.category_name,
    p.mrp
FROM Products AS p
INNER JOIN Brands AS b
    ON p.brand_id = b.brand_id
INNER JOIN Categories AS c
    ON p.category_id = c.category_id
ORDER BY p.mrp DESC;

/*
======================================================================
Business Question 8

Department:
Product Analytics

Business Requirement:

The Product Management team wants to identify the
top 10 highest-rated products available on the
platform.

======================================================================
*/

SELECT TOP 10
    p.product_name,
    b.brand_name,
    c.category_name,
    p.rating
FROM Products AS p
INNER JOIN Brands AS b
    ON p.brand_id = b.brand_id
INNER JOIN Categories AS c
    ON p.category_id = c.category_id
ORDER BY p.rating DESC, p.product_name ASC;

/*
======================================================================
Business Question 9

Department:
Product Analytics

Business Requirement:

The Product Management team wants to compare the
average selling price across different product
categories.

======================================================================
*/

SELECT
    c.category_name,
    CAST(AVG(p.selling_price) AS DECIMAL(10,2)) AS Average_Selling_Price
FROM Products AS p
INNER JOIN Categories AS c
    ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY Average_Selling_Price DESC;

/*
======================================================================
Business Question 10

Department:
Product Analytics

Business Requirement:

The Product Management team wants to identify the
products currently being sold below their MRP.

======================================================================
*/

SELECT
    p.product_name,
    b.brand_name,
    c.category_name,
    p.mrp,
    p.selling_price,
    CAST((p.mrp - p.selling_price) AS DECIMAL(10,2)) AS Discount_Amount
FROM Products AS p
INNER JOIN Brands AS b
    ON p.brand_id = b.brand_id
INNER JOIN Categories AS c
    ON p.category_id = c.category_id
WHERE p.selling_price < p.mrp
ORDER BY Discount_Amount DESC;


/*
======================================================================
MODULE 2 : SALES ANALYTICS
======================================================================
*/

/*
======================================================================
Business Question 1

Department:
Sales Analytics

Business Requirement:

The Sales Management team wants to know the total
sales revenue generated on the platform.

======================================================================
*/

SELECT
    CAST(SUM(total_amount) AS DECIMAL(12,2)) AS Total_Sales_Revenue
FROM Customer_Orders
WHERE order_status = 'Delivered';

/*
======================================================================
Business Question 2

Department:
Sales Analytics

Business Requirement:

The Sales Management team wants to know the total
number of orders placed on the platform.

======================================================================
*/

SELECT
    COUNT(order_id) AS Total_Orders
FROM Customer_Orders;

/*
======================================================================
Business Question 3

Department:
Sales Analytics

Business Requirement:

The Sales Management team wants to calculate the
average order value for all successfully delivered
orders on the platform.

======================================================================
*/

SELECT
    CAST(AVG(total_amount) AS DECIMAL(10,2)) AS Average_Order_Value
FROM Customer_Orders
WHERE order_status = 'Delivered';

/*
======================================================================
Business Question 4

Department:
Sales Analytics

Business Requirement:

The Sales Management team wants to analyze the
distribution of orders by their current status.

======================================================================
*/

SELECT
    order_status,
    COUNT(order_id) AS Total_Orders
FROM Customer_Orders
GROUP BY order_status
ORDER BY Total_Orders DESC;

/*
======================================================================
Business Question 5

Department:
Sales Analytics

Business Requirement:

The Sales Management team wants to analyze customer
payment preferences across different payment methods.

======================================================================
*/

SELECT
    payment_method,
    COUNT(order_id) AS Total_Orders
FROM Customer_Orders
GROUP BY payment_method
ORDER BY Total_Orders DESC;

/*
======================================================================
Business Question 6

Department:
Sales Analytics

Business Requirement:

The Sales Management team wants to analyze the
total sales revenue generated through each payment
method.

======================================================================
*/

SELECT
    payment_method,
    CAST(SUM(total_amount) AS DECIMAL(12,2)) AS Total_Revenue
FROM Customer_Orders
WHERE order_status = 'Delivered'
GROUP BY payment_method
ORDER BY Total_Revenue DESC;

/*
======================================================================
Business Question 7

Department:
Sales Analytics

Business Requirement:

The Sales Management team wants to analyze the
monthly sales revenue trend on the platform.

======================================================================
*/

SELECT
    DATENAME(MONTH, order_date) AS Month_Name,
    CAST(SUM(total_amount) AS DECIMAL(12,2)) AS Total_Revenue
FROM Customer_Orders
WHERE order_status = 'Delivered'
GROUP BY
    MONTH(order_date),
    DATENAME(MONTH, order_date)
ORDER BY
    MONTH(order_date);

/*
======================================================================
Business Question 8

Department:
Sales Analytics

Business Requirement:

The Sales Management team wants to analyze the
total sales revenue generated by each dark store.

======================================================================
*/

SELECT
    ds.store_name,
    ds.city,
    CAST(SUM(co.total_amount) AS DECIMAL(12,2)) AS Total_Revenue
FROM Customer_Orders AS co
INNER JOIN Dark_Stores AS ds
    ON co.store_id = ds.store_id
WHERE co.order_status = 'Delivered'
GROUP BY
    ds.store_name,
    ds.city
ORDER BY Total_Revenue DESC;

/*
======================================================================
Business Question 9

Department:
Sales Analytics

Business Requirement:

The Sales Management team wants to identify the
top 10 highest-value customer orders based on
their total order amount.

======================================================================
*/

SELECT TOP 10
    co.order_id,
    c.customer_name,
    ds.store_name,
    CAST(co.total_amount AS DECIMAL(10,2)) AS Order_Value
FROM Customer_Orders AS co
INNER JOIN Customers AS c
    ON co.customer_id = c.customer_id
INNER JOIN Dark_Stores AS ds
    ON co.store_id = ds.store_id
WHERE co.order_status = 'Delivered'
ORDER BY co.total_amount DESC;

/*
======================================================================
Business Question 10

Department:
Sales Analytics

Business Requirement:

The Sales Management team wants to identify the
top 5 customers based on total purchase value.

======================================================================
*/

SELECT TOP 5
    c.customer_name,
    COUNT(co.order_id) AS Total_Orders,
    CAST(SUM(co.total_amount) AS DECIMAL(12,2)) AS Total_Spent
FROM Customer_Orders AS co
INNER JOIN Customers AS c
    ON co.customer_id = c.customer_id
WHERE co.order_status = 'Delivered'
GROUP BY c.customer_name
ORDER BY Total_Spent DESC;

/*
======================================================================
MODULE 3 : CUSTOMER ANALYTICS
======================================================================
*/

/*
======================================================================
Business Question 1

Department:
Customer Analytics

Business Requirement:

The Customer Success team wants to know the total
number of registered customers on the platform.

======================================================================
*/

SELECT
    COUNT(customer_id) AS Total_Customers
FROM Customers;

/*
======================================================================
Business Question 2

Department:
Customer Analytics

Business Requirement:

The Customer Success team wants to analyze the
distribution of customers based on gender.

======================================================================
*/

SELECT
    gender,
    COUNT(customer_id) AS Total_Customers,
    CAST(
        COUNT(customer_id) * 100.0 /
        SUM(COUNT(customer_id)) OVER()
    AS DECIMAL(5,2)) AS Customer_Percentage
FROM Customers
GROUP BY gender
ORDER BY Total_Customers DESC;

/*
======================================================================
Business Question 3

Department:
Customer Analytics

Business Requirement:

The Customer Success team wants to analyze the
distribution of customers based on membership type.

======================================================================
*/

SELECT
    membership_type,
    COUNT(customer_id) AS Total_Customers,
    CAST(
        COUNT(customer_id) * 100.0 /
        SUM(COUNT(customer_id)) OVER()
    AS DECIMAL(5,2)) AS Customer_Percentage
FROM Customers
GROUP BY membership_type
ORDER BY Total_Customers DESC;

/*
======================================================================
Business Question 4

Department:
Customer Analytics

Business Requirement:

The Customer Success team wants to identify the
top 10 cities with the highest number of registered
customers.

======================================================================
*/

SELECT TOP 10
    city,
    COUNT(customer_id) AS Total_Customers
FROM Customers
GROUP BY city
ORDER BY Total_Customers DESC;

/*
======================================================================
Business Question 5

Department:
Customer Analytics

Business Requirement:

The Customer Success team wants to calculate the
average age of registered customers on the platform.

======================================================================
*/

SELECT
    CAST(AVG(age) AS DECIMAL(5,2)) AS Average_Customer_Age
FROM Customers;

/*
======================================================================
Business Question 6

Department:
Customer Analytics

Business Requirement:

The Customer Success team wants to analyze the
distribution of customers across different age groups.

======================================================================
*/

SELECT
    CASE
        WHEN age BETWEEN 18 AND 25 THEN '18-25'
        WHEN age BETWEEN 26 AND 35 THEN '26-35'
        WHEN age BETWEEN 36 AND 45 THEN '36-45'
        WHEN age BETWEEN 46 AND 55 THEN '46-55'
        ELSE '56+'
    END AS Age_Group,

    COUNT(customer_id) AS Total_Customers,

    CAST(
        COUNT(customer_id) * 100.0 /
        SUM(COUNT(customer_id)) OVER()
    AS DECIMAL(5,2)) AS Customer_Percentage

FROM Customers

GROUP BY
    CASE
        WHEN age BETWEEN 18 AND 25 THEN '18-25'
        WHEN age BETWEEN 26 AND 35 THEN '26-35'
        WHEN age BETWEEN 36 AND 45 THEN '36-45'
        WHEN age BETWEEN 46 AND 55 THEN '46-55'
        ELSE '56+'
    END

ORDER BY Age_Group;

/*
======================================================================
Business Question 7

Department:
Customer Analytics

Business Requirement:

The Customer Success team wants to analyze the
monthly customer registration trend on the platform.

======================================================================
*/

SELECT
    DATENAME(MONTH, signup_date) AS Month_Name,
    COUNT(customer_id) AS Total_Registrations
FROM Customers
GROUP BY
    MONTH(signup_date),
    DATENAME(MONTH, signup_date)
ORDER BY
    MONTH(signup_date);

/*
======================================================================
Business Question 8

Department:
Customer Analytics

Business Requirement:

The Customer Success team wants to identify the
top 10 customers based on their total spending.

======================================================================
*/

SELECT TOP 10
    c.customer_name,
    COUNT(co.order_id) AS Total_Orders,
    CAST(SUM(co.total_amount) AS DECIMAL(12,2)) AS Total_Spending
FROM Customers AS c
INNER JOIN Customer_Orders AS co
    ON c.customer_id = co.customer_id
WHERE co.order_status = 'Delivered'
GROUP BY c.customer_name
ORDER BY Total_Spending DESC;

/*
======================================================================
Business Question 9

Department:
Customer Analytics

Business Requirement:

The Customer Success team wants to identify the
top 10 customers based on the number of orders placed.

======================================================================
*/

SELECT TOP 10
    c.customer_name,
    COUNT(co.order_id) AS Total_Orders,
    CAST(SUM(co.total_amount) AS DECIMAL(12,2)) AS Total_Spending
FROM Customers AS c
INNER JOIN Customer_Orders AS co
    ON c.customer_id = co.customer_id
WHERE co.order_status = 'Delivered'
GROUP BY c.customer_name
ORDER BY Total_Orders DESC, Total_Spending DESC;

/*
======================================================================
Business Question 10

Department:
Customer Analytics

Business Requirement:

The Customer Success team wants to analyze customer
spending across different membership types.

======================================================================
*/

SELECT
    c.membership_type,
    COUNT(DISTINCT c.customer_id) AS Total_Customers,
    COUNT(co.order_id) AS Total_Orders,
    CAST(SUM(co.total_amount) AS DECIMAL(12,2)) AS Total_Spending,
    CAST(AVG(co.total_amount) AS DECIMAL(10,2)) AS Average_Order_Value
FROM Customers AS c
INNER JOIN Customer_Orders AS co
    ON c.customer_id = co.customer_id
WHERE co.order_status = 'Delivered'
GROUP BY c.membership_type
ORDER BY Total_Spending DESC;

/*
======================================================================
MODULE 4 : INVENTORY ANALYTICS
======================================================================
*/

/*
======================================================================
Business Question 1

Department:
Inventory Analytics

Business Requirement:

The Inventory Management team wants to know the
total number of inventory records across all
dark stores.

======================================================================
*/

SELECT
    COUNT(inventory_id) AS Total_Inventory_Items
FROM Inventory;

/*
======================================================================
Business Question 2

Department:
Inventory Analytics

Business Requirement:

The Inventory Management team wants to analyze the
total available stock for each product across all
dark stores.

======================================================================
*/

SELECT
    p.product_name,
    SUM(i.stock_quantity) AS Total_Stock
FROM Inventory AS i
INNER JOIN Products AS p
    ON i.product_id = p.product_id
GROUP BY p.product_name
ORDER BY Total_Stock DESC;

/*
======================================================================
Business Question 3

Department:
Inventory Analytics

Business Requirement:

The Inventory Management team wants to identify the
top 10 products with the highest stock available
across all dark stores.

======================================================================
*/

SELECT TOP 10
    p.product_name,
    b.brand_name,
    c.category_name,
    SUM(i.stock_quantity) AS Total_Stock
FROM Inventory AS i
INNER JOIN Products AS p
    ON i.product_id = p.product_id
INNER JOIN Brands AS b
    ON p.brand_id = b.brand_id
INNER JOIN Categories AS c
    ON p.category_id = c.category_id
GROUP BY
    p.product_name,
    b.brand_name,
    c.category_name
ORDER BY Total_Stock DESC;

/*
======================================================================
Business Question 4

Department:
Inventory Analytics

Business Requirement:

The Inventory Management team wants to identify the
top 10 products with the lowest stock available
across all dark stores.

======================================================================
*/

SELECT TOP 10
    p.product_name,
    b.brand_name,
    c.category_name,
    SUM(i.stock_quantity) AS Total_Stock
FROM Inventory i
INNER JOIN Products p
    ON i.product_id = p.product_id
INNER JOIN Brands b
    ON p.brand_id = b.brand_id
INNER JOIN Categories c
    ON p.category_id = c.category_id
GROUP BY
    p.product_name,
    b.brand_name,
    c.category_name
ORDER BY Total_Stock ASC;

/*
======================================================================
Business Question 5

Department:
Inventory Analytics

Business Requirement:

The Inventory Management team wants to identify
products where the available stock has fallen
below the reorder level.

======================================================================
*/

SELECT
    p.product_name,
    b.brand_name,
    c.category_name,
    ds.store_name,
    i.stock_quantity,
    i.reorder_level
FROM Inventory i
INNER JOIN Products p
    ON i.product_id = p.product_id
INNER JOIN Brands b
    ON p.brand_id = b.brand_id
INNER JOIN Categories c
    ON p.category_id = c.category_id
INNER JOIN Dark_Stores ds
    ON i.store_id = ds.store_id
WHERE i.stock_quantity < i.reorder_level
ORDER BY
    i.stock_quantity ASC,
    i.reorder_level DESC;

/*
======================================================================
Business Question 6

Department:
Inventory Analytics

Business Requirement:

The Inventory Management team wants to analyze the
average stock quantity available across each
dark store.

======================================================================
*/

SELECT
    ds.store_name,
    ds.city,
    CAST(AVG(i.stock_quantity) AS DECIMAL(10,2)) AS Average_Stock
FROM Inventory i
INNER JOIN Dark_Stores ds
    ON i.store_id = ds.store_id
GROUP BY
    ds.store_name,
    ds.city
ORDER BY Average_Stock DESC;

/*
======================================================================
Business Question 7

Department:
Inventory Analytics

Business Requirement:

The Inventory Management team wants to analyze the
total inventory available across different product
categories.

======================================================================
*/

SELECT
    c.category_name,
    SUM(i.stock_quantity) AS Total_Stock
FROM Inventory i
INNER JOIN Products p
    ON i.product_id = p.product_id
INNER JOIN Categories c
    ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY Total_Stock DESC;

/*
======================================================================
Business Question 8

Department:
Inventory Analytics

Business Requirement:

The Inventory Management team wants to analyze the
total inventory available across all dark stores.

======================================================================
*/

SELECT
    ds.store_name,
    ds.city,
    SUM(i.stock_quantity) AS Total_Stock
FROM Inventory i
INNER JOIN Dark_Stores ds
    ON i.store_id = ds.store_id
GROUP BY
    ds.store_name,
    ds.city
ORDER BY Total_Stock DESC;

/*
======================================================================
Business Question 9

Department:
Inventory Analytics

Business Requirement:

The Inventory Management team wants to identify the
products that are available in the highest number
of dark stores.

======================================================================
*/

SELECT
    p.product_name,
    b.brand_name,
    c.category_name,
    COUNT(DISTINCT i.store_id) AS Available_In_Stores
FROM Inventory i
INNER JOIN Products p
    ON i.product_id = p.product_id
INNER JOIN Brands b
    ON p.brand_id = b.brand_id
INNER JOIN Categories c
    ON p.category_id = c.category_id
WHERE i.stock_quantity > 0
GROUP BY
    p.product_name,
    b.brand_name,
    c.category_name
ORDER BY Available_In_Stores DESC;

/*
======================================================================
Business Question 10

Department:
Inventory Analytics

Business Requirement:

The Inventory Management team wants to identify the
top 10 products with the highest inventory value
across all dark stores.

======================================================================
*/

SELECT TOP 10
    p.product_name,
    b.brand_name,
    c.category_name,
    SUM(i.stock_quantity) AS Total_Stock,
    CAST(SUM(i.stock_quantity * p.selling_price) AS DECIMAL(12,2)) AS Inventory_Value
FROM Inventory i
INNER JOIN Products p
    ON i.product_id = p.product_id
INNER JOIN Brands b
    ON p.brand_id = b.brand_id
INNER JOIN Categories c
    ON p.category_id = c.category_id
GROUP BY
    p.product_name,
    b.brand_name,
    c.category_name
ORDER BY Inventory_Value DESC;

/*
======================================================================
MODULE 5 : DARK STORE ANALYTICS
======================================================================
*/

/*
======================================================================
Business Question 1

Department:
Dark Store Analytics

Business Requirement:

The Operations team wants to know the total
number of dark stores currently available
on the platform.

======================================================================
*/

SELECT
    COUNT(store_id) AS Total_Dark_Stores
FROM Dark_Stores;

/*
======================================================================
Business Question 2

Department:
Dark Store Analytics

Business Requirement:

The Operations team wants to analyze the
distribution of dark stores across different
cities.

======================================================================
*/

SELECT
    city,
    COUNT(store_id) AS Total_Dark_Stores,
    CAST(
        COUNT(store_id) * 100.0 /
        SUM(COUNT(store_id)) OVER()
    AS DECIMAL(5,2)) AS Store_Percentage
FROM Dark_Stores
GROUP BY city
ORDER BY Total_Dark_Stores DESC;

/*
======================================================================
Business Question 3

Department:
Dark Store Analytics

Business Requirement:

The Operations team wants to analyze the
distribution of dark stores across different
states.

======================================================================
*/

SELECT
    state,
    COUNT(store_id) AS Total_Dark_Stores,
    CAST(
        COUNT(store_id) * 100.0 /
        SUM(COUNT(store_id)) OVER()
    AS DECIMAL(5,2)) AS Store_Percentage
FROM Dark_Stores
GROUP BY state
ORDER BY Total_Dark_Stores DESC;

/*
======================================================================
Business Question 4

Department:
Dark Store Analytics

Business Requirement:

The Operations team wants to analyze the
operational status of all dark stores.

======================================================================
*/

SELECT
    operating_status,
    COUNT(store_id) AS Total_Dark_Stores,
    CAST(
        COUNT(store_id) * 100.0 /
        SUM(COUNT(store_id)) OVER()
    AS DECIMAL(5,2)) AS Store_Percentage
FROM Dark_Stores
GROUP BY operating_status
ORDER BY Total_Dark_Stores DESC;

/*
======================================================================
Business Question 5

Department:
Dark Store Analytics

Business Requirement:

The Operations team wants to identify the
total number of customer orders processed
by each dark store.

======================================================================
*/

SELECT
    ds.store_name,
    ds.city,
    COUNT(co.order_id) AS Total_Orders
FROM Dark_Stores ds
INNER JOIN Customer_Orders co
    ON ds.store_id = co.store_id
GROUP BY
    ds.store_name,
    ds.city
ORDER BY Total_Orders DESC;

/*
======================================================================
Business Question 6

Department:
Dark Store Analytics

Business Requirement:

The Operations team wants to analyze the
total sales revenue generated by each
dark store.

======================================================================
*/

SELECT
    ds.store_name,
    ds.city,
    CAST(SUM(co.total_amount) AS DECIMAL(12,2)) AS Total_Revenue
FROM Dark_Stores ds
LEFT JOIN Customer_Orders co
    ON ds.store_id = co.store_id
WHERE co.order_status = 'Delivered'
GROUP BY
    ds.store_name,
    ds.city
ORDER BY Total_Revenue DESC;

/*
======================================================================
Business Question 7

Department:
Dark Store Analytics

Business Requirement:

The Operations team wants to analyze the
average order value generated by each
dark store.

======================================================================
*/

SELECT
    ds.store_name,
    ds.city,
    COUNT(co.order_id) AS Total_Orders,
    CAST(AVG(co.total_amount) AS DECIMAL(10,2)) AS Average_Order_Value
FROM Dark_Stores ds
LEFT JOIN Customer_Orders co
    ON ds.store_id = co.store_id
   AND co.order_status = 'Delivered'
GROUP BY
    ds.store_name,
    ds.city
ORDER BY Average_Order_Value DESC;

/*
======================================================================
Business Question 8

Department:
Dark Store Analytics

Business Requirement:

The Operations team wants to analyze the
current inventory value held by each
dark store.

======================================================================
*/

SELECT
    ds.store_name,
    ds.city,
    CAST(SUM(i.stock_quantity * p.selling_price) AS DECIMAL(12,2)) AS Inventory_Value
FROM Dark_Stores ds
INNER JOIN Inventory i
    ON ds.store_id = i.store_id
INNER JOIN Products p
    ON i.product_id = p.product_id
GROUP BY
    ds.store_name,
    ds.city
ORDER BY Inventory_Value DESC;

/*
======================================================================
Business Question 9

Department:
Dark Store Analytics

Business Requirement:

The Operations team wants to identify the
top 10 best-performing dark stores based on
their sales revenue and total orders.

======================================================================
*/

SELECT TOP 10
    ds.store_name,
    ds.city,
    COUNT(co.order_id) AS Total_Orders,
    CAST(SUM(co.total_amount) AS DECIMAL(12,2)) AS Total_Revenue,
    CAST(AVG(co.total_amount) AS DECIMAL(10,2)) AS Average_Order_Value
FROM Dark_Stores ds
LEFT JOIN Customer_Orders co
    ON ds.store_id = co.store_id
   AND co.order_status = 'Delivered'
GROUP BY
    ds.store_name,
    ds.city
ORDER BY
    Total_Revenue DESC,
    Total_Orders DESC;

/*
======================================================================
Business Question 10

Department:
Dark Store Analytics

Business Requirement:

The Operations team wants to compare the
overall performance of each city based on
the number of dark stores, total orders,
and total sales revenue.

======================================================================
*/

SELECT
    ds.city,
    COUNT(DISTINCT ds.store_id) AS Total_Dark_Stores,
    COUNT(co.order_id) AS Total_Orders,
    CAST(SUM(co.total_amount) AS DECIMAL(12,2)) AS Total_Revenue,
    CAST(AVG(co.total_amount) AS DECIMAL(10,2)) AS Average_Order_Value
FROM Dark_Stores ds
LEFT JOIN Customer_Orders co
    ON ds.store_id = co.store_id
   AND co.order_status = 'Delivered'
GROUP BY
    ds.city
ORDER BY
    Total_Revenue DESC;

/*
======================================================================
MODULE 6 : ORDER ANALYTICS
======================================================================
*/

/*
======================================================================
Business Question 1

Department:
Order Analytics

Business Requirement:

The Order Management team wants to analyze
the total number of orders for each order
status.

======================================================================
*/

SELECT
    order_status,
    COUNT(order_id) AS Total_Orders
FROM Customer_Orders
GROUP BY order_status
ORDER BY Total_Orders DESC;

/*
======================================================================
Business Question 2

Department:
Order Analytics

Business Requirement:

The Order Management team wants to analyze
the percentage distribution of orders based
on their current status.

======================================================================
*/

SELECT
    order_status,
    COUNT(order_id) AS Total_Orders,
    CAST(
        COUNT(order_id) * 100.0 /
        SUM(COUNT(order_id)) OVER()
    AS DECIMAL(5,2)) AS Order_Percentage
FROM Customer_Orders
GROUP BY order_status
ORDER BY Total_Orders DESC;

/*
======================================================================
Business Question 3

Department:
Order Analytics

Business Requirement:

The Order Management team wants to analyze
the average delivery time for each order
status.

======================================================================
*/

SELECT
    order_status,
    COUNT(order_id) AS Total_Orders,
    CAST(AVG(delivery_time_minutes) AS DECIMAL(10,2)) AS Average_Delivery_Time_Minutes
FROM Customer_Orders
WHERE delivery_time_minutes IS NOT NULL
GROUP BY order_status
ORDER BY Average_Delivery_Time_Minutes;

/*
======================================================================
Business Question 4

Department:
Order Analytics

Business Requirement:

The Order Management team wants to analyze
how many customer orders were successfully
delivered within 30 minutes.

======================================================================
*/

SELECT
    COUNT(order_id) AS Orders_Delivered_Within_30_Minutes,
    CAST(
        COUNT(order_id) * 100.0 /
        (
            SELECT COUNT(*)
            FROM Customer_Orders
            WHERE order_status = 'Delivered'
        )
    AS DECIMAL(5,2)) AS Delivery_Success_Rate_Percentage
FROM Customer_Orders
WHERE order_status = 'Delivered'
  AND delivery_time_minutes <= 30;

/*
======================================================================
Business Question 5

Department:
Order Analytics

Business Requirement:

The Order Management team wants to analyze
the average order value for each order
status.

======================================================================
*/

SELECT
    order_status,
    COUNT(order_id) AS Total_Orders,
    CAST(AVG(total_amount) AS DECIMAL(10,2)) AS Average_Order_Value,
    CAST(SUM(total_amount) AS DECIMAL(12,2)) AS Total_Revenue
FROM Customer_Orders
GROUP BY order_status
ORDER BY Average_Order_Value DESC;

/*
======================================================================
Business Question 6

Department:
Order Analytics

Business Requirement:

The Order Management team wants to analyze
the daily order volume and revenue trend.

======================================================================
*/

SELECT
    order_date,
    COUNT(order_id) AS Total_Orders,
    CAST(SUM(total_amount) AS DECIMAL(12,2)) AS Total_Revenue
FROM Customer_Orders
WHERE order_status = 'Delivered'
GROUP BY order_date
ORDER BY order_date;

/*
======================================================================
Business Question 7

Department:
Order Analytics

Business Requirement:

The Order Management team wants to identify
the peak order hours to optimize delivery
operations and workforce planning.

======================================================================
*/

SELECT
    DATEPART(HOUR, order_time) AS Order_Hour,
    COUNT(order_id) AS Total_Orders
FROM Customer_Orders
GROUP BY DATEPART(HOUR, order_time)
ORDER BY Total_Orders DESC;

/*
======================================================================
Business Question 8

Department:
Order Analytics

Business Requirement:

The Order Management team wants to compare
customer order volume on weekdays and
weekends.

======================================================================
*/

SELECT
    CASE
        WHEN DATENAME(WEEKDAY, order_date) IN ('Saturday', 'Sunday')
            THEN 'Weekend'
        ELSE 'Weekday'
    END AS Day_Type,
    COUNT(order_id) AS Total_Orders,
    CAST(SUM(total_amount) AS DECIMAL(12,2)) AS Total_Revenue
FROM Customer_Orders
WHERE order_status = 'Delivered'
GROUP BY
    CASE
        WHEN DATENAME(WEEKDAY, order_date) IN ('Saturday', 'Sunday')
            THEN 'Weekend'
        ELSE 'Weekday'
    END
ORDER BY Total_Orders DESC;

/*
======================================================================
Business Question 9

Department:
Order Analytics

Business Requirement:

The Order Management team wants to identify
the top 10 customer orders that received the
highest discount amount.

======================================================================
*/

SELECT TOP 10
    co.order_id,
    c.customer_name,
    CAST(co.total_amount AS DECIMAL(10,2)) AS Order_Value,
    CAST(co.discount_amount AS DECIMAL(10,2)) AS Discount_Amount,
    CAST(
        (co.discount_amount * 100.0) /
        NULLIF(co.total_amount + co.discount_amount, 0)
    AS DECIMAL(5,2)) AS Discount_Percentage
FROM Customer_Orders co
INNER JOIN Customers c
    ON co.customer_id = c.customer_id
WHERE co.discount_amount > 0
ORDER BY
    co.discount_amount DESC;

/*
======================================================================
Business Question 10

Department:
Order Analytics

Business Requirement:

The Order Management team wants to generate
an overall delivery performance summary to
monitor operational efficiency.

======================================================================
*/

SELECT
    COUNT(order_id) AS Total_Orders,

    SUM(CASE
            WHEN order_status = 'Delivered' THEN 1
            ELSE 0
        END) AS Delivered_Orders,

    SUM(CASE
            WHEN order_status = 'Cancelled' THEN 1
            ELSE 0
        END) AS Cancelled_Orders,

    SUM(CASE
            WHEN order_status = 'Returned' THEN 1
            ELSE 0
        END) AS Returned_Orders,

    SUM(CASE
            WHEN order_status = 'Failed' THEN 1
            ELSE 0
        END) AS Failed_Orders,

    CAST(AVG(delivery_time_minutes) AS DECIMAL(10,2))
        AS Average_Delivery_Time_Minutes,

    CAST(
        SUM(CASE
                WHEN order_status = 'Delivered'
                 AND delivery_time_minutes <= 30
                THEN 1
                ELSE 0
            END) * 100.0
        /
        NULLIF(
            SUM(CASE
                    WHEN order_status = 'Delivered'
                    THEN 1
                    ELSE 0
                END),0
        )
    AS DECIMAL(5,2)) AS Delivery_Success_Rate_Percentage
FROM Customer_Orders;


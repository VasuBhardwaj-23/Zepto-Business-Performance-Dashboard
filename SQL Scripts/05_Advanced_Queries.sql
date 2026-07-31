/*
======================================================================
MODULE 7 : ADVANCED BUSINESS ANALYTICS
======================================================================
*/

/*
======================================================================
CTE (Common Table Expression)
======================================================================
*/

/*
======================================================================
Business Question 1

Department:
Executive Analytics

Business Requirement:

The Executive Management team wants to identify
the top 10 revenue-generating products across
all customer orders.

======================================================================
*/

WITH Product_Revenue AS
(
    SELECT
        p.product_name,
        b.brand_name,
        c.category_name,
        CAST(SUM(oi.total_price) AS DECIMAL(12,2)) AS Total_Revenue
    FROM Order_Items oi
    INNER JOIN Products p
        ON oi.product_id = p.product_id
    INNER JOIN Brands b
        ON p.brand_id = b.brand_id
    INNER JOIN Categories c
        ON p.category_id = c.category_id
    GROUP BY
        p.product_name,
        b.brand_name,
        c.category_name
)

SELECT TOP 10 *
FROM Product_Revenue
ORDER BY Total_Revenue DESC;

/*
======================================================================
CTE (Common Table Expression)
======================================================================
*/

/*
======================================================================
Business Question 2

Department:
Executive Analytics

Business Requirement:

The Executive Management team wants to identify
the highest revenue-generating product categories
across all customer orders.

======================================================================
*/

WITH Category_Revenue AS
(
    SELECT
        c.category_name,
        CAST(SUM(oi.total_price) AS DECIMAL(12,2)) AS Total_Revenue
    FROM Order_Items oi
    INNER JOIN Products p
        ON oi.product_id = p.product_id
    INNER JOIN Categories c
        ON p.category_id = c.category_id
    GROUP BY c.category_name
)

SELECT
    category_name,
    Total_Revenue
FROM Category_Revenue
ORDER BY Total_Revenue DESC;

/*
======================================================================
Window Functions
======================================================================
*/
/*
======================================================================
Business Question 3

Department:
Executive Analytics

Business Requirement:

The Executive Management team wants to identify
the top 3 highest-selling products within each
product category.

======================================================================
*/

WITH Product_Sales AS
(
    SELECT
        c.category_name,
        p.product_name,
        b.brand_name,
        CAST(SUM(oi.total_price) AS DECIMAL(12,2)) AS Total_Revenue,

        ROW_NUMBER() OVER
        (
            PARTITION BY c.category_name
            ORDER BY SUM(oi.total_price) DESC
        ) AS Row_Num

    FROM Order_Items oi

    INNER JOIN Products p
        ON oi.product_id = p.product_id

    INNER JOIN Brands b
        ON p.brand_id = b.brand_id

    INNER JOIN Categories c
        ON p.category_id = c.category_id

    GROUP BY
        c.category_name,
        p.product_name,
        b.brand_name
)

SELECT
    category_name,
    product_name,
    brand_name,
    Total_Revenue
FROM Product_Sales
WHERE Row_Num <= 3
ORDER BY
    category_name,
    Total_Revenue DESC;

/*
======================================================================
Business Question 4

Department:
Executive Analytics

Business Requirement:

The Executive Management team wants to rank
customers based on their total spending to
identify the highest-value customers.

======================================================================
*/

WITH Customer_Spending AS
(
    SELECT
        c.customer_name,
        CAST(SUM(co.total_amount) AS DECIMAL(12,2)) AS Total_Spending,

        RANK() OVER
        (
            ORDER BY SUM(co.total_amount) DESC
        ) AS Customer_Rank

    FROM Customers c

    INNER JOIN Customer_Orders co
        ON c.customer_id = co.customer_id

    WHERE co.order_status = 'Delivered'

    GROUP BY
        c.customer_name
)

SELECT
    Customer_Rank,
    customer_name,
    Total_Spending
FROM Customer_Spending
ORDER BY Customer_Rank;

/*
======================================================================
Business Question 5

Department:
Executive Analytics

Business Requirement:

The Executive Management team wants to rank
dark stores based on their total sales revenue.

======================================================================
*/

WITH Store_Revenue AS
(
    SELECT
        ds.store_name,
        ds.city,
        CAST(SUM(co.total_amount) AS DECIMAL(12,2)) AS Total_Revenue,

        DENSE_RANK() OVER
        (
            ORDER BY SUM(co.total_amount) DESC
        ) AS Store_Rank

    FROM Dark_Stores ds

    INNER JOIN Customer_Orders co
        ON ds.store_id = co.store_id

    WHERE co.order_status = 'Delivered'

    GROUP BY
        ds.store_name,
        ds.city
)

SELECT
    Store_Rank,
    store_name,
    city,
    Total_Revenue
FROM Store_Revenue
ORDER BY Store_Rank;

/*
======================================================================
Business Question 6

Department:
Executive Analytics

Business Requirement:

The Executive Management team wants to segment
customers into four spending groups based on
their total purchase value.

======================================================================
*/

WITH Customer_Spending AS
(
    SELECT
        c.customer_name,
        CAST(SUM(co.total_amount) AS DECIMAL(12,2)) AS Total_Spending
    FROM Customers c
    INNER JOIN Customer_Orders co
        ON c.customer_id = co.customer_id
    WHERE co.order_status = 'Delivered'
    GROUP BY c.customer_name
),
Customer_Segments AS
(
    SELECT
        customer_name,
        Total_Spending,
        NTILE(4) OVER (ORDER BY Total_Spending DESC) AS Spending_Quartile
    FROM Customer_Spending
)

SELECT
    customer_name,
    Total_Spending,
    CASE Spending_Quartile
        WHEN 1 THEN 'Premium'
        WHEN 2 THEN 'High Value'
        WHEN 3 THEN 'Medium Value'
        WHEN 4 THEN 'Regular'
    END AS Customer_Segment
FROM Customer_Segments
ORDER BY Total_Spending DESC;

/*
======================================================================
Business Question 7

Department:
Executive Analytics

Business Requirement:

The Executive Management team wants to compare
monthly sales revenue with the previous month
to analyze revenue trends.

======================================================================
*/

WITH Monthly_Revenue AS
(
    SELECT
        YEAR(order_date) AS Order_Year,
        MONTH(order_date) AS Order_Month,
        CAST(SUM(total_amount) AS DECIMAL(12,2)) AS Total_Revenue
    FROM Customer_Orders
    WHERE order_status = 'Delivered'
    GROUP BY
        YEAR(order_date),
        MONTH(order_date)
)

SELECT
    Order_Year,
    Order_Month,
    Total_Revenue,

    LAG(Total_Revenue) OVER
    (
        ORDER BY Order_Year, Order_Month
    ) AS Previous_Month_Revenue,

    CAST
    (
        Total_Revenue -
        LAG(Total_Revenue) OVER
        (
            ORDER BY Order_Year, Order_Month
        )
    AS DECIMAL(12,2)) AS Revenue_Change

FROM Monthly_Revenue
ORDER BY
    Order_Year,
    Order_Month;

/*
======================================================================
Business Question 8

Department:
Executive Analytics

Business Requirement:

The Executive Management team wants to compare
monthly sales revenue with the following month
to analyze future revenue trends.

======================================================================
*/

WITH Monthly_Revenue AS
(
    SELECT
        YEAR(order_date) AS Order_Year,
        MONTH(order_date) AS Order_Month,
        CAST(SUM(total_amount) AS DECIMAL(12,2)) AS Total_Revenue
    FROM Customer_Orders
    WHERE order_status = 'Delivered'
    GROUP BY
        YEAR(order_date),
        MONTH(order_date)
)

SELECT
    Order_Year,
    Order_Month,
    Total_Revenue,

    LEAD(Total_Revenue) OVER
    (
        ORDER BY Order_Year, Order_Month
    ) AS Next_Month_Revenue,

    CAST
    (
        LEAD(Total_Revenue) OVER
        (
            ORDER BY Order_Year, Order_Month
        ) - Total_Revenue
    AS DECIMAL(12,2)) AS Revenue_Change

FROM Monthly_Revenue
ORDER BY
    Order_Year,
    Order_Month;

/*
======================================================================
Business Question 9

Department:
Executive Analytics

Business Requirement:

The Executive Management team wants to analyze
the cumulative monthly sales revenue to monitor
overall business growth over time.

======================================================================
*/

WITH Monthly_Revenue AS
(
    SELECT
        YEAR(order_date) AS Order_Year,
        MONTH(order_date) AS Order_Month,
        CAST(SUM(total_amount) AS DECIMAL(12,2)) AS Total_Revenue
    FROM Customer_Orders
    WHERE order_status = 'Delivered'
    GROUP BY
        YEAR(order_date),
        MONTH(order_date)
)

SELECT
    Order_Year,
    Order_Month,
    Total_Revenue,

    CAST
    (
        SUM(Total_Revenue) OVER
        (
            ORDER BY Order_Year, Order_Month
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        )
    AS DECIMAL(12,2)) AS Running_Total_Revenue

FROM Monthly_Revenue
ORDER BY
    Order_Year,
    Order_Month;

/*
======================================================================
Business Question 10

Department:
Executive Analytics

Business Requirement:

The Executive Management team wants to analyze
the revenue contribution of each product category
to the overall sales revenue.

======================================================================
*/

WITH Category_Revenue AS
(
    SELECT
        c.category_name,
        CAST(SUM(oi.total_price) AS DECIMAL(12,2)) AS Total_Revenue
    FROM Order_Items oi

    INNER JOIN Products p
        ON oi.product_id = p.product_id

    INNER JOIN Categories c
        ON p.category_id = c.category_id

    GROUP BY
        c.category_name
)

SELECT
    category_name,
    Total_Revenue,

    CAST
    (
        Total_Revenue * 100.0
        /
        SUM(Total_Revenue) OVER()
    AS DECIMAL(5,2)) AS Revenue_Contribution_Percentage

FROM Category_Revenue
ORDER BY Total_Revenue DESC;

/*
======================================================================
Subqueries
======================================================================
*/
/*
======================================================================
Business Question 11

Department:
Executive Analytics

Business Requirement:

The Executive Management team wants to identify
products whose selling price is higher than the
average selling price across all products.

======================================================================
*/

SELECT
    p.product_name,
    b.brand_name,
    c.category_name,
    p.selling_price
FROM Products p

INNER JOIN Brands b
    ON p.brand_id = b.brand_id

INNER JOIN Categories c
    ON p.category_id = c.category_id

WHERE p.selling_price >
(
    SELECT AVG(selling_price)
    FROM Products
)

ORDER BY
    p.selling_price DESC;

/*
======================================================================
Business Question 12

Department:
Executive Analytics

Business Requirement:

The Executive Management team wants to identify
customers whose total spending is higher than
the average spending of all customers.

======================================================================
*/

SELECT
    c.customer_name,
    CAST(SUM(co.total_amount) AS DECIMAL(12,2)) AS Total_Spending
FROM Customers c

INNER JOIN Customer_Orders co
    ON c.customer_id = co.customer_id

WHERE co.order_status = 'Delivered'

GROUP BY
    c.customer_name

HAVING SUM(co.total_amount) >
(
    SELECT AVG(Customer_Total_Spending)
    FROM
    (
        SELECT
            SUM(total_amount) AS Customer_Total_Spending
        FROM Customer_Orders
        WHERE order_status = 'Delivered'
        GROUP BY customer_id
    ) AS Customer_Average
)

ORDER BY
    Total_Spending DESC;

/*
======================================================================
EXISTS & NOT EXISTS
======================================================================
*/
/*
======================================================================
Business Question 13

Department:
Executive Analytics

Business Requirement:

The Executive Management team wants to identify
all products that have been ordered at least
once by customers.

======================================================================
*/

SELECT
    p.product_id,
    p.product_name,
    b.brand_name,
    c.category_name
FROM Products p

INNER JOIN Brands b
    ON p.brand_id = b.brand_id

INNER JOIN Categories c
    ON p.category_id = c.category_id

WHERE EXISTS
(
    SELECT 1
    FROM Order_Items oi
    WHERE oi.product_id = p.product_id
)

ORDER BY
    c.category_name,
    p.product_name;

/*
======================================================================
Business Question 14

Department:
Executive Analytics

Business Requirement:

The Executive Management team wants to identify
customers whose total spending is higher than
the average spending of customers in their city.

======================================================================
*/

SELECT
    c.customer_name,
    c.city,
    CAST(SUM(co.total_amount) AS DECIMAL(12,2)) AS Total_Spending
FROM Customers c
INNER JOIN Customer_Orders co
    ON c.customer_id = co.customer_id
WHERE co.order_status = 'Delivered'
GROUP BY
    c.customer_id,
    c.customer_name,
    c.city
HAVING SUM(co.total_amount) >
(
    SELECT AVG(City_Spending)
    FROM
    (
        SELECT
            SUM(co2.total_amount) AS City_Spending
        FROM Customers c2
        INNER JOIN Customer_Orders co2
            ON c2.customer_id = co2.customer_id
        WHERE
            c2.city = c.city
            AND co2.order_status = 'Delivered'
        GROUP BY c2.customer_id
    ) AS City_Avg
)
ORDER BY
    Total_Spending DESC;

/*
======================================================================
STRING_AGG()
======================================================================
*/
/*
======================================================================
Business Question 15

Department:
Executive Analytics

Business Requirement:

The Executive Management team wants to view
all products purchased in each customer order
as a single comma-separated list.

======================================================================
*/

SELECT
    oi.order_id,
    STRING_AGG(p.product_name, ', ') AS Products_Purchased,
    COUNT(oi.product_id) AS Total_Items
FROM Order_Items oi

INNER JOIN Products p
    ON oi.product_id = p.product_id

GROUP BY
    oi.order_id

ORDER BY
    oi.order_id;

/*
======================================================================
PIVOT
======================================================================
*/
/*
======================================================================
Business Question 16

Department:
Executive Analytics

Business Requirement:

The Executive Management team wants to generate
a city-wise revenue report where each order
status is displayed as a separate column.

======================================================================
*/
SELECT
    city,
    ISNULL([Delivered],0) AS Delivered_Revenue,
    ISNULL([Cancelled],0) AS Cancelled_Revenue,
    ISNULL([Returned],0) AS Returned_Revenue,
    ISNULL([Failed],0) AS Failed_Revenue
FROM
(
    SELECT
        ds.city,
        co.order_status,
        co.total_amount
    FROM Customer_Orders co
    INNER JOIN Dark_Stores ds
        ON co.store_id = ds.store_id
) AS Source_Table

PIVOT
(
    SUM(total_amount)
    FOR order_status IN
    (
        [Delivered],
        [Cancelled],
        [Returned],
        [Failed]
    )
) AS Pivot_Table

ORDER BY city;

/*
======================================================================
Business Question 17

Department:
Executive Analytics

Business Requirement:

The Executive Management team frequently
analyzes product-wise sales performance.

To simplify reporting, create a reusable SQL
View that provides revenue, quantity sold,
and total orders for each product.

======================================================================
*/

CREATE VIEW vw_Product_Sales_Summary
AS

SELECT
    p.product_id,
    p.product_name,
    b.brand_name,
    c.category_name,

    SUM(oi.quantity) AS Total_Quantity_Sold,

    COUNT(DISTINCT oi.order_id) AS Total_Orders,

    CAST(SUM(oi.total_price) AS DECIMAL(12,2)) AS Total_Revenue

FROM Order_Items oi

INNER JOIN Products p
    ON oi.product_id = p.product_id

INNER JOIN Brands b
    ON p.brand_id = b.brand_id

INNER JOIN Categories c
    ON p.category_id = c.category_id

GROUP BY
    p.product_id,
    p.product_name,
    b.brand_name,
    c.category_name;

    SELECT *
FROM vw_Product_Sales_Summary
ORDER BY Total_Revenue DESC;

/*
======================================================================
Stored Procedures
======================================================================
*/

/*
======================================================================
Business Question 18

Department:
Executive Analytics

Business Requirement:

The Executive Management team wants to generate
a city-wise sales report dynamically by passing
the city name as a parameter.

======================================================================
*/

CREATE PROCEDURE usp_City_Sales_Report
    @City VARCHAR(50)
AS
BEGIN

    SET NOCOUNT ON;

    SELECT
        ds.city,

        COUNT(co.order_id) AS Total_Orders,

        SUM(CASE
                WHEN co.order_status = 'Delivered' THEN 1
                ELSE 0
            END) AS Delivered_Orders,

        SUM(CASE
                WHEN co.order_status = 'Cancelled' THEN 1
                ELSE 0
            END) AS Cancelled_Orders,

        SUM(CASE
                WHEN co.order_status = 'Returned' THEN 1
                ELSE 0
            END) AS Returned_Orders,

        SUM(CASE
                WHEN co.order_status = 'Failed' THEN 1
                ELSE 0
            END) AS Failed_Orders,

        CAST(
            SUM(
                CASE
                    WHEN co.order_status = 'Delivered'
                    THEN co.total_amount
                    ELSE 0
                END
            ) AS DECIMAL(12,2)
        ) AS Total_Revenue,

        CAST(
            AVG(
                CASE
                    WHEN co.order_status = 'Delivered'
                    THEN co.total_amount
                END
            ) AS DECIMAL(10,2)
        ) AS Average_Order_Value

    FROM Customer_Orders co

    INNER JOIN Dark_Stores ds
        ON co.store_id = ds.store_id

    WHERE ds.city = @City

    GROUP BY
        ds.city;

END;

EXEC usp_City_Sales_Report @City = 'Bengaluru';
EXEC usp_City_Sales_Report @City = 'Delhi';
EXEC usp_City_Sales_Report @City = 'Mumbai';

/*
======================================================================
Business Question 19

Department:
Executive Analytics

Business Requirement:

The Executive Management team wants to generate
an executive KPI dashboard that summarizes the
overall business performance.

======================================================================
*/

SELECT

    COUNT(DISTINCT co.order_id) AS Total_Orders,

    COUNT(DISTINCT co.customer_id) AS Total_Customers,

    COUNT(DISTINCT oi.product_id) AS Products_Sold,

    CAST(
        SUM(
            CASE
                WHEN co.order_status = 'Delivered'
                THEN co.total_amount
                ELSE 0
            END
        ) AS DECIMAL(12,2)
    ) AS Total_Revenue,

    CAST(
        AVG(
            CASE
                WHEN co.order_status = 'Delivered'
                THEN co.total_amount
            END
        ) AS DECIMAL(10,2)
    ) AS Average_Order_Value,

    CAST(
        AVG(
            CASE
                WHEN co.order_status = 'Delivered'
                THEN co.delivery_time_minutes
            END
        ) AS DECIMAL(10,2)
    ) AS Average_Delivery_Time,

    CAST(
        SUM(
            CASE
                WHEN co.order_status='Delivered'
                 AND co.delivery_time_minutes<=30
                THEN 1
                ELSE 0
            END
        ) * 100.0
        /
        NULLIF(
            SUM(
                CASE
                    WHEN co.order_status='Delivered'
                    THEN 1
                    ELSE 0
                END
            ),0
        )
    AS DECIMAL(5,2)) AS Delivery_Success_Rate_Percentage

FROM Customer_Orders co

INNER JOIN Order_Items oi
    ON co.order_id = oi.order_id;

/*
======================================================================
Business Question 20

Department:
Executive Analytics

Business Requirement:

The Executive Management team wants to identify
the top-performing dark stores based on their
overall business performance, including revenue,
order volume, average order value, and ranking.

======================================================================
*/

WITH Store_Performance AS
(
    SELECT
        ds.store_id,
        ds.store_name,
        ds.city,

        COUNT(co.order_id) AS Total_Orders,

        CAST(
            SUM(
                CASE
                    WHEN co.order_status = 'Delivered'
                    THEN co.total_amount
                    ELSE 0
                END
            ) AS DECIMAL(12,2)
        ) AS Total_Revenue,

        CAST(
            AVG(
                CASE
                    WHEN co.order_status = 'Delivered'
                    THEN co.total_amount
                END
            ) AS DECIMAL(10,2)
        ) AS Average_Order_Value

    FROM Dark_Stores ds

    LEFT JOIN Customer_Orders co
        ON ds.store_id = co.store_id

    GROUP BY
        ds.store_id,
        ds.store_name,
        ds.city
)

SELECT

    DENSE_RANK() OVER
    (
        ORDER BY Total_Revenue DESC
    ) AS Store_Rank,

    store_name,
    city,
    Total_Orders,
    Total_Revenue,
    Average_Order_Value,

    CAST
    (
        Total_Revenue * 100.0
        /
        SUM(Total_Revenue) OVER()
    AS DECIMAL(5,2)) AS Revenue_Contribution_Percentage

FROM Store_Performance

ORDER BY
    Store_Rank;
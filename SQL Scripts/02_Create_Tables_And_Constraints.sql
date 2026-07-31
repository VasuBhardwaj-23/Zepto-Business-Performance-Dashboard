/*
==========================================================
Table Name : Categories
Description : Stores all product categories available on
              the Zepto platform.
==========================================================
*/

CREATE TABLE Categories
(
    category_id VARCHAR(10) PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    category_type VARCHAR(50) NOT NULL,
    is_active BIT NOT NULL
);
GO

EXEC sp_help 'Categories';
SELECT *
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME='Categories';


/*
==========================================================
Table Name : Brands
Description : Stores product brand information.
==========================================================
*/

CREATE TABLE Brands
(
    brand_id VARCHAR(10) PRIMARY KEY,
    brand_name VARCHAR(100) NOT NULL,
    brand_type VARCHAR(50) NOT NULL,
    origin_country VARCHAR(50) NOT NULL,
    is_active BIT NOT NULL
);
GO

EXEC sp_help 'Brands';


/*
==========================================================
Table Name : Products
Description : Stores product information available on
              the Zepto platform.
==========================================================
*/

CREATE TABLE Products
(
    product_id VARCHAR(10) PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    brand_id VARCHAR(10) NOT NULL,
    category_id VARCHAR(10) NOT NULL,
    sku VARCHAR(30) NOT NULL,
    mrp DECIMAL(10,2) NOT NULL,
    selling_price DECIMAL(10,2) NOT NULL,
    unit VARCHAR(30) NOT NULL,
    launch_date DATE NOT NULL,
    rating DECIMAL(2,1) NULL,

    CONSTRAINT CHK_Product_MRP
        CHECK (mrp > 0),

    CONSTRAINT CHK_Selling_Price
        CHECK (selling_price > 0),

    CONSTRAINT CHK_Product_Price
        CHECK (selling_price <= mrp),

    CONSTRAINT CHK_Product_Rating
        CHECK (rating BETWEEN 0 AND 5)
);
GO

EXEC sp_help 'Products';

/*
==========================================================
Table Name : Dark_Stores
Description : Stores Zepto dark store information.
==========================================================
*/

CREATE TABLE Dark_Stores
(
    store_id VARCHAR(10) PRIMARY KEY,
    store_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    opening_date DATE NOT NULL,
    manager_name VARCHAR(100) NOT NULL,
    contact_number VARCHAR(15) NOT NULL,
    operating_status VARCHAR(20) NOT NULL,

    CONSTRAINT CHK_Operating_Status
        CHECK (operating_status IN ('Active','Inactive'))
);
GO

EXEC sp_help 'Dark_Stores';

/*
==========================================================
Table Name : Customers
Description : Stores customer information.
==========================================================
*/

CREATE TABLE Customers
(
    customer_id VARCHAR(10) PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    age INT NOT NULL,
    city VARCHAR(50) NOT NULL,
    signup_date DATE NOT NULL,
    membership_type VARCHAR(20) NOT NULL,

    CONSTRAINT UQ_Customers_Email
        UNIQUE(email),

    CONSTRAINT CHK_Customer_Gender
        CHECK (gender IN ('Male','Female','Other')),

    CONSTRAINT CHK_Customer_Age
        CHECK (age >= 18),

    CONSTRAINT CHK_Membership_Type
        CHECK (membership_type IN ('Silver','Gold','Platinum'))
);
GO

EXEC sp_help 'Customers';

/*
==========================================================
Table Name : Inventory
Description : Stores inventory details of products
              available in each Zepto dark store.
==========================================================
*/

CREATE TABLE Inventory
(
    inventory_id VARCHAR(10) PRIMARY KEY,
    store_id VARCHAR(10) NOT NULL,
    product_id VARCHAR(10) NOT NULL,
    stock_quantity INT NOT NULL,
    reorder_level INT NOT NULL,
    last_restock_date DATE NOT NULL,

    CONSTRAINT CHK_Stock_Quantity
        CHECK (stock_quantity >= 0),

    CONSTRAINT CHK_Reorder_Level
        CHECK (reorder_level >= 0)
);
GO

EXEC sp_help 'Inventory';

/*
==========================================================
Table Name : Customer_Orders
Description : Stores customer order details.
==========================================================
*/

CREATE TABLE Customer_Orders
(
    order_id VARCHAR(10) PRIMARY KEY,
    customer_id VARCHAR(10) NOT NULL,
    store_id VARCHAR(10) NOT NULL,

    order_date DATE NOT NULL,
    order_time TIME NOT NULL,

    delivery_date DATE NULL,
    delivery_time_minutes INT NULL,

    payment_method VARCHAR(30) NOT NULL,
    order_status VARCHAR(20) NOT NULL,

    total_amount DECIMAL(10,2) NOT NULL,
    discount_amount DECIMAL(10,2) NOT NULL,
    delivery_fee DECIMAL(10,2) NOT NULL,

    CONSTRAINT CHK_Total_Amount
        CHECK (total_amount >= 0),

    CONSTRAINT CHK_Discount_Amount
        CHECK (discount_amount >= 0),

    CONSTRAINT CHK_Delivery_Fee
        CHECK (delivery_fee >= 0),

    CONSTRAINT CHK_Delivery_Time
        CHECK (delivery_time_minutes >= 0 OR delivery_time_minutes IS NULL),

    CONSTRAINT CHK_Order_Status
        CHECK (order_status IN
        ('Delivered','Cancelled','Returned','Failed')),

    CONSTRAINT CHK_Payment_Method
        CHECK (payment_method IN
        ('UPI','Credit Card','Debit Card','Cash on Delivery','Wallet'))
);
GO

EXEC sp_help 'Customer_Orders';

/*
==========================================================
Table Name : Order_Items
Description : Stores individual products purchased
              in each customer order.
==========================================================
*/

CREATE TABLE Order_Items
(
    order_item_id VARCHAR(10) PRIMARY KEY,

    order_id VARCHAR(10) NOT NULL,
    product_id VARCHAR(10) NOT NULL,

    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,

    CONSTRAINT CHK_Quantity
        CHECK (quantity > 0),

    CONSTRAINT CHK_Unit_Price
        CHECK (unit_price >= 0),

    CONSTRAINT CHK_Total_Price
        CHECK (total_price >= 0)
);
GO

EXEC sp_help 'Order_Items';
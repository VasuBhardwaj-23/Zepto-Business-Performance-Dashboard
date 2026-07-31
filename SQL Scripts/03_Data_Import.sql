/*
==========================================================
Script Name : 03_Data_Import.sql
Description : Imports all CSV datasets into Zepto_DB tables.
==========================================================
*/

USE Zepto_DB;
GO

/*==========================================================
Import Categories
==========================================================*/

BULK INSERT Categories
FROM 'C:\Users\Vasu Bhardwaj\Downloads\Categories.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = '65001',
    TABLOCK
);
GO

/*==========================================================
Import Brands
==========================================================*/

BULK INSERT Brands
FROM 'C:\Users\Vasu Bhardwaj\Downloads\Brands.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = '65001',
    TABLOCK
);
GO

/*==========================================================
Import Products
==========================================================*/

BULK INSERT Products
FROM 'C:\Users\Vasu Bhardwaj\Downloads\Products.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = '65001',
    TABLOCK
);
GO

/*==========================================================
Import Dark Stores
==========================================================*/

BULK INSERT Dark_Stores
FROM 'C:\Users\Vasu Bhardwaj\Downloads\Dark_Stores.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = '65001',
    TABLOCK
);
GO

/*==========================================================
Import Customers
==========================================================*/

BULK INSERT Customers
FROM 'C:\Users\Vasu Bhardwaj\Downloads\Customers.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = '65001',
    TABLOCK
);
GO

/*==========================================================
Import Inventory
==========================================================*/

BULK INSERT Inventory
FROM 'C:\Users\Vasu Bhardwaj\Downloads\Inventory.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = '65001',
    TABLOCK
);
GO

/*==========================================================
Import Customer Orders
==========================================================*/

BULK INSERT Customer_Orders
FROM 'C:\Users\Vasu Bhardwaj\Downloads\Customer_Orders.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = '65001',
    TABLOCK
);
GO

/*==========================================================
Import Order Items
==========================================================*/

BULK INSERT Order_Items
FROM 'C:\Users\Vasu Bhardwaj\Downloads\Order_Items.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A',
    CODEPAGE = '65001',
    TABLOCK
);
GO

/*==========================================================
Verify Imported Data
==========================================================*/

SELECT COUNT(*) AS TotalCategories
FROM Categories;

SELECT COUNT(*) AS TotalBrands
FROM Brands;

SELECT COUNT(*) AS TotalProducts
FROM Products;

SELECT COUNT(*) AS TotalDarkStores
FROM Dark_Stores;

SELECT COUNT(*) AS TotalCustomers
FROM Customers;

SELECT COUNT(*) AS TotalInventory
FROM Inventory;

SELECT COUNT(*) AS TotalOrders
FROM Customer_Orders;

SELECT COUNT(*) AS TotalOrderItems
FROM Order_Items;
GO
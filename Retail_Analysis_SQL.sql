USE retail_analysis;

SELECT COUNT(*) AS Total_Rows FROM retail_cleaned_dataset;
DESCRIBE retail_cleaned_dataset;

SELECT SUM(Sales) AS Total_Sales, SUM(Profit) AS Total_Profit FROM retail_cleaned_dataset;

SELECT Category, SUM(Sales) AS Total_Sales, SUM(Profit) AS Total_Profit,
(SUM(Profit)/SUM(Sales))*100 AS Profit_Pct
FROM retail_cleaned_dataset GROUP BY Category ORDER BY Total_Sales DESC;

SELECT Region, SUM(Sales) AS Total_Sales, SUM(Profit) AS Total_Profit,
(SUM(Profit)/SUM(Sales))*100 AS Profit_Pct -- YE ADD KAR
FROM retail_cleaned_dataset GROUP BY Region ORDER BY Total_Profit DESC;

SELECT PaymentMode, COUNT(*) AS Total_Orders FROM retail_cleaned_dataset GROUP BY PaymentMode ORDER BY Total_Orders DESC;

CREATE TABLE IF NOT EXISTS customer_master AS
SELECT CustomerID, MAX(CustomerName) AS CustomerName, MAX(City) AS City, MAX(Region) AS Region
FROM retail_cleaned_dataset WHERE CustomerID IS NOT NULL GROUP BY CustomerID;

CREATE TABLE IF NOT EXISTS products AS
SELECT DISTINCT ProductID, ProductName, Category, SubCategory
FROM retail_cleaned_dataset WHERE ProductID IS NOT NULL;

-- Joins
SELECT r.CustomerID, c.CustomerName, c.City, r.Sales, r.Profit
FROM retail_cleaned_dataset r JOIN customer_master c ON r.CustomerID = c.CustomerID LIMIT 20;

SELECT CustomerID, CustomerName, SUM(Sales) AS Total_Sales FROM retail_cleaned_dataset GROUP BY CustomerID, CustomerName ORDER BY Total_Sales DESC LIMIT 10;

SELECT MONTH(OrderDate) AS Month, SUM(Sales) AS Total_Sales FROM retail_cleaned_dataset GROUP BY MONTH(OrderDate) ORDER BY Month;
SELECT SUM(Sales)/COUNT(*) AS Average_Order_Value FROM retail_cleaned_dataset;

SELECT ProductID, ProductName, SUM(Sales) AS Total_Sales, SUM(Profit) AS Total_Profit FROM retail_cleaned_dataset GROUP BY ProductID, ProductName ORDER BY Total_Profit DESC LIMIT 10;

SELECT COUNT(*) AS Matched_Rows FROM retail_cleaned_dataset r INNER JOIN customer_master c ON r.CustomerID = c.CustomerID;
SELECT COUNT(*) AS Matched_Product_Rows FROM retail_cleaned_dataset r INNER JOIN products p ON r.ProductID = p.ProductID;

CREATE OR REPLACE VIEW vw_dashboard AS
SELECT Region, Category, PaymentMode, SUM(Sales) as Total_Sales, SUM(Profit) as Total_Profit, (SUM(Profit)/SUM(Sales))*100 as Profit_Pct
FROM retail_cleaned_dataset GROUP BY Region, Category, PaymentMode;
    
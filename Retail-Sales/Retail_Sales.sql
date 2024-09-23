USE Retail_Sales
GO

 SELECT top 10 * from  Retail_Sales

 SELECT COUNT(*) FROM [Retail_Sales];
-------------------------------------------------------------------

 SELECT * FROM Retail_Sales
 WHERE 
	dbo.[Retail_Sales].[customer_id] IS NULL
	OR
	dbo.[Retail_Sales].[gender] IS NULL
	OR
	dbo.[Retail_Sales].[age] IS NULL
	OR
	dbo.[Retail_Sales].[category] IS NULL
	OR
	dbo.[Retail_Sales].[quantiy] IS NULL
	OR
	dbo.[Retail_Sales].[price_per_unit] IS NULL
	OR
	dbo.[Retail_Sales].[cogs] IS NULL
	OR
	dbo.[Retail_Sales].[total_sale] IS NULL


DELETE FROM Retail_Sales.dbo.[Retail_Sales]
WHERE  
	dbo.[Retail_Sales].[customer_id] IS NULL
	OR
	dbo.[Retail_Sales].[gender] IS NULL
	OR
	dbo.[Retail_Sales].[age] IS NULL
	OR
	dbo.[Retail_Sales].[category] IS NULL
	OR
	dbo.[Retail_Sales].[quantiy] IS NULL
	OR
	dbo.[Retail_Sales].[price_per_unit] IS NULL
	OR
	dbo.[Retail_Sales].[cogs] IS NULL
	OR
	dbo.[Retail_Sales].[total_sale] IS NULL


 SELECT * FROM Retail_Sales
 WHERE 
	dbo.[Retail_Sales].[customer_id] IS NULL
	OR
	dbo.[Retail_Sales].[gender] IS NULL
	OR
	dbo.[Retail_Sales].[category] IS NULL
	OR
	dbo.[Retail_Sales].[quantiy] IS NULL
	OR
	dbo.[Retail_Sales].[price_per_unit] IS NULL
	OR
	dbo.[Retail_Sales].[cogs] IS NULL
	OR
	dbo.[Retail_Sales].[total_sale] IS NULL


SELECT COUNT(*) FROM Retail_Sales

----------------------Data Exploration-----------------------


SELECT COUNT(*) as total_sale from Retail_Sales;

SELECT COUNT(DISTINCT customer_id) as UniqueCustomers from Retail_Sales;


SELECT DISTINCT(category) as UniqueCategories from Retail_Sales;
SELECT COUNT(DISTINCT category) as UniqueCategories from Retail_Sales;

---------------------------------------------------------------------------------------------------------

SELECT * FROM Retail_Sales
WHERE sale_date='2022-11-05';


SELECT *
FROM 
	Retail_Sales
WHERE 
	category='Clothing'
	AND MONTH(sale_date) = '11'
	AND YEAR(sale_date) ='2022'
	AND quantiy >= 4

-------------------------------------------------------------------------

SELECT 
	category,
	SUM(total_sale) as [net_sale],
	COUNT(*) as [total_orders]
FROM 
	Retail_Sales
GROUP BY 
	category
--------------------------------------------------------------------
SELECT 
	ROUND(AVG(age),2) as [Avg_Age]
FROM
	Retail_Sales
WHERE category = 'Beauty'

------------------------------------------------
SELECT 
	*
FROM 
	Retail_Sales
Where 
	total_sale > 1000
------------------------------------------------

SELECT 
	category,	
	gender,
	COUNT(*) as Total_Number
FROM
	Retail_Sales
GROUP BY gender,category
ORDER BY 3 DESC ,2,1 

--------------------------------------------------

SELECT 
	YEAR(Sale_date) AS 'YEAR',
	MONTH(sale_date) AS 'MONTH', 
	AVG(total_sale) AS 'AVG_SALE'
FROM 
	Retail_Sales
GROUP BY MONTH(Sale_date),YEAR(Sale_date)
ORDER BY 1,3DESC



SELECT 
	YEAR(Sale_date) AS 'YEAR',
	MONTH(sale_date) AS 'MONTH', 
	AVG(total_sale) AS 'AVG_SALE',
	RANK()OVER(ORDER BY AVG(total_sale) DESC) as 'RANK'
FROM 
	Retail_Sales
GROUP BY MONTH(Sale_date),YEAR(Sale_date)


SELECT 
	YEAR(Sale_date) AS 'YEAR',
	MONTH(sale_date) AS 'MONTH', 
	AVG(total_sale) AS 'AVG_SALE',
	RANK()OVER(PARTITION BY YEAR(Sale_date) ORDER BY AVG(total_sale) DESC) as 'RANK'
FROM 
	Retail_Sales
GROUP BY MONTH(Sale_date),YEAR(Sale_date)


SELECT 
	YEAR,
	MONTH,
	AVG_SALE
FROM 
	(
	SELECT 
		YEAR(Sale_date) AS YEAR,
		MONTH(sale_date) AS MONTH, 
		AVG(total_sale) AS AVG_SALE,
		RANK()OVER(PARTITION BY YEAR(Sale_date) ORDER BY AVG(total_sale) DESC) as RANK
	FROM 
		Retail_Sales
	GROUP BY 
		MONTH(Sale_date),YEAR(Sale_date)
) as subquery

where RANK = 1

----------------------------------------------------------------------

SELECT TOP 5
	customer_id,
	SUM(total_sale) as Highest_total
FROM 
	Retail_Sales
GROUP BY 
	customer_id
ORDER BY 2 DESC 
-----------------------------------------------------------------------
SELECT 
	category,
	COUNT(DISTINCT customer_id) Unique_customers
FROM 
	Retail_Sales
GROUP BY category
------------------------------------------------------------------------

SELECT 
    *,
    CASE 
        WHEN DATEPART(HOUR, sale_time) <= 12 THEN 'Morning'
        WHEN DATEPART(HOUR, sale_time) > 12 AND DATEPART(HOUR, sale_time) <= 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS Shift
FROM 
    Retail_Sales;

SELECT SHIFT,
	COUNT(*) as NUM_Shift
FROM (
SELECT 
    *,
    CASE 
        WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
        WHEN DATEPART(HOUR, sale_time) >= 12 AND DATEPART(HOUR, sale_time) <= 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS Shift
FROM 
    Retail_Sales) as subquery

GROUP BY Shift
--Subquery approach:

SELECT
A.OrderMonth,
A.Top10Total,
PrevTop10Total = B.Top10Total

FROM (
SELECT
OrderMonth,
Top10Total = SUM(TotalDue)
FROM (
SELECT 
       OrderDate
	  ,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
      ,TotalDue
	  ,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
FROM AdventureWorks2019.Sales.SalesOrderHeader
) X
WHERE OrderRank <= 10
GROUP BY OrderMonth
) A

LEFT JOIN (
SELECT
OrderMonth,
Top10Total = SUM(TotalDue)
FROM (
SELECT 
       OrderDate
	  ,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
      ,TotalDue
	  ,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
FROM AdventureWorks2019.Sales.SalesOrderHeader
) X
WHERE OrderRank <= 10
GROUP BY OrderMonth
) B
ON A.OrderMonth = DATEADD(MONTH,1,B.OrderMonth)

ORDER BY 1




--Refactored using CTE:

WITH Sales AS
(
SELECT 
       OrderDate
	  ,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
      ,TotalDue
	  ,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
FROM AdventureWorks2019.Sales.SalesOrderHeader
)

,Top10Sales AS
(
SELECT
OrderMonth,
Top10Total = SUM(TotalDue)
FROM Sales
WHERE OrderRank <= 10
GROUP BY OrderMonth
)


SELECT
A.OrderMonth,
A.Top10Total,
PrevTop10Total = B.Top10Total

FROM Top10Sales A
	LEFT JOIN Top10Sales B
		ON A.OrderMonth = DATEADD(MONTH,1,B.OrderMonth)

ORDER BY 1

--"CTEs - Exercise Starter Code.sql" 

SELECT
A.OrderMonth,
A.TotalSales,
B.TotalPurchases

FROM (
	SELECT
	OrderMonth,
	TotalSales = SUM(TotalDue)
	FROM (
		SELECT 
		   OrderDate
		  ,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
		  ,TotalDue
		  ,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
		FROM AdventureWorks2019.Sales.SalesOrderHeader
		) S
	WHERE OrderRank > 10
	GROUP BY OrderMonth
) A

JOIN (
	SELECT
	OrderMonth,
	TotalPurchases = SUM(TotalDue)
	FROM (
		SELECT 
		   OrderDate
		  ,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
		  ,TotalDue
		  ,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
		FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader
		) P
	WHERE OrderRank > 10
	GROUP BY OrderMonth
) B	ON A.OrderMonth = B.OrderMonth

ORDER BY 1

-------------------------------------------------------------------

--CTEs - Exercise
--For this exercise, assume the CEO of our fictional company decided
--that the top 10 orders per month are actually outliers that need to be
--clipped out of our data before doing meaningful analysis.

--Further, she would like the sum of sales AND purchases (minus these
--"outliers") listed side by side, by month.

--We've got a query that already does this (see the file "CTEs -
--Exercise Starter Code.sql" in the resources for this section), but it's
--messy and hard to read. Re-write it using a CTE so other analysts
--can read and understand the code.

--Hint: Since you're comparing data from two different sources (sales
--vs purchases), you may not be able to re-use a CTE like we did in the video.



with sales as 
(
SELECT 
		   OrderDate
		  ,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
		  ,TotalDue
		  ,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
		FROM AdventureWorks2019.Sales.SalesOrderHeader
), 

SalesMinusTop10 AS 
(
SELECT
	OrderMonth,
	TotalSales = SUM(TotalDue)
	FROM sales 
	WHERE OrderRank > 10
	GROUP BY OrderMonth
),

Purchases AS
(
SELECT 
		   OrderDate
		  ,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
		  ,TotalDue
		  ,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
		FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader
), 

PurchasesMinusTop10 AS 
(
SELECT
	OrderMonth,
	TotalPurchases = SUM(TotalDue)
	FROM Purchases
	WHERE OrderRank > 10
	GROUP BY OrderMonth
) 

SELECT
A.OrderMonth,
A.TotalSales,
B.TotalPurchases

from SalesMinusTop10 A
JOIN PurchasesMinusTop10 B
ON A.OrderMonth = B.OrderMonth

ORDER BY 1
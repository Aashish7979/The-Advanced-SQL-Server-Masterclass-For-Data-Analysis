--Temp table --Create and Insert example

CREATE TABLE #Sales
(
       OrderDate DATE
	  ,OrderMonth DATE
      ,TotalDue MONEY
	  ,OrderRank INT
)

INSERT INTO #Sales
(
       OrderDate
	  ,OrderMonth
      ,TotalDue
	  ,OrderRank
)
SELECT 
       OrderDate
	  ,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
      ,TotalDue
	  ,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)

FROM AdventureWorks2019.Sales.SalesOrderHeader



CREATE TABLE #Top10Sales
(
OrderMonth DATE,
Top10Total MONEY
)

INSERT INTO #Top10Sales

SELECT
OrderMonth,
Top10Total = SUM(TotalDue)

FROM #Sales
WHERE OrderRank <= 10
GROUP BY OrderMonth



SELECT
A.OrderMonth,
A.Top10Total,
PrevTop10Total = B.Top10Total

FROM #Top10Sales A
	LEFT JOIN #Top10Sales B
		ON A.OrderMonth = DATEADD(MONTH,1,B.OrderMonth)

ORDER BY 1

SELECT * FROM #Sales WHERE OrderRank <= 10

DROP TABLE #Sales
DROP TABLE #Top10Sales

--Create and Insert excercise 
--Exercise
--Rewrite your solution from last video's exercise using CREATE and
--INSERT instead of SELECT INTO.

CREATE TABLE #Sales
(
       OrderDate DATE
	  ,OrderMonth DATE
      ,TotalDue MONEY
	  ,OrderRank INT
)

INSERT INTO #Sales
(
       OrderDate
	  ,OrderMonth
      ,TotalDue
	  ,OrderRank
)
SELECT 
       OrderDate
	  ,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
      ,TotalDue
	  ,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)

FROM AdventureWorks2019.Sales.SalesOrderHeader



CREATE TABLE #SalesMinusTop10
(
OrderMonth DATE,
TotalSales MONEY
)

INSERT INTO #SalesMinusTop10
(
OrderMonth,
TotalSales
)
SELECT
OrderMonth,
TotalSales = SUM(TotalDue)
FROM #Sales
WHERE OrderRank > 10
GROUP BY OrderMonth


CREATE TABLE #Purchases
(
       OrderDate DATE
	  ,OrderMonth DATE
      ,TotalDue MONEY
	  ,OrderRank INT
)

INSERT INTO #Purchases
(
       OrderDate
	  ,OrderMonth
      ,TotalDue
	  ,OrderRank
)
SELECT 
       OrderDate
	  ,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
      ,TotalDue
	  ,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)

FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader



CREATE TABLE #PurchaseMinusTop10
(
OrderMonth DATE,
TotalPurchases MONEY
)

INSERT INTO #PurchaseMinusTop10
(
OrderMonth,
TotalPurchases
)
SELECT
OrderMonth,
TotalPurchases = SUM(TotalDue)
FROM #Purchases
WHERE OrderRank > 10
GROUP BY OrderMonth



SELECT
A.OrderMonth,
A.TotalSales,
B.TotalPurchases

FROM #SalesMinusTop10 A
	JOIN #PurchaseMinusTop10 B
		ON A.OrderMonth = B.OrderMonth

ORDER BY 1

DROP TABLE #Sales
DROP TABLE #SalesMinusTop10
DROP TABLE #Purchases
DROP TABLE #PurchaseMinusTop10

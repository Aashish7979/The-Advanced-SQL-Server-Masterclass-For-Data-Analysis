--Temp Tables Introduction Example
SELECT 
       OrderDate
	  ,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
      ,TotalDue
	  ,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)

INTO #Sales

FROM AdventureWorks2019.Sales.SalesOrderHeader


SELECT
	OrderMonth,
	Top10Total = SUM(TotalDue)

INTO #Top10Sales

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

--Excercise 

SELECT 
		   OrderDate
		  ,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
		  ,TotalDue
		  ,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)

		INTO #sales
		FROM AdventureWorks2019.Sales.SalesOrderHeader
 


SELECT
	OrderMonth,
	TotalSales = SUM(TotalDue)

	INTO #SalesMinusTop10
	FROM #sales 
	WHERE OrderRank > 10
	GROUP BY OrderMonth


SELECT 
		   OrderDate
		  ,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
		  ,TotalDue
		  ,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)

		INTO #Purchases
		FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader


SELECT
	OrderMonth,
	TotalPurchases = SUM(TotalDue)

	INTO #PurchasesMinusTop10
	FROM #Purchases
	WHERE OrderRank > 10
	GROUP BY OrderMonth


SELECT
A.OrderMonth,
A.TotalSales,
B.TotalPurchases

from #SalesMinusTop10 A
JOIN #PurchasesMinusTop10 B
ON A.OrderMonth = B.OrderMonth

ORDER BY 1

DROP Table #sales
DROP Table #SalesMinusTop10
DROP Table #Purchases
DROP Table #PurchasesMinusTop10


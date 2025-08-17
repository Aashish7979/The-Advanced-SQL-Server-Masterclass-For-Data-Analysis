--Temp tables Truncate Example
--Top 10 sales + purchases script

CREATE TABLE #Orders
(
       OrderDate DATE
	  ,OrderMonth DATE
      ,TotalDue MONEY
	  ,OrderRank INT
)



INSERT INTO #Orders
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



CREATE TABLE #Top10Orders
(
OrderMonth DATE,
OrderType VARCHAR(32),
Top10Total MONEY
)


INSERT INTO #Top10Orders
(
OrderMonth,
OrderType,
Top10Total
)
SELECT
OrderMonth,
OrderType = 'Sales',
Top10Total = SUM(TotalDue)

FROM #Orders
WHERE OrderRank <= 10
GROUP BY OrderMonth


/*Fun part begins here*/

TRUNCATE TABLE #Orders

INSERT INTO #Orders
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


INSERT INTO #Top10Orders
(
OrderMonth,
OrderType,
Top10Total
)
SELECT
OrderMonth,
OrderType = 'Purchase',
Top10Total = SUM(TotalDue)

FROM #Orders
WHERE OrderRank <= 10
GROUP BY OrderMonth


SELECT
A.OrderMonth,
A.OrderType,
A.Top10Total,
PrevTop10Total = B.Top10Total

FROM #Top10Orders A
	LEFT JOIN #Top10Orders B
		ON A.OrderMonth = DATEADD(MONTH,1,B.OrderMonth)
			AND A.OrderType = B.OrderType

ORDER BY 3 DESC

DROP TABLE #Orders
DROP TABLE #Top10Orders

----Temp tables Truncate Excersice 
--Exercise
--Leverage TRUNCATE to re-use temp tables in your solution to
--"CREATE and INSERT" exercise.
--Your output should look something like this:
--Hints:
--1.)Instead of joining two tables in your final SELECT
--(#AvgSalesMinusTop10 and #AvgPurchasesMinusTop10), you will
--most likely need to join a single consolidated query to itself.

--The join will work much like before, but you will need to add a new
--wrinkle that filters each copy of the table based on whether it
--contains purchase or sales data.

--For whatever copy of the table you put after the FROM, include the
--filtering criteria in the WHERE clause.

--For the other copy of the table, apply the filtering criteria directly in the join.

--These different "cuts" of the same table will accomplish the same
--thing as two distinct tables did previously.

--2.)In the SELECT clause of your final query, you will probably need to
--apply aliases to a couple of field names
--to distinguish total sales from total purchases. Make sure you apply
--the appropriate alias to the field from the appropriate copy of the table.

CREATE TABLE #Orders
(
       OrderDate DATE
	  ,OrderMonth DATE
      ,TotalDue MONEY
	  ,OrderRank INT
)


--Insert sales data:

INSERT INTO #Orders
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

FROM AdventureWorks2019.Sales.SalesOrderHeader --sales data



CREATE TABLE #OrdersMinusTop10
(
OrderMonth DATE,
OrderType VARCHAR(32),
TotalDue MONEY
)

--Insert sales data:
INSERT INTO #OrdersMinusTop10
(
OrderMonth,
OrderType,
TotalDue
)
SELECT
OrderMonth,
OrderType = 'Sales',
TotalDue = SUM(TotalDue)
FROM #Orders
WHERE OrderRank > 10
GROUP BY OrderMonth


--Empty out #Orders table

TRUNCATE TABLE #Orders


--Insert purchase data:

INSERT INTO #Orders
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

FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader --purchase data


--Insert purchase data:

INSERT INTO #OrdersMinusTop10
(
OrderMonth,
OrderType,
TotalDue
)
SELECT
OrderMonth,
OrderType = 'Purchase',
TotalDue = SUM(TotalDue)
FROM #Orders
WHERE OrderRank > 10
GROUP BY OrderMonth




SELECT
A.OrderMonth,
TotalSales = A.TotalDue,
TotalPurchases = B.TotalDue

FROM #OrdersMinusTop10 A
	JOIN #OrdersMinusTop10 B
		ON A.OrderMonth = B.OrderMonth
			AND B.OrderType = 'Purchase'

WHERE A.OrderType = 'Sales'

ORDER BY 1

DROP TABLE #Orders
DROP TABLE #OrdersMinusTop10



--Optimisation 
--Select all orders with at least one item over 10K, using EXISTS

SELECT
       A.SalesOrderID
      ,A.OrderDate
      ,A.TotalDue

FROM AdventureWorks2019.Sales.SalesOrderHeader A

WHERE EXISTS (
	SELECT
	1
	FROM AdventureWorks2019.Sales.SalesOrderDetail B
	WHERE A.SalesOrderID = B.SalesOrderID
		AND B.LineTotal > 10000
)

ORDER BY 1



--5.) Select all orders with at least one item over 10K, including a line item value, using UPDATE

--Create a table with Sales data, including a field for line total:
CREATE TABLE #Sales
(
SalesOrderID INT,
OrderDate DATE,
TotalDue MONEY,
LineTotal MONEY
)


--Insert sales data to temp table
INSERT INTO #Sales
(
SalesOrderID,
OrderDate,
TotalDue
)

SELECT
SalesOrderID,
OrderDate,
TotalDue

FROM AdventureWorks2019.Sales.SalesOrderHeader


--Update temp table with > 10K line totals

UPDATE A
SET LineTotal = B.LineTotal

FROM #Sales A
	JOIN AdventureWorks2019.Sales.SalesOrderDetail B
		ON A.SalesOrderID = B.SalesOrderID
WHERE B.LineTotal > 10000


--Recreate EXISTS:

SELECT * FROM #Sales WHERE LineTotal IS NOT NULL


--Recreate NOT EXISTS:

SELECT * FROM #Sales WHERE LineTotal IS NULL


--Excersie 
--Starter code 

SELECT
       A.PurchaseOrderID,
	   A.OrderDate,
	   A.TotalDue

FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader A

WHERE EXISTS (
	SELECT
	1
	FROM AdventureWorks2019.Purchasing.PurchaseOrderDetail B
	WHERE A.PurchaseOrderID = B.PurchaseOrderID
		AND B.RejectedQty > 5
)

ORDER BY 1



--Exercise
--Re-write the query in the "An Improved EXISTS With UPDATE -
--Exercise Starter Code.sql" file (you can find the file in the Resources
--for this section), using temp tables and UPDATE statements instead of EXISTS.

--In addition to the three columns in the original query, you should also
--include a fourth column called "RejectedQty", which has one value
--for rejected quantity from the Purchasing.PurchaseOrderDetail table.
 
--Re-write:

CREATE TABLE #Purchases
(
PurchaseOrderID INT,
OrderDate DATE,
TotalDue MONEY,
RejectedQty INT
)



INSERT INTO #Purchases
(
PurchaseOrderID,
OrderDate,
TotalDue
)

SELECT
PurchaseOrderID,
OrderDate,
TotalDue

FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader


UPDATE A
	SET RejectedQty = B.RejectedQty

FROM #Purchases A
	JOIN AdventureWorks2019.Purchasing.PurchaseOrderDetail B
		ON A.PurchaseOrderID = B.PurchaseOrderID
WHERE B.RejectedQty > 5



SELECT * FROM #Purchases WHERE RejectedQty IS NOT NULL


DROP TABLE #Purchases




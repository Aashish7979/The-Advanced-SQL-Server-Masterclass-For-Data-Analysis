--Example 1

SELECT * FROM AdventureWorks2019.Sales.SalesOrderHeader WHERE SalesOrderID = 43683

SELECT * FROM AdventureWorks2019.Sales.SalesOrderDetail WHERE SalesOrderID = 43683





--Example 2: One to many join with criteria

SELECT
       A.SalesOrderID
      ,A.OrderDate
      ,A.TotalDue

FROM AdventureWorks2019.Sales.SalesOrderHeader A
	INNER JOIN AdventureWorks2019.Sales.SalesOrderDetail B
		ON A.SalesOrderID = B.SalesOrderID

WHERE EXISTS(
	SELECT
		1

	FROM AdventureWorks2019.Sales.SalesOrderDetail B
	
	WHERE B.LineTotal > 10000
		AND A.SalesOrderID = B.SalesOrderID
	)

ORDER BY 1





--Example 3: Using EXISTS to pick only the records we need

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



--Example 4: exclusionary one to many join

SELECT
       A.SalesOrderID
      ,A.OrderDate
      ,A.TotalDue
	  ,B.SalesOrderDetailID
	  ,B.LineTotal

FROM AdventureWorks2019.Sales.SalesOrderHeader A
	INNER JOIN AdventureWorks2019.Sales.SalesOrderDetail B
		ON A.SalesOrderID = B.SalesOrderID

WHERE B.LineTotal < 10000
	AND A.SalesOrderID = 43683

ORDER BY 1



--Example 5: but this doesn't even do what we want!

SELECT
*
FROM AdventureWorks2019.Sales.SalesOrderDetail

WHERE SalesOrderID = 43683

ORDER BY LineTotal DESC




--Example 6: NOT EXISTS

SELECT
       A.SalesOrderID
      ,A.OrderDate
      ,A.TotalDue

FROM AdventureWorks2019.Sales.SalesOrderHeader A

WHERE NOT EXISTS (
	SELECT
	1
	FROM AdventureWorks2019.Sales.SalesOrderDetail B
	WHERE A.SalesOrderID = B.SalesOrderID
		AND B.LineTotal > 10000
)
	--AND A.SalesOrderID = 43683

ORDER BY 1

--Exercise 1
--Select all records from the Purchasing.PurchaseOrderHeader table
--such that there is at least one item in the order with an order
--quantity greater than 500. The individual items tied to an order can
--be found in the Purchasing.PurchaseOrderDetail table.
--Select the following columns:
--PurchaseOrderID, OrderDate, SubTotal, TaxAmt
--Sort by purchase order ID.

	select 
		PurchaseOrderID
		,OrderDate
		,SubTotal
		,TaxAmt

	from Purchasing.PurchaseOrderHeader a

	where exists (select 1
				  from Purchasing.PurchaseOrderDetail b
				  where b.PurchaseOrderID = a.PurchaseOrderID
				  and b.OrderQty > 500) 

	order by PurchaseOrderID

	--Exercise 2
	--Modify your query from Exercise 1 as follows: 
	--Select all records from the Purchasing.PurchaseOrderHeader table
	--such that there is at least one item in the order with an order
	--quantity greater than 500, AND a unit price greater than $50.00.
	
	--Select ALL columns from the Purchasing.PurchaseOrderHeader
	--table for display in your output.

	--Even if you have aliased this table to enable the use of a JOIN or
	--EXISTS, you can still use the SELECT * shortcut to do this. Assuming
	--you have aliased your table "A", simply use "SELECT A.*" to select all
	--columns from that table.

	select 
		a.*

	from Purchasing.PurchaseOrderHeader a

	where exists (select 1
				  from Purchasing.PurchaseOrderDetail b
				  where b.PurchaseOrderID = a.PurchaseOrderID
				  and b.OrderQty > 500 
				  and b.UnitPrice > 50) 

	order by a.PurchaseOrderID 


	--Exercise 3
	--Select all records from the Purchasing.PurchaseOrderHeader table
	--such that NONE of the items within the order have a rejected
	--quantity greater than 0.

	--Select ALL columns from the Purchasing.PurchaseOrderHeader
	--table using the "SELECT *" shortcut.

	select 
		a.*

		from Purchasing.PurchaseOrderHeader a 
		where not exists (select 1
						  from Purchasing.PurchaseOrderDetail b
						  where b.RejectedQty > 0
						  and a.PurchaseOrderID = b.PurchaseOrderID)

	
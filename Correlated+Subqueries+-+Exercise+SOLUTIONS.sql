SELECT 
       SalesOrderID
      ,OrderDate
      ,SubTotal
      ,TaxAmt
      ,Freight
      ,TotalDue
	  ,MultiOrderCount = --correlated subquery
	  (
		SELECT 
		count(*) 

		FROM AdventureWorks2019.Sales.SalesOrderDetail b
		where b.SalesOrderID = a.SalesOrderID
		and OrderQty > 1
	  )

  FROM AdventureWorks2019.Sales.SalesOrderHeader A

  --Correlated Subqueries - Exercises
--Write a query that outputs all records from the
--Purchasing.PurchaseOrderHeader table. Include the following
--columns from the table:
--PurchaseOrderID, VendorID, OrderDate, TotalDue
--Add a derived column called NonRejectedItems which returns, for
--each purchase order ID in the query output, the number of line items
--from the Purchasing.PurchaseOrderDetail table which did not have
--any rejections (i.e., RejectedQty = 0). Use a correlated subquery to
--do this.

	select 
			PurchaseOrderID
			,VendorID
			,OrderDate
			,TotalDue
			,NonRejectedItems = 

			(
			select 
				count(*)
			from Purchasing.PurchaseOrderDetail b
			where b.PurchaseOrderID = a.PurchaseOrderID
			and b.RejectedQty = 0
			)

	from Purchasing.PurchaseOrderHeader a

--Exercise 2
--Modify your query to include a second derived field called
--MostExpensiveItem.

--This field should return, for each purchase order ID, the UnitPrice of
--the most expensive item for that order in the
--Purchasing.PurchaseOrderDetail table.
--Use a correlated subquery to do this as well.

--Hint: Think of the most appropriate aggregate function to use in the
--correlated subquery for this scenario.

	select 
			PurchaseOrderID
			,VendorID
			,OrderDate
			,TotalDue
			,NonRejectedItems = 
			(
			select 
				count(*)
			from Purchasing.PurchaseOrderDetail b
			where b.PurchaseOrderID = a.PurchaseOrderID
			and RejectedQty = 0
			)
			,MostExpensiveItem = 
			(
			select 
				max(UnitPrice)
			from Purchasing.PurchaseOrderDetail c
			where c.PurchaseOrderID = a.PurchaseOrderID
			)

	from Purchasing.PurchaseOrderHeader a

			
	
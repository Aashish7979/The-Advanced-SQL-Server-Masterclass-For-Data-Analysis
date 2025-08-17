--Basic LEAD/LAG example

SELECT
       SalesOrderID
      ,OrderDate
      ,CustomerID
      ,TotalDue
	  ,NextTotalDue = LEAD(TotalDue, 3) OVER(ORDER BY SalesOrderID)
	  ,PrevTotalDue = LAG(TotalDue, 3) OVER(ORDER BY SalesOrderID)

FROM AdventureWorks2019.Sales.SalesOrderHeader

ORDER BY SalesOrderID




--Looking forward (or backward) more than one record

SELECT
       SalesOrderID
      ,OrderDate
      ,CustomerID
      ,TotalDue
	  ,NextTotalDue = LEAD(TotalDue, 3) OVER(ORDER BY SalesOrderID)
	  ,PrevTotalDue = LAG(TotalDue, 3) OVER(ORDER BY SalesOrderID)

FROM AdventureWorks2019.Sales.SalesOrderHeader

ORDER BY SalesOrderID





--Using PARTITION with LEAD and LAG

SELECT
       SalesOrderID
      ,OrderDate
      ,CustomerID
      ,TotalDue
	  ,NextTotalDue = LEAD(TotalDue, 1) OVER(PARTITION BY CustomerID ORDER BY SalesOrderID)
	  ,PrevTotalDue = LAG(TotalDue, 1) OVER(PARTITION BY CustomerID ORDER BY SalesOrderID)

FROM AdventureWorks2019.Sales.SalesOrderHeader

ORDER BY CustomerID, SalesOrderID

--Exercise 1
--Create a query with the following columns:
--“PurchaseOrderID” from the Purchasing.PurchaseOrderHeader table
--“OrderDate” from the Purchasing.PurchaseOrderHeader table
--“TotalDue” from the Purchasing.PurchaseOrderHeader table
--“Name” from the Purchasing.Vendor table, which can be aliased as “VendorName”*
--*Join Purchasing.Vendor to Purchasing.PurchaseOrderHeader on BusinessEntityID = VendorID
--Apply the following criteria to the query:
--Order must have taken place on or after 2013
--TotalDue must be greater than $500

select 
	a.PurchaseOrderID,
	a.OrderDate,
	a.TotalDue,
	VendorName = b.Name

from Purchasing.PurchaseOrderHeader a
join Purchasing.Vendor b
on a.VendorID = b.BusinessEntityID

where year(a.OrderDate) >= '2013'
and a.TotalDue > 500

--Exercise 2
--Modify your query from Exercise 1 by adding a derived column called
--"PrevOrderFromVendorAmt", that returns the “previous” TotalDue
--value (relative to the current row) within the group of all orders with
--the same vendor ID. We are defining “previous” based on order date.

select 
	a.PurchaseOrderID,
	a.OrderDate,
	a.TotalDue,
	VendorName = b.Name,
	PrevOrderFromVendorAmt = lag(a.TotalDue, 1) over(partition by A.VendorID order by a.OrderDate)

from Purchasing.PurchaseOrderHeader a
join Purchasing.Vendor b
on a.VendorID = b.BusinessEntityID

where year(a.OrderDate) >= '2013'
and a.TotalDue > 500

ORDER BY 
  A.VendorID,
  A.OrderDate

  --Exercise 3
  --Modify your query from Exercise 2 by adding a derived column called
  --"NextOrderByEmployeeVendor", that returns the “next” vendor name
  --(the “name” field from Purchasing.Vendor) within the group of all
  --orders that have the same EmployeeID value in
  --Purchasing.PurchaseOrderHeader. Similar to the last exercise, we
  --are defining “next” based on order date.

 select 
	a.PurchaseOrderID,
	a.OrderDate,
	a.TotalDue,
	VendorName = b.Name,
	PrevOrderFromVendorAmt = lag(a.TotalDue, 1) over(partition by a.VendorID order by a.OrderDate),
	NextOrderByEmployeeVendor = lead(b.Name,1) over(partition by a.EmployeeID order by a.OrderDate)

from Purchasing.PurchaseOrderHeader a
join Purchasing.Vendor b
on a.VendorID = b.BusinessEntityID

where year(a.OrderDate) >= '2013'
and a.TotalDue > 500

ORDER BY 
  a.EmployeeID, 
  a.OrderDate

  --Exercise 4
  --Modify your query from Exercise 3 by adding a derived column called
  --"Next2OrderByEmployeeVendor" that returns, within the group of all
  --orders that have the same EmployeeID, the vendor name offset TWO
  --orders into the “future” relative to the order in the current row. The
  --code should be very similar to Exercise 3, but with an extra argument
  --passed to the Window Function used.
 
 select 
	a.PurchaseOrderID,
	a.OrderDate,
	a.TotalDue,
	VendorName = b.Name,
	PrevOrderFromVendorAmt = lag(a.TotalDue, 1) over(partition by a.VendorID order by a.OrderDate),
	NextOrderByEmployeeVendor = lead(b.Name,1) over(partition by a.EmployeeID order by a.OrderDate),
	Next2OrderByEmployeeVendor = lead(b.Name,2) over(partition by a.EmployeeID order by a.OrderDate)

from Purchasing.PurchaseOrderHeader a
join Purchasing.Vendor b
on a.VendorID = b.BusinessEntityID

where year(a.OrderDate) >= '2013'
and a.TotalDue > 500

ORDER BY 
  a.EmployeeID, 
  a.OrderDate


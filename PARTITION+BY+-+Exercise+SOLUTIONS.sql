--Partition by 

--Sum of line totals, grouped by ProductID AND OrderQty, in an aggregate query

SELECT
	ProductID,
	OrderQty,
	LineTotal = SUM(LineTotal)

FROM AdventureWorks2019.Sales.SalesOrderDetail

GROUP BY
	ProductID,
	OrderQty

ORDER BY 1,2 DESC



--Sum of line totals via OVER with PARTITION BY

SELECT
	ProductID,
	SalesOrderID,
	SalesOrderDetailID,
	OrderQty,
	UnitPrice,
	UnitPriceDiscount,
	LineTotal,
	ProductIDLineTotal = SUM(LineTotal) OVER(PARTITION BY ProductID, OrderQty)

FROM AdventureWorks2019.Sales.SalesOrderDetail

ORDER BY ProductID, OrderQty DESC


--Exercise 1
--Create a query with the following columns:
--“Name” from the Production.Product table, which can be alised as “ProductName”
--“ListPrice” from the Production.Product table
--“Name” from the Production. ProductSubcategory table, which can be alised as “ProductSubcategory”*
--“Name” from the Production.ProductCategory table, which can be alised as “ProductCategory”**
--*Join Production.ProductSubcategory to Production.Product on “ProductSubcategoryID”
--**Join Production.ProductCategory to ProductSubcategory on “ProductCategoryID”
--All the tables can be inner joined, and you do not need to apply any criteria.
select 
	ProductName = a.Name, 
	a.ListPrice, 
	ProductSubcategory = b.Name,
	ProductCategory = c.Name
from Production.Product a 
join Production. ProductSubcategory b 
on a.ProductSubcategoryID = b.ProductSubcategoryID
join Production.ProductCategory c
on b.ProductCategoryID = c.ProductCategoryID

--Exercise 2
--Enhance your query from Exercise 1 by adding a derived column called
--"AvgPriceByCategory " that returns the average ListPrice for the product category in each given row.

select 
	ProductName = a.Name, 
	a.ListPrice, 
	ProductSubcategory = b.Name,
	ProductCategory = c.Name,
	AvgPriceByCategory = avg(a.ListPrice) over(partition by c.Name)
from Production.Product a 
join Production. ProductSubcategory b 
on a.ProductSubcategoryID = b.ProductSubcategoryID
join Production.ProductCategory c
on b.ProductCategoryID = c.ProductCategoryID

--Exercise 3
--Enhance your query from Exercise 2 by adding a derived column called
--"AvgPriceByCategoryAndSubcategory" that returns the average ListPrice for the product category AND subcategory in each given row.

select 
	ProductName = a.Name, 
	a.ListPrice, 
	ProductSubcategory = b.Name,
	ProductCategory = c.Name,
	AvgPriceByCategory = avg(a.ListPrice) over(partition by c.Name),
	AvgPriceByCategoryAndSubcategory = avg(a.ListPrice) over(partition by c.Name, b.Name)
from Production.Product a 
join Production. ProductSubcategory b 
on a.ProductSubcategoryID = b.ProductSubcategoryID
join Production.ProductCategory c
on b.ProductCategoryID = c.ProductCategoryID

--Exercise 4:
--Enhance your query from Exercise 3 by adding a derived column called
--"ProductVsCategoryDelta" that returns the result of the following calculation:
--A product's list price, MINUS the average ListPrice for that product’s category.

select 
	ProductName = a.Name, 
	a.ListPrice, 
	ProductSubcategory = b.Name,
	ProductCategory = c.Name,
	AvgPriceByCategory = avg(a.ListPrice) over(partition by c.Name),
	AvgPriceByCategoryAndSubcategory = avg(a.ListPrice) over(partition by c.Name, b.Name),
	ProductVsCategoryDelta = a.ListPrice - avg(a.ListPrice) over(partition by c.Name)
from Production.Product a 
join Production. ProductSubcategory b 
on a.ProductSubcategoryID = b.ProductSubcategoryID
join Production.ProductCategory c
on b.ProductCategoryID = c.ProductCategoryID


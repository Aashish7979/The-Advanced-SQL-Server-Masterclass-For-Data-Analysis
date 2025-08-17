--Row number - Excercise
--Ranking all records within each group of sales order IDs

SELECT
	SalesOrderID,
	SalesOrderDetailID,
	LineTotal,
	ProductIDLineTotal = SUM(LineTotal) OVER(PARTITION BY SalesOrderID),
	Ranking = ROW_NUMBER() OVER(PARTITION BY SalesOrderID ORDER BY LineTotal DESC)

FROM AdventureWorks2019.Sales.SalesOrderDetail

ORDER BY
SalesOrderID




--Ranking ALL records by line total - no groups!

SELECT
	SalesOrderID,
	SalesOrderDetailID,
	LineTotal,
	ProductIDLineTotal = SUM(LineTotal) OVER(PARTITION BY SalesOrderID),
	Ranking = ROW_NUMBER() OVER(ORDER BY LineTotal DESC)

FROM AdventureWorks2019.Sales.SalesOrderDetail

ORDER BY 5

--Exercise 1
--Create a query with the following columns (feel free to borrow your code from Exercise 1 of the PARTITION BY exercises):
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

from AdventureWorks2019.Production.Product a
join AdventureWorks2019.Production. ProductSubcategory b
on a.ProductSubcategoryID = b.ProductSubcategoryID
join AdventureWorks2019.Production.ProductCategory c
on b.ProductCategoryID = c.ProductCategoryID

--Exercise 2
--Enhance your query from Exercise 1 by adding a derived column called
--"Price Rank " that ranks all records in the dataset by ListPrice, in
--descending order. That is to say, the product with the most
--expensive price should have a rank of 1, and the product with the
--least expensive price should have a rank equal to the number of
--records in the dataset.

select
	ProductName = a.Name,
	a.ListPrice,
	ProductSubcategory = b.Name,
	ProductCategory = c.Name,
	"Price Rank" = row_number() Over(order by a.ListPrice desc)  

from AdventureWorks2019.Production.Product a
join AdventureWorks2019.Production. ProductSubcategory b
on a.ProductSubcategoryID = b.ProductSubcategoryID
join AdventureWorks2019.Production.ProductCategory c
on b.ProductCategoryID = c.ProductCategoryID

--Exercise 3
--Enhance your query from Exercise 2 by adding a derived column called
--"Category Price Rank" that ranks all products by ListPrice – within
--each category - in descending order. In other words, every product
--within a given category should be ranked relative to other products
--in the same category.

select
	ProductName = a.Name,
	a.ListPrice,
	ProductSubcategory = b.Name,
	ProductCategory = c.Name,
	"Price Rank" = row_number() Over(order by a.ListPrice desc),
	"Category Price Rank" = row_number() Over(partition by c.Name order by a.ListPrice desc)

from AdventureWorks2019.Production.Product a
join AdventureWorks2019.Production. ProductSubcategory b
on a.ProductSubcategoryID = b.ProductSubcategoryID
join AdventureWorks2019.Production.ProductCategory c
on b.ProductCategoryID = c.ProductCategoryID

--Exercise 4
--Enhance your query from Exercise 3 by adding a derived column called
--"Top 5 Price In Category" that returns the string “Yes” if a product
--has one of the top 5 list prices in its product category, and “No” if it
--does not. You can try incorporating your logic from Exercise 3 into a
--CASE statement to make this work.

select
	ProductName = a.Name,
	a.ListPrice,
	ProductSubcategory = b.Name,
	ProductCategory = c.Name,
	"Price Rank" = row_number() Over(order by a.ListPrice desc),
	"Category Price Rank" = row_number() Over(partition by c.Name order by a.ListPrice desc), 
	"Top 5 Price In Category" = case 
									 when row_number() over(partition by c.Name order by a.ListPrice desc) <= 5 then 'Yes'
									 else 'No' 
								End 

from AdventureWorks2019.Production.Product a
join AdventureWorks2019.Production. ProductSubcategory b
on a.ProductSubcategoryID = b.ProductSubcategoryID
join AdventureWorks2019.Production.ProductCategory c
on b.ProductCategoryID = c.ProductCategoryID


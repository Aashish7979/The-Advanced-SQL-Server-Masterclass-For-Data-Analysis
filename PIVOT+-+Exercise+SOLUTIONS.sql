--Pivot
--Example 1

SELECT
[Accessories],
[Bikes],
[Clothing],
[Components]

FROM
(
SELECT
	   ProductCategoryName = D.Name,
	   A.LineTotal

FROM AdventureWorks2019.Sales.SalesOrderDetail A
	JOIN AdventureWorks2019.Production.Product B
		ON A.ProductID = B.ProductID
	JOIN AdventureWorks2019.Production.ProductSubcategory C
		ON B.ProductSubcategoryID = C.ProductSubcategoryID
	JOIN AdventureWorks2019.Production.ProductCategory D
		ON C.ProductCategoryID = D.ProductCategoryID
) E

PIVOT(
SUM(LineTotal)
FOR ProductCategoryName IN([Accessories],[Bikes],[Clothing],[Components])
) F

ORDER BY 1

--Example 2

SELECT
[Order Quantity] = OrderQty,
[Bikes],
[Clothing] 

FROM
(
SELECT
	   ProductCategoryName = D.Name,
	   A.LineTotal,
	   A.OrderQty

FROM AdventureWorks2019.Sales.SalesOrderDetail A
	JOIN AdventureWorks2019.Production.Product B
		ON A.ProductID = B.ProductID
	JOIN AdventureWorks2019.Production.ProductSubcategory C
		ON B.ProductSubcategoryID = C.ProductSubcategoryID
	JOIN AdventureWorks2019.Production.ProductCategory D
		ON C.ProductCategoryID = D.ProductCategoryID
) E

PIVOT(
SUM(LineTotal)
FOR ProductCategoryName IN([Bikes],[Clothing])
) F

ORDER BY 1

--Exercise 1
--Using PIVOT, write a query against the HumanResources.Employee table
--that summarizes the average amount of vacation time for Sales
--Representatives, Buyers, and Janitors.

--Your output should look like the image below.
select * 
from (
	select
			JobTitle,
			VacationHours

	from AdventureWorks2019.HumanResources.Employee

	) a

pivot(
avg(VacationHours)
for [JobTitle] IN ([Sales Representative], [Buyer], [Janitor]) ) b   

--Exercise 2
--Modify your query from Exercise 1 such that the results are broken
--out by Gender. Alias the Gender field as "Employee Gender" in your
--output.

--Your output should look like the image below:

select * 
from (
	select
			JobTitle,
			VacationHours,
			Gender

	from AdventureWorks2019.HumanResources.Employee

	) a

pivot(
avg(VacationHours)
for [JobTitle] IN ([Sales Representative], [Buyer], [Janitor]) ) b 


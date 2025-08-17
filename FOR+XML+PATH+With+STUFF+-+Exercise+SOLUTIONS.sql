--Step 1

		  SELECT
		  COUNT(*)
		  FROM AdventureWorks2019.Sales.SalesOrderDetail A
		  WHERE A.SalesOrderID = 43659



--Step 2:

		  SELECT
		  *
		  FROM AdventureWorks2019.Sales.SalesOrderDetail A
		  WHERE A.SalesOrderID = 43659

--Step 3:

		  SELECT
		  LineTotal
		  FROM AdventureWorks2019.Sales.SalesOrderDetail A
		  WHERE A.SalesOrderID = 43659


--Step 4:

		  SELECT
		  LineTotal
		  FROM AdventureWorks2019.Sales.SalesOrderDetail A
		  WHERE A.SalesOrderID = 43659
		  FOR XML PATH('')

--Step 5:

		  SELECT
		  ',' + CAST(CAST(LineTotal AS MONEY) AS VARCHAR)
		  FROM AdventureWorks2019.Sales.SalesOrderDetail A
		  WHERE A.SalesOrderID = 43659
		  FOR XML PATH('')

--Step 6:

SELECT
	STUFF(
		  (
			  SELECT
			  ',' + CAST(CAST(LineTotal AS MONEY) AS VARCHAR)
			  FROM AdventureWorks2019.Sales.SalesOrderDetail A
			  WHERE A.SalesOrderID = 43659
			  FOR XML PATH('')
		  ),
		  1,1,'I''m stuffed!')



--Step 7:

SELECT 
       SalesOrderID
      ,OrderDate
      ,SubTotal
      ,TaxAmt
      ,Freight
      ,TotalDue
	  ,LineTotals = 
		STUFF(
			  (
				  SELECT
				  ',' + CAST(CAST(LineTotal AS MONEY) AS VARCHAR)
				  FROM AdventureWorks2019.Sales.SalesOrderDetail B
				  WHERE A.SalesOrderID = B.SalesOrderID 
				  FOR XML PATH('')
			  ),
			  1,1,''
		  )

FROM AdventureWorks2019.Sales.SalesOrderHeader A


--Exercise 1
--Create a query that displays all rows from the
--Production.ProductSubcategory table, and includes the following fields:

--The "Name" field from Production.ProductSubcategory, which should be aliased as "SubcategoryName"
--A derived field called "Products" which displays, for each
--Subcategory in Production.ProductSubcategory, a semicolon-
--separated list of all products from Production.Product contained
--within the given subcategory
--Hint: Production.ProductSubcategory and Production.Product are
--related by the "ProductSubcategoryID" field.

	select 
			a.*,
			SubcategoryName = a.Name,
			Products = 
						STUFF(
								(
									SELECT
										';' + b.Name

									FROM AdventureWorks2019.Production.Product b

									WHERE a.ProductSubcategoryID = b.ProductSubcategoryID

									FOR XML PATH('')

								),1,1,''
							)
	from Production.ProductSubcategory a

	--Exercise 2
	--Modify the query from Exercise 1 such that only products with a
	--ListPrice value greater than $50 are listed in the "Products" field.
	--Hint: Assuming you used a correlated subquery in Exercise 1, keep in
	--mind that you can apply additional criteria to it, just as with any other
	--correlated subquery.

	--NOTE: Your query should still include ALL product subcategories, but
	--only list associated products greater than $50. But since there are
	--certain product subcategories that don't have any associated products
	--greater than $50, some rows in your query output may have a NULL
	--value in the product field.

SELECT 
       SubcategoryName = A.[Name]
	  ,Products =
		STUFF(
			(
				SELECT
					';' + B.Name

				FROM AdventureWorks2019.Production.Product B

				WHERE A.ProductSubcategoryID = B.ProductSubcategoryID
					AND B.ListPrice > 50

				FOR XML PATH('')

			),1,1,''
		)

 FROM AdventureWorks2019.Production.ProductSubcategory A


--Optimization with Indexes
--Starter Code:

SELECT 
	   A.SalesOrderID
	  ,A.OrderDate
      ,B.ProductID
      ,B.LineTotal
	  ,C.[Name] AS ProductName
	  ,D.[Name] AS ProductSubcategory
	  ,E.[Name] AS ProductCategory


FROM AdventureWorks2019.Sales.SalesOrderHeader A
	JOIN AdventureWorks2019.Sales.SalesOrderDetail B
		ON A.SalesOrderID = B.SalesOrderID
	JOIN AdventureWorks2019.Production.Product C
		ON B.ProductID = C.ProductID
	JOIN AdventureWorks2019.Production.ProductSubcategory D
		ON C.ProductSubcategoryID = D.ProductSubcategoryID
	JOIN AdventureWorks2019.Production.ProductCategory E
		ON D.ProductCategoryID = E.ProductCategoryID

WHERE YEAR(A.OrderDate) = 2012


--Optimized script


--1.) Create filtered temp table of sales order header table WHERE year = 2012

CREATE TABLE #Sales2012 
(
SalesOrderID INT,
OrderDate DATE
)

INSERT INTO #Sales2012
(
SalesOrderID,
OrderDate
)

SELECT
SalesOrderID,
OrderDate

FROM AdventureWorks2019.Sales.SalesOrderHeader

WHERE YEAR(OrderDate) = 2012




--2.) Create new temp table after joining in SalesOrderDetail  table

CREATE TABLE #ProductsSold2012
(
SalesOrderID INT,
OrderDate DATE,
LineTotal MONEY,
ProductID INT,
ProductName VARCHAR(64),
ProductSubcategoryID INT,
ProductSubcategory VARCHAR(64),
ProductCategoryID INT,
ProductCategory VARCHAR(64)
)

INSERT INTO #ProductsSold2012
(
SalesOrderID,
OrderDate,
LineTotal,
ProductID
)

SELECT 
	   A.SalesOrderID
	  ,A.OrderDate
      ,B.LineTotal
      ,B.ProductID

FROM #Sales2012 A
	JOIN AdventureWorks2019.Sales.SalesOrderDetail B
		ON A.SalesOrderID = B.SalesOrderID



--3.) Add product data with UPDATE

UPDATE A
SET
ProductName = B.[Name],
ProductSubcategoryID = B.ProductSubcategoryID

FROM #ProductsSold2012 A
	JOIN AdventureWorks2019.Production.Product B
		ON A.ProductID = B.ProductID



--4.) Add product subcategory with UPDATE

UPDATE A
SET
ProductSubcategory= B.[Name],
ProductCategoryID = B.ProductCategoryID

FROM #ProductsSold2012 A
	JOIN AdventureWorks2019.Production.ProductSubcategory B
		ON A.ProductSubcategoryID = B.ProductSubcategoryID





--5.) Add product category data with UPDATE


UPDATE A
SET
ProductCategory= B.[Name]

FROM #ProductsSold2012 A
	JOIN AdventureWorks2019.Production.ProductCategory B
		ON A.ProductCategoryID = B.ProductCategoryID


SELECT * FROM #ProductsSold2012

---Excercise starter code 

SELECT 
	   A.BusinessEntityID
      ,A.Title
      ,A.FirstName
      ,A.MiddleName
      ,A.LastName
	  ,B.PhoneNumber
	  ,PhoneNumberType = C.Name
	  ,D.EmailAddress

FROM AdventureWorks2019.Person.Person A
	LEFT JOIN AdventureWorks2019.Person.PersonPhone B
		ON A.BusinessEntityID = B.BusinessEntityID
	LEFT JOIN AdventureWorks2019.Person.PhoneNumberType C
		ON B.PhoneNumberTypeID = C.PhoneNumberTypeID
	LEFT JOIN AdventureWorks2019.Person.EmailAddress D
		ON A.BusinessEntityID = D.BusinessEntityID
		
--Exercise
--Using indexes, further optimize your solution to the "Optimizing With
--UPDATE" exercise. You can find the starter code in the "Optimizing
--With UPDATE - Exercise Starter Code.sql" file in the Resources for this section.


--Rewrite:

CREATE TABLE #PersonContactInfo
(
	   BusinessEntityID INT
      ,Title VARCHAR(8)
      ,FirstName VARCHAR(50)
      ,MiddleName VARCHAR(50)
      ,LastName VARCHAR(50)
	  ,PhoneNumber VARCHAR(25)
	  ,PhoneNumberTypeID VARCHAR(25)
	  ,PhoneNumberType VARCHAR(25)
	  ,EmailAddress VARCHAR(50)
)

INSERT INTO #PersonContactInfo
(
	   BusinessEntityID
      ,Title
      ,FirstName
      ,MiddleName
      ,LastName
)

SELECT
	   BusinessEntityID
      ,Title
      ,FirstName
      ,MiddleName
      ,LastName

FROM AdventureWorks2019.Person.Person


UPDATE A
SET
	PhoneNumber = B.PhoneNumber,
	PhoneNumberTypeID = B.PhoneNumberTypeID

FROM #PersonContactInfo A
	JOIN AdventureWorks2019.Person.PersonPhone B
		ON A.BusinessEntityID = B.BusinessEntityID


UPDATE A
SET	PhoneNumberType = B.Name

FROM #PersonContactInfo A
	JOIN AdventureWorks2019.Person.PhoneNumberType B
		ON A.PhoneNumberTypeID = B.PhoneNumberTypeID


UPDATE A
SET	EmailAddress = B.EmailAddress

FROM #PersonContactInfo A
	JOIN AdventureWorks2019.Person.EmailAddress B
		ON A.BusinessEntityID = B.BusinessEntityID


SELECT * FROM #PersonContactInfo


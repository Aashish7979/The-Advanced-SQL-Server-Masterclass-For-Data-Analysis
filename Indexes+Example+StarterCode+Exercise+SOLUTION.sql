--Optimization using Index 

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


--1.) Add clustered index to #Sales2012


CREATE CLUSTERED INDEX Sales2012_idx ON #Sales2012(SalesOrderID)


--2.) Add sales order detail ID

CREATE TABLE #ProductsSold2012
(
SalesOrderID INT,
SalesOrderDetailID INT, --Add for clustered index
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
SalesOrderDetailID,
OrderDate,
LineTotal,
ProductID
)

SELECT 
	   A.SalesOrderID
	  ,B.SalesOrderDetailID
	  ,A.OrderDate
      ,B.LineTotal
      ,B.ProductID

FROM #Sales2012 A
	JOIN AdventureWorks2019.Sales.SalesOrderDetail B
		ON A.SalesOrderID = B.SalesOrderID


--3.) Add clustered index on SalesOrderDetailID

CREATE CLUSTERED INDEX ProductsSold2012_idx ON #ProductsSold2012(SalesOrderDetailID)


--4.) Add nonclustered index on product Id

CREATE NONCLUSTERED INDEX ProductsSold2012_idx2 ON #ProductsSold2012(ProductID)



--3.) Add product data with UPDATE


UPDATE A
SET
ProductName = B.[Name],
ProductSubcategoryID = B.ProductSubcategoryID

FROM #ProductsSold2012 A
	JOIN AdventureWorks2019.Production.Product B
		ON A.ProductID = B.ProductID


--4.) Add nonclustered index on product subcategory ID

CREATE NONCLUSTERED INDEX ProductsSold2012_idx3 ON #ProductsSold2012(ProductSubcategoryID)






UPDATE A
SET
ProductSubcategory= B.[Name],
ProductCategoryID = B.ProductCategoryID

FROM #ProductsSold2012 A
	JOIN AdventureWorks2019.Production.ProductSubcategory B
		ON A.ProductSubcategoryID = B.ProductSubcategoryID


--5) Add nonclustered index on category Id

CREATE NONCLUSTERED INDEX ProductsSold2012_idx4 ON #ProductsSold2012(ProductCategoryID)



UPDATE A
SET
ProductCategory= B.[Name]

FROM #ProductsSold2012 A
	JOIN AdventureWorks2019.Production.ProductCategory B
		ON A.ProductCategoryID = B.ProductCategoryID


SELECT * FROM #ProductsSold2012


--Index Starter code 

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

--Index Solution 

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


CREATE CLUSTERED INDEX pci_idx1 ON #PersonContactInfo(BusinessEntityID)


UPDATE A
SET
	PhoneNumber = B.PhoneNumber,
	PhoneNumberTypeID = B.PhoneNumberTypeID

FROM #PersonContactInfo A
	JOIN AdventureWorks2019.Person.PersonPhone B
		ON A.BusinessEntityID = B.BusinessEntityID


CREATE NONCLUSTERED INDEX pci_idx2 ON #PersonContactInfo(PhoneNumberTypeID)


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



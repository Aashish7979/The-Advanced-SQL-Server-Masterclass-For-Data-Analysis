--Optimisation Using Views
--Creating the view:

CREATE VIEW Sales.vw_SalesRolling3Days AS

SELECT
    OrderDate,
    TotalDue,
	SalesLast3Days = SUM(TotalDue) OVER(ORDER BY OrderDate ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
FROM (
	SELECT
		OrderDate,
		TotalDue = SUM(TotalDue)
	FROM
		Sales.SalesOrderHeader

	WHERE YEAR(OrderDate) = 2014

	GROUP BY
		OrderDate
) X


--Querying against the view:

SELECT
	OrderDate
   ,TotalDue
   ,SalesLast3Days
   ,[% Rolling 3 Days Sales] = FORMAT(TotalDue / SalesLast3Days, 'p')

FROM AdventureWorks2019.Sales.vw_SalesRolling3Days

--Exercise 1
--Create a view named vw_Top10MonthOverMonth in your
--AdventureWorks database, based on the query below. Assign the
--view to the Sales schema.

--HINT: You will need to make a slight tweak to the query code before
--it can be successfully converted to a view.

Create view Sales.vw_Top10MonthOverMonth as 

 WITH Sales AS
(
SELECT
OrderDate
,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
,TotalDue
,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
FROM AdventureWorks2019.Sales.SalesOrderHeader
)
 
,Top10Sales AS
(
SELECT
OrderMonth,
Top10Total = SUM(TotalDue)
FROM Sales
WHERE OrderRank <= 10
GROUP BY OrderMonth
)
 
 
SELECT
A.OrderMonth,
A.Top10Total,
PrevTop10Total = B.Top10Total
 
FROM Top10Sales A
LEFT JOIN Top10Sales B
ON A.OrderMonth = DATEADD(MONTH,1,B.OrderMonth)

--ORDER BY 1

/* Exercise 2
--Try converting the below query to a view.

What happens? Why? (You may need to do a little Google-ing/Bing-ing to find out.) */

--Solution: 

create view Sales.vw_TempTable as  

SELECT
OrderDate
,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
,TotalDue
,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)

INTO #Sales
 
FROM AdventureWorks2019.Sales.SalesOrderHeader

SELECT
OrderMonth,
Top10Total = SUM(TotalDue)
 
INTO #Top10Sales
 
FROM #Sales
 
WHERE OrderRank <= 10
 
GROUP BY OrderMonth

SELECT
A.OrderMonth,
A.Top10Total,
PrevTop10Total = B.Top10Total
 
FROM #Top10Sales A
LEFT JOIN #Top10Sales B
ON A.OrderMonth = DATEADD(MONTH,1,B.OrderMonth)

/*

As you probably found out, If you try to use a temporary table in a view definition, you'll
receive an error.

In SQL Server, you cannot include temporary tables (either local or global) as part of a
view definition. Temporary tables have a limited scope and lifespan; they exist only for the
duration of a user session or the scope of the routine they were created in. Because of this
transient nature, they cannot be used as part of a view, which should have a more permanent
and consistent structure.

*/
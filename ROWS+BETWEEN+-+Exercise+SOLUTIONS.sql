/*Rolling 3 day total*/

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

ORDER BY
    OrderDate



/*Rolling 3 day total, not inclusive of "current" row*/


SELECT
    OrderDate,
    TotalDue,
	SalesLast3Days = SUM(TotalDue) OVER(ORDER BY OrderDate ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING)
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

ORDER BY
    OrderDate


/*Rolling 3 day total, spanning previous and following row*/


SELECT
    OrderDate,
    TotalDue,
	SalesLast3Days = SUM(TotalDue) OVER(ORDER BY OrderDate ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING)
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

ORDER BY
    OrderDate



/*Rolling 3 day average - aka, a "moving" average*/


SELECT
    OrderDate,
    TotalDue,
	SalesLast3Days = AVG(TotalDue) OVER(ORDER BY OrderDate ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
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

ORDER BY
    OrderDate


--Exercise 1
--Create a query with the following columns:

--“OrderMonth”, a derived column (you’ll have to create this one
--yourself) featuring the month number corresponding with the
--Order Date in a given row

--“OrderYear”, a derived column featuring the year corresponding
--with the Order Date in a given row

--“SubTotal” from the Purchasing.PurchaseOrderHeader table

--Your query should be an aggregate query – specifically, it should
--sum “SubTotal”, and group by the remaining fields.

select 
		OrderMonth = month(OrderDate),
		OrderYear = year(OrderDate), 
		sum(SubTotal) 

from Purchasing.PurchaseOrderHeader

group by month(OrderDate), year(OrderDate)

--Exercise 2
--Modify your query from Exercise 1 by adding a derived column called
--"Rolling3MonthTotal", that displays  - for a given row - a running total
--of “SubTotal” for the prior three months (including the current row).

--HINT: You will need to include multiple fields in your ORDER BY to
--get this to work!

select 
		OrderMonth,
		OrderYear , 
		SubTotal,
		Rolling3MonthTotal = sum(SubTotal) over(order by OrderYear, OrderMonth ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
from 

(
	select 
			OrderMonth = month(OrderDate),
			OrderYear = year(OrderDate), 
			SubTotal = sum(SubTotal)

	from Purchasing.PurchaseOrderHeader

	group by 
		month(OrderDate), 
		year(OrderDate) 
	
) X

--Exercise 3
--Modify your query from Exercise 3 by adding another derived column
--called "MovingAvg6Month", that calculates a rolling average of
--“SubTotal” for the previous 6 months, relative to the month in the
--“current” row. Note that this average should NOT include the current
--row.

select 
		OrderMonth,
		OrderYear , 
		SubTotal,
		Rolling3MonthTotal = sum(SubTotal) over(order by OrderYear, OrderMonth ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),
		MovingAvg6Month = avg(SubTotal) over(order by OrderYear, OrderMonth ROWS BETWEEN 6 PRECEDING AND 1 PRECEDING) 

from 

(
	select 
			OrderMonth = month(OrderDate),
			OrderYear = year(OrderDate), 
			SubTotal = sum(SubTotal)

	from Purchasing.PurchaseOrderHeader

	group by 
		month(OrderDate), 
		year(OrderDate) 
	
) X

--Exercise 4

--Modify your query from Exercise 3 by adding (yet) another derived
--column called “MovingAvgNext2Months” , that calculates a rolling
--average of “SubTotal” for the month in the current row and the next
--two months after that. This moving average will provide a kind of
--"forecast" for Subtotal by month. 


select 
		OrderMonth,
		OrderYear , 
		SubTotal,
		Rolling3MonthTotal = sum(SubTotal) over(order by OrderYear, OrderMonth ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),
		MovingAvg6Month = avg(SubTotal) over(order by OrderYear, OrderMonth ROWS BETWEEN 6 PRECEDING AND 1 PRECEDING),  
		MovingAvgNext2Months = avg(SubTotal) over(order by OrderYear, OrderMonth ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) 

from 

(
	select 
			OrderMonth = month(OrderDate),
			OrderYear = year(OrderDate), 
			SubTotal = sum(SubTotal)

	from Purchasing.PurchaseOrderHeader

	group by 
		month(OrderDate), 
		year(OrderDate) 
	
) X















/*Rolling 3 day total, spanning previous and following row*/



SELECT
    OrderDate,
    TotalDue,
	SalesLast3Days = SUM(TotalDue) OVER(ORDER BY OrderDate ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING)
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

ORDER BY
    OrderDate
















/*Rolling 3 day average - aka, a "moving" average*/


SELECT
    OrderDate,
    TotalDue,
	SalesLast3Days = AVG(TotalDue) OVER(ORDER BY OrderDate ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
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

ORDER BY
    OrderDate
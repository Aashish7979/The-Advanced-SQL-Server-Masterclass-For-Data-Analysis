--Optimization using Lookup tables Examples
--Create Table

CREATE TABLE Adventureworks2019.dbo.Calendar
(
DateValue DATE,
DayOfWeekNumber INT,
DayOfWeekName VARCHAR(32),
DayOfMonthNumber INT,
MonthNumber INT,
YearNumber INT,
WeekendFlag TINYINT,
HolidayFlag TINYINT
)


--Insert values manually

INSERT INTO Adventureworks2019.dbo.Calendar
(
DateValue,
DayOfWeekNumber,
DayOfWeekName,
DayOfMonthNumber,
MonthNumber,
YearNumber,
WeekendFlag,
HolidayFlag
)

VALUES
(CAST('01-01-2011' AS DATE),7,'Saturday',1,1,2011,1,1),
(CAST('01-02-2011' AS DATE),1,'Sunday',2,1,2011,1,0)


SELECT * FROM Adventureworks2019.dbo.Calendar


--Truncate manually inserted values


TRUNCATE TABLE Adventureworks2019.dbo.Calendar




--Insert dates to table with recursive CTE

WITH Dates AS
(
SELECT
 CAST('01-01-2011' AS DATE) AS MyDate

UNION ALL

SELECT
DATEADD(DAY, 1, MyDate)
FROM Dates
WHERE MyDate < CAST('12-31-2030' AS DATE)
)

INSERT INTO AdventureWorks2019.dbo.Calendar
(
DateValue
)
SELECT
MyDate

FROM Dates
OPTION (MAXRECURSION 10000)

SELECT * FROM AdventureWorks2019.dbo.Calendar


--Update NULL fields in Calendar table

UPDATE AdventureWorks2019.dbo.Calendar
SET
DayOfWeekNumber = DATEPART(WEEKDAY,DateValue),
DayOfWeekName = FORMAT(DateValue,'dddd'),
DayOfMonthNumber = DAY(DateValue),
MonthNumber = MONTH(DateValue),
YearNumber = YEAR(DateValue)


SELECT * FROM AdventureWorks2019.dbo.Calendar



UPDATE AdventureWorks2019.dbo.Calendar
SET
WeekendFlag = 
	CASE
		WHEN DayOfWeekNumber IN(1,7) THEN 1
		ELSE 0
	END


SELECT * FROM AdventureWorks2019.dbo.Calendar



UPDATE AdventureWorks2019.dbo.Calendar
SET
HolidayFlag =
	CASE
		WHEN DayOfMonthNumber = 1 AND MonthNumber = 1 THEN 1
		ELSE 0
	END


SELECT * FROM AdventureWorks2019.dbo.Calendar


--Use Calendar table in a query


SELECT
A.*

FROM AdventureWorks2019.Sales.SalesOrderHeader A
	JOIN AdventureWorks2019.dbo.Calendar B
		ON A.OrderDate = B.DateValue

WHERE B.WeekendFlag = 1


--Exercise 1
--Update your calendar lookup table with a few holidays of your choice
--that always fall on the same day of the year - for example, New Year's.


UPDATE AdventureWorks2019.dbo.Calendar
SET
HolidayFlag =
	CASE
		WHEN DayOfMonthNumber = 1 AND MonthNumber = 1 THEN 1
		WHEN DayOfMonthNumber = 4 AND MonthNumber = 7 THEN 1
		WHEN DayOfMonthNumber = 11 AND MonthNumber = 11 THEN 1
		WHEN DayOfMonthNumber = 25 AND MonthNumber = 12 THEN 1
		ELSE 0
	END

	
--Exercise 2
--Using your updated calendar table, pull all purchasing orders that
--were made on a holiday. It's fine to simply select all columns via SELECT *.


SELECT
A.*

FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader A
	JOIN AdventureWorks2019.dbo.Calendar B
		ON A.OrderDate = B.DateValue

WHERE B.HolidayFlag = 1

--Exercise 3
--Again using your updated calendar table, now pull all purchasing
--orders that were made on a holiday that also fell on a weekend.


SELECT
A.*

FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader A
	JOIN AdventureWorks2019.dbo.Calendar B
		ON A.OrderDate = B.DateValue

WHERE B.HolidayFlag = 1 AND B.WeekendFlag = 1


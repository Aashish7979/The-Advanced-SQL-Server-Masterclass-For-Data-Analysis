-- Introducing Window Functions With OVER and Exercises

  --YTD Sales Via Aggregate Query:

SELECT

      [Total YTD Sales] = SUM(SalesYTD)
      ,[Max YTD Sales] = MAX(SalesYTD)

FROM AdventureWorks2019.Sales.SalesPerson



--YTD Sales With OVER:

SELECT BusinessEntityID
      ,TerritoryID
      ,SalesQuota
      ,Bonus
      ,CommissionPct
      ,SalesYTD
	  ,SalesLastYear
      ,[Total YTD Sales] = SUM(SalesYTD) OVER()
      ,[Max YTD Sales] = MAX(SalesYTD) OVER()
      ,[% of Best Performer] = SalesYTD/MAX(SalesYTD) OVER()

FROM AdventureWorks2019.Sales.SalesPerson

--Exercise 1
--Create a query with the following columns:
--FirstName and LastName, from the Person.Person table
Select FirstName, LastName
from Person.Person

--JobTitle, from the HumanResources.Employee table
select JobTitle
from HumanResources.Employee

--Rate, from the HumanResources.EmployeePayHistory table
select Rate
from HumanResources.EmployeePayHistory

--A derived column called "AverageRate" that returns the average of all values in the "Rate" column, in each row
select avg(Rate) as AverageRate
from HumanResources.EmployeePayHistory

--**All the above tables can be joined on BusinessEntityID 
--All the tables can be inner joined, and you do not need to apply any criteria.
Select 
	pp.FirstName, 
	pp.LastName, 
	HRE.JobTitle, 
	AverageRate = avg(HEP.Rate) over()
from Person.Person pp
join HumanResources.Employee HRE
on pp.BusinessEntityID = HRE.BusinessEntityID
join HumanResources.EmployeePayHistory HEP
on HRE.BusinessEntityID = HEP.BusinessEntityID

--Exercise 2
--Enhance your query from Exercise 1 by adding a derived column called
--"MaximumRate" that returns the largest of all values in the "Rate" column, in each row.
Select 
	pp.FirstName, 
	pp.LastName, 
	HRE.JobTitle, 
	AverageRate = avg(HEP.Rate) over(), 
	MaximumRate = max(HEP.Rate) over()
from Person.Person pp
join HumanResources.Employee HRE
on pp.BusinessEntityID = HRE.BusinessEntityID
join HumanResources.EmployeePayHistory HEP
on HRE.BusinessEntityID = HEP.BusinessEntityID

--Exercise 3 
--Enhance your query from Exercise 2 by adding a derived column called
--"DiffFromAvgRate" that returns the result of the following calculation:
--An employees's pay rate, MINUS the average of all values in the "Rate" column.
Select 
	pp.FirstName, 
	pp.LastName, 
	HRE.JobTitle, 
	AverageRate = avg(HEP.Rate) over(), 
	MaximumRate = max(HEP.Rate) over(),
	DiffFromAvgRate = HEP.Rate - avg(HEP.Rate) over()
from Person.Person pp
join HumanResources.Employee HRE
on pp.BusinessEntityID = HRE.BusinessEntityID
join HumanResources.EmployeePayHistory HEP
on HRE.BusinessEntityID = HEP.BusinessEntityID

--Exercise 4
--Enhance your query from Exercise 3 by adding a derived column called
--"PercentofMaxRate" that returns the result of the following calculation:
--An employees's pay rate, DIVIDED BY the maximum of all values in the "Rate" column, times 100.
Select 
	pp.FirstName, 
	pp.LastName, 
	HRE.JobTitle, 
	AverageRate = avg(HEP.Rate) over(), 
	MaximumRate = max(HEP.Rate) over(),
	DiffFromAvgRate = HEP.Rate - avg(HEP.Rate) over(),
	PercentofMaxRate = (HEP.Rate / max(HEP.Rate) over()) * 100
from Person.Person pp
join HumanResources.Employee HRE
on pp.BusinessEntityID = HRE.BusinessEntityID
join HumanResources.EmployeePayHistory HEP
on HRE.BusinessEntityID = HEP.BusinessEntityID





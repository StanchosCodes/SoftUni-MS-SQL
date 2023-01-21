USE [SoftUni]

GO

-- Task 2
SELECT * FROM Departments

-- Task 3
SELECT [Name] FROM Departments

-- Task 4
SELECT FirstName, LastName, Salary FROM Employees

-- Task 5
SELECT FirstName, MiddleName, LastName FROM Employees

-- Task 6
SELECT CONCAT(FirstName, '.', LastName, '@softuni.bg') AS [Full Email Address] FROM Employees

-- Task 7
SELECT DISTINCT [Salary] FROM [Employees] ORDER BY [Salary] ASC

-- Task 8
SELECT * FROM [Employees] WHERE [JobTitle] = 'Sales Representative'

-- Task 9
SELECT [FirstName], [LastName], [JobTitle] FROM [Employees] WHERE [Salary] >= 20000 AND [Salary] <= 30000
-- SELECT [FirstName], [LastName], [JobTitle] FROM [Employees] WHERE [Salary] BETWEEN 20000 AND 30000 - both values are inclusive

-- Task 10
SELECT CONCAT(FirstName, ' ', MiddleName, ' ', LastName) AS [Full Name] FROM [Employees] WHERE [Salary] = 25000 OR [Salary] = 14000 OR [Salary] = 12500 OR [Salary] = 23600
-- SELECT CONCAT(FirstName, ' ', MiddleName, ' ', LastName) AS [Full Name] FROM [Employees] WHERE [Salary] IN (25000, 14000, 12500, 23600)
-- SELECT CONCAT_WS(' ', FirstName, MiddleName, LastName) AS [Full Name] FROM [Employees] WHERE [Salary] IN (25000, 14000, 12500, 23600) - like string.join

-- Task 11
SELECT [FirstName], [LastName] FROM [Employees] WHERE [ManagerID] IS NULL

-- Task 12
SELECT [FirstName], [LastName], [Salary] FROM [Employees] WHERE [Salary] > 50000 ORDER BY [Salary] DESC

-- Task 13
SELECT TOP 5 [FirstName], [LastName] FROM [Employees] ORDER BY [Salary] DESC

-- Task 14
SELECT [FirstName], [LastName] FROM [Employees] WHERE [DepartmentID] NOT IN (4)

-- Task 15
SELECT * FROM [Employees] ORDER BY [Salary] DESC, [FirstName] ASC, [LastName] DESC, [MiddleName] ASC

-- Task 16
GO
CREATE VIEW V_EmployeesSalaries AS SELECT FirstName, LastName, Salary FROM [Employees]
GO
-- SELECT * FROM [V_EmployeesSalaries] - calling the view

-- Task 17
CREATE VIEW V_EmployeeNameJobTitle AS SELECT CONCAT(FirstName, ' ', MiddleName, ' ', LastName) AS [Full Name], [JobTitle] FROM [Employees]
GO
-- SELECT * FROM [V_EmployeeNameJobTitle] - calling the view

-- Task 18
SELECT DISTINCT [JobTitle] FROM [Employees]

-- Task 19
SELECT TOP 10 * FROM [Projects] WHERE [StartDate] IS NOT NULL ORDER BY [StartDate] ASC, [Name] ASC

-- Task 20
SELECT TOP 7 [FirstName], [LastName], [HireDate] FROM [Employees] ORDER BY [HireDate] DESC

-- Task 21
UPDATE [Employees]
SET [Salary] = [Salary] + [Salary] * 0.12 WHERE [DepartmentID] = 1 OR [DepartmentID] = 2 OR [DepartmentID] = 4 OR [DepartmentID] = 11

SELECT [Salary] FROM [Employees]

-- Task 22
USE [Geography]

GO

SELECT [PeakName] FROM [Peaks] ORDER BY [PeakName] ASC

-- Task 23
SELECT TOP 30 [CountryName], [Population] FROM [Countries] WHERE [ContinentCode] = 'EU' ORDER BY [Population] DESC, [CountryName] ASC

-- Task 24
  SELECT [CountryName]
       , [CountryCode]
	   , CASE
			 WHEN [CurrencyCode] = 'EUR'
			 THEN 'Euro'
			 ELSE 'Not Euro'
	     END
      AS [Currency]
    FROM [Countries]
ORDER BY [CountryName] ASC

-- Task 25
USE [Diablo]

GO

SELECT [Name] FROM [Characters] ORDER BY [Name] ASC
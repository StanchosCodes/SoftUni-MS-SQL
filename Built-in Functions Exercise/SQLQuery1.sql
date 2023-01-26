-- Task 1\
USE [Softuni]

GO

SELECT [FirstName], [LastName] FROM [Employees] WHERE SUBSTRING([FirstName], 1, 2) = 'Sa'
-- Variant 2 SELECT [FirstName], [LastName] FROM [Employees] WHERE LEFT([FirstName], 2) = 'Sa'
-- Varinat 3 SELECT [FirstName], [LastName] FROM [Employees] WHERE [FirstName] LIKE 'Sa$'

-- Task 2
SELECT [FirstName], [LastName] FROM [Employees] WHERE CHARINDEX('ei', [LastName]) NOT LIKE 0 -- Or CHARINDEX('ei', [LastName]) > 0
-- Variant 2 SELECT [FirstName], [LastName] FROM [Employees] WHERE [LastName] LIKE '%ei%'

-- Task 3
SELECT [FirstName] FROM [Employees] WHERE [DepartmentID] IN (3, 10) AND DATEPART(YEAR, [HireDate]) BETWEEN 1995 AND 2005
-- Variant 2 SELECT [FirstName] FROM [Employees] WHERE [DepartmentID] IN (3, 10) AND YEAR([HireDate]) BETWEEN 1995 AND 2005

-- Task 4
SELECT [FirstName], [LastName] FROM [Employees] WHERE [JobTitle] NOT LIKE '%engineer%'
-- Variant 2 SELECT [FirstName], [LastName] FROM [Employees] WHERE CHARINDEX('engineer', [JobTitle]) = 0 (It means no index was found with the given string)

-- Task 5
SELECT [Name] FROM [Towns] WHERE LEN([Name]) IN (5, 6) ORDER BY ([Name]) ASC

-- Task 6
SELECT * FROM [Towns] WHERE [Name] LIKE 'M%' OR [Name] LIKE 'K%' OR [Name] LIKE 'B%' OR [Name] LIKE 'E%' ORDER BY ([Name]) ASC
-- Variant 2 SELECT * FROM [Towns] WHERE [Name] LIKE '[MKBE]%' ORDER BY ([Name]) ASC (Same like the first one but with [] which means it takes only one char from  the given in the string and it may be something after it or not (said by the % in the end))
-- Variant 3 SELECT * FROM [Towns] WHERE LEFT([Name], 1) IN ('M', 'K', 'B', 'E') ORDER BY ([Name]) ASC
-- Variant 4 SELECT * FROM [Towns] WHERE SUBSTRING([Name], 1, 1) IN ('M', 'K', 'B', 'E') ORDER BY ([Name]) ASC

-- Task 7
SELECT * FROM [Towns] WHERE [Name] NOT LIKE 'R%' AND [Name] NOT LIKE 'B%' AND [Name] NOT LIKE 'D%' ORDER BY ([Name]) ASC

-- Task 8
GO
CREATE VIEW [V_EmployeesHiredAfter2000] AS SELECT [FirstName], [LastName] FROM [Employees] WHERE DATEPART(YEAR, [HireDate]) > 2000
GO

SELECT * FROM [V_EmployeesHiredAfter2000]

-- Task 9
SELECT [FirstName], [LastName] FROM [Employees] WHERE LEN([LastName]) = 5

-- Task 10
SELECT [EmployeeID], [FirstName], [LastName], [Salary]
    , DENSE_RANK() OVER
	 (PARTITION BY [Salary] ORDER BY [EmployeeID] ASC) AS [Rank]
	  FROM [Employees]
	  WHERE [Salary] BETWEEN 10000 AND 50000
	  ORDER BY [Salary] DESC

-- Task 11
-- Making a SubQuery because that way the Rank column will be made and after that we will call it because otherway the rank is not made yet when we call it
SELECT * FROM ( -- Fifth to execute
     SELECT [EmployeeID], [FirstName], [LastName], [Salary] -- Third to execute
         , DENSE_RANK() OVER -- Third to execute
     	 (PARTITION BY [Salary] ORDER BY [EmployeeID] ASC) AS [Rank]
     	  FROM [Employees] -- First to execute
     	  WHERE ([Salary] BETWEEN 10000 AND 50000) -- Second to execute
		  ) AS [RankingSubQuery]
		  WHERE [Rank] = 2 -- Fourth to execute
     	  ORDER BY [Salary] DESC -- Sixth to execute

-- Task 12
USE [Geography]

GO

    SELECT [CountryName], [IsoCode]
      FROM [Countries]
	 WHERE [CountryName] LIKE '%a%a%a%' -- It means that we are looking for atleast 3 times a where there might be something in between then or before them or after them but they have to be atleast 3
  ORDER BY [IsoCode]

  -- To be case-insensitive
  --    SELECT [CountryName], [IsoCode]
  --    FROM [Countries]
  --   WHERE LOWER([CountryName]) LIKE '%a%a%a%' -- It means that we are looking for atleast 3 times a where there might be something in between then or before them or after them but they have to be atleast 3
 -- ORDER BY [IsoCode]

 -- Variant 2 by removing the 'a' letters and counting the diff
 SELECT [CountryName], [IsoCode]
      FROM [Countries]
	 WHERE LEN([CountryName]) - LEN(REPLACE(LOWER([CountryName]), 'a', '')) >= 3 -- It means that if the word have 3 or more 'a' letters the diff between the two len will be 3 or more because after the replacing we remove the count of the remaining letters from the count of the whole word and the result is the count of the 'a' letters
  ORDER BY [IsoCode]

  -- Task 13
  SELECT [p].[PeakName]
       , [r].[RiverName]
	   , LOWER(CONCAT(SUBSTRING([p].[PeakName], 1, LEN([p].[PeakName]) - 1), [r].RiverName)) AS [Mix]
    FROM [Peaks]
	  AS [p],
	     [Rivers]
      AS [r]
   WHERE RIGHT(LOWER([p].[PeakName]), 1) = LEFT(LOWER([r].RiverName), 1)
ORDER BY [Mix] ASC

-- Task 14
USE [Diablo]

GO

SELECT TOP(50) [Name], FORMAT([Start], 'yyyy-MM-dd') AS [Start]
FROM [Games]
WHERE YEAR([Start]) IN (2011, 2012)
ORDER BY [Start] ASC, [Name] ASC

-- Task 15
   SELECT [Username]
        , SUBSTRING([Email]
		          , CHARINDEX('@', [Email]) + 1
				  , LEN([Email]) - CHARINDEX('@', [Email])) 
				 AS [Email Provider] 
			   FROM [Users] 
		   ORDER BY [Email Provider] ASC
		          , [Username] ASC

-- Task 16
  SELECT [Username]
	   , [IpAddress]
	  AS [IP Address]
    FROM [Users]
   WHERE [IpAddress] LIKE '___.1%.%.___'
ORDER BY [Username] ASC

-- Task 17
	SELECT [Name] 
	    AS [Game]
	           , CASE
			          WHEN DATEPART(HOUR, [Start]) >= 0 AND DATEPART(HOUR, [Start]) < 12 THEN 'Morning'
					  WHEN DATEPART(HOUR, [Start]) >= 12 AND DATEPART(HOUR, [Start]) < 18 THEN 'Afternoon'
					  WHEN DATEPART(HOUR, [Start]) >= 18 AND DATEPART(HOUR, [Start]) < 24 THEN 'Evening' -- It can be in ELSE
			     END AS [Part of the Day]
			   , CASE 
			          WHEN [Duration] <= 3 THEN 'Extra Short'
					  WHEN [Duration] BETWEEN 4 AND 6 THEN 'Short'
					  WHEN [Duration] > 6 THEN 'Long'
					  WHEN [Duration] IS NULL THEN 'Extra Long' -- It can be in ELSE
				 END AS [Duration]
	  FROM [Games]
  ORDER BY [Game] ASC, [Duration] ASC, [Part of the Day] ASC

-- Task 18
USE [Orders]

GO

SELECT [ProductName]
     , [OrderDate]
	 , DATEADD(DAY, 3, [OrderDate]) AS [Pay Due]
	 , DATEADD(MONTH, 1, [OrderDate]) AS [Deliver Due]
  FROM [Orders]

-- Task 19
CREATE TABLE [People]
(
[Id] INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) NOT NULL,
[Birthdate] DATETIME2 NOT NULL
)

INSERT INTO [People]
VALUES
('Victor', '2000-12-07 00:00:00.000'),
('Steven', '1992-09-10 00:00:00.000'),
('Stephen', '1910-09-19 00:00:00.000'),
('John', '2010-01-06 00:00:00.000')

SELECT * FROM [People]

SELECT [Name]
     , DATEDIFF(YEAR, [Birthdate], GETDATE())
	AS [Age in Years]
	 , DATEDIFF(MONTH, [Birthdate], GETDATE())
	AS [Age in Months]
	 , DATEDIFF(DAY, [Birthdate], GETDATE())
	AS [Age in Days]
	 , DATEDIFF(MINUTE, [Birthdate], GETDATE())
	AS [Age in Minutes]
  FROM [People]
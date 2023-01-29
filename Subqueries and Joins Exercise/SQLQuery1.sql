-- Task 1
USE [Softuni]

GO

SELECT * FROM [Employees]
SELECT * FROM [Addresses]

   SELECT TOP (5) [e].[EmployeeID], [e].[JobTitle], [e].[AddressID], [a].[AddressText]
     FROM [Employees] AS e
LEFT JOIN [Addresses] AS a -- LEFT JOIN because the [e].[AddressID] can be null and inner join will skip it while left join will take it
       ON [e].[AddressID] = [a].[AddressID]
 ORDER BY [e].[AddressID] ASC

-- Task 2
  SELECT TOP (50) [e].[FirstName], [e].[LastName], [t].[Name] AS [Town], [a].[AddressText]
    FROM [Employees] AS e
	JOIN [Addresses] AS a
	  ON [e].[AddressID] = [a].[AddressID]
	JOIN [Towns] AS t
	  ON [a].[TownID] = [t].[TownID]
ORDER BY [e].[FirstName] ASC, [e].[LastName] ASC

-- Task 3
SELECT * FROM [Departments]
SELECT * FROM [Employees]

  SELECT [e].[EmployeeID], [e].[FirstName], [e].[LastName], [d].[Name] AS [DepartmentName]
    FROM [Employees] AS e
	JOIN [Departments] AS d
	  ON [e].[DepartmentID] = [d].[DepartmentID] AND [e].[DepartmentID] = 3
ORDER BY [e].[EmployeeID] ASC

-- Task 4
  SELECT TOP (5) [e].[EmployeeID], [e].[FirstName], [e].[Salary], [d].[Name] AS [DepartmentName]
    FROM [Employees] AS e
	JOIN [Departments] AS d
	  ON [e].[DepartmentID] = [d].[DepartmentID]
   WHERE [e].[Salary] > 15000
ORDER BY [e].[DepartmentID] ASC

-- Task 5
SELECT * FROM [Projects]
SELECT * FROM [EmployeesProjects]
SELECT * FROM [Employees]

   SELECT TOP (3) [e].[EmployeeID], [e].[FirstName]
     FROM [Employees] AS e
LEFT JOIN [EmployeesProjects] AS ep
	   ON [e].[EmployeeID] = [ep].[EmployeeID]
    WHERE [ep].[EmployeeID] IS NULL -- Where in this case makes it anti left join, means we take only these results which dont match the ep table results
 ORDER BY [e].[EmployeeID] ASC

-- Task 6
SELECT * FROM [Departments]

  SELECT [e].[FirstName], [e].[LastName], [e].[HireDate], [d].[Name] AS [DeptName]
    FROM [Employees] AS e
	JOIN [Departments] AS d
	  ON [e].[DepartmentID] = [d].[DepartmentID] AND [d].[DepartmentID] IN (3, 10)
   WHERE [e].[HireDate] > '1.1.1999'
ORDER BY [e].[HireDate] ASC

-- Task 7
SELECT * FROM [Projects]
SELECT * FROM [EmployeesProjects]

  SELECT TOP (5) [e].[EmployeeID], [e].[FirstName], [p].[Name] AS [ProjectName]
    FROM [Employees] AS e
	JOIN [EmployeesProjects] AS ep -- its inner join because we need only the employees the work on a project
	  ON [e].[EmployeeID] = [ep].[EmployeeID]
    JOIN [Projects] AS p -- its inner join because we need only the employees the work on a project
	  ON [ep].[ProjectID] = [p].[ProjectID]
   WHERE [p].[StartDate] > '2002.08.13' AND [p].[EndDate] IS NULL
ORDER BY [e].[EmployeeID] ASC

-- Task 8
SELECT [e].[EmployeeID], [e].[FirstName],
  CASE
     WHEN YEAR([p].[StartDate]) >= 2005  THEN NULL
	 ELSE [p].[Name]
END AS [ProjectName]
  FROM [Employees] AS e
  JOIN [EmployeesProjects] AS ep
    ON [e].[EmployeeID] = [ep].[EmployeeID]
  JOIN [Projects] AS p
    ON [ep].[ProjectID] = [p].[ProjectID]
 WHERE [e].[EmployeeID] = 24

-- Task 9
SELECT * FROM [Employees]

  SELECT [e].[EmployeeID], [e].[FirstName], [e].[ManagerID], [em].[FirstName] AS [ManagerName]
    FROM [Employees] AS e
	JOIN [Employees] AS em -- Joining a self-referenced table
	  ON [e].[ManagerID] = [em].[EmployeeID] -- comparing the FK to the PK
   WHERE [e].[ManagerID] IN (3, 7)
ORDER BY [e].[EmployeeID] ASC

-- Task 10
SELECT * FROM [Departments]

  SELECT TOP (50) [e].[EmployeeID], CONCAT([e].[FirstName], ' ', [e].[LastName]) AS [EmployeeName], CONCAT([em].[FirstName], ' ', [em].[LastName]) AS [ManagerName], [d].[Name] AS [DepartmentName]
    FROM [Employees] AS e
	JOIN [Employees] AS em
	  ON [e].[ManagerID] = [em].[EmployeeID]
	JOIN [Departments] AS d
	  ON [e].[DepartmentID] = [d].[DepartmentID]
ORDER BY [e].[EmployeeID] ASC

-- Task 11
SELECT * FROM [Employees]

  SELECT TOP (1) [MinAverageSalary]
        FROM
           (SELECT [DepartmentID], AVG([Salary]) AS [MinAverageSalary] FROM [Employees]
          GROUP BY [DepartmentID]) AS [MinSalary]
ORDER BY [MinAverageSalary] ASC

-- Task 12
USE [Geography]

GO

SELECT * FROM [Countries]
SELECT * FROM [Mountains]
SELECT * FROM [Peaks]
SELECT * FROM [MountainsCountries]

-- It can be solved starting from the MointainsCountries table amd skiping Countries table because we only need the CountryCode and it is contained in MountainsCountries table, and we will skip one join
  SELECT [c].[CountryCode], [m].[MountainRange], [p].[PeakName], [p].[Elevation]
    FROM [Countries] AS c
	JOIN [MountainsCountries] AS mc
	  ON [c].[CountryCode] = [mc].[CountryCode]
	JOIN [Mountains] AS m
	  ON [mc].[MountainId] = [m].[Id]
	JOIN [Peaks] AS p
	  ON [m].[Id] = [p].[MountainId]
   WHERE [c].[CountryCode] = 'BG' AND [p].[Elevation] > 2835
ORDER BY [p].[Elevation] DESC

-- Task 13 With Join
SELECT * FROM [Countries]

  SELECT [mc].[CountryCode], COUNT([mc].[MountainId]) AS [MountainRanges]
    FROM [MountainsCountries] AS mc
    JOIN [Mountains] AS m
      ON [mc].[MountainId] = [m].[Id]
   WHERE [mc].[CountryCode] IN ('BG', 'RU', 'US')
GROUP BY [mc].[CountryCode]

-- Task 13 Simplier way with SubQuery
  SELECT [CountryCode],
         COUNT([MountainId]) AS [MountainRanges]
    FROM [MountainsCountries]
   WHERE [CountryCode] IN
						  (
						    SELECT [CountryCode]
						      FROM [Countries]
						     WHERE [CountryName] IN ('United States', 'Russia', 'Bulgaria')
						  )
GROUP BY [CountryCode]

-- Task 14
SELECT * FROM [Countries]
SELECT * FROM [Rivers]
SELECT * FROM [CountriesRivers]

   SELECT TOP (5) [c].[CountryName], [r].[RiverName]
     FROM [Countries] AS c
LEFT JOIN [CountriesRivers] AS cr
	   ON [c].[CountryCode] = [cr].[CountryCode]
LEFT JOIN [Rivers] AS r
 	   ON [cr].[RiverId] = [r].[Id]
    WHERE [c].[ContinentCode] = 'AF'
 ORDER BY [c].[CountryName] ASC

-- Task 15
SELECT * FROM [Currencies]
SELECT * FROM [Continents]

  SELECT [ContinentCode], [CurrencyCode], [CurrencyUsage]
    FROM (
           SELECT *, DENSE_RANK() OVER (PARTITION BY [ContinentCode] ORDER BY [CurrencyUsage] DESC) AS [CurrencyRank]
             FROM (
                    SELECT [ContinentCode], [CurrencyCode], COUNT(*) AS [CurrencyUsage] -- taking the count of the curreny codes in the continent
                      FROM [Countries] AS c
                  GROUP BY [ContinentCode], [CurrencyCode] --Grouping continent code and currency code so we can group the specific currency codes in the specific   continent
                    HAVING COUNT(*) > 1 -- Removing the currancies which are used only once
  				) AS [CurrancyUsageQuery]
  	   ) AS [RankedQuery]
   WHERE [CurrencyRank] = 1
ORDER BY [ContinentCode] ASC

-- Task 16
SELECT * FROM [Mountains]
SELECT * FROM [Countries]
SELECT * FROM [MountainsCountries]

  SELECT COUNT([Count]) AS [Count]
    FROM
                (SELECT COUNT([mc].[CountryCode]) AS [Count]
	               FROM [Countries] AS c
        FULL OUTER JOIN [MountainsCountries] AS mc
                     ON [c].[CountryCode] = [mc].[CountryCode]
               GROUP BY [c].[CountryCode]) AS [MountainCount]
   WHERE [Count] = 0
GROUP BY [Count]

-- Task 17
   SELECT TOP (5) [c].[CountryName], MAX([p].[Elevation]) AS [HighestPeakElevation], MAX([r].[Length]) AS [LongestRiverLength]
     FROM [Countries] AS c
LEFT JOIN [CountriesRivers] AS cr
       ON [c].[CountryCode] = [cr].[CountryCode]
LEFT JOIN [Rivers] AS r
       ON [cr].[RiverId] = [r].[Id]
LEFT JOIN [MountainsCountries] AS mc
       ON [c].[CountryCode] = [mc].[CountryCode]
LEFT JOIN [Mountains] AS m
       ON [mc].[MountainId] = [m].[Id]
LEFT JOIN [Peaks] AS p
       ON [p].MountainId = [m].[Id]
 GROUP BY [c].[CountryName]
ORDER BY [HighestPeakElevation] DESC, [LongestRiverLength] DESC, [c].[CountryName] ASC

-- Task 18
  SELECT TOP (5) [CountryName] AS [Country],
		CASE
			WHEN [PeakName] IS NULL THEN '(no highest peak)'
			ELSE [PeakName]
	  END AS [Highest Peak Name],
	    CASE
			WHEN [Elevation] IS NULL THEN 0
			ELSE [Elevation]
	  END AS [Highest Peak Elevation],
	   CASE
			WHEN [MountainRange] IS NULL THEN '(no mountain)'
			ELSE [MountainRange]
	  END AS [Mountain]
    FROM (
	         SELECT [c].[CountryName], [p].[PeakName], [p].[Elevation], [m].[MountainRange],
       DENSE_RANK() OVER(PARTITION BY [c].[CountryName] ORDER BY [p].[Elevation] DESC) AS [PeaksRank]
               FROM [Countries] AS c
          LEFT JOIN [MountainsCountries] AS mc
                 ON [c].[CountryCode] = [mc].[CountryCode]
          LEFT JOIN [Mountains] AS m
                 ON [mc].[MountainId] = [m].[Id]
          LEFT JOIN [Peaks] AS p
                 ON [m].[Id] = [p].[MountainId]
	     ) AS [RankedQuery]
   WHERE [PeaksRank] = 1
ORDER BY [CountryName] ASC, [PeakName] ASC
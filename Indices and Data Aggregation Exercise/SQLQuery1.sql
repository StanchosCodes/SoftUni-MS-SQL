-- Task 1
USE [Gringotts]

GO

SELECT COUNT(*) AS [Count]
  FROM [WizzardDeposits]

-- Task 2
SELECT MAX([MagicWandSize]) AS [LongestMagicWand]
  FROM [WizzardDeposits]

-- Task 3
  SELECT [DepositGroup], MAX([MagicWandSize]) AS [LongestMagicWand]
    FROM [WizzardDeposits]
GROUP BY [DepositGroup]

-- Task 4
SELECT TOP (2) [DepositGroup]
      FROM [WizzardDeposits]
  GROUP BY [DepositGroup]
  ORDER BY AVG([MagicWandSize]) ASC

-- Task 5
  SELECT [DepositGroup], SUM([DepositAmount]) AS [TotalSum]
    FROM [WizzardDeposits]
GROUP BY [DepositGroup]

-- Task 6
  SELECT [DepositGroup], SUM([DepositAmount]) AS [TotalSum]
    FROM [WizzardDeposits]
   WHERE [MagicWandCreator] = 'Ollivander family'
GROUP BY [DepositGroup]

-- Task 7
  SELECT *
    FROM (
  		    SELECT [DepositGroup], SUM([DepositAmount]) AS [TotalSum]
                FROM [WizzardDeposits]
               WHERE [MagicWandCreator] = 'Ollivander family'
            GROUP BY [DepositGroup]
         ) AS [TotalSumQuery]
   WHERE [TotalSum] < 150000
ORDER BY [TotalSum] DESC

-- Task 7 With HAVING Clouse
  SELECT [DepositGroup], SUM([DepositAmount]) AS [TotalSum]
    FROM [WizzardDeposits]
   WHERE [MagicWandCreator] = 'Ollivander family'
GROUP BY [DepositGroup]
  HAVING SUM([DepositAmount]) < 150000
ORDER BY [TotalSum] DESC

-- Task 8
  SELECT [DepositGroup], [MagicWandCreator], MIN([DepositCharge]) AS [MinDepositCharge]
    FROM [WizzardDeposits]
GROUP BY [DepositGroup], [MagicWandCreator]
ORDER BY [MagicWandCreator] ASC, [DepositGroup] ASC

-- Task 9
SELECT *, COUNT([AgeGroup]) AS [WizardCount]
  FROM (
		  SELECT CASE
			          WHEN [Age] <= 10 THEN '[0-10]'
			          WHEN [Age] <= 20 THEN '[11-20]'
			          WHEN [Age] <= 30 THEN '[21-30]'
			          WHEN [Age] <= 40 THEN '[31-40]'
			          WHEN [Age] <= 50 THEN '[41-50]'
			          WHEN [Age] <= 60 THEN '[51-60]'
			          ELSE '[61+]'
	           END AS [AgeGroup]
  FROM [WizzardDeposits]
	   ) AS [AgeGroupQuery]
GROUP BY [AgeGroup]

-- Task 10
  SELECT [FirstLetter]
    FROM (
               SELECT SUBSTRING([FirstName], 1, 1) AS [FirstLetter]
                 FROM [WizzardDeposits]
                WHERE [DepositGroup] = 'Troll Chest'
             GROUP BY [FirstName]
  	     ) AS [FirstLetterGroupQuery]
GROUP BY [FirstLetter]
ORDER BY [FirstLetter]

-- Task 11
  SELECT [DepositGroup], [IsDepositExpired], AVG([DepositInterest]) AS [AverageInterest]
    FROM [WizzardDeposits]
   WHERE [DepositStartDate] > '01/01/1985'
GROUP BY [DepositGroup], [IsDepositExpired]
ORDER BY [DepositGroup] DESC, [IsDepositExpired] ASC

-- Task 12 CAN BE SOLVED WITH JOIN TOO BY SELF JOIN
SELECT SUM([Difference]) AS [SumDifference]
  FROM (
    	     SELECT [FirstName] AS [Host Wizard],
                    [DepositAmount] AS [Host Wizard Deposit],
                    LEAD([FirstName]) OVER(ORDER BY [Id]) AS [Guest Wizard], -- LEAD Takes the next row of the given column Ordered by given column
                    LEAD([DepositAmount]) OVER(ORDER BY [Id]) AS [Guest Wizard Deposit],
	                [DepositAmount] - LEAD([DepositAmount]) OVER(ORDER BY [Id]) AS [Difference]
               FROM [WizzardDeposits]
	   ) AS [DifferenceSubQuery]

	   -- LAG gives the previous row of the given column
	   -- LEAD gives the next row of the given column

-- Task 13
USE [SoftUni]

GO

  SELECT [DepartmentID], SUM([Salary]) AS [TotalSalary]
    FROM [Employees]
GROUP BY [DepartmentID]

-- Task 14
  SELECT [DepartmentID], MIN([Salary]) AS [MinimumSalary]
    FROM [Employees]
   WHERE [DepartmentID] IN (2, 5, 7) AND [HireDate] > '01/01/2000'
GROUP BY [DepartmentID]

-- Task 15
SELECT *
  INTO [EmployeesSalaryOver30000]
  FROM [Employees]
 WHERE [Salary] > 30000

DELETE
  FROM [EmployeesSalaryOver30000]
 WHERE [ManagerID] = 42

 UPDATE [EmployeesSalaryOver30000]
    SET [Salary] += 5000
  WHERE [DepartmentID] = 1

  SELECT [DepartmentID], AVG([Salary]) AS [AverageSalary]
    FROM [EmployeesSalaryOver30000]
GROUP BY [DepartmentID]

-- Task 16
  SELECT [DepartmentID], MAX([Salary]) AS [MaxSalary]
    FROM [Employees]
GROUP BY [DepartmentID]
  HAVING MAX([Salary]) NOT BETWEEN 30000 AND 70000

-- Task 17
SELECT COUNT([Salary]) AS [Count]
  FROM [Employees]
 WHERE [ManagerID] IS NULL

-- Task 18
SELECT DISTINCT [DepartmentID], [Salary]
  FROM (
            SELECT [DepartmentID], [Salary], DENSE_RANK() OVER(PARTITION BY [DepartmentID] ORDER BY [Salary] DESC) AS [SalaryRank]
              FROM [Employees]
	   ) AS [RankedSalary]
 WHERE [SalaryRank] = 3

-- Task 19
SELECT TOP (10) [e].[FirstName], [e].[LastName], [e].[DepartmentID]
      FROM [Employees] AS e
     WHERE [e].[Salary] > (
							SELECT AVG([Salary]) AS [AverageSalary]
							  FROM [Employees] AS [SubE]
							 WHERE [SubE].[DepartmentID] = [e].[DepartmentID]
						  GROUP BY [DepartmentID]
   					  )
  ORDER BY [e].[DepartmentID] ASC
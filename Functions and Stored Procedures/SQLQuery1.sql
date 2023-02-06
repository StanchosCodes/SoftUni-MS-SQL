-- Task 1
SELECT * FROM [Employees]

CREATE PROCEDURE [usp_GetEmployeesSalaryAbove35000]
              AS
		   BEGIN
			     SELECT [FirstName], [LastName]
				   FROM [Employees]
				  WHERE [Salary] > 35000
			 END
			  GO

EXEC [usp_GetEmployeesSalaryAbove35000]

-- Task 2
GO

CREATE PROC [usp_GetEmployeesSalaryAboveNumber](@number DECIMAL(18, 4)) -- We can use PROC or PROCEDURE to create a procedure
         AS
	  BEGIN
		    SELECT [FirstName], [LastName]
			  FROM [Employees]
			 WHERE [Salary] >= @number
		END
		 GO

EXEC [usp_GetEmployeesSalaryAboveNumber] 48100

-- Task 3
GO

CREATE PROC [usp_GetTownsStartingWith](@stringPattern VARCHAR(50))
         AS
	  BEGIN
		    SELECT [Name]
			  FROM [Towns]
			 WHERE SUBSTRING([Name], 1, LEN(@stringPattern)) = @stringPattern

		END
		 GO

EXEC [usp_GetTownsStartingWith] 'b'

GO

ALTER PROC [usp_GetTownsStartingWith](@stringPattern VARCHAR(50))
	     AS
	  BEGIN
		     SELECT [Name] AS [Town]
			  FROM [Towns]
			 WHERE SUBSTRING([Name], 1, LEN(@stringPattern)) = @stringPattern
	    END
	     GO

EXEC [usp_GetTownsStartingWith] 'b'

-- Task 4
GO

CREATE PROC [usp_GetEmployeesFromTown](@TownName VARCHAR(50))
         AS
	  BEGIN
		    SELECT [FirstName] AS [First Name], [LastName] AS [Last Name]
			  FROM [Employees] AS e
			  JOIN [Addresses] AS a
			    ON [e].AddressID = [a].[AddressID]
			  JOIN [Towns] AS t
			    ON [a].[TownID] = [t].[TownID]
			 WHERE [t].[Name] = @TownName
		END
		 GO

DROP PROC [usp_GetEmployeesFromTown]

EXEC [usp_GetEmployeesFromTown] 'Sofia'

-- Task 5
GO

CREATE FUNCTION [ufn_GetSalaryLevel](@Salary DECIMAL(18,4))
        RETURNS VARCHAR(10)
		     AS
		  BEGIN
		        DECLARE @SalaryLevel VARCHAR(10) = 'Average'

						IF (@Salary < 30000)
						    SET @SalaryLevel = 'Low'
						ELSE IF (@Salary > 50000)
						    SET @SalaryLevel = 'High'

				RETURN @SalaryLevel
		    END;
		     GO

SELECT [Salary], [dbo].[ufn_GetSalaryLevel]([Salary]) AS [Salary Level]
  FROM [Employees]

-- Task 6
GO

CREATE PROC [usp_EmployeesBySalaryLevel](@SalaryLevel VARCHAR(10))
         AS
	  BEGIN
		    SELECT [FirstName] AS [First Name], [LastName] AS [Last Name]
			  FROM [Employees]
			 WHERE dbo.ufn_GetSalaryLevel([Salary]) = @SalaryLevel
		END
		 GO

EXEC [usp_EmployeesBySalaryLevel] 'High'

-- Task 7
GO

CREATE FUNCTION [ufn_IsWordComprised](@SetOfLetters VARCHAR(50), @Word VARCHAR(50))
        RETURNS BIT
		     AS
		  BEGIN
			     DECLARE @Result BIT = 1
				 DECLARE @Index INT = 1

				 WHILE (@Index <= LEN(@Word))
				      BEGIN
					         DECLARE @CurrentChar CHAR = SUBSTRING(@Word, @Index, 1)
							      IF (CHARINDEX(@CurrentChar, @SetOfLetters) = 0)
								      BEGIN
									           SET @Result = 0
									         BREAK
										END;
								ELSE SET @Index += 1
						END;
				  
				  RETURN @Result
		    END;
			 GO

SELECT [dbo].[ufn_IsWordComprised]('oistmiahf', 'Sofia') AS [Result]

-- Task 8
GO

CREATE PROC [usp_DeleteEmployeesFromDepartment] (@departmentId INT)
         AS
	  BEGIN
		    DECLARE @EmployeesToDelete TABLE ([Id] INT)
			INSERT INTO @EmployeesToDelete
						SELECT [EmployeeID]
						  FROM [Employees]
						 WHERE [DepartmentID] = @departmentId

			-- Deleting from EmployeesProjects table because the desired employees may be working on a project and that is a relation we need to remove
			DELETE
			  FROM [EmployeesProjects]
			 WHERE [EmployeeID] IN (SELECT [Id] FROM @EmployeesToDelete)

			-- Making the ManagerId column in Departments table to be nullable because the employees can be managers and we need to remove this relation too
			 ALTER TABLE [Departments]
			ALTER COLUMN [ManagerID] INT NULL

			-- Setting the ManagerID in Departments table whos EmployeeID is one of the desired employees to null to remove the relation with the Employees table
			UPDATE [Departments]
			   SET [ManagerID] = NULL
		     WHERE [ManagerID] IN (SELECT [Id] FROM @EmployeesToDelete)

			-- Setting the ManagerID in Employees table whos EmployeeID is one of the desired employyes to null to remove the self-reference in the employee table
			UPDATE [Employees]
			   SET [ManagerID] = NULL
			 WHERE [ManagerID] IN (SELECT [Id] FROM @EmployeesToDelete)

			-- After removing all relations we are deleting the employees with the given DepartmentID from Employees table which is first part of the main task
			DELETE
			  FROM [Employees]
			 WHERE [DepartmentID] = @departmentId -- Or we can use this too [EmployeeID] IN (SELECT [Id] FROM @EmployeesToDelete)

			-- Finaly deleting the departments with the given DepartmentID from the Department table which is the second part of the main task
			DELETE
			  FROM [Departments]
			 WHERE [DepartmentID] = @departmentId

			SELECT COUNT([EmployeeID]) AS [Count]
              FROM [Employees]
             WHERE [DepartmentID] = @departmentId
		END
		 GO

EXEC [usp_DeleteEmployeesFromDepartment] 1

-- Restore DataBase
USE [master]
USE [SoftUni]

SELECT *
  FROM [Employees]
 WHERE [DepartmentID] = 1

-- Таск 9
GO

USE [Bank]

GO

CREATE PROC [usp_GetHoldersFullName]
         AS
	  BEGIN
			  SELECT CONCAT([FirstName], ' ', [LastName]) AS [Full Name] 
			    FROM [AccountHolders]
	    END

EXEC [usp_GetHoldersFullName]

-- Task 10
GO

CREATE PROC usp_GetHoldersWithBalanceHigherThan(@Budget DECIMAL(10, 2))
		 AS
	  BEGIN
			    SELECT [ah].[FirstName] AS [First Name], [ah].[LastName] AS [Last Name]
			      FROM [AccountHolders] AS ah
			  	  JOIN [Accounts] AS a
			  	    ON [ah].[Id] = [a].[AccountHolderId]
			  GROUP BY [a].[AccountHolderId], [ah].[FirstName], [ah].[LastName]
			    HAVING SUM([a].[Balance]) > @Budget
			  ORDER BY [ah].[FirstName] ASC, [ah].[LastName] ASC
	    END

SELECT * FROM [Accounts]
SELECT * FROM [AccountHolders]

EXEC [usp_GetHoldersWithBalanceHigherThan] 245656

-- Task 11  FORMULA 𝐹𝑉=𝐼×((1+𝑅)𝑇) - I – Initial sum; R – Yearly interest rate; T – Number of years; DEFAULT for float is 53 which is 8 bit number (24 is 4bit num)
GO

CREATE FUNCTION ufn_CalculateFutureValue(@Sum DECIMAL(14, 4), @YearlyInterestRate FLOAT, @Years INT)
        RETURNS DECIMAL(14, 4)
		     AS
		  BEGIN
				   DECLARE @ResultSum DECIMAL(14, 4) = @Sum * POWER((1 + @YearlyInterestRate), @Years)

				   RETURN @ResultSum
		    END
			 GO

SELECT [dbo].[ufn_CalculateFutureValue](1000, 0.1, 5) AS [Future Sum]

-- Task 12
GO

CREATE PROC usp_CalculateFutureValueForAccount(@AccountId INT, @InterestRate FLOAT)
         AS
	  BEGIN
			  SELECT [a].[AccountHolderId] AS [Account Id],
					 [ah].[FirstName] AS [First Name],
					 [ah].[LastName] AS [Last Name],
					 [a].[Balance] AS [Current Balance],
					 [dbo].[ufn_CalculateFutureValue]([a].[Balance], @InterestRate, 5) AS [Balance in 5 years]
			    FROM [AccountHolders] AS ah
				JOIN [Accounts] AS a
				  ON [ah].[Id] = [a].[AccountHolderId]
			   WHERE [a].[Id] = @AccountId
	    END

EXEC [usp_CalculateFutureValueForAccount] 1, 0.1

-- Task 13
GO

USE [Diablo]

GO

CREATE FUNCTION ufn_CashInUsersGames(@GameName NVARCHAR(50))
        RETURNS TABLE
		     AS
		 RETURN
			     (
				        SELECT SUM([Cash]) AS [SumCash]
                          FROM (
                          		    SELECT [g].[Name], [u].[Cash], ROW_NUMBER() OVER(ORDER BY [u].[Cash] DESC) AS [RowNumber]
                                      FROM [UsersGames] AS u
                                      JOIN [Games] AS g
                                        ON [u].[GameId] = [g].[Id]
                                     WHERE [g].[Name] = @GameName
                        	   ) AS [RowSubQuery]
                         WHERE [RowNumber] % 2 <> 0 -- <> means different then ( like != in C# )
				 )

GO

SELECT * FROM [dbo].[ufn_CashInUsersGames]('Love in a mist')
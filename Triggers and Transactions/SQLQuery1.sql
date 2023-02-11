-- Task 1
USE [Bank]

GO

CREATE TABLE [Logs]
(
[LogId] INT PRIMARY KEY IDENTITY,
[AccountId] INT,
[OldSum] DECIMAL(18, 4),
[NewSum] DECIMAL(18, 4)
)

GO

CREATE TRIGGER [tr_InsertIntoLogsAfterUpdateInAccounts]
            ON [Accounts]
    FOR UPDATE
	        AS
			   BEGIN
			           INSERT INTO [Logs] ([AccountId], [OldSum], [NewSum])
					        SELECT i.[AccountHolderId], d.[Balance], i.[Balance]
							  FROM inserted AS i
							  JOIN deleted AS d
							    ON i.[Id] = d.[Id]
						     WHERE i.[Balance] <> d.[Balance]
			     END

UPDATE [Accounts]
   SET [Balance] += 100
 WHERE [AccountHolderId] = 6

 SELECT * FROM [Accounts]
 SELECT * FROM [Logs]

-- Task 2
CREATE TABLE [NotificationEmails]
(
[Id] INT PRIMARY KEY IDENTITY,
[Recipient] INT,
[Subject] VARCHAR(50),
[Body] VARCHAR(100)
)

GO

CREATE TRIGGER [tr_InsertIntoNotificationEmailsAfterInsertInLogs]
            ON [Logs]
    FOR INSERT
	        AS
		 BEGIN
		        INSERT INTO [NotificationEmails] ([Recipient], [Subject], [Body])
				     SELECT [AccountId], CONCAT('Balance change for account: ', [AccountId]), CONCAT('On ', GETDATE(), ' your balance was changed from ', [OldSum], ' to ', [NewSum], '.')
					   FROM [inserted]
		   END

UPDATE [Accounts]
   SET [Balance] += 100
 WHERE [AccountHolderId] = 6

SELECT * FROM [Accounts]
SELECT * FROM [Logs]
SELECT * FROM [NotificationEmails]

-- Task 3
GO

      CREATE PROC [usp_DepositMoney](@AccountId INT, @MoneyAmount DECIMAL(18, 4))
               AS
BEGIN TRANSACTION
                        IF NOT EXISTS (SELECT [Id] FROM [Accounts] WHERE [Id] = @AccountId)
						      BEGIN
							        ROLLBACK;
									THROW 50001, 'Invalid Account Id, Account not exists', 1
							    END

                        IF (@MoneyAmount < 0)
			        	      BEGIN
			        		        ROLLBACK;
			        				THROW 50001, 'Money Amount can not be negative number', 1
			        		    END
	                UPDATE [Accounts]
		   	           SET [Balance] += @MoneyAmount
		             WHERE [Id] = @AccountId
		   COMMIT

EXEC [usp_DepositMoney] 1, 10
EXEC [usp_DepositMoney] 1, -10
SELECT * FROM [Accounts]

-- Also works for judge
GO

CREATE PROC [usp_DepositMoney](@AccountId INT, @MoneyAmount DECIMAL(18, 4))
         AS
	  BEGIN
	         UPDATE [Accounts]
			    SET [Balance] += @MoneyAmount
			  WHERE [Id] = @AccountId AND @MoneyAmount > 0
	    END

-- Task 4
GO

      CREATE PROC [usp_WithdrawMoney](@AccountId INT, @MoneyAmount DECIMAL(18, 4))
               AS
BEGIN TRANSACTION
                        IF NOT EXISTS (SELECT [Id] FROM [Accounts] WHERE [Id] = @AccountId)
						      BEGIN
							        ROLLBACK;
									THROW 50001, 'Invalid Account Id, Account not exists', 1
							    END

                        IF ((SELECT [Balance] FROM [Accounts] WHERE [Id] = @AccountId) < @MoneyAmount)
			        	      BEGIN
			        		        ROLLBACK;
			        				THROW 50002, 'Balance not enough', 1
			        		    END
	                UPDATE [Accounts]
		   	           SET [Balance] -= @MoneyAmount
		             WHERE [Id] = @AccountId
		   COMMIT

EXEC [usp_WithdrawMoney] 1, 10
EXEC [usp_WithdrawMoney] -1, 10
EXEC [usp_WithdrawMoney] 200, 10
EXEC [usp_WithdrawMoney] 1, 300
SELECT * FROM [Accounts]

-- Alse works for judge
GO

CREATE PROC [usp_DepositMoney](@AccountId INT, @MoneyAmount DECIMAL(18, 4))
         AS
	  BEGIN
	         UPDATE [Accounts]
			    SET [Balance] -= @MoneyAmount
			  WHERE [Id] = @AccountId AND @MoneyAmount > 0
	    END

-- Task 5
GO

      CREATE PROC [usp_TransferMoney](@SenderId INT, @ReceiverId INT, @Amount DECIMAL(18, 4))
               AS
BEGIN TRANSACTION
				    EXEC [usp_WithdrawMoney] @SenderId, @Amount
					EXEC [usp_DepositMoney] @ReceiverId, @Amount
					-- Using only these to procedures because they have the error handling needed in them
		   COMMIT

EXEC [usp_TransferMoney] 5, 1, 5000

SELECT * FROM [Accounts]

-- Task 7
GO

USE [Diablo]

SELECT * FROM [Users] -- id 9
SELECT * FROM [Games] -- id 87
SELECT * FROM [Items] WHERE [MinLevel] IN (11, 12, 19, 20, 21)
SELECT * FROM [UsersGames] -- id 110
SELECT i.[Name] FROM [UserGameItems] AS ugi JOIN [Items] AS i ON ugi.[ItemId] = i.[Id] WHERE [UserGameId] = 110 ORDER BY i.[Name] ASC
SELECT * FROM [UserGameItems]

GO

DECLARE @UserId INT = (SELECT [Id] FROM [Users] WHERE [FirstName] = 'Stamat')
DECLARE @GameId INT = (SELECT [Id] FROM [Games] WHERE [Name] = 'Safflower') 
DECLARE @UserGameId INT = (SELECT [Id] FROM [UsersGames] WHERE [GameId] = @GameId AND [UserId] = @UserId)
DECLARE @ItemsPriceSum DECIMAL(18, 4) = (SELECT SUM([Price]) FROM [Items] WHERE [MinLevel] BETWEEN 11 AND 12)
DECLARE @UserCash DECIMAL(18, 4) = (SELECT [Cash] FROM [UsersGames] WHERE [Id] = @UserGameId)

		IF (@ItemsPriceSum <= @UserCash)
			            BEGIN
			BEGIN TRANSACTION	
									UPDATE [UsersGames]
									   SET [Cash] -= @ItemsPriceSum
									 WHERE [Id] = @UserGameId

							   INSERT INTO [UserGameItems]([ItemId], [UserGameId])
							        SELECT i.[Id], @UserGameId
							          FROM [Items] AS i
							         WHERE [MinLevel] BETWEEN 11 AND 12
           
					   COMMIT  
						  END

	   	SET @ItemsPriceSum = (SELECT SUM([Price]) FROM [Items] WHERE [MinLevel] BETWEEN 19 AND 21)
		SET @UserCash = (SELECT [Cash] FROM [UsersGames] WHERE [Id] = @UserGameId)

	    IF (@ItemsPriceSum <= @UserCash)
			            BEGIN
			BEGIN TRANSACTION

									UPDATE [UsersGames]
								       SET [Cash] -= @ItemsPriceSum
								     WHERE [Id] = @UserGameId
									       
							   INSERT INTO [UserGameItems]([ItemId], [UserGameId])
								    SELECT i.[Id], @UserGameId
									  FROM [Items] AS i
								     WHERE [MinLevel] BETWEEN 19 AND 21
           
								
					     COMMIT
						    END

					

	SELECT [i].[Name] AS [Item Name]
	  FROM [UserGameItems] AS ugi
	  JOIN [Items] AS i
	    ON [ugi].[ItemId] = [i].[Id]
	 WHERE [ugi].[UserGameId] = @UserGameId
  ORDER BY [i].[Name] ASC

EXEC [usp_ItemsShopping]

-- Task 8
GO

USE [SoftUni]

SELECT * FROM [Employees]
SELECT * FROM [Projects]
SELECT * FROM [EmployeesProjects]
SELECT COUNT([ProjectId]) FROM [EmployeesProjects] WHERE [EmployeeID] = 6

GO

CREATE PROC [usp_AssignProject](@emloyeeId INT, @projectID INT)
         AS
		     DECLARE @EmployeeProjectsCount INT = (SELECT COUNT([ProjectId]) FROM [EmployeesProjects] WHERE [EmployeeID] = @emloyeeId)
             BEGIN TRANSACTION
			                    IF (@EmployeeProjectsCount >= 3)
								     BEGIN
									        ROLLBACK;
											THROW 50001, 'The employee has too many projects!', 1
									   END

								INSERT INTO [EmployeesProjects]([EmployeeID], [ProjectID])
								     SELECT @emloyeeId, @projectID

					    COMMIT

EXEC [usp_AssignProject] 2, 5

-- Task 9
SELECT * FROM [Employees]

CREATE TABLE [Deleted_Employees]
(
[EmployeeId] INT PRIMARY KEY IDENTITY,
[FirstName] VARCHAR(50),
[LastName] VARCHAR(50),
[MiddleName] VARCHAR(50),
[JobTitle] VARCHAR(50),
[DepartmentId] INT,
[Salary] MONEY
)

GO

    CREATE TRIGGER [tr_InsertIntoDeletedEmployeesWhenDeletedFiredFromEmployees]
               ON [Employees]
       FOR DELETE
	           AS
	        BEGIN
		           INSERT INTO [Deleted_Employees] ([FirstName], [LastName], [MiddleName], [JobTitle], [DepartmentID], [Salary])
		  		        SELECT d.[FirstName], d.[LastName], d.[MiddleName], d.[JobTitle], d.[DepartmentID], d.[Salary]
					      FROM [deleted] AS d
		      END

SELECT * FROM [Deleted_Employees]

DELETE
  FROM [Employees]
 WHERE [EmployeeID] = 1
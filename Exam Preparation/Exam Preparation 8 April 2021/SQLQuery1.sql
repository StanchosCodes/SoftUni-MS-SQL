-- Section 1 Task 1
CREATE DATABASE [Service]

GO

USE [Service]

GO

CREATE TABLE [Users]
(
[Id] INT PRIMARY KEY IDENTITY,
[Username] VARCHAR(30) UNIQUE NOT NULL,
[Password] VARCHAR(50) UNIQUE NOT NULL,
[Name] VARCHAR(50),
[Birthdate] DATETIME,
[Age] INT CHECK([Age] BETWEEN 14 AND 110),
[Email] VARCHAR(50) NOT NULL
)

CREATE TABLE [Departments]
(
[Id] INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE [Employees]
(
[Id] INT PRIMARY KEY IDENTITY,
[FirstName] VARCHAR(25),
[LastName] VARCHAR(25),
[Birthdate] DATETIME,
[Age] INT CHECK([Age] BETWEEN 18 AND 110),
[DepartmentId] INT FOREIGN KEY REFERENCES [Departments]
)

CREATE TABLE [Categories]
(
[Id] INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) NOT NULL,
[DepartmentId] INT FOREIGN KEY REFERENCES [Departments] NOT NULL
)

CREATE TABLE [Status]
(
[Id] INT PRIMARY KEY IDENTITY,
[Label] VARCHAR(20) NOT NULL
)

CREATE TABLE [Reports]
(
[Id] INT PRIMARY KEY IDENTITY,
[CategoryId] INT FOREIGN KEY REFERENCES [Categories] NOT NULL,
[StatusId] INT FOREIGN KEY REFERENCES [Status] NOT NULL,
[OpenDate] DATETIME NOT NULL,
[CloseDate] DATETIME,
[Description] VARCHAR(200) NOT NULL,
[UserId] INT FOREIGN KEY REFERENCES [Users] NOT NULL,
[EmployeeId] INT FOREIGN KEY REFERENCES [Employees]
)

-- Section 2 Task 1
INSERT INTO [Employees]([FirstName], [LastName], [Birthdate], [DepartmentId])
VALUES
('Marlo', 'O''Malley', '1958-9-21', 1),
('Niki', 'Stanaghan', '1969-11-26', 4),
('Ayrton', 'Senna', '1960-03-21', 9),
('Ronnie', 'Peterson', '1944-02-14', 9),
('Giovanna', 'Amati', '1959-07-20', 5)

INSERT INTO [Reports]([CategoryId], [StatusId], [OpenDate], [CloseDate], [Description], [UserId], [EmployeeId])
VALUES
(1, 1, '2017-04-13', NULL, 'Stuck Road on Str.133', 6, 2),
(6, 3, '2015-09-05', '2015-12-05', 'Charity trail running', 3, 5),
(14, 2, '2015-09-07', NULL, 'Falling bricks on Str.58', 5, 2),
(4, 3, '2017-07-03', '2017-07-06', 'Cut off streetlight on Str.11', 1, 1)

-- Task 3
UPDATE [Reports]
   SET [CloseDate] = GETDATE()
 WHERE [CloseDate] IS NULL

-- Task 4
DELETE
  FROM [Reports]
 WHERE [StatusId] = 4

-- Section 3 Task 5
SELECT [r].[Description], FORMAT([r].[OpenDate], 'dd-MM-yyyy') AS [OpenDate]
  FROM [Reports] AS r
 WHERE [EmployeeId] IS NULL
ORDER BY [r].[OpenDate] ASC, [r].[Description] ASC

-- Task 6
   SELECT [r].[Description], [c].[Name] AS [CategoryName]
     FROM [Reports] AS r
LEFT JOIN [Categories] AS c
       ON [r].[CategoryId] = [c].[Id]
 ORDER BY [r].[Description] ASC, [c].[Name] DESC

-- Task 7
  SELECT TOP (5)[c].[Name] AS [CategoryName], COUNT([r].[CategoryId]) AS [ReportsNumber]
        FROM [Reports] AS r
        JOIN [Categories] AS c
          ON [r].[CategoryId] = [c].[Id]
    GROUP BY [c].[Name]
    ORDER BY [ReportsNumber] DESC, [CategoryName] ASC

-- Task 8
SELECT [u].[Username], [c].[Name] AS [CategoryName]
  FROM [Users] AS u
  JOIN [Reports] AS r
    ON [u].[Id] = [r].[UserId]
  JOIN [Categories] AS c
    ON [c].[Id] = [r].[CategoryId]
 WHERE MONTH([u].[Birthdate]) = MONTH([r].[OpenDate]) AND DAY([u].[Birthdate]) = DAY([r].[OpenDate])
ORDER BY [u].[Username] ASC, [c].[Name] ASC

-- Task 9
   SELECT CONCAT([e].[FirstName], ' ', [e].[LastName]) AS [FullName], COUNT([r].[UserId]) AS [UsersCount]
     FROM [Employees] AS e
LEFT JOIN [Reports] AS r
       ON [e].[Id] = [r].[EmployeeId]
 GROUP BY [e].[Id], [e].[FirstName], [e].[LastName]
 ORDER BY [UsersCount] DESC, [FullName] ASC

-- Task 10
   SELECT CASE
                  WHEN [e].[FirstName] IS NULL OR [e].[LastName] IS NULL THEN 'None'
				  ELSE CONCAT([e].[FirstName], ' ', [e].[LastName])
		  END AS [Employee],
		  CASE
		          WHEN [e].[DepartmentId] IS NULL THEN 'None'
				  ELSE [d].[Name]
		  END AS [Department],
		  [c].[Name] AS [Category],
		  [r].[Description],
		  FORMAT([r].[OpenDate], 'dd.MM.yyyy') AS [OpenDate],
		  [s].[Label] AS [Status],
		  CASE 
		          WHEN [u].[Name] IS NULL THEN 'None'
				  ELSE [u].[Name]
		  END AS  [User]
     FROM [Reports] AS r
LEFT JOIN [Employees] AS e
       ON [r].[EmployeeId] = [e].[Id]
LEFT JOIN [Departments] AS d
       ON [e].[DepartmentId] = [d].[Id]
LEFT JOIN [Categories] AS c
       ON [c].[Id] = [r].[CategoryId]
LEFT JOIN [Status] AS s
       ON [s].[Id] = [r].[StatusId]
LEFT JOIN [Users] AS u
       ON [u].[Id] = [r].[UserId]
 ORDER BY [e].[FirstName] DESC, [e].[LastName] DESC, [Department] ASC, [Category] ASC, [Description] ASC, [OpenDate] ASC, [Status] ASC, [User] ASC

-- Section 4 Task 11
GO

CREATE FUNCTION [udf_HoursToComplete] (@StartDate DATETIME, @EndDate DATETIME)
    RETURNS INT
	         AS
		  BEGIN
		         DECLARE @TakenHours INT;

				      IF @StartDate IS NULL OR @EndDate IS NULL
					     SET @TakenHours = 0
					ELSE SET @TakenHours = DATEDIFF(HOUR, @StartDate, @EndDate)

				  RETURN @TakenHours
		    END

GO

SELECT [dbo].[udf_HoursToComplete] (OpenDate, CloseDate) AS TotalHours
  FROM Reports

-- Task 12
SELECT * FROM [Employees]
SELECT * FROM [Categories]
SELECT * FROM [Reports]

GO

CREATE PROC [usp_AssignEmployeeToReport] (@EmployeeId INT, @ReportId INT)
         AS
	  BEGIN
			 DECLARE @CategoryDepartmentId INT = (SELECT [c].[DepartmentId]
												    FROM [Reports] AS r
												    JOIN [Categories] AS c
												      ON [r].[CategoryId] = [c].[Id]
												   WHERE [r].[Id] = @ReportId)
			 DECLARE @EmployeeDepartmentId INT = (SELECT [DepartmentId] FROM [Employees] WHERE [Id] = @EmployeeId)

			      IF @CategoryDepartmentId <> @EmployeeDepartmentId
			         THROW 50001, 'Employee doesn''t belong to the appropriate department!', 1
			    ELSE UPDATE [Reports]
			            SET [EmployeeId] = @EmployeeId
			          WHERE [Id] = @ReportId
	    END

GO

EXEC [usp_AssignEmployeeToReport] 30, 1
EXEC [usp_AssignEmployeeToReport] 17, 2
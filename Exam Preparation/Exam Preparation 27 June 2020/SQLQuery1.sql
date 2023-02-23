-- Section 1 Task 1
CREATE DATABASE [WMS]

GO

USE [WMS]

GO

CREATE TABLE [Clients]
(
[ClientId] INT PRIMARY KEY IDENTITY,
[FirstName] NVARCHAR(50) NOT NULL,
[LastName] NVARCHAR(50) NOT NULL,
[Phone] VARCHAR(12) CHECK(LEN([Phone]) = 12) NOT NULL
)

CREATE TABLE [Mechanics]
(
[MechanicId] INT PRIMARY KEY IDENTITY,
[FirstName] NVARCHAR(50) NOT NULL,
[LastName] NVARCHAR(50) NOT NULL,
[Address] NVARCHAR(255) NOT NULL
)

CREATE TABLE [Models]
(
[ModelId] INT PRIMARY KEY IDENTITY NOT NULL,
[Name] NVARCHAR(50) UNIQUE NOT NULL
)

CREATE TABLE [Jobs]
(
[JobId] INT PRIMARY KEY IDENTITY,
[ModelId] INT FOREIGN KEY REFERENCES [Models] NOT NULL,
[Status] NVARCHAR(11) DEFAULT 'Pending' CHECK([Status] IN ('Pending', 'In Progress', 'Finished')) NOT NULL,
[ClientId] INT FOREIGN KEY REFERENCES [Clients] NOT NULL,
[MechanicId] INT FOREIGN KEY REFERENCES [Mechanics],
[IssueDate] DATE NOT NULL,
[FinishDate] DATE
)

CREATE TABLE [Orders]
(
[OrderId] INT PRIMARY KEY IDENTITY,
[JobId] INT FOREIGN KEY REFERENCES [Jobs] NOT NULL,
[IssueDate] DATE,
[Delivered] BIT DEFAULT 0 NOT NULL
)

CREATE TABLE [Vendors]
(
[VendorId] INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(50) UNIQUE NOT NULL
)

CREATE TABLE [Parts]
(
[PartId] INT PRIMARY KEY IDENTITY,
[SerialNumber] NVARCHAR(50) UNIQUE NOT NULL,
[Description] NVARCHAR(255),
[Price] DECIMAL(6, 2) CHECK([Price] > 0) NOT NULL,
[VendorId] INT FOREIGN KEY REFERENCES [Vendors] NOT NULL,
[StockQty] INT CHECK([StockQty] >= 0) DEFAULT 0 NOT NULL
)

CREATE TABLE [OrderParts]
(
[OrderId] INT FOREIGN KEY REFERENCES [Orders] NOT NULL,
[PartId] INT FOREIGN KEY REFERENCES [Parts] NOT NULL,
[Quantity] INT CHECK([Quantity] > 0) DEFAULT 1 NOT NULL,
PRIMARY KEY ([OrderId], [PartId])
)

CREATE TABLE [PartsNeeded]
(
[JobId] INT FOREIGN KEY REFERENCES [Jobs] NOT NULL,
[PartId] INT FOREIGN KEY REFERENCES [Parts] NOT NULL,
[Quantity] INT CHECK([Quantity] > 0) DEFAULT 1 NOT NULL,
PRIMARY KEY ([JobId], [PartId])
)

-- Section 2 Task 2
INSERT INTO [Clients]([FirstName], [LastName], [Phone])
VALUES
('Teri', 'Ennaco', '570-889-5187'),
('Merlyn', 'Lawler', '201-588-7810'),
('Georgene', 'Montezuma', '925-615-5185'),
('Jettie', 'Mconnell', '908-802-3564'),
('Lemuel', 'Latzke', '631-748-6479'),
('Melodie', 'Knipp', '805-690-1682'),
('Candida', 'Corbley', '908-275-8357')

INSERT INTO [Parts]([SerialNumber], [Description], [Price], [VendorId])
VALUES
('WP8182119', 'Door Boot Seal', 117.86, 2),
('W10780048', 'Suspension Rod', 42.81, 1),
('W10841140', 'Silicone Adhesive ', 6.77, 4),
('WPY055980', 'High Temperature Adhesive', 13.94, 3)

-- Task 3
SELECT * FROM [Mechanics] WHERE [FirstName] = 'Ryan' -- Id = 3

UPDATE [Jobs]
   SET [MechanicId] = 3, [Status] = 'In Progress'
 WHERE [Status] = 'Pending'

-- Task 4
DELETE
  FROM [OrderParts]
 WHERE [OrderId] = 19

DELETE
  FROM [Orders]
 WHERE [OrderId] = 19

-- Section 3 Task 5
  SELECT CONCAT([m].[FirstName], ' ', [m].[LastName]) AS [Mechanic], [j].[Status], [j].[IssueDate]
    FROM [Mechanics] AS m
    JOIN [Jobs] AS j
      ON [m].[MechanicId] = [j].[MechanicId]
ORDER BY [m].[MechanicId] ASC, [j].[IssueDate] ASC, [j].[JobId] ASC

-- Task 6
SELECT CONCAT([c].[FirstName], ' ', [c].[LastName]) AS [Client], DATEDIFF(DAY, [j].[IssueDate], '2017-04-24') AS [Days going], [j].[Status]
  FROM [Clients] AS c
  JOIN [Jobs] AS j
    ON [c].[ClientId] = [j].[ClientId]
 WHERE [j].[FinishDate] IS NULL

-- Task 7
SELECT * FROM [Jobs]

  SELECT CONCAT([m].[FirstName], ' ', [m].[LastName]) AS [Mechanic], AVG(DATEDIFF(DAY, [j].[IssueDate], [j].[FinishDate])) AS [Average Days]
    FROM [Mechanics] AS m
    JOIN [Jobs] AS j
      ON [m].[MechanicId] = [j].[MechanicId]
GROUP BY [m].[FirstName], [m].[LastName], [m].[MechanicId]
ORDER BY [m].[MechanicId] ASC

-- Task 8
SELECT * FROM [Jobs]
SELECT * FROM [Mechanics]

   SELECT CONCAT([m].[FirstName], ' ', [m].[LastName]) AS [Available]
     FROM [Mechanics] AS m
LEFT JOIN [Jobs] AS j
       ON [m].[MechanicId] = [j].[MechanicId]
    WHERE [m].[MechanicId] NOT IN (
                                     SELECT [m].[MechanicId]
       								   FROM [Mechanics] AS m
       								   JOIN [Jobs] AS j
       								     ON [m].[MechanicId] = [j].[MechanicId]
       								  WHERE [j].[Status] NOT LIKE 'Finished'
                                  )
 GROUP BY [m].[FirstName], [m].[LastName], [m].[MechanicId]
 ORDER BY [m].[MechanicId] ASC

-- Task 9
  SELECT [j].[JobId], SUM([p].[Price] * [pn].[Quantity]) AS [Total]
    FROM [Jobs] AS j
    JOIN [PartsNeeded] AS pn
      ON [j].[JobId] = [pn].[JobId]
    JOIN [Parts] AS p
      ON [pn].[PartId] = [p].[PartId]
   WHERE [j].[Status] = 'Finished'
GROUP BY [j].[JobId]
ORDER BY [Total] DESC, [j].[JobId] ASC

-- Task 10
   SELECT [p].[PartId], [p].[Description], SUM([pn].[Quantity]) AS [Required], SUM([p].[StockQty]) AS [In Stock], ISNULL(SUM([oq].[Quantity]), 0) AS [Ordered]
     FROM [Jobs] AS j
LEFT JOIN [PartsNeeded] AS pn
       ON [j].[JobId] = [pn].[JobId]
	 JOIN [Parts] AS p
       ON [pn].[PartId] = [p].[PartId]
LEFT JOIN (
                  SELECT [op].[PartId], [op].[Quantity]
					FROM [Orders] AS o
					JOIN [OrderParts] AS op
					  ON [op].[OrderId] = [o].[OrderId]
				   WHERE [o].[Delivered] = 0
	      ) AS [oq]
	   ON [oq].[PartId] = [p].[PartId]
    WHERE [j].[Status] NOT LIKE 'Finished'
 GROUP BY [p].[PartId], [p].[Description]
   HAVING (SUM([p].[StockQty]) + ISNULL(SUM([oq].[Quantity]), 0)) < SUM([pn].[Quantity])
 ORDER BY [p].[PartId] ASC

-- Section 4 Task 11

-- Task 12
GO

CREATE FUNCTION [udf_GetCost] (@JobId INT)
RETURNS DECIMAL (6, 2)
             AS
		  BEGIN
		            DECLARE @Cost DECIMAL(6, 2)
					    SET @Cost = (    SELECT SUM([p].[Price] * [pn].[Quantity]) AS [Result]
									       FROM [Jobs] AS j
									       JOIN [PartsNeeded] AS pn
									         ON [j].[JobId] = [pn].[JobId]
									       JOIN [Parts] AS p
									         ON [pn].[PartId] = [p].[PartId]
									      WHERE [j].[Status] = 'Finished' AND [j].[JobId] = @JobId
									   GROUP BY [j].[JobId]
						            )
		            RETURN @Cost
		    END

GO

SELECT [dbo].[udf_GetCost] (1) AS [Result]
SELECT [dbo].[udf_GetCost] (3) AS [Result]
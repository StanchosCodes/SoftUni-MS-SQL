-- Section 1 Task 1
CREATE DATABASE [Boardgames]

GO

USE [Boardgames]

GO

CREATE TABLE [Categories]
(
[Id] INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE [Addresses]
(
[Id] INT PRIMARY KEY IDENTITY,
[StreetName] NVARCHAR(100) NOT NULL,
[StreetNumber] INT NOT NULL,
[Town] VARCHAR(30) NOT NULL,
[Country] VARCHAR(50) NOT NULL,
[ZIP] INT NOT NULL
)

CREATE TABLE [Publishers]
(
[Id] INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(30) UNIQUE NOT NULL,
[AddressId] INT FOREIGN KEY REFERENCES [Addresses] NOT NULL,
[Website] NVARCHAR(40),
[Phone] NVARCHAR(20)
)

CREATE TABLE [PlayersRanges]
(
[Id] INT PRIMARY KEY IDENTITY,
[PlayersMin] INT NOT NULL,
[PlayersMax] INT NOT NULL
)

CREATE TABLE [Boardgames]
(
[Id] INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(30) NOT NULL,
[YearPublished] INT NOT NULL,
[Rating] DECIMAL(18, 2) NOT NULL,
[CategoryId] INT FOREIGN KEY REFERENCES [Categories] NOT NULL,
[PublisherId] INT FOREIGN KEY REFERENCES [Publishers] NOT NULL,
[PlayersRangeId] INT FOREIGN KEY REFERENCES [PlayersRanges] NOT NULL
)

CREATE TABLE [Creators]
(
[Id] INT PRIMARY KEY IDENTITY,
[FirstName] NVARCHAR(30) NOT NULL,
[LastName] NVARCHAR(30) NOT NULL,
[Email] NVARCHAR(30) NOT NULL
)

CREATE TABLE [CreatorsBoardgames]
(
[CreatorId] INT FOREIGN KEY REFERENCES [Creators] NOT NULL,
[BoardgameId] INT FOREIGN KEY REFERENCES [Boardgames] NOT NULL,
PRIMARY KEY ([Creatorid], [BoardgameId])
)

-- Section 2 Task 2
INSERT INTO [Publishers]([Name], [AddressId], [Website], [Phone])
VALUES
('Agman Games', 5, 'www.agmangames.com', '+16546135542'),
('Amethyst Games', 7, 'www.amethystgames.com', '+15558889992'),
('BattleBooks', 13, 'www.battlebooks.com', '+12345678907')

INSERT INTO [Boardgames]([Name], [YearPublished], [Rating], [CategoryId], [PublisherId], [PlayersRangeId])
VALUES
('Deep Blue', 2019, 5.67, 1, 15, 7),
('Paris', 2016, 9.78, 7, 1, 5),
('Catan: Starfarers', 2021, 9.87, 7, 13, 6),
('Bleeding Kansas', 2020, 3.25, 3, 7, 4),
('One Small Step', 2019, 5.75, 5, 9, 2)

-- Task 3
SELECT * FROM [PlayersRanges]
SELECT * FROM [Boardgames]

UPDATE [PlayersRanges]
   SET [PlayersMax] += 1
 WHERE [PlayersMin] = 2 AND [PlayersMax] = 2

UPDATE [Boardgames]
   SET [Name] += 'V2'
 WHERE [YearPublished] >= 2020

-- Task 4
SELECT * FROM [Addresses] WHERE SUBSTRING([Town], 1, 1) = 'L'
SELECT * FROM [Publishers] WHERE [AddressId] = 5
SELECT * FROM [Boardgames] WHERE [PublisherId] = 1
SELECT * FROM [CreatorsBoardgames] WHERE [BoardgameId] IN (1, 16, 31)

DELETE
  FROM [CreatorsBoardgames]
 WHERE [BoardgameId] IN (
							SELECT [Id]
							  FROM [Boardgames]
							 WHERE [PublisherId] IN (
														SELECT [Id]
														  FROM [Publishers]
														 WHERE [AddressId] IN (
																				 SELECT [Id]
																				   FROM [Addresses]
																				  WHERE SUBSTRING([Town], 1, 1) = 'L'
																			  )
													)
						)

DELETE
  FROM [Boardgames]
 WHERE [PublisherId] IN (
							SELECT [Id]
							  FROM [Publishers]
							 WHERE [AddressId] IN (
														SELECT [Id]
														  FROM [Addresses]
														 WHERE SUBSTRING([Town], 1, 1) = 'L'
												   )
						)

DELETE
  FROM [Publishers]
 WHERE [AddressId] IN (
						 SELECT [Id]
						   FROM [Addresses]
						  WHERE SUBSTRING([Town], 1, 1) = 'L'
                      )

DELETE
  FROM [Addresses]
WHERE SUBSTRING([Town], 1, 1) = 'L'

-- Section 3 Task 5
  SELECT [Name], [Rating]
    FROM [Boardgames]
ORDER BY [YearPublished] ASC, [Name] DESC

-- Task 6
  SELECT [b].[Id], [b].[Name], [b].[YearPublished], [c].[Name] AS [CategoryName]
    FROM [Boardgames] AS b
    JOIN [Categories] AS c
      ON [b].[CategoryId] = [c].[Id]
   WHERE [c].[Name] IN ('Strategy Games', 'Wargames')
ORDER BY [b].[YearPublished] DESC

-- Task 7
SELECT [Id], CONCAT([FirstName], ' ', [LastName]) AS [CreatorName], [Email]
  FROM [Creators]
 WHERE [Id] NOT IN (
					   SELECT [CreatorId]
					     FROM [CreatorsBoardgames]
				   )

-- Task 8
SELECT TOP (5)[b].[Name], [b].[Rating], [c].[Name] AS [CategoryName]
      FROM [Boardgames] AS b
      JOIN [PlayersRanges] AS pr
        ON [b].[PlayersRangeId] = [pr].[Id]
      JOIN [Categories] AS c
        ON [b].[CategoryId] = [c].[Id]
     WHERE ([b].[Rating] > 7.00 AND [b].[Name] LIKE '%a%') OR ([b].[Rating] > 7.50 AND ([pr].[PlayersMin] = 2 AND [pr].[PlayersMax] = 5))
  ORDER BY [b].[Name] ASC, [b].[Rating] DESC

-- Task 9
  SELECT [FullName], [Email], [Rating]
    FROM (
              SELECT CONCAT([c].[FirstName], ' ', [c].[LastName]) AS [FullName], [c].[Email], [b].[Rating],
  		             DENSE_RANK() OVER(PARTITION BY [c].[Email] ORDER BY [b].[Rating] DESC) AS [RankedRating]
                FROM [Creators] AS c
                JOIN [CreatorsBoardgames] AS cb
                  ON [c].[Id] = [cb].[CreatorId]
                JOIN [Boardgames] as b
                  ON [cb].[BoardgameId] = [b].[Id]
               WHERE SUBSTRING([c].[Email], LEN([c].[Email]) - 3, 4) = '.com'
  		) AS [Subquery]
   WHERE [RankedRating] = 1
ORDER BY [FullName] ASC

-- Task 10
SELECT [c].[LastName], CEILING(AVG([b].[Rating])) AS [AverageRating], [p].[Name] AS [PublisherName]
  FROM [Creators] AS c
  JOIN [CreatorsBoardgames] AS cb
    ON [c].[Id] = [cb].[CreatorId]
  JOIN [Boardgames] AS b
    ON [b].[Id] = [cb].[BoardgameId]
  JOIN [Publishers] AS p
    ON [p].[Id] = [b].[PublisherId]
 WHERE [p].[Name] = 'Stonemaier Games'
GROUP BY [c].[LastName], [p].[Name]
ORDER BY AVG([b].[Rating]) DESC

-- Section 4 Task 11
GO

CREATE FUNCTION [udf_CreatorWithBoardgames] (@name NVARCHAR(30))
    RETURNS INT
	         AS
		  BEGIN
		         DECLARE @Count INT;
                     SET @Count = (
					                 SELECT COUNT([cb].[CreatorId])
									   FROM [Creators] AS c
									   JOIN [CreatorsBoardgames] AS cb
									     ON [c].[Id] = [cb].[CreatorId]
									  WHERE [c].[Id] = (
									                      SELECT [Id]
														    FROM [Creators]
														   WHERE [FirstName] = @name
									                   )
					              )

				 RETURN @Count
		    END

GO

SELECT [dbo].[udf_CreatorWithBoardgames] ('Bruno') AS [Count]

-- Task 12
GO

CREATE PROC [usp_SearchByCategory] (@category VARCHAR(50))
         AS
	  BEGIN
			  SELECT [b].[Name],
			         [b].[YearPublished],
					 [b].[Rating],
					 [c].[Name] AS [CategoryName],
					 [p].[Name] AS [PublisherName],
					 CONCAT([pr].[PlayersMin], ' people') AS [MinPlayers],
					 CONCAT([pr].[PlayersMax], ' people') AS [MaxPlayers]
			    FROM [Boardgames] AS b
				JOIN [Categories] AS c
				  ON [b].[CategoryId] = [c].[Id]
				JOIN [Publishers] AS p
				  ON [p].[Id] = [b].[PublisherId]
				JOIN [PlayersRanges] AS pr
				  ON [pr].[Id] = [b].[PlayersRangeId]
			   WHERE [c].[Name] = @category
			ORDER BY [p].[Name] ASC, [b].[YearPublished] DESC
	    END

GO

EXEC [usp_SearchByCategory] 'Wargames'
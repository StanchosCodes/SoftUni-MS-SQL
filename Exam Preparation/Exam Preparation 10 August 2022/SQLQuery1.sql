-- Section 1 Task 1
CREATE DATABASE [NationalTouristSitesOfBulgaria]

GO

USE [NationalTouristSitesOfBulgaria]

GO

CREATE TABLE [Categories]
(
[Id] INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE [Locations]
(
[Id] INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) NOT NULL,
[Municipality] VARCHAR(50),
[Province] VARCHAR(50)
)

CREATE TABLE [Sites]
(
[Id] INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(100) NOT NULL,
[LocationId] INT FOREIGN KEY REFERENCES [Locations] NOT NULL,
[CategoryId] INT FOREIGN KEY REFERENCES [Categories] NOT NULL,
[Establishment] VARCHAR(15)
)

CREATE TABLE [Tourists]
(
[Id] INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) NOT NULL,
[Age] INT CHECK([Age] BETWEEN 0 AND 120) NOT NULL,
[PhoneNumber] VARCHAR(20) NOT NULL,
[Nationality] VARCHAR(30) NOT NULL,
[Reward] VARCHAR(20)
)

CREATE TABLE [SitesTourists]
(
[TouristId] INT FOREIGN KEY REFERENCES [Tourists] NOT NULL,
[SiteId] INT FOREIGN KEY REFERENCES [Sites] NOT NULL,
PRIMARY KEY ([TouristId], [SiteId])
)

CREATE TABLE [BonusPrizes]
(
[Id] INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE [TouristsBonusPrizes]
(
[TouristId] INT FOREIGN KEY REFERENCES [Tourists] NOT NULL,
[BonusPrizeId] INT FOREIGN KEY REFERENCES [BonusPrizes] NOT NULL,
PRIMARY KEY ([TouristId], [BonusPrizeId])
)

-- Section 2 Task 2
INSERT INTO [Tourists] ([Name], [Age], [PhoneNumber], [Nationality], [Reward])
VALUES
('Borislava Kazakova', 52, '+359896354244', 'Bulgaria', NULL),
('Peter Bosh', 48, '+447911844141', 'UK', NULL),
('Martin Smith', 29, '+353863818592', 'Ireland', 'Bronze badge'),
('Svilen Dobrev', 49, '+359986584786', 'Bulgaria', 'Silver badge'),
('Kremena Popova', 38, '+359893298604', 'Bulgaria', NULL)

INSERT INTO [Sites] ([Name], [LocationId], [CategoryId], [Establishment])
VALUES
('Ustra fortress', 90, 7, 'X'),
('Karlanovo Pyramids', 65, 7, NULL),
('The Tomb of Tsar Sevt', 63, 8, 'V BC'),
('Sinite Kamani Natural Park', 17, 1, NULL),
('St. Petka of Bulgaria – Rupite', 92, 6, '1994')

-- Task 3
UPDATE [Sites]
   SET [Establishment] = '(not defined)'
 WHERE [Establishment] IS NULL

SELECT * FROM [Sites]

-- Task 4
SELECT * FROM [BonusPrizes]
SELECT * FROM [TouristsBonusPrizes] WHERE [BonusPrizeId] = 5
SELECT * FROM [Tourists] WHERE [Id] IN (18, 20)

-- Deleting first from the mapping table
DELETE
  FROM [TouristsBonusPrizes]
 WHERE [BonusPrizeId] = (
				            SELECT [Id]
						      FROM [BonusPrizes]
						     WHERE [Name] = 'Sleeping bag'
				        )

-- Then deleting from the main table want to delete from
DELETE
  FROM [BonusPrizes]
 WHERE [Name] = 'Sleeping bag'

-- Section 3 Task 5
  SELECT [Name], [Age], [PhoneNumber], [Nationality]
    FROM [Tourists]
ORDER BY [Nationality] ASC, [Age] DESC, [Name] ASC

-- Task 6
  SELECT [s].[Name] AS [Site], [l].[Name] AS [Location], [s].[Establishment], [c].[Name] AS [Category]
    FROM [Sites] AS s
    JOIN [Locations] AS l
      ON [s].[LocationId] = [l].[Id]
    JOIN [Categories] AS c
      ON [s].[CategoryId] = [c].[Id]
ORDER BY [c].[Name] DESC, [l].[Name] ASC, [s].[Name] ASC

-- Task 7
SELECT * FROM [Locations]
SELECT * FROM [Sites]

  SELECT [l].[Province], [l].[Municipality], [l].[Name] AS [Locations], COUNT([s].[Id]) AS [CountOfSites]
    FROM [Locations] AS l
    JOIN [Sites] AS s
      ON [l].[Id] = [s].[LocationId]
   WHERE [l].[Province] = 'Sofia'
GROUP BY [l].[Province], [l].[Municipality], [l].[Name]
ORDER BY [CountOfSites] DESC, [l].[Name] ASC

-- Task 8
SELECT [s].[Name] AS [Site], [l].[Name] AS [Location], [l].[Municipality], [l].[Province], [s].[Establishment]
  FROM [Sites] AS s
  JOIN [Locations] AS l
    ON [s].[LocationId] = [l].[Id]
 WHERE SUBSTRING([l].[Name], 1, 1) NOT IN ('B', 'M', 'D') AND [s].[Establishment] LIKE '%BC'
ORDER BY [Site] ASC

-- Task 9
  SELECT [t].[Name], [t].[Age], [t].[PhoneNumber], [t].[Nationality],
           CASE
  	            WHEN [t].[Id] NOT IN (SELECT [TouristId] FROM [TouristsBonusPrizes]) THEN '(no bonus prize)'
  		  	    ELSE [bp].[Name]
         END AS [Reward]
    FROM [Tourists] AS t
    LEFT JOIN [TouristsBonusPrizes] AS tbp
      ON [t].[Id] = [tbp].[TouristId]
    LEFT JOIN [BonusPrizes] AS bp
      ON [tbp].[BonusPrizeId] = [bp].[Id]
ORDER BY [t].[Name]

-- Task 10
SELECT DISTINCT SUBSTRING([t].[Name], CHARINDEX(' ', [t].[Name]) + 1, LEN([t].[Name]) - CHARINDEX(' ', [t].[Name])) AS [LastName], [t].[Nationality], [t].[Age], [t].[PhoneNumber]
  FROM [Tourists] AS t
  JOIN [SitesTourists] AS st
    ON [t].[Id] = [st].[TouristId]
  JOIN [Sites] AS s
    ON [st].[SiteId] = [s].[Id]
 WHERE [s].[CategoryId] = (
                             SELECT [Id]
							   FROM [Categories]
							  WHERE [Name] = 'History and archaeology'
                          )
ORDER BY [LastName] ASC

SELECT * FROM [Tourists]
SELECT * FROM [SitesTourists]
SELECT * FROM [Sites]

-- Section 4 Task 11
GO

CREATE FUNCTION [udf_GetTouristsCountOnATouristSite] (@Site VARCHAR(100))
    RETURNS INT
	         AS
		  BEGIN
		         DECLARE @CountOfTourists INT;
				     SET @CountOfTourists = (
					                           SELECT COUNT([st].[TouristId])
											     FROM [Sites] AS s
												 JOIN [SitesTourists] AS st
												   ON [s].[Id] = [st].[SiteId]
												WHERE [Name] = @Site
												GROUP BY [st].[SiteId]
					                        )
				 RETURN @CountOfTourists;
		    END

GO

SELECT [dbo].[udf_GetTouristsCountOnATouristSite] ('Regional History Museum – Vratsa') AS [Count]
SELECT [dbo].[udf_GetTouristsCountOnATouristSite] ('Samuil’s Fortress') AS [Count]
SELECT [dbo].[udf_GetTouristsCountOnATouristSite] ('Gorge of Erma River') AS [Count]

-- Task 12
GO

CREATE PROC [usp_AnnualRewardLottery] (@TouristName VARCHAR(50))
         AS
	  BEGIN
	          DECLARE @CountOfSites INT = (  
									           SELECT COUNT([st].[SiteId])
											     FROM [Tourists] AS t
											     JOIN [SitesTourists] AS st
											       ON [t].[Id] = [st].[TouristId]
												WHERE [t].[Name] = @TouristName
										     GROUP BY [st].[TouristId]
									      )
	          UPDATE [Tourists]
			     SET [Reward] = CASE
				                     WHEN @CountOfSites >= 100 THEN 'Gold badge'
									 WHEN @CountOfSites >= 50 THEN 'Silver badge'
									 WHEN @CountOfSites >= 25 THEN 'Bronze badge'
							     END

			 SELECT [Name], [Reward]
			   FROM [Tourists]
			  WHERE [Name] = @TouristName
	    END

GO

EXEC [usp_AnnualRewardLottery] 'Gerhild Lutgard'
EXEC [usp_AnnualRewardLottery] 'Teodor Petrov'
EXEC [usp_AnnualRewardLottery] 'Zac Walsh'
EXEC [usp_AnnualRewardLottery] 'Brus Brown'
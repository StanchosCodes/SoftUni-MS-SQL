-- Section 1 Task 1
CREATE DATABASE [CigarShop]

GO

USE [CigarShop]

GO

CREATE TABLE [Sizes]
(
[Id] INT PRIMARY KEY IDENTITY,
[Length] INT CHECK([Length] BETWEEN 10 AND 25) NOT NULL,
[RingRange] DECIMAL(3, 2) CHECK([RingRange] BETWEEN 1.5 AND 7.5) NOT NULL
)

CREATE TABLE [Tastes]
(
[Id] INT PRIMARY KEY IDENTITY,
[TasteType] VARCHAR(20) NOT NULL,
[TasteStrength] VARCHAR(15) NOT NULL,
[ImageUrl] NVARCHAR(100) NOT NULL
)

CREATE TABLE [Brands]
(
[Id] INT PRIMARY KEY IDENTITY,
[BrandName] VARCHAR(30) UNIQUE NOT NULL,
[BrandDescription] VARCHAR(MAX)
)

CREATE TABLE [Cigars]
(
[Id] INT PRIMARY KEY IDENTITY,
[CigarName] VARCHAR(80) NOT NULL,
[BrandId] INT FOREIGN KEY REFERENCES [Brands] NOT NULL,
[TastId] INT FOREIGN KEY REFERENCES [Tastes] NOT NULL,
[SizeId] INT FOREIGN KEY REFERENCES [Sizes] NOT NULL,
[PriceForSingleCigar] DECIMAL(18, 2) NOT NULL,
[ImageUrl] NVARCHAR(100) NOT NULL
)

CREATE TABLE [Addresses]
(
[Id] INT PRIMARY KEY IDENTITY,
[Town] VARCHAR(30) NOT NULL,
[Country] NVARCHAR(30) NOT NULL,
[Street] NVARCHAR(100) NOT NULL,
[ZIP] VARCHAR(20) NOT NULL
)

CREATE TABLE [Clients]
(
[Id] INT PRIMARY KEY IDENTITY,
[FirstName] NVARCHAR(30) NOT NULL,
[LastName] NVARCHAR(30) NOT NULL,
[Email] NVARCHAR(50) NOT NULL,
[AddressId] INT FOREIGN KEY REFERENCES [Addresses] NOT NULL
)

CREATE TABLE [ClientsCigars]
(
[ClientId] INT FOREIGN KEY REFERENCES [Clients] NOT NULL,
[CigarId] INT FOREIGN KEY REFERENCES [Cigars] NOT NULL,
PRIMARY KEY ([ClientId], [CigarId])
)

-- Section 2 Task 2
INSERT INTO [Cigars]
VALUES
('COHIBA ROBUSTO',9 ,1 ,5 ,15.50 ,'cohiba-robusto-stick_18.jpg'),
('COHIBA SIGLO I',9 ,1 ,10 ,410.00 ,'cohiba-siglo-i-stick_12.jpg'),
('HOYO DE MONTERREY LE HOYO DU MAIRE',14 ,5 ,11 ,7.50 ,'hoyo-du-maire-stick_17.jpg'),
('HOYO DE MONTERREY LE HOYO DE SAN JUAN',14 ,4 ,15 ,32.00 ,'hoyo-de-san-juan-stick_20.jpg'),
('TRINIDAD COLONIALES',2 ,3 ,8 ,85.21 ,'trinidad-coloniales-stick_30.jpg')

INSERT INTO [Addresses]
VALUES
('Sofia', 'Bulgaria', '18 Bul. Vasil levski', 1000),
('Athens', 'Greece', '4342 McDonald Avenue', 10435),
('Zagreb', 'Croatia', '4333 Lauren Drive', 10000)

-- Task 3
UPDATE [Cigars]
   SET [PriceForSingleCigar] *= 1.2
 WHERE [TastId] = (
                      SELECT [Id]
					    FROM [Tastes]
					   WHERE [TasteType] = 'Spicy'
                  )

UPDATE [Brands]
   SET [BrandDescription] = 'New description'
 WHERE [BrandDescription] IS NULL

-- Task 4
SELECT * FROM [Addresses]
 WHERE SUBSTRING([Country], 1, 1) = 'C' -- 7, 8, 10, 23

SELECT * FROM [Clients]
 WHERE [AddressId] IN (7, 8, 10, 23) -- 7, 8, 10

SELECT * FROM [ClientsCigars]
 WHERE [ClientId] IN (7, 8, 10) -- None

DELETE
  FROM [Clients]
 WHERE [AddressId] IN (
                  SELECT [Id]
				   FROM [Addresses]
				   WHERE SUBSTRING([Country], 1, 1) = 'C'
               )

DELETE
  FROM [Addresses]
 WHERE SUBSTRING([Country], 1, 1) = 'C'

-- Section 3 Task 5
  SELECT [CigarName], [PriceForSingleCigar], [ImageUrl]
    FROM [Cigars]
ORDER BY [PriceForSingleCigar] ASC, [CigarName] DESC

-- Task 6
  SELECT [c].[Id], [c].[CigarName], [c].[PriceForSingleCigar], [t].[TasteType], [t].[TasteStrength]
    FROM [Cigars] AS c
    JOIN [Tastes] AS t
      ON [c].[TastId] = [t].[Id]
   WHERE [t].[TasteType] IN ('Earthy', 'Woody')
ORDER BY [c].[PriceForSingleCigar] DESC

-- Task 7
   SELECT [c].[Id], CONCAT([c].[FirstName], ' ', [c].[LastName]) AS [ClientName], [c].[Email]
     FROM [Clients] AS c
LEFT JOIN [ClientsCigars] AS cc
       ON [c].[Id] = [cc].[ClientId]
    WHERE [cc].[ClientId] IS NULL
 ORDER BY [ClientName] ASC

-- Task 8
  SELECT TOP (5) [c].[CigarName], [c].[PriceForSingleCigar], [c].[ImageUrl]
        FROM [Cigars] AS c
        JOIN [Sizes] AS s
          ON [c].[SizeId] = [s].[Id]
       WHERE [s].[Length] >= 12 AND ([c].[CigarName] LIKE '%ci%' OR [c].[PriceForSingleCigar] > 50) AND [s].[RingRange] > 2.55
    ORDER BY [c].[CigarName] ASC, [c].[PriceForSingleCigar] DESC

-- Task 9
  SELECT [FullName], [Country], [ZIP], [CigarPrice]
    FROM (
            SELECT CONCAT([c].[FirstName], ' ', [c].[LastName]) AS [FullName],
                   [a].[Country] AS [Country], [a].[ZIP] AS [ZIP],
  	               CONCAT('$', [ci].[PriceForSingleCigar]) AS [CigarPrice],
  	               DENSE_RANK() OVER(PARTITION BY [c].[Id] ORDER BY [ci].[PriceForSingleCigar] DESC) AS [RankedCigars]
              FROM [Clients] AS c
              JOIN [Addresses] AS a
                ON [c].[AddressId] = [a].[Id]
              JOIN [ClientsCigars] AS cc
                ON [c].[Id] = [cc].[ClientId]
              JOIN [Cigars] AS ci
                ON [cc].[CigarId] = [ci].[Id]
             WHERE ISNUMERIC([a].[ZIP]) = 1
         ) AS [RankedSubquery]
   WHERE [RankedCigars] = 1
ORDER BY [FullName] ASC

-- Task 10
   SELECT [c].[LastName], AVG([s].[Length]) AS [CiagrLength], CEILING(AVG([s].[RingRange])) AS [CiagrRingRange]
     FROM [Clients] AS c
LEFT JOIN [ClientsCigars] AS cc
       ON [c].[Id] = [cc].[ClientId]
LEFT JOIN [Cigars] AS ci
       ON [ci].[Id] = [cc].[CigarId]
	 JOIN [Sizes] AS s
       ON [ci].[SizeId] = [s].[Id]
 GROUP BY [c].[LastName]
 ORDER BY [CiagrLength] DESC

-- Section 4 Task 11
GO

CREATE FUNCTION [udf_ClientWithCigars] (@name NVARCHAR(30))
    RETURNS INT
	         AS
		  BEGIN
		         DECLARE @Count INT;
				     SET @Count = ISNULL(  
					                   (SELECT COUNT([cc].[CigarId])
									     FROM [Clients] AS c
									     JOIN [ClientsCigars] AS cc
									       ON [c].[Id] = [cc].[ClientId]
										WHERE [c].[FirstName] = @name
								     GROUP BY [cc].[ClientId]),
					                    0)
				 RETURN @Count;
		    END

GO

SELECT [dbo].[udf_ClientWithCigars] ('Betty') AS [Count]

-- Task 12
GO

CREATE PROC [usp_SearchByTaste] (@taste VARCHAR(20))
         AS
	  BEGIN
	         SELECT [c].[CigarName],
			        CONCAT('$', [c].[PriceForSingleCigar]) AS [Price],
					[t].[TasteType],
					[b].[BrandName],
					CONCAT([s].[Length], ' ', 'cm') AS [CigarLength],
					CONCAT([s].[RingRange], ' ', 'cm') AS [CigarRingRange]
			   FROM [Cigars] AS c
			   JOIN [Tastes] AS t
			     ON [c].[TastId] = [t].[Id]
			   JOIN [Brands] AS b
			     ON [c].[BrandId] = [b].[Id]
			   JOIN [Sizes] AS s
			     ON [c].[SizeId] = [s].[Id]
			  WHERE [t].[TasteType] = @taste
		   ORDER BY [s].[Length] ASC, [s].[RingRange] DESC
	    END

GO

EXEC [usp_SearchByTaste] 'Woody'
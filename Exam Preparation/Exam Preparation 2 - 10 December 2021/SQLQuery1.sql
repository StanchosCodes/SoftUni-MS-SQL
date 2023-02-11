-- Section 1 Task 1
CREATE DATABASE [Airport]

GO

USE [Airport]

GO

CREATE TABLE [Passengers]
(
[Id] INT PRIMARY KEY IDENTITY,
[FullName] VARCHAR(100) UNIQUE NOT NULL,
[Email] VARCHAR(50) UNIQUE NOT NULL
)

CREATE TABLE [Pilots]
(
[Id] INT PRIMARY KEY IDENTITY,
[FirstName] VARCHAR(30) UNIQUE NOT NULL,
[LastName] VARCHAR(30) UNIQUE NOT NULL,
[Age] TINYINT CHECK ([Age] BETWEEN 21 AND 62) NOT NULL,
[Rating] FLOAT CHECK ([Rating] BETWEEN 0.0 AND 10.0) -- have to be FLOAT for judge
)

CREATE TABLE [AircraftTypes]
(
[Id] INT PRIMARY KEY IDENTITY,
[TypeName] VARCHAR(30) UNIQUE NOT NULL
)

CREATE TABLE [Aircraft]
(
[Id] INT PRIMARY KEY IDENTITY,
[Manufacturer] VARCHAR(25) NOT NULL,
[Model] VARCHAR(30) NOT NULL,
[Year] INT NOT NULL,
[FlightHours] INT,
[Condition] CHAR(1) NOT NULL,
[TypeId] INT FOREIGN KEY REFERENCES [AircraftTypes] NOT NULL
)

CREATE TABLE [PilotsAircraft]
(
[AircraftId] INT FOREIGN KEY REFERENCES [Aircraft] NOT NULL,
[PilotId] INT FOREIGN KEY REFERENCES [Pilots] NOT NULL,
PRIMARY KEY ([AircraftId], [PilotId])
)

CREATE TABLE [Airports]
(
[Id] INT PRIMARY KEY IDENTITY,
[AirportName] VARCHAR(70) UNIQUE NOT NULL,
[Country] VARCHAR(100) UNIQUE NOT NULL
)

CREATE TABLE [FlightDestinations]
(
[Id] INT PRIMARY KEY IDENTITY,
[AirportId] INT FOREIGN KEY REFERENCES [Airports] NOT NULL,
[Start] DATETIME NOT NULL,
[AircraftId] INT FOREIGN KEY REFERENCES [Aircraft] NOT NULL,
[PassengerId] INT FOREIGN KEY REFERENCES [Passengers] NOT NULL,
[TicketPrice] DECIMAL(18, 2) DEFAULT 15 NOT NULL
)

SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_CATALOG = DB_NAME()

-- Section 2 Task 2
SELECT * FROM [Passengers]
SELECT * FROM [Pilots]

INSERT INTO [Passengers] ([FullName], [Email])
     SELECT CONCAT([p].[FirstName], ' ', [p].[LastName]), CONCAT([p].[FirstName], [p].[LastName], '@gmail.com')
	   FROM [Pilots] AS p
	  WHERE [p].[Id] BETWEEN 5 AND 15

-- Task 3
SELECT * FROM [Aircraft]

UPDATE [Aircraft]
   SET [Condition] = 'A'
 WHERE ([Condition] = 'C' OR [Condition] = 'B') AND ([FlightHours] IS NULL OR [FlightHours] <= 100) AND [Year] >= 2013

-- Task 4
SELECT *
  FROM [Passengers]
 WHERE LEN([FullName]) <= 10

DELETE
  FROM [FlightDestinations]
 WHERE [PassengerId] IN (
                            SELECT [Id]
                              FROM [Passengers]
                             WHERE LEN([FullName]) <= 10
                        )

DELETE
  FROM [Passengers]
 WHERE LEN([FullName]) <= 10

-- Section 3 Task 5
  SELECT [Manufacturer], [Model], [FlightHours], [Condition]
    FROM [Aircraft]
ORDER BY [FlightHours] DESC

-- Task 6
SELECT * FROM [PilotsAircraft]

SELECT [p].[FirstName], [p].[LastName], [a].[Manufacturer], [a].[Model], [a].[FlightHours]
  FROM [Pilots] AS p
  JOIN [PilotsAircraft] AS pa
    ON [p].[Id] = [pa].[PilotId]
  JOIN [Aircraft] AS a
    ON [pa].[AircraftId] = [a].[Id]
 WHERE [a].[FlightHours] IS NOT NULL AND [a].[FlightHours] <= 304
ORDER BY [a].[FlightHours] DESC, [p].[FirstName] ASC

-- Task 7
SELECT * FROM [FlightDestinations]

SELECT TOP (20) [fd].[Id] AS [DestinationId], [fd].[Start], [p].[FullName], [a].[AirportName], [fd].[TicketPrice]
      FROM [FlightDestinations] AS fd
      JOIN [Passengers] AS p
        ON [fd].[PassengerId] = [p].[Id]
      JOIN [Airports] AS a
        ON [fd].[AirportId] = [a].[Id]
     WHERE DAY([fd].[Start]) % 2 = 0
  ORDER BY [fd].[TicketPrice] DESC, [a].[AirportName] ASC

-- Task 8
  SELECT [GroupedSubquery].[AircraftId], [a].[Manufacturer], [a].[FlightHours], [FlightDestinationsCount], ROUND([AvgPrice], 2) AS [AvgPrice]
    FROM (
	           SELECT [a].[Id] AS [AircraftId], COUNT(*) AS [FlightDestinationsCount], AVG([fd].[TicketPrice]) AS [AvgPrice]
                 FROM [Aircraft] AS a
            LEFT JOIN [FlightDestinations] AS fd
                   ON [a].[Id] = [fd].[AircraftId]
             GROUP BY [a].[Id]
		       HAVING  COUNT(*) >= 2
	     ) AS [GroupedSubquery], [Aircraft] AS a
   WHERE [a].[Id] = [GroupedSubquery].[AircraftId]
ORDER BY [FlightDestinationsCount] DESC, [a].[Id] ASC

-- Task 8 Second variant easyer way
  SELECT [a].[Id] AS [AircraftId], [a].[Manufacturer], [a].[FlightHours], COUNT(*) AS [FlightDestinationsCount], ROUND(AVG([fd].[TicketPrice]), 2) AS [AvgPrice]
    FROM [Aircraft] AS a
    JOIN [FlightDestinations] AS fd
      ON [a].[Id] = [fd].[AircraftId]
GROUP BY [a].[Id], [a].[Manufacturer], [a].[FlightHours]
  HAVING  COUNT([fd].[Id]) >= 2
ORDER BY [FlightDestinationsCount] DESC, [a].[Id] ASC

-- Task 9
   SELECT [p].[FullName], COUNT(*) AS [CountOfAircraft], SUM([TicketPrice]) AS [TotalPayed]
     FROM [FlightDestinations] AS fd
LEFT JOIN [Passengers] AS p
       ON [fd].[PassengerId] = [p].[Id]
    WHERE SUBSTRING([p].[FullName], 2, 1) = 'a'
 GROUP BY [p].[FullName]
   HAVING COUNT(*) > 1
 ORDER BY [p].[FullName] ASC

-- Task 10
   SELECT [a].[AirportName], [fd].[Start] AS [DayTime], [fd].[TicketPrice], [p].[FullName], [ac].[Manufacturer], [ac].[Model]
     FROM [FlightDestinations] AS fd
LEFT JOIN [Passengers] AS p
       ON [fd].[PassengerId] = [p].[Id]
LEFT JOIN [Airports] as a
       ON [fd].[AirportId] = [a].[Id]
LEFT JOIN [Aircraft] AS ac
       ON [fd].[AircraftId] = [ac].[Id]
	WHERE CAST([fd].[Start] AS TIME) BETWEEN '6:00' AND '20:00' AND [fd].[TicketPrice] > 2500 -- more precise way
	-- WHERE (DATEPART(HOUR, [fd].[Start]) BETWEEN 6 AND 20) AND [fd].[TicketPrice] > 2500 Another way to do it
 ORDER BY [ac].[Model] ASC

-- Section 4 Task 11
GO

CREATE FUNCTION [udf_FlightDestinationsByEmail](@email VARCHAR(50))
    RETURNS INT
	         AS
		  BEGIN
		          DECLARE @FlightsCount INT;

				      SET @FlightsCount = (   ISNULL(
											   (SELECT COUNT([fd].[Id]) AS [Count]
				                                  FROM [Passengers] AS p
										   	      JOIN [FlightDestinations] AS fd
											        ON [p].[Id] = [fd].[PassengerId]
											     WHERE [p].[Email] = @email
										      GROUP BY [fd].[PassengerId]),
											       0)
										  )

				  RETURN @FlightsCount
		    END

GO

SELECT [dbo].[udf_FlightDestinationsByEmail] ('PierretteDunmuir@gmail.com') AS [Count]
SELECT [dbo].[udf_FlightDestinationsByEmail] ('Montacute@gmail.com') AS [Count]
SELECT [dbo].[udf_FlightDestinationsByEmail] ('MerisShale@gmail.com') AS [Count]

-- Task 12
GO

CREATE PROC [usp_SearchByAirportName] (@airportName VARCHAR(70))
         AS
	  BEGIN
	         SELECT [a].[AirportName], [p].[FullName], CASE
															WHEN [fd].[TicketPrice] <= 400 THEN 'Low'
															WHEN [fd].[TicketPrice] <= 1500 THEN 'Medium'
															ELSE 'High'
													 END AS [LevelOfTicketPrice],
					[ac].[Manufacturer], [ac].[Condition], [at].[TypeName]
			   FROM [Airports] AS a
			   JOIN [FlightDestinations] AS fd
			     ON [a].[Id] = [fd].[AirportId]
			   JOIN [Passengers] AS p
			     ON [p].[Id] = [fd].[PassengerId]
			   JOIN [Aircraft] AS ac
			     ON [fd].[AircraftId] = [ac].[Id]
			   JOIN [AircraftTypes] AS [at]
			     ON [ac].[TypeId] = [at].[Id]
			  WHERE [a].[AirportName] = @airportName
			  ORDER BY [ac].[Manufacturer] ASC, [p].[FullName] ASC
	    END

EXEC [usp_SearchByAirportName] 'Sir Seretse Khama International Airport'
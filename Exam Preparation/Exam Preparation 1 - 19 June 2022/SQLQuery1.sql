-- Section 1 Task 1
CREATE DATABASE [Zoo]

GO

USE [Zoo]

GO

CREATE TABLE [Owners]
(
[Id] INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) NOT NULL,
[PhoneNumber] VARCHAR(15) NOT NULL,
[Address] VARCHAR(50)
)

CREATE TABLE [AnimalTypes]
(
[Id] INT PRIMARY KEY IDENTITY,
[AnimalType] VARCHAR(30) NOT NULL
)

CREATE TABLE [Cages]
(
[Id] INT PRIMARY KEY IDENTITY,
[AnimalTypeId] INT FOREIGN KEY REFERENCES [AnimalTypes]([Id]) NOT NULL
)

CREATE TABLE [Animals]
(
[Id] INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(30) NOT NULL,
[BirthDate] DATE NOT NULL,
[OwnerId] INT FOREIGN KEY REFERENCES [Owners]([Id]),
[AnimalTypeId] INT FOREIGN KEY REFERENCES [AnimalTypes]([Id]) NOT NULL
)

CREATE TABLE [AnimalsCages]
(
[CageId] INT FOREIGN KEY REFERENCES [Cages]([Id]) NOT NULL,
[AnimalId] INT FOREIGN KEY REFERENCES [Animals]([Id]) NOT NULL,
PRIMARY KEY ([CageId], [AnimalId])
)

CREATE TABLE [VolunteersDepartments]
(
[Id] INT PRIMARY KEY IDENTITY,
[DepartmentName] VARCHAR(30) NOT NULL
)

CREATE TABLE [Volunteers]
(
[Id] INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) NOT NULL,
[PhoneNumber] VARCHAR(15) NOT NULL,
[Address] VARCHAR(50),
[AnimalId] INT FOREIGN KEY REFERENCES [Animals]([Id]),
[DepartmentId] INT FOREIGN KEY REFERENCES [VolunteersDepartments]([Id]) NOT NULL
)

-- Section 2 Task 2
INSERT INTO [Animals] -- Inserting first because it does not have relation with the volunteers table
VALUES
('Giraffe', '2018-09-21', 21, 1),
('Harpy Eagle', '2015-04-17', 15, 3),
('Hamadryas Baboon', '2017-11-02', NULL, 1),
('Tuatara', '2021-06-30', 2, 4)

INSERT INTO [Volunteers] -- Inserting second because it has relation with the animals table
VALUES
('Anita Kostova', '0896365412', 'Sofia, 5 Rosa str.', 15, 1),
('Dimitur Stoev', '0877564223', NULL, 42, 4),
('Kalina Evtimova', '0896321112', 'Silistra, 21 Breza str.', 9, 7),
('Stoyan Tomov', '0898564100', 'Montana, 1 Bor str.', 18, 8),
('Boryana Mileva', '0888112233', NULL, 31, 5)

-- Task 3
UPDATE [Animals]
   SET [OwnerId] = (
                      SELECT [Id] FROM [Owners]
                       WHERE [Name] = 'Kaloqn Stoqnov'
                   )
 WHERE [OwnerId] IS NULL

-- Task 4
DELETE
  FROM [Volunteers]
 WHERE [DepartmentId] = (
                           SELECT [Id] FROM [VolunteersDepartments]
                            WHERE [DepartmentName] = 'Education program assistant'
                        )

DELETE
  FROM [VolunteersDepartments]
 WHERE [DepartmentName] = 'Education program assistant'

-- Section 3 Task 5
  SELECT [Name], [PhoneNumber], [Address], [AnimalId], [DepartmentId]
    FROM [Volunteers]
ORDER BY [Name] ASC, [AnimalId] ASC, [DepartmentId] ASC

-- Task 6
SELECT * FROM [Animals]
SELECT * FROM [AnimalTypes]

  SELECT [a].[Name], [at].[AnimalType], FORMAT([a].[BirthDate], 'dd.MM.yyyy') AS [BirthDate]
    FROM [Animals] AS a
    JOIN [AnimalTypes] AS at
      ON [a].[AnimalTypeId] = [at].[Id]
ORDER BY [a].[Name] ASC

-- Task 7
SELECT TOP (5) [o].[Name] AS [Owner], COUNT(*) AS [CountOfAnimals]
      FROM [Owners] AS o
LEFT  JOIN [Animals] AS a
        ON [o].[Id] = [a].[OwnerId]
  GROUP BY [o].[Name]
  ORDER BY [CountOfAnimals] DESC

-- Task 8
SELECT * FROM [AnimalsCages]
SELECT * FROM [AnimalTypes]

SELECT CONCAT([o].[Name], '-', [a].[Name]) AS [OwnersAnimals], [o].[PhoneNumber], [ac].[CageId]
  FROM [Owners] AS o
  JOIN [Animals] AS a
    ON [o].[Id] = [a].[OwnerId]
  JOIN [AnimalsCages] AS ac
    ON [a].[Id] = [ac].[AnimalId]
  JOIN [AnimalTypes] AS [at]
    ON [a].[AnimalTypeId] = [at].[Id]
 WHERE [at].[AnimalType] = 'Mammals'
ORDER BY [o].[Name] ASC, [a].[Name] DESC

-- Task 9
  SELECT [Name], [PhoneNumber], TRIM(REPLACE(REPLACE([Address], 'Sofia', ''), ',', '')) AS [Address]
    FROM [Volunteers]
   WHERE [DepartmentId] = (
                              SELECT [Id]
			   			  	    FROM [VolunteersDepartments]
							   WHERE [DepartmentName] = 'Education program assistant'
                          )
         AND [Address] LIKE '%Sofia%'
ORDER BY [Name] ASC

-- Task 10
  SELECT [a].[Name], YEAR([a].[BirthDate]) AS [BirthDate], [at].[AnimalType]
    FROM [Animals] AS a
    JOIN [AnimalTypes] AS at
      ON [a].[AnimalTypeId] = [at].[Id]
   WHERE [a].[OwnerId] IS NULL AND DATEDIFF(YEAR, [a].[BirthDate], '01/01/2022') < 5 AND [at].[AnimalType] <> 'Birds'
ORDER BY [a].[Name] ASC

-- Section 4 Task 11
SELECT * FROM [VolunteersDepartments]
SELECT * FROM [Volunteers]
GO

CREATE FUNCTION [udf_GetVolunteersCountFromADepartment] (@VolunteersDepartment VARCHAR(30))
    RETURNS INT
	         AS
		  BEGIN
		         DECLARE @CountOfVolunteers INT;

		             SET @CountOfVolunteers = (
					                                SELECT COUNT(*) AS [Count]
				                                      FROM [VolunteersDepartments] AS vd
				                                      JOIN [Volunteers] AS v
				                                        ON [vd].[Id] = [v].[DepartmentId]
				                                     WHERE [vd].[DepartmentName] = @VolunteersDepartment
				                                  GROUP BY [v].[DepartmentId]
					                          )

				 RETURN @CountOfVolunteers;
		    END

GO

SELECT [dbo].[udf_GetVolunteersCountFromADepartment] ('Education program assistant') AS [Count]
SELECT [dbo].[udf_GetVolunteersCountFromADepartment] ('Guest engagement') AS [Count]
SELECT [dbo].[udf_GetVolunteersCountFromADepartment] ('Zoo events') AS [Count]

-- Task 12
GO

CREATE PROC [usp_AnimalsWithOwnersOrNot] (@AnimalName VARCHAR(30))
    AS
 BEGIN
	     SELECT [a].[Name], CASE
		             WHEN [a].[OwnerId] IS NULL THEN 'For adoption'
					 ELSE [o].[Name]
				   END AS [OwnersName]
		   FROM [Animals] AS a
	  LEFT JOIN [Owners] AS o
		     ON [a].[OwnerId] = [o].[Id]
		  WHERE [a].[Name] = @AnimalName
   END

EXEC [usp_AnimalsWithOwnersOrNot] 'Pumpkinseed Sunfish'
EXEC [usp_AnimalsWithOwnersOrNot] 'Hippo'
EXEC [usp_AnimalsWithOwnersOrNot] 'Brown bear'
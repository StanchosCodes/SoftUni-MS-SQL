CREATE DATABASE [Relations]

GO

USE Relations

GO

-- Task 1 One-To-One Relation
CREATE TABLE [Passports]
(
[PassportID] INT PRIMARY KEY IDENTITY(101, 1),
[PassportNumber] VARCHAR(8) NOT NULL
)

CREATE TABLE [Persons]
(
[PersonID] INT PRIMARY KEY IDENTITY, -- By default it starts from 1 and increments by 1
[FirstName] VARCHAR(50) NOT NULL,
[Salary] DECIMAL(8, 2) NOT NULL,
[PassportID] INT FOREIGN KEY REFERENCES [Passports]([PassportID]) UNIQUE NOT NULL -- One To One Relation (One person can have one passpoet id and one id can be assigned to one person)
)

INSERT INTO [Passports]
VALUES
('N34FG21B'),
('K65LO4R7'),
('ZE657QP2')

INSERT INTO [Persons]
VALUES
('Roberto', 43400.00, 102),
('Tom', 56100.00, 103),
('Yana', 60200.00, 101)

SELECT * FROM [Passports]
SELECT * FROM [Persons]

-- Not from the task
ALTER TABLE [Passports]
ADD UNIQUE ([PassportNumber]) -- Adding unique constraint to the PassportNumber column

-- Task 2 One-To-Many Relation
CREATE TABLE [Manufacturers]
(
[ManufacturerID] INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) NOT NULL,
[EstablishedOn] DATE NOT NULL
)

CREATE TABLE [Models]
(
[ModelID] INT PRIMARY KEY IDENTITY(101, 1),
[Name] VARCHAR(50) NOT NULL,
[ManufacturerID] INT FOREIGN KEY REFERENCES [Manufacturers] ([ManufacturerID]) NOT NULL -- One to Many Relation (One Manufacturer can make many Models) and Many to One (Many Models can be made by one Manufacturer)
)

INSERT INTO [Manufacturers]
VALUES
('BMW', '07/03/1916'),
('Tesla', '01/01/2003'),
('Lada', '01/05/1966')

INSERT INTO [Models]
VALUES
('X1', 1),
('i6', 1),
('Model S', 2),
('Model X', 2),
('Model 3', 2),
('Nova', 3)

SELECT * FROM [Manufacturers]
SELECT * FROM [Models]

-- Task 3 Many-To-Many Relation
CREATE TABLE [Students]
(
[StudentID] INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(50) NOT NULL
)

CREATE TABLE [Exams]
(
[ExamID] INT PRIMARY KEY IDENTITY(101, 1),
[Name] NVARCHAR(50) NOT NULL
)

CREATE TABLE [StudentsExams]
(
[StudentID] INT FOREIGN KEY REFERENCES [Students] ([StudentID]), -- Creating first One to Many Relation
[ExamID] INT FOREIGN KEY REFERENCES [Exams] ([ExamID]), -- Creating second One to Many Relation
PRIMARY KEY ([StudentID], [ExamID]) -- Creating Composite Primary Key
)

INSERT INTO [Students]
VALUES
('Mila'),
('Toni'),
('Ron')

INSERT INTO [Exams]
VALUES
('SpringMVC'),
('Neo4j'),
('Oracle 11g')

INSERT INTO [StudentsExams]
VALUES
(1, 101),
(1, 102),
(2, 101),
(3, 103),
(2, 102),
(2, 103)

SELECT * FROM [Students]
SELECT * FROM [Exams]
SELECT * FROM [StudentsExams]

-- Task 4 Self-Referencing
CREATE TABLE [Teachers]
(
[TeacherID] INT PRIMARY KEY IDENTITY(101, 1),
[Name] VARCHAR(50) NOT NULL,
[ManagerID] INT FOREIGN KEY REFERENCES [Teachers] ([TeacherID]) -- Creating a Self-Referencing Foreign Key (ManagerID Refers to TeacherID)
)

INSERT INTO [Teachers]
VALUES
('John', NULL),
('Maya', 106),
('Silvia', 106),
('Ted', 105),
('Mark', 101),
('Greta', 101)

SELECT * FROM [Teachers]

-- Task 5
CREATE DATABASE [OnlineStore]

GO

USE [OnlineStore]

GO

CREATE TABLE [Cities]
(
[CityID] INT PRIMARY KEY,
[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE [Customers]
(
[CustomerID] INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(50) NOT NULL,
[Birthday] DATETIME2,
[CityID] INT FOREIGN KEY REFERENCES [Cities] ([CityID]) NOT NULL -- Creating One to Many Relation (One City can have Many Customers)
)

CREATE TABLE [Orders]
(
[OrderID] INT PRIMARY KEY,
[CustomerID] INT FOREIGN KEY REFERENCES [Customers] ([CustomerID]) NOT NULL -- Creating One to Many Relation (One Customer can have Many Orders)
)

CREATE TABLE [ItemTypes]
(
[ItemTypeID] INT PRIMARY KEY,
[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE [Items]
(
[ItemID] INT PRIMARY KEY,
[Name] VARCHAR(50) NOT NULL,
[ItemTypeID] INT FOREIGN KEY REFERENCES [ItemTypes] ([ItemTypeID]) NOT NULL -- Creating One to Many Relation (One ItemType can hold Many Items)
)

CREATE TABLE [OrderItems]
(
[OrderID] INT FOREIGN KEY REFERENCES [Orders] ([OrderID]) NOT NULL, -- Creating first One to Many Relation
[ItemID] INT FOREIGN KEY REFERENCES [Items] ([ItemID]) NOT NULL, -- Creating second One to Many Relation
PRIMARY KEY ([OrderID], [ItemID]) -- Creating Composite Primary Key
)

SELECT * FROM [OrderItems]
SELECT * FROM [Items]
SELECT * FROM [ItemTypes]
SELECT * FROM [Orders]
SELECT * FROM [Customers]
SELECT * FROM [Cities]

-- Task 6
CREATE DATABASE [University]

GO

USE [University]

GO

CREATE TABLE [Majors]
(
[MajorID] INT PRIMARY KEY,
[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE [Students]
(
[StudentID] INT PRIMARY KEY IDENTITY,
[StudentNumber] INT NOT NULL,
[StudentName] VARCHAR(50) NOT NULL,
[MajorID] INT FOREIGN KEY REFERENCES [Majors] ([MajorID]) NOT NULL -- Creating One to Many Relation (One Major can be studied by Many Students)
)

CREATE TABLE [Payments]
(
[PaymentID] INT PRIMARY KEY IDENTITY,
[PaymentDate] DATETIME2 NOT NULL,
[PaymentAmount] DECIMAL(8, 2),
[StudentID] INT FOREIGN KEY REFERENCES [Students] ([StudentID]) NOT NULL -- Creating One to Many Relation (One Student can have Many Payments)
)

CREATE TABLE [Subjects]
(
[SubjectID] INT PRIMARY KEY,
[SubjectName] VARCHAR(50) NOT NULL
)

CREATE TABLE [Agenda]
(
[StudentID] INT FOREIGN KEY REFERENCES [Students] ([StudentID]) NOT NULL, -- Creating first One to Many Relation
[SubjectID] INT FOREIGN KEY REFERENCES [Subjects] ([SubjectID]) NOT NULL,-- Creating second One to Many Relation
PRIMARY KEY ([StudentID], [SubjectID]) -- Creating Composite Primary Key
)

SELECT * FROM [Majors]
SELECT * FROM [Students]
SELECT * FROM [Payments]
SELECT * FROM [Subjects]
SELECT * FROM [Agenda]

-- Task 9
USE Geography

GO

SELECT * FROM [Peaks]
SELECT * FROM [Mountains]

SELECT m.MountainRange, p.PeakName, p.Elevation FROM [Peaks] AS p JOIN [Mountains] AS m ON m.Id = 17 AND p.MountainId = 17 ORDER BY p.Elevation DESC

-- SECOND WAY

--SELECT m.MountainRange, p.PeakName, p.Elevation -- Selecting the Columns we want to see
--  FROM [Mountains] AS m -- Setting an alias to Mountains table to be m
--  JOIN [Peaks] AS p -- Joining Mountains table with Peaks table and setting an alias to Peaks table to be p
--    ON m.Id = p.MountainId -- Giving a condition on witch the tables will be joined
-- WHERE m.MountinRange = 'Rila' -- Giving a condition on witch the results will be filtered
-- ORDER BY p.Elevation DESC -- Giving a sorting condition
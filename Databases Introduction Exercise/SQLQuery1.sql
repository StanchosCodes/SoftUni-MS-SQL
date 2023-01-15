-- Task 1
CREATE DATABASE Minions

USE Minions

-- Task 2
CREATE TABLE Minions(
Id INT,
[Name] VARCHAR(100),
Age INT
)

-- Task 2
CREATE TABLE Towns(
Id INT,
[Name] VARCHAR(100)
)

-- Task 2
ALTER TABLE Minions
ALTER COLUMN Id INT NOT NULL

-- Task 2
ALTER TABLE Minions
ADD CONSTRAINT PK_Id PRIMARY KEY (Id)

-- Task 2
ALTER TABLE Towns
ALTER COLUMN Id INT NOT NULL

-- Task 2
ALTER TABLE Towns
ADD CONSTRAINT PKey_Id PRIMARY KEY (Id)

-- Task 3
ALTER TABLE Minions
ADD [TownId] INT FOREIGN KEY REFERENCES Towns(Id)

-- Task 4
INSERT INTO Towns
VALUES
(1, 'Sofia'),
(2, 'Plivdiv'),
(3, 'Varna')

SELECT * FROM Towns

-- Task 4
INSERT INTO Minions
VALUES
(1, 'Kevin', 22, 1),
(2, 'Bob', 3, 3),
(3, 'Steward', NULL, 2)

SELECT * FROM Minions

UPDATE Towns
SET [Name] = 'Plovdiv'
WHERE Id = 2

-- Task 5
TRUNCATE TABLE Minions

-- Task 6
DROP TABLE Minions
DROP TABLE Towns

-- Task 7
CREATE TABLE People (
Id BIGINT PRIMARY KEY IDENTITY,
[Name] VARCHAR(100) NOT NULL,
Picture BINARY,
Height NUMERIC(4, 2),
[Weight] NUMERIC(4, 2),
Gender CHAR CHECK (Gender in ('m','f')) NOT NULL,
Birthdate DATE NOT NULL,
Biography NVARCHAR(MAX)
)

-- Task 7
INSERT INTO People
VALUES
('Pesho', NULL, 1.78, 65.80, 'm', 'January 2 1995', NULL),
('Gosho', NULL, 1.603, 64.902, 'm', 'March 3 2016', NULL),
('Todor', NULL, 1.567, 62.769, 'm', 'July 6 2001', NULL),
('Mimi', NULL, 1.478, 38.476, 'f', 'September 10 2019', NULL),
('Aleks', NULL, 1.56, 46.567, 'f', 'December 11 1998', NULL)

SELECT * FROM People

INSERT INTO People
VALUES
('Test', NULL, 1.38, 62.30, 'm', 'January 2 2966', NULL)

DROP TABLE People

-- Task 8
CREATE TABLE Users (
Id BIGINT PRIMARY KEY IDENTITY,
Username VARCHAR(30) NOT NULL,
[Password] VARCHAR(26) NOT NULL,
ProfilePicture VARBINARY(MAX), -- LIMIT TO 900000 bytes 900KB = 900 000 Bytes
LastLoginTime DATETIME2,
IsDeleted BIT -- IT CAN ALSE BE THIS WAY {VARCHAR(5) CHECK (IsDeleted in ('True', 'False'))}
)

-- Task 8
INSERT INTO Users
VALUES
('Pesho', '123456', NULL, '10-10-2022', 0),
('Gosho', '12344', NULL, '11-23-2021', 0),
('Mimi', '123456', NULL, '9-5-2016', 1),
('Koko', '12345', NULL, '12-26-2023', 0),
('Shoko', '12454', NULL, '6-14-2020', 1)

SELECT * FROM Users

INSERT INTO Users (Username, [Password], ProfilePicture, IsDeleted)
VALUES
('Qgodcho', '12436', NULL, 0)

INSERT INTO Users
VALUES
('Marmaladcho', '12485', NULL, '2020-12-23 15:40:45.2756145', 0)

-- Task 9
ALTER TABLE Users
DROP CONSTRAINT PK__Users__3214EC076A44A9E5;

-- Task 9
ALTER TABLE Users
ADD CONSTRAINT PK_IdUsername PRIMARY KEY (Id, Username);

-- Task 10
ALTER TABLE Users
ADD CONSTRAINT CHK_PassMinLength CHECK(LEN(Password) >= 5);

TRUNCATE TABLE Users

-- Task 11
ALTER TABLE Users ADD CONSTRAINT DF_LastLoginTime DEFAULT GETDATE() FOR LastLoginTime

-- Task 12
ALTER TABLE Users DROP CONSTRAINT PK_IdUsername
ALTER TABLE Users ADD Constraint PK_Id PRIMARY KEY (Id)
ALTER TABLE Users ADD CONSTRAINT UC_Username UNIQUE (Username)

SELECT * FROM Users

DELETE FROM Users WHERE Username LIKE 'Qgodcho'

-- '%qgodcho%' Deletes every entry where qgodcho is included ('qgodcho123', '123qgodcho', 'qgodcho') - it will all be deleted

ALTER TABLE Users
ADD CONSTRAINT CHK_UsernameLength CHECK(LEN(Username) >= 3);

-- Task 13
CREATE DATABASE Movies

USE Movies

CREATE TABLE Directors (
Id INT PRIMARY KEY NOT NULL,
DirectorName VARCHAR(100) NOT NULL,
Notes VARCHAR(MAX)
)

CREATE TABLE Genres (
Id INT PRIMARY KEY NOT NULL,
GenreName VARCHAR(100) NOT NULL,
Notes VARCHAR(MAX)
)

CREATE TABLE Categories (
Id INT PRIMARY KEY NOT NULL,
CategoryName VARCHAR(100) NOT NULL,
Notes VARCHAR(MAX)
)

CREATE TABLE Movies (
Id INT PRIMARY KEY NOT NULL,
Title VARCHAR(100) NOT NULL,
DirectorId INT NOT NULL,
CopyrightYear DATE,
[Length] TIME NOT NULL,
GenreId INT NOT NULL,
CategoryId INT NOT NULL,
Rating NUMERIC(3, 1),
Notes VARCHAR(MAX)
)

INSERT INTO Directors
VALUES
(1, 'Pesho', 'SomeNotes'),
(2, 'Gosho', 'SomeNotes2'),
(3, 'Mimi', 'SomeNotes3'),
(4, 'Tosho', NULL),
(5, 'Mitko', NULL)

INSERT INTO Genres
VALUES
(1, 'Drama', NULL),
(2, 'Comedy', 'SomeNotes234'),
(3, 'Sci-Fi', NULL),
(4, 'Crimi', 'SomeNotes23'),
(5, 'Horor', 'SomeNotes345')

INSERT INTO Categories
VALUES
(1, 'DramaCategory', 'SomeNotes4645'),
(2, 'ComedyCategory', NULL),
(3, 'Sci-FiCategory', 'SomeNotes234'),
(4, 'CrimiCategory', 'SomeNotes23'),
(5, 'HororCategory', 'SomeNotes345')

INSERT INTO Movies
VALUES
(1, 'DramaTitle', 2, 'January 10 2023', '1:40:45.2756145', 1, 1, 3.2,'SomeNotes45'),
(2, 'ComedyTitle', 1, 'April 12 2022', '3:30:45.2756145', 2, 2, 10.0,'SomeNotes345345'),
(3, 'Sci-FiTitle', 4, 'March 23 2019', '3:20:45.2756145', 3, 3, 6.8,'SomeNotes445345'),
(4, 'CrimiTitle', 5, 'July 6 2024', '2:50:45.2756145', 4, 4, 5.4, NULL),
(5, 'HororTitle', 3, 'October 10 2026', '1:24:45.2756145', 5, 5, 1.3,'SomeNotes45rerw')

SELECT * FROM Directors
SELECT * FROM Genres
SELECT * FROM Categories
SELECT * FROM Movies

-- Task 14
CREATE DATABASE CarRental

USE CarRental

CREATE TABLE Categories (
Id INT PRIMARY KEY NOT NULL,
CategoryName VARCHAR(100) NOT NULL,
DailyRate NUMERIC(4, 2),
WeeklyRate NUMERIC(4, 2),
MonthlyRate NUMERIC(4, 2),
WeekendRate NUMERIC(4, 2)
)

CREATE TABLE Cars (
Id INT PRIMARY KEY NOT NULL,
PlateNumber VARCHAR(20) NOT NULL,
Manufacturer VARCHAR(100) NOT NULL,
Model VARCHAR(100) NOT NULL,
CarYear DATE,
CategoryId INT NOT NULL,
Doors INT,
Picture VARBINARY(MAX),
Condition VARCHAR(100),
Available BIT NOT NULL,
)

CREATE TABLE Employees (
Id INT PRIMARY KEY NOT NULL,
FirstName VARCHAR(50) NOT NULL,
LastName VARCHAR(50) NOT NULL,
Title VARCHAR(100) NOT NULL,
Notes VARCHAR(100)
)

CREATE TABLE Customers (
Id INT PRIMARY KEY NOT NULL,
DriverLicenceNumber VARCHAR(20) NOT NULL,
FullName VARCHAR(100) NOT NULL,
[Address] VARCHAR(200),
City VARCHAR(50),
ZIPCode VARCHAR(50),
Notes VARCHAR(100)
)

CREATE TABLE RentalOrders (
Id INT PRIMARY KEY NOT NULL,
EmployeeId INT NOT NULL,
CustomerId INT NOT NULL,
CarId INT NOT NULL,
TankLevel INT NOT NULL,
KilometrageStart INT NOT NULL,
KilometrageEnd INT NOT NULL,
TotalKilometrage INT NOT NULL,
StartDate DATE NOT NULL,
EndDate DATE NOT NULL,
TotalDays INT NOT NULL,
RateApplied NUMERIC(4, 2),
TaxRate NUMERIC(4, 2),
OrderStatus VARCHAR(50),
Notes VARCHAR(100)
)

INSERT INTO Categories
VALUES
(1, 'Sport', 5.6, 6.5, 7.6, 8.7),
(2, 'Comfort', 6.6, 7.5, 8.6, 9.7),
(3, 'Normal', 10.0, 9.56, NULL, 10.00)

INSERT INTO Cars
VALUES
(1, 'V8099KS', 'SomeManufacturer', 'SomeModel', 'January 10 1999', 2, 4, NULL, 'Exellent', 1),
(2, 'R9878UYR', 'SomeManufacturer2', 'SomeModel1', 'March 13 2056', 1, 2, NULL, 'It Drives', 0),
(3, 'V8099KS', 'SomeManufacturer3', 'SomeModel2', 'April 26 2098', 3, 5, NULL, 'It Exists', 1)

INSERT INTO Employees
VALUES
(1, 'Pesho', 'Peshev', 'Intern', 'SomeNotes'),
(2, 'Gosho', 'Goshev', 'Junier', 'SomeNotes2'),
(3, 'Mimi', 'Mimeva', 'Senior', 'SomeNotes3')

INSERT INTO Customers
VALUES
(1, 'V4636GH', 'Gosho Peshev', 'Street1', 'Varna', '9000', 'SomeNotes'),
(2, 'R68768HJ', 'Mimi Gosheva', 'Street2', 'Sofia', 'DB87 58 DDD', 'SomeNotes2'),
(3, 'T7879HJ', 'Pesho Mimev', 'Street3', 'Gabrovo', '6788', 'SomeNotes3')

INSERT INTO RentalOrders
VALUES
(1, 2, 3, 1, 60, 268000, 300000, 32000, 'January 23 2022', 'January 28 2022', 6, 5.6, 1.2, 'In Progress', 'Trashy'),
(2, 3, 1, 3, 45, 220000, 320000, 100000, 'March 26 2024', 'March 28 2024', 5, 2.4, 0.5, 'In Pit Stop', 'Very Trashy'),
(3, 1, 2, 2, 56, 210000, 340000, 130000, 'April 19 2026', 'November 30 2028', 678, 1.5, 1.1, 'In Garbage', 'Extra Trashy')

SELECT * FROM Categories
SELECT * FROM Cars
SELECT * FROM Employees
SELECT * FROM Customers
SELECT * FROM RentalOrders

-- Task 15
CREATE DATABASE Hotel

USE Hotel

CREATE TABLE Employees (
Id INT PRIMARY KEY NOT NULL,
FirstName VARCHAR(50) NOT NULL,
LastName VARCHAR(50) NOT NULL,
Title VARCHAR(50) NOT NULL,
Notes VARCHAR(50)
)

CREATE TABLE Customers (
AccountNumber INT PRIMARY KEY NOT NULL,
FirstName VARCHAR(50) NOT NULL,
LastName VARCHAR(50) NOT NULL,
PhoneNumber INT NOT NULL,
EmergencyName VARCHAR(50) NOT NULL,
EmergencyNumber INT NOT NULL,
Notes VARCHAR(50)
)

CREATE TABLE RoomStatus (
RoomStatus VARCHAR(50) PRIMARY KEY NOT NULL,
Notes VARCHAR(50)
)

CREATE TABLE RoomTypes (
RoomType VARCHAR(50) PRIMARY KEY NOT NULL,
Notes VARCHAR(50)
)

CREATE TABLE BedTypes (
BedType VARCHAR(50) PRIMARY KEY NOT NULL,
Notes VARCHAR(50)
)

CREATE TABLE Rooms (
RoomNumber INT PRIMARY KEY NOT NULL,
RoomType VARCHAR(50) NOT NULL,
BedType VARCHAR(50) NOT NULL,
Rate NUMERIC(4, 2),
RoomStatus VARCHAR(50) NOT NULL,
Notes VARCHAR(50)
)

CREATE TABLE Payments (
Id INT PRIMARY KEY NOT NULL,
EmployeeId INT NOT NULL,
PaymentDate DATE NOT NULL,
AccountNumber  INT NOT NULL,
FirstDateOccupied DATE NOT NULL,
LastDateOccupied DATE NOT NULL,
TotalDays  INT NOT NULL,
AmountCharged NUMERIC(5, 2),
TaxRate NUMERIC(4, 2),
TaxAmount  NUMERIC(4, 2),
PaymentTotal  NUMERIC(5, 2),
Notes VARCHAR(50)
)

CREATE TABLE Occupancies (
Id INT PRIMARY KEY NOT NULL,
EmployeeId INT NOT NULL,
DateOccupied DATE NOT NULL,
AccountNumber INT NOT NULL,
RoomNumber INT NOT NULL,
RateApplied NUMERIC(4, 2),
PhoneCharge NUMERIC(5, 2),
Notes VARCHAR(50)
)

INSERT INTO Employees
VALUES
(1, 'Pesho', 'Peshev', 'Employee1', 'SomeNotes1'),
(2, 'Gosho', 'Goshev', 'Employee2', 'SomeNotes2'),
(3, 'Mimi', 'Mimeva', 'Employee3', 'SomeNotes3')

INSERT INTO Customers
VALUES
(1234, 'Customer1', 'Cust1', 32543412, 'Custemer11', 32542533, 'SomeNotes11'),
(2345, 'Custemer2', 'Cust2', 23325324, 'Custemer22', 34324243, 'SomeNotes22'),
(3456, 'Customer3', 'Cust3', 23434234, 'Custemer33', 32432423, 'SomeNotes33')

INSERT INTO RoomStatus
VALUES
('Active', 'It is free'),
('Occupied', 'It is not free'),
('Hot', 'It is getting hot in here')

INSERT INTO RoomTypes
VALUES
('One bed', 'It is free'),
('Two beds', 'It is not free'),
('Three beds', 'It is very hot in here')

INSERT INTO BedTypes
VALUES
('Soft', 'It is free'),
('Not good', 'It is not free'),
('Extra good', 'It is very hot in here')

INSERT INTO Rooms
VALUES
(24, 'One bed', 'Soft', 10.00, 'Active', 'Come'),
(25, 'Two beds', 'Not good', 2, 'Occupied', 'Coming'),
(26, 'Three beds', 'Extra good', 10, 'Hot', 'Come with me')

INSERT INTO Payments
VALUES
(1, 3, 'January 11 2046', 2345, 'January 3 2046', 'January 11 2046', 9, 200, 8.00, 8, 208, 'SomeNotesHere1'),
(2, 1, 'March 18 2026', 1234, 'March 8 2026', 'March 18 2026', 11, 150, 10.00, 10, 160, 'SomeNotesHere2'),
(3, 2, 'April 24 2084', 3456, 'April 4 2084', 'April 24 2084', 21, 300, 9.00, 9, 309, 'SomeNotesHere3')

INSERT INTO Occupancies
VALUES
(1, 3, 'January 3 2046', 2345, 24, 8.00, 10, 'SomeNotesHere1'),
(2, 2, 'April 4 2084', 3456, 25, 9.00, 10, 'SomeNotesHere2'),
(3, 1, 'March 8 2026', 1234, 26, 10.00, 10, 'SomeNotesHere3')

SELECT * FROM Employees
SELECT * FROM Customers
SELECT * FROM RoomStatus
SELECT * FROM RoomTypes
SELECT * FROM BedTypes
SELECT * FROM Rooms
SELECT * FROM Payments
SELECT * FROM Occupancies

-- Task 16
CREATE DATABASE SoftUni

USE SoftUni

CREATE TABLE Towns (
Id INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(100) NOT NULL
)

CREATE TABLE Addresses (
Id INT PRIMARY KEY IDENTITY,
AddressText VARCHAR(100) NOT NULL
)

ALTER TABLE Addresses
ADD [TownId] INT FOREIGN KEY REFERENCES Towns(Id)

CREATE TABLE Departments (
Id INT PRIMARY KEY IDENTITY,
[Name] VARCHAR(100) NOT NULL
)

CREATE TABLE Employees (
Id INT PRIMARY KEY IDENTITY,
FirstName VARCHAR(100) NOT NULL,
MiddleName VARCHAR(100) NOT NULL,
LastName VARCHAR(100) NOT NULL, 
JobTitle VARCHAR(100) NOT NULL,
HireDate DATETIME2,
Salary DECIMAL(7, 2) NOT NULL
)

ALTER TABLE Employees
ADD [DepartmentId] INT FOREIGN KEY REFERENCES Departments(Id)

ALTER TABLE Employees
ADD [AddressId] INT FOREIGN KEY REFERENCES Addresses(Id)

-- Task 18
INSERT INTO Towns
VALUES
('Varna')

INSERT INTO Towns
VALUES
('Sofia'),
('Burgas'),
('Plovdiv')

INSERT INTO Addresses
VALUES
('Stenka Razin', 1),
('Bul Bulgaria', 2),
('Emil Panayotov', 4),
('Perushtica', 3)

INSERT INTO Departments
VALUES
('Junior'),
('Senior')

INSERT INTO Employees
VALUES
('Pesho', 'Peshev', 'Peshev', '.NET DEV', '2020-12-23 15:40:45.2756145', 5000.50, 2, 1),
('Gosho', 'Goshev', 'Goshev', 'NODE DEV', '2020-12-23 15:40:45.2756145', 3000.46, 1, 2)

-- Task 19
SELECT * FROM Towns
SELECT * FROM Departments
SELECT * FROM Employees

-- Task 20
SELECT [Name] FROM Towns
SELECT [Name] FROM Departments
SELECT FirstName, LastName, JobTitle, Salary FROM Employees

-- Task 21
SELECT [Name] FROM Towns ORDER BY [Name] asc
SELECT [Name] FROM Departments ORDER BY [Name] asc
SELECT FirstName, LastName, JobTitle, Salary FROM Employees ORDER BY [Salary] desc

-- Task 22
UPDATE Employees
SET Salary = Salary + Salary * 0.1

SELECT Salary FROM Employees

-- Task 23
USE HOTEL

UPDATE Payments
SET TaxRate = TaxRate - TaxRate * 0.03

SELECT TaxRate FROM Payments

-- Task 24
TRUNCATE TABLE Occupancies

SELECT * FROM Occupancies
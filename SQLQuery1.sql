---------------- SQL DROP DATABASE Statement for deleting a DB
USE master;

-- Cannot drop database "koko5" because it is currently in use.
-- (database koko5 is still connected by some session — possibly your current one.
ALTER DATABASE koko5 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;  


USE master;
IF EXISTS(SELECT * FROM sys.databases WHERE name='MyDB2')
	BEGIN
		ALTER DATABASE MyDB2 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
		DROP DATABASE MyDB2;
	END

-- DROP DATABASE koko1 -- اذا قمت بازالة ال فاصلة المنقوطة بعد اسم الداتابيس سينحل الايرور ! شي غريب


----------------- Lesson 1 of creating DB (also if it isn't exist constaint)
-- The "--" is used for comments

--a
--b
--c

--create database koko;

IF NOT EXISTS(SELECT * FROM sys.databases WHERE name='koko5')
	BEGIN
		CREATE DATABASE koko5;
	END


SELECT * FROM sys.databases WHERE name='koko5';
SELECT * FROM sys.databases;
SELECT * FROM sys.databases WHERE name='koko';



---------------- Switching DB (All Commands will be executed on the selected DB !) 

USE AhmadFirstDataBase;		-- Any new Query will be executed on AhmadFirstDataBase DB
-- It is better to use the Scripting for USING or switch DBs because احتمالية الخطأ أقل
select * from sys.databases;




--		SQL CREATE TABLE Statement

CREATE TABLE People (
	ID INT NOT NULL,
	Name NVARCHAR(50) NOT NULL,
	PhoneNumber NVARCHAR(10) NULL,
	Address NVARCHAR(100) NULL,
	PRIMARY KEY (ID)
);



-------------------- SQL DROP TABLE Statement
USE AhmadFirstDataBase;

CREATE TABLE Employees (
	ID INT NOT NULL,
	Salary SMALLMONEY NOT NULL,
	OfficeNumber NVARCHAR(20) NULL,
	Age datetime2 NULL,
	PRIMARY KEY (ID)
);

--Script to Drop Table If It Exists
IF EXISTS(
			SELECT * 
			FROM  INFORMATION_SCHEMA.TABLES 
			WHERE TABLE_NAME = 'Employees') 
BEGIN
		drop table Employees;
END



IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Employees')
BEGIN
    CREATE TABLE TempEmployee (
        ID INT NOT NULL,
        Name NVARCHAR(100) NOT NULL,
        Salary SMALLMONEY NOT NULL,
        Phone NVARCHAR(20) NULL,
        PRIMARY KEY (ID)
    );
END



--✅ Add Schema (Recommended)
--Always specify the schema (e.g., dbo) to avoid ambiguity or runtime errors in databases with multiple schemas.
IF EXISTS (
    SELECT * FROM sys.tables 
    WHERE name = 'Employees' AND schema_id = SCHEMA_ID('dbo')
)
BEGIN
    DROP TABLE dbo.Employees;
END


-------------- (Alter Table) Add Column in a Table
ALTER TABLE dbo.Employees
ADD Warnings int;			-- Can be null .. by default


ALTER TABLE dbo.People
ADD Gendor char(1) NOT NULL;



------------- Rename Column in a Table (Most Databases)

------------ This works in many databases; but unfortunately in SQL Server it doesn't ...
--ALTER TABLE dbo.People
--RENAME COLUMN Gendor to Gender

-- -- Working Approach in SQL Server: 
-- sp stands for Stored Procedure ! 
EXEC sp_rename 'dbo.People.Gendor', 'Gender', 'COLUMN';
USE AhmadFirstDataBase;
GO


SELECT TABLE_SCHEMA, COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'People';

USE AhmadFirstDataBase;
GO

EXEC sp_rename 'dbo.People.Gender', 'Sex', 'COLUMN';

ALTER TABLE dbo.People
DROP COLUMN [dbo.People.Gender];

ALTER TABLE dbo.People
ADD Gender CHAR(1) NOT NULL;

EXEC sp_rename 'People.Gender', 'Sex', "Column";



---------- Rename a Table (Most Databases)

CREATE TABLE EMPSS
(
	ID INT NOT NULL,
	Name VARCHAR(30)
);


-- This works in many databases; but unfortunately in SQL Server it doesn't ... you should use Stored Procedures...
--ALTER TABLE EMPSS
--RENAME TO Employees2


exec sp_rename 'EMPSS', 'EMPLOYEES2';





----------- Modify Column in a Table

CREATE TABLE NewTempTableForColsModification (
	Hi INT NOT NULL,
	Bye NVARCHAR(50) NOT NULL,
	Die NVARCHAR(10) NULL,
	HAIHAI NVARCHAR(100) NULL,
	PRIMARY KEY (HI)
);

ALTER TABLE NewTempTableForColsModification
ALTER COLUMN Hi NVARCHAR(100) NOT NULL;



------ 🔸 This works because SQL Server will auto-generate a name like PK__NewTempTable__....
ALTER TABLE NewTempTableForColsModification
ADD PRIMARY KEY (Hi);


---- Complete way to add Primary key :
ALTER TABLE NewTempTableForColsModification
ALTER COLUMN HAIHAI NVARCHAR(100) NOT NULL;

ALTER TABLE NewTempTableForColsModification
ADD CONSTRAINT PK_NewTempTable PRIMARY KEY (HAIHAI);

--- OR USE:

ALTER TABLE NewTempTableForColsModification
ADD CONSTRAINT PK_NewTempTable PRIMARY KEY (HAIHAI, HI);



--------------- Delete Column in a Table

ALTER TABLE dbo.NewTempTableForColsModification
DROP COLUMN Bye;



----------  SQL BACKUP DATABASE Statement

BACKUP DATABASE AhmadFirstDataBase
TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\BACKUP_BY_SCRIPT.bak';


-----	SQL DIFFERENTIAL BACKUP DATABASE Statement

BACKUP DATABASE AhmadFirstDataBase
TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\BACKUP_BY_SCRIPT.bak'
WITH DIFFERENTIAL;



ALTER DATABASE AhmadFirstDataBase SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
------ Restore Database From Backup
USE master;
GO
RESTORE DATABASE AhmadFirstDataBase
FROM DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\BACKUP_BY_SCRIPT.bak';


-------------------------------------------------------------	Data Manipulation Language - DML

-- INSERT INTO Statement
USE AhmadFirstDataBase;

select * from People;

INSERT INTO People
values
(1, 'Ahmad Hirzallah', '0792001744', 'Amman/Jordan', 'M');


INSERT INTO People
values
(2, 'Abood Hirzallah', '0793248824', 'Amman/Jordan', 'M');



INSERT INTO People
VALUES
	(3, 'ALIA JAREER', '0771238222', 'ZARQA/Jordan', 'F'),
	(4, 'LEENA JAREER', '0781978883', 'IRBID/Jordan', 'F'),
	(5, 'SAMI JARRAH', '077723111', 'Aqaba/Jordan', 'F');



--      	     both not null    null     not null
INSERT INTO People (Sex, ID,     Address,    Name)
VALUES	('M', 6, 'Jaban/Fizita', 'Kakaroto');




--      	     both not null    null     not null
INSERT INTO People (Sex, ID,     Address,    Name)
VALUES	('M', 6, 'Jaban/Fizita', 'Kakaroto');



--      	     all not null
INSERT INTO People (Sex, ID, Name)
VALUES	('F', 7, 'Lura Jesse');



--   Error: Cannot insert the value NULL into column 'Name',, column does not allow nulls. INSERT fails.
INSERT INTO People (Sex, ID)
VALUES	('F', 8);


--      	     both not null    null     not null
INSERT INTO People (Sex, ID,     Address,    Name)
VALUES	('M', 9, null, 'Frezar');



INSERT INTO People
VALUES (10, 'Yousuf Omar', NULL, 'Irbid/Jordan', 'M');



---------		UPDATE Statement
USE  AhmadFirstDataBase;

select * from People;

UPDATE People
SET Name = 'AHMAD OMAR IBRHAHIM HIRZALLAH'
WHERE ID = 1;


-- !!!!!!!!!!!!! IF YOU DONE THE BELOW SCRIPT

UPDATE People				-- DON'T USE THIS !!!!!!!!!!!!!!!!!
SET Name = 'AHMAD OMAR IBRHAHIM HIRZALLAH'
-- !!!!!!!!!!!!!! ALL THE NAMES WILL BE REPLACED With the new Name ! SO DATA WILL BE CORRUPTED !!!

----- YOU SHOULD BE VERY CARFUL WHEN U USE ( UPDATE or DELETE )

UPDATE People
SET NAME = 'LINA NIDAL HAJJAR' , Address = 'Riyad/Saudia Arabia'
WHERE ID = 4 AND SEX = 'F';

------

INSERT INTO People
VALUES (1, 'Yousuf Omar', NULL, 'Irbid/Jordan', 'M');

INSERT INTO dbo.Employees
VALUES 
		(2, 'Ali Abu Gazleh', '079213214', 200.8, 'Organges', 4),
		(3, 'Mahmoud Zeko', '07123142', 100.67, 'Apples', 5),
		(4, 'Yousuf Omar', '0771241114', 700.3, 'Kiwi', 6),
		(5, 'Ahmad Hirzallah', '0792001744', 350.3, 'Bananas', 1);


select * from dbo.Employees;


UPDATE Employees
SET  Salary = Salary + 70.70
WHERE Salary < 500;


-- DELETE FROM Employees;

UPDATE Employees
SET  Salary = Salary * 1.1
WHERE Salary < 850;

select * from dbo.Employees;

---- Note: Be careful when updating records in a table! Notice the WHERE clause in the UPDATE statement. The WHERE clause specifies which record(s) that should be updated. If you omit the WHERE clause, all records in the table will be updated!





-------------------------------------------- DELETE Statement

-- It is very dangerous to use DELETE like the using of UPDATE statements



INSERT INTO dbo.Employees
VALUES 
		(6, 'Alia Abu Gazleh', '901238132', 555.8, 'Bananas', 3),
		(7, 'Selena Zeko', '07623472', 400.67, 'Carrots', 2);


INSERT INTO dbo.Employees
VALUES 
		(8, 'Salama FGajsd', '0656372', NULL, 'Bananas', 3),
		(9, 'Ameera khajsad', '065723742', NULL, 'Carrots', 2);

DELETE FROM Employees
WHERE Salary IS NULL;


DELETE FROM Employees
WHERE ID = 4;


select * from Employees;


---- If no record or row or entity is exist ; no error will appears
DELETE FROM Employees
WHERE ID = 999;


DELETE FROM Employees
WHERE Salary <= 600;



----------------- SELECT INTO Statement
-- In SQL, we can copy data from one database table to a new table using the SELECT INTO command. For example,
--		Note: The SELECT INTO statement creates a new table.
--			If the database already has a table with the same name, SELECT INTO gives an error.
-- If we want to copy data to an existing table (rather than creating a new table), we should use the INSERT INTO SELECT statement.


SELECT * 
INTO EmployeesTempBySelectInto
FROM Employees;

SELECT * 
FROM EmployeesTempBySelectInto;



SELECT ID, Name, Salary
INTO EmployeesTempBySelectInto_2
FROM EmployeesTempBySelectInto;

SELECT * 
FROM EmployeesTempBySelectInto_2;



---- Trick to create table with all Data Fields/Columns/Attributes BUT WITH NO ANY RECORD/ROW/ENTITY !!!
SELECT *
INTO EmployeesTempBySelectInto_3
FROM EmployeesTempBySelectInto
WHERE 5=7;

SELECT * 
FROM EmployeesTempBySelectInto_3;





SELECT * 
FROM EmployeesTempBySelectInto;

SELECT *
INTO EmployeesTempBySelectInto_4
FROM EmployeesTempBySelectInto
WHERE Salary > 600;

SELECT * 
FROM EmployeesTempBySelectInto_4;





SELECT * 
FROM EmployeesTempBySelectInto;

SELECT *
INTO EmployeesTempBySelectInto_5
FROM EmployeesTempBySelectInto
WHERE Warnings < 3;

SELECT * 
FROM EmployeesTempBySelectInto_5;










--------------------------		INSERT INTO SELECT Statement


--Copy all columns from one table to another table:

--INSERT INTO table2
--SELECT * FROM table1
--WHERE condition;

--Copy only some columns from one table into another table:

--INSERT INTO table2 (column1, column2, column3, ...)
--SELECT column1, column2, column3, ...
--FROM table1
--WHERE condition;


SELECT *
FROM People;

SELECT *
INTO PeopleTemp
FROM People
WHERE 5=7;


SELECT *
FROM PeopleTemp;

INSERT INTO PeopleTemp
	SELECT *
	FROM People;

SELECT *
FROM People
WHERE ID >= 5;


INSERT INTO PeopleTemp
	SELECT *
	FROM People
	WHERE ID >= 5;



-- IF TABLE DOESN'T EXIST;; ERROR :

--INSERT INTO PeopleTemp_1
--	SELECT *
--	FROM People
--	WHERE ID >= 5;










-------------------------------------	Identity Field (Auto Increment)


--AUTO INCREMENT Field
--Auto-increment allows a unique number to be generated automatically when a new record is inserted into a table.

--Often this is the primary key field that we would like to be created automatically every time a new record is inserted.


SELECT * FROM Departments


----------------	You can't Insert  Identity Column 
--INSERT INTO Departments
--VALUES (6, 'Arts');



-- Works 100%

INSERT INTO Departments
VALUES ('Arts');


UPDATE Departments
SET  Name = 'Computer Engeneering'
WHERE Name = 'ComputerEngeneering';

SELECT * FROM Departments

UPDATE Departments
SET  Name = 'Computer Science'
WHERE Name = 'ComputerScience';




INSERT INTO Departments
VALUES ('Accountant 1'); 

INSERT INTO Departments
VALUES ('Accountant 2'); 

INSERT INTO Departments
VALUES ('Accountant 3'); 

SELECT * FROM Departments

print @@identity


---			Adding Identity Attribute using SQL Scripts:

--	Auto-increment allows a unique number to be generated automatically when a new record is inserted into a table.

--	Often this is the primary key field that we would like to be created automatically every time a new record is inserted.

CREATE TABLE Offices 
(	
	ID INT IDENTITY(1,1) NOT NULL,  -- The starting value for IDENTITY is 1, and it will increment by 1 for each new record.
	Name NVARCHAR(50) NOT NULL,
	PRIMARY KEY(ID)
);

--		If it should start at value 10 and increment by 5, change it to IDENTITY(10,5).

INSERT INTO Offices
VALUES ('Administrator');

SELECT * FROM Offices;


INSERT INTO Offices
VALUES ('Dr. Ali');

INSERT INTO Offices
VALUES ('Pr. Omar');

SELECT * FROM Offices;




--------------------------			Delete vs Truncate statement


SELECT *
INTO TempOfficesTable
FROM Offices;

SELECT *
FROM Offices;

SELECT *
FROM TempOfficesTable;

INSERT INTO TempOfficesTable
VALUES ('Pr. Naji');

DELETE FROM TempOfficesTable;		-- Delete All Rows & (NOT) Reseting Identity Index

INSERT INTO TempOfficesTable
VALUES ('Pr. Naji');

INSERT INTO TempOfficesTable
VALUES ('Dr. Ali');

INSERT INTO TempOfficesTable
VALUES ('Pr. Omar');

print @@IDENTITY		-- Last Reached Identity (Last Inserted/Exist Record Identity ID) will be Printed


SELECT *
FROM TempOfficesTable;		-- Identity will continue and insertion will be from last index reached by Identity...



TRUNCATE TABLE TempOfficesTable;	-- Delete All Rows & Reset Identity Index

INSERT INTO TempOfficesTable
VALUES ('Pr. Naji');

INSERT INTO TempOfficesTable
VALUES ('Dr. Ali');

INSERT INTO TempOfficesTable
VALUES ('Pr. Omar');

SELECT *
FROM TempOfficesTable;		-- Identity will be restarted and insertion will be from 1'st index defined in identity !...


print @@IDENTITY		-- Last Reached Identity (Last Inserted/Exist Record Identity ID) will be Printed





-------------------------		SQL FOREIGN KEY Constraint

--	In SQL, we can create a relationship between two tables using the FOREIGN KEY constraint.


-- First table; it shouldn't have any foreign key (FK) Because it is First Table!

USE AhmadFirstDataBase;

CREATE TABLE Customers 
(
	ID				INT,
	FirstName		VARCHAR(40),
	LastName		VARCHAR(40),
	Age				INT,
	Country			VARCHAR(40),

	PRIMARY KEY(ID)
);


CREATE TABLE Orders 
(
	ID				INT IDENTITY(1,1) NOT NULL,
	Item			VARCHAR(40),
	Amount			INT,
	CustomerID		INT REFERENCES Customers(ID),

	PRIMARY KEY(ID)
);


CREATE TABLE Items 
(
	ID				INT IDENTITY(1,1) NOT NULL,
	Name			VARCHAR(40),
	Price			INT,
	OrderID			INT

	PRIMARY KEY(ID)
);


-- Using Alter

ALTER TABLE Items
ADD FOREIGN KEY(OrderID) REFERENCES Orders(ID);

SELECT Items.ID, Orders.ID AS Expr1
FROM   Orders INNER JOIN
             Items ON Orders.ID = Items.OrderID


---- You can use mouse : right click + Press on (Design Query in Editor...) or (CTRL + SHIFT + Q)

SELECT Customers.FirstName, Customers.LastName, Orders.Item, Orders.Amount, Orders.CustomerID, Customers.ID
FROM   Customers INNER JOIN
             Orders ON Customers.ID = Orders.CustomerID;






------------------------------------- DQL : Data Query Language.


--- Dropping olded not used DBs

USE master;

IF EXISTS(SELECT * FROM sys.databases WHERE name='MyDB1')
	BEGIN
		ALTER DATABASE MyDB1 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
		DROP DATABASE MyDB1;
	END
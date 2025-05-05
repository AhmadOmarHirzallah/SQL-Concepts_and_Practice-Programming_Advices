# SQL-Concepts_and_Practice-Programming_Advices

## Part 1
<details>
<summary>Show SQL code</summary>

```sql
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

```

</details>



## Part 2
<details>
<summary>Show SQL code</summary>

```sql



RESTORE DATABASE HR_Database
FROM DISK = 'E:\1-ProgrammingAdvices\DB-Courses\DB-Course-15\Database-DataSamples\HR_Database.bak'

USE HR_Database EXEC sp_changedbowner 'sa'




----------------------------- DQL -- Data Query Language :  استعلام البيانات
USE HR_Database;

SELECT * FROM Employees;


SELECT * FROM Departments;


SELECT * FROM Countries;




SELECT * FROM Employees;
SELECT Employees.* FROM Employees;


SELECT ID, FirstName, LastName FROM Employees;


SELECT ID, FirstName, LastName, MonthlySalary FROM Employees;


SELECT ID, FirstName, DateOfBirth FROM Employees;






---------------------------			  Select Distinct Statement

SELECT Employees.DepartmentID FROM Employees;		-- Many repetion of the Department ID that are used by Employees Table Data...

SELECT DISTINCT Employees.DepartmentID FROM Employees;


SELECT Employees.FirstName FROM Employees;
SELECT DISTINCT Employees.FirstName FROM Employees;



SELECT Employees.FirstName, Employees.DepartmentID FROM Employees;


-- DISTINCT WILL BE APPLIED IN ALL COLUMNS ! NOT JUST 1 BEFORE NAME ; ALL THE COLUMNS/ATTRIBUTES SEPARATED BY , , , WILL BE DISTINCTED....
-- DISTINCT WILL BE ON ENTITY-ROW-RECORD LEVEL ...
SELECT DISTINCT Employees.FirstName, Employees.DepartmentID FROM Employees;







------------------------------------		  Where Statement + AND , OR, NOT

-- شروط الفلترةة

USE HR_Database;
SELECT * FROM Employees;

-- Where
SELECT * FROM Employees
WHERE Employees.Gendor = 'f';

SELECT * FROM Employees
WHERE Employees.MonthlySalary <= 500;


SELECT * FROM Employees
WHERE Employees.MonthlySalary > 500;
-- Same as :
SELECT * FROM Employees
WHERE NOT Employees.MonthlySalary <= 500;


SELECT * FROM Employees
WHERE  (Employees.MonthlySalary <= 500) AND (Employees.Gendor='F');


SELECT Employees.* FROM Employees
WHERE Employees.CountryID = 1;


SELECT Employees.* FROM Employees
WHERE NOT (Employees.CountryID = 1)
ORDER BY(Employees.CountryID);

-- NOT IS SAME AS <>

SELECT Employees.* FROM Employees
WHERE  (Employees.CountryID <> 1)
ORDER BY(Employees.CountryID);

SELECT Employees.* FROM Employees
WHERE (Employees.DepartmentID = 1) AND (Employees.Gendor= 'M');

SELECT Employees.* FROM Employees
WHERE ((Employees.DepartmentID = 1) AND (Employees.Gendor= 'M'))
		OR ((Employees.DepartmentID = 2) AND (Employees.Gendor = 'F'))
ORDER BY (Employees.DepartmentID);


SELECT Employees.* FROM Employees
WHERE (Employees.DepartmentID = 1) OR (Employees.DepartmentID = 2);


SELECT * FROM Employees
WHERE Employees.ExitDate IS NULL;	-- DON'T USE (= NULL) -- USE (IS NULL)


SELECT * FROM Employees
WHERE NOT Employees.ExitDate IS NULL;	


SELECT * FROM Employees
WHERE Employees.ExitDate IS NOT NULL;	







------------------------		"In" Operator
-- The IN operator allows you to specify multiple values in a WHERE clause.
-- The IN operator is a shorthand for multiple OR conditions.


SELECT * FROM Employees
WHERE (Employees.DepartmentID = 1) OR (Employees.DepartmentID = 2) OR (Employees.DepartmentID = 7)
ORDER BY (Employees.DepartmentID);

SELECT * FROM Employees
WHERE (Employees.DepartmentID = 1) OR
		(Employees.DepartmentID = 2) OR	
		(Employees.DepartmentID = 5) OR
		(Employees.DepartmentID = 7)
ORDER BY (Employees.DepartmentID);

-- SET OF VALUES TO THE SAME ATTRIBUTE; CAN BE QUERED USING BETTER OPERATOR (IN) STATEMENT
-- IT CAN BE NUMBERS, STRINGS, DATES ... ETC 
-- SO (IN) is shortcut for (OR) for better comparision
SELECT * FROM Employees
WHERE (Employees.DepartmentID IN (1,2,5,7))
ORDER BY (Employees.DepartmentID)


SELECT * FROM Employees
WHERE Employees.FirstName IN ('Jacob', 'Brooks', 'Harper')
ORDER BY (Employees.FirstName);


-- USING MULTIPLE SELECT STATEMENTS (SELECT GIVE U A SET OF RECORDS; YOU CAN USE THEM FOR (IN))

SELECT (Departments.Name) FROM Departments
WHERE ID IN (
				SELECT Employees.DepartmentID FROM Employees
				WHERE (Employees.MonthlySalary <= 210)
			)
ORDER BY (Departments.Name);
	


SELECT (Departments.Name) FROM Departments
WHERE ID NOT IN (
				SELECT Employees.DepartmentID FROM Employees
				WHERE (Employees.MonthlySalary <= 210)
			)
ORDER BY (Departments.Name);

-- استخراج اسماء الموظفين حسب الدول
SELECT	(Employees.FirstName), (Employees.LastName) --, (CountryID)
FROM	Employees
WHERE Employees.CountryID IN 
		(
			SELECT	Countries.ID
			FROM	Countries
			WHERE	Countries.Name = 'USA'
		)
ORDER BY (FirstName) ASC, LastName DESC; 



------------------------		Sorting : Order By

-- The ORDER BY keyword is used to sort the result-set in ascending or descending order.

-- The ORDER BY keyword sorts the records in ascending order by default. To sort the records in descending order, use the DESC keyword.


SELECT Employees.ID, Employees.FirstName, Employees.MonthlySalary 
FROM Employees
WHERE Employees.DepartmentID = 1
ORDER BY (Employees.FirstName) ASC;

SELECT Employees.ID, Employees.FirstName, Employees.MonthlySalary 
FROM Employees
WHERE Employees.DepartmentID = 1
ORDER BY (Employees.MonthlySalary) ASC;


SELECT Employees.ID, Employees.FirstName, Employees.MonthlySalary 
FROM Employees
WHERE Employees.DepartmentID = 1
ORDER BY (Employees.FirstName) DESC;

SELECT Employees.ID, Employees.FirstName, Employees.MonthlySalary 
FROM Employees
WHERE Employees.DepartmentID = 1
ORDER BY (Employees.MonthlySalary) DESC;




-- MULTIPLE ORDERS BY CONTIDTIONS !
SELECT Employees.ID, Employees.FirstName, Employees.MonthlySalary 
FROM Employees
WHERE Employees.DepartmentID = 1
ORDER BY (Employees.FirstName) ASC ,(Employees.MonthlySalary) DESC;

SELECT Employees.ID, Employees.FirstName, Employees.MonthlySalary 
FROM Employees
WHERE Employees.DepartmentID = 1
ORDER BY (Employees.FirstName) ASC ,(Employees.MonthlySalary) ASC;



--- USING SPLITTING
SELECT		Employees.FirstName, '/', Employees.LastName , '/', 
			Employees.MonthlySalary, '/', Employees.DateOfBirth
FROM Employees
ORDER BY (Employees.MonthlySalary) DESC;


---- this one is tricky a little bit cuz the DESC here is for the younger in age and ASC is for the older
SELECT		firstname, monthlysalary  , DateOfBirth 
FROM		employees 
WHERE		DepartmentID = 1
ORDER BY	DateOfBirth;

SELECT		firstname, monthlysalary  , DateOfBirth 
FROM		employees 
WHERE		DepartmentID = 1
ORDER BY	DateOfBirth DESC;


SELECT		firstname, monthlysalary 
FROM		employees 
WHERE		DepartmentID = 1
ORDER BY	DateOfBirth;





-------------------------		The SQL SELECT TOP Clause

SELECT TOP 5	Employees.*
FROM			Employees;

SELECT TOP 10	Employees.*
FROM			Employees;

SELECT TOP 2	Employees.*
FROM			Employees;

SELECT TOP 10 PERCENT	Employees.*
FROM					Employees;


---- TRY TO FIND TOP 3 SALARIES BETWEEN ALL EMPLOYEES !

--SELECT TOP 3	Employees.FirstName, Employees.LastName
--FROM			Employees
--WHERE (Employees > MONTH)

SELECT Employees.MonthlySalary FROM Employees
ORDER BY MonthlySalary	DESC;

-- IN ABOVE SCRIPT SOME SALARIES COULD REPEATED ! WE WANT TOP 3 SALARIES IN VALUES SO TO FIX IT USE:
SELECT DISTINCT		Employees.MonthlySalary 
FROM				Employees
ORDER BY			MonthlySalary	DESC;



SELECT DISTINCT TOP 3		Employees.MonthlySalary 
FROM						Employees
ORDER BY					MonthlySalary	DESC;


-- ERRROR ; FALSE SYNTAX; USE DISTINCT BEFORE
--SELECT TOP 3 DISTINCT		Employees.MonthlySalary 
--FROM						Employees
--ORDER BY					MonthlySalary	DESC;

SELECT		Employees.ID, Employees.FirstName, Employees.LastName
FROM		Employees
WHERE		Employees.MonthlySalary IN
						(
							SELECT DISTINCT TOP 3	Employees.MonthlySalary
							FROM					Employees
							ORDER BY				MonthlySalary DESC
						)
ORDER BY MonthlySalary DESC;


-- (IF HE ASKED FOR ONLY 3 NAMES USE TOP 3 AGAIN AS BELOW)
-- THE RETURN VALUE COULD HAVE MORE THAN 3 PEOPLE RETURNED IF YOU DON'T USE THIS
SELECT TOP 3		Employees.ID, Employees.FirstName, Employees.LastName
FROM				Employees
WHERE				Employees.MonthlySalary IN
						(
							SELECT DISTINCT TOP 3	Employees.MonthlySalary
							FROM					Employees
							ORDER BY				MonthlySalary DESC
						)
ORDER BY MonthlySalary DESC;



-- للحصول على اقل 3 رواتب للموظفين : فقط 3 موظفين يذكرو

SELECT TOP 3		Employees.ID, Employees.FirstName, Employees.LastName
FROM				Employees
WHERE				Employees.MonthlySalary IN
						(
							SELECT DISTINCT TOP 3	Employees.MonthlySalary
							FROM					Employees
							ORDER BY				MonthlySalary ASC
						)
ORDER BY MonthlySalary ASC;



-- للحصول على اقل 3 رواتب للموظفين : اذكر اقل 3 رواتب لا عدد من الموظفين

SELECT				Employees.ID, Employees.FirstName, Employees.LastName
FROM				Employees
WHERE				Employees.MonthlySalary IN
						(
							SELECT DISTINCT TOP 3	Employees.MonthlySalary
							FROM					Employees
							ORDER BY				MonthlySalary ASC
						)
ORDER BY MonthlySalary ASC;




-------------------------		Select As

USE HR_Database;

SELECT A = 5 * 4 , B = 6 / 2;

SELECT 7 * 8 ,  20 / 2;

SELECT 7 * 8 ,  20 / 2
FROM Employees;



SELECT		A = 5 * 5	,	 B = 7 * 7
FROM		Employees;



SELECT		'The ID' = Employees.ID, 
			'The First Name' = Employees.FirstName,
			'Salary * 2' = Employees.MonthlySalary / 2
FROM		Employees


SELECT		Employees.ID,						-- To use space separated name use Single Qutations: 'full name' 
			Employees.FirstName + ' ' +Employees.LastName AS 'Full Name'
FROM		Employees;


SELECT		Employees.ID, 
			Employees.FirstName + ' ' +Employees.LastName AS FullName
FROM		Employees;	


SELECT		ID,
			FullName = Employees.FirstName +  ' ' + Employees.LastName
FROM		Employees;


SELECT		ID,
			'Full Name' = Employees.FirstName +  ' ' + Employees.LastName
FROM		Employees;


SELECT		Employees.ID,
			Employees.FirstName + ' ' + Employees. LastName AS 'Full Name',
			Employees.MonthlySalary,
			'Yearly Salary' = Employees.MonthlySalary * 12
FROM		Employees;


SELECT		Employees.ID, 
			Employees.FirstName + ' ' + Employees. LastName AS 'Full Name',
			'Yearly Salary' = Employees.MonthlySalary * 12,
			Employees.BonusPerc,
			Employees.BonusPerc * Employees.MonthlySalary AS 'BONUS AMOUNT'
FROM		Employees
ORDER BY	'BONUS AMOUNT' DESC;



SELECT		Employees.ID, 
			Employees.FirstName + ' ' + Employees. LastName AS 'Full Name',
			DATEDIFF(YEAR, Employees.DateOfBirth, GETDATE()) AS 'Age (Years)'
FROM		Employees
ORDER BY	'Age (Years)' DESC;

SELECT		Employees.ID, 
			Employees.FirstName + ' ' + Employees. LastName AS 'Full Name',
			DATEDIFF(YEAR, Employees.DateOfBirth, GETDATE()) AS 'Age (Years)'
FROM		Employees
ORDER BY	'Age (Years)' ASC;


SELECT TODAY = GETDATE();






--------------------------			Between Operator

SELECT		* 
FROM		Employees
WHERE		Employees.MonthlySalary >= 500 AND
			Employees.MonthlySalary <= 1000
ORDER BY	MonthlySalary DESC;



SELECT		*
FROM		Employees
WHERE		Employees.MonthlySalary BETWEEN
			500 AND 1000
ORDER BY	MonthlySalary;


SELECT		*
FROM		Employees
WHERE		Employees.FirstName BETWEEN 'A' AND 'E'
ORDER BY	Employees.FirstName ASC;



SELECT		*
FROM		Employees
WHERE		Employees.HireDate BETWEEN '2022-01-01' AND '2023-01-01'
ORDER BY	Employees.HireDate ASC;







----------------------		 Count, Sum, Avg, Min, Max Functions

--	The COUNT() function returns the number of rows that matches a specified   criterion:معيار
--	The AVG() function returns the average value of a numeric column. 
--	The SUM() function returns the total sum of a numeric column. 
--	The SQL MIN() and MAX() Functions
--		The MAX() function returns the largest value of the selected column.
--		The MIN() function returns the smallest value of the selected column.



SELECT		'TOTAL COUNT' = COUNT(Employees.ID),
			'TOTAL SUM'	  = SUM(Employees.MonthlySalary),
			'AVERAGE IS'  = AVG(Employees.MonthlySalary),
			MIN(Employees.MonthlySalary) AS 'MINIMUM SALARY',
			MAX(Employees.MonthlySalary) AS 'MAXIMUM SALARY'
FROM		Employees;



SELECT		'TOTAL COUNT' = COUNT(Employees.ID),
			'TOTAL SUM'	  = SUM(Employees.MonthlySalary),
			'AVERAGE IS'  = AVG(Employees.MonthlySalary),
			MIN(Employees.MonthlySalary) AS 'MINIMUM SALARY',
			MAX(Employees.MonthlySalary) AS 'MAXIMUM SALARY'
FROM		Employees
WHERE		Employees.DepartmentID = 1;


SELECT		'TOTAL COUNT' = COUNT(Employees.ID),
			'TOTAL SUM'	  = SUM(Employees.MonthlySalary),
			'AVERAGE IS'  = AVG(Employees.MonthlySalary),
			MIN(Employees.MonthlySalary) AS 'MINIMUM SALARY',
			MAX(Employees.MonthlySalary) AS 'MAXIMUM SALARY'
FROM		Employees
WHERE		CountryID IN
						(
							SELECT Countries.ID FROM Countries 
							WHERE Countries.Name = 'USA'
						);


SELECT	COUNT(Employees.ID)  AS 'COUNT OF EMPLOYEES'
FROM	Employees;				-- NO NULL IS COUNTED !! ID IS NOT NULLABLE

SELECT	COUNT(Employees.ExitDate) AS 'COUNT OF RETIERED EMPLOYEES'
FROM	Employees;








---------------------------			The SQL GROUP BY Statement


SELECT		'TOTAL COUNT' = COUNT(Employees.ID),
			'TOTAL SUM'	  = SUM(Employees.MonthlySalary),
			'AVERAGE IS'  = AVG(Employees.MonthlySalary),
			MIN(Employees.MonthlySalary) AS 'MINIMUM SALARY',
			MAX(Employees.MonthlySalary) AS 'MAXIMUM SALARY'
FROM		Employees;




---- Error you can add aggregate functions with random attribute ! only with GROUP BY it will works !
SELECT		Employees.DepartmentID,
			'TOTAL COUNT' = COUNT(Employees.ID),
			'TOTAL SUM'	  = SUM(Employees.MonthlySalary),
			'AVERAGE IS'  = AVG(Employees.MonthlySalary),
			MIN(Employees.MonthlySalary) AS 'MINIMUM SALARY',
			MAX(Employees.MonthlySalary) AS 'MAXIMUM SALARY'
FROM		Employees
ORDER BY	DepartmentID;



SELECT		Employees.DepartmentID,
			'TOTAL COUNT' = COUNT(Employees.ID),
			'TOTAL SUM'	  = SUM(Employees.MonthlySalary),
			'AVERAGE IS'  = AVG(Employees.MonthlySalary),
			MIN(Employees.MonthlySalary) AS 'MINIMUM SALARY',
			MAX(Employees.MonthlySalary) AS 'MAXIMUM SALARY'
FROM		Employees
GROUP BY	DepartmentID
ORDER BY	DepartmentID;




-----	1-Write a query to count the number of employees hired in each year.
SELECT		YEAR(Employees.HireDate) AS [HIRE YEAR],
			COUNT(*) AS [NUMBER OF EMPLOYEES]
FROM		Employees
GROUP BY	YEAR(Employees.HireDate)
ORDER BY	YEAR(Employees.HireDate);



-----	2-Write a query to count the number of employees who have the same job title.
SELECT	
		(
			SELECT	D.Name
			FROM	Departments D
			WHERE	D.ID = E.DepartmentID
		)		AS [Department Name]
		, COUNT(*) AS [COUNT THE EMPLOYEES]
FROM Employees E
GROUP BY E.DepartmentID;


--	3-Write a query to calculate the average salary of employees hired after 2018, grouped by department.
SELECT		(
				SELECT D.Name
				FROM Departments D
				WHERE D.ID = E.DepartmentID
			)	 AS [DepartmentName]
			, AVG(E.MonthlySalary) AS [AVERAGE SALARY]
FROM		Employees E
WHERE		(YEAR(E.HireDate) > 2018)
GROUP BY	E.DepartmentID;





--	4-Write a query to count the employees in each department who earn more than 2000.

SELECT		(
				SELECT		D.Name
				FROM		Departments D
				WHERE		D.ID = E.DepartmentID
			)	AS [Department Name]
			, COUNT(*) AS [Employees Count WITH SALARY > 2000]
FROM		Employees E
WHERE		E.MonthlySalary > 2000
GROUP BY	E.DepartmentID;



--	5-Write a query that returns both the highest and lowest salaries for each department.
SELECT
			(
				SELECT	D.Name
				FROM	Departments D
				WHERE	D.ID = E.DepartmentID
			)	AS [Department Name]	,
			MAX(E.MonthlySalary) AS [HIGHEST SALARY],
			MIN(E.MonthlySalary) AS [LOWEST SALARY]
FROM		Employees E
GROUP BY	E.DepartmentID;



----------		The SQL HAVING Clause
--	The HAVING clause was added to SQL because the WHERE keyword cannot be used with aggregate functions in a direct way
--	For Filtering Result of Group By !

USE HR_Database;

SELECT		E.DepartmentID,
			'TOTAL COUNT' = COUNT(E.ID),
			'TOTAL SUM'	  = SUM(E.MonthlySalary),
			'AVERAGE IS'  = AVG(E.MonthlySalary),
			MIN(E.MonthlySalary) AS 'MINIMUM SALARY',
			MAX(E.MonthlySalary) AS 'MAXIMUM SALARY'
FROM		Employees E
GROUP BY	DepartmentID
ORDER BY	DepartmentID;
-- WHERE COUNT(E.MonthlySalary) > 100 !! ERROR


SELECT		E.DepartmentID,
			'TOTAL COUNT' = COUNT(E.ID),
			'TOTAL SUM'	  = SUM(E.MonthlySalary),
			'AVERAGE IS'  = AVG(E.MonthlySalary),
			MIN(E.MonthlySalary) AS 'MINIMUM SALARY',
			MAX(E.MonthlySalary) AS 'MAXIMUM SALARY'
FROM		Employees E
GROUP BY	DepartmentID
HAVING		COUNT(E.MonthlySalary) > 100
ORDER BY	DepartmentID





SELECT * FROM
	(
		SELECT		E.DepartmentID,
					'TOTAL COUNT' = COUNT(E.ID),
					'TOTAL SUM'	  = SUM(E.MonthlySalary),
					'AVERAGE IS'  = AVG(E.MonthlySalary),
					MIN(E.MonthlySalary) AS 'MINIMUM SALARY',
					MAX(E.MonthlySalary) AS 'MAXIMUM SALARY'
		FROM		Employees E
		GROUP BY	DepartmentID
	) AS RES
WHERE RES.[TOTAL COUNT] > 100; 







-------------		The SQL LIKE Operator

SELECT		E.ID, E.FirstName
FROM		Employees E
WHERE		E.FirstName LIKE 'a%';


SELECT		E.ID, E.FirstName
FROM		Employees E
WHERE		E.FirstName LIKE '%A'


SELECT		E.ID, E.FirstName
FROM		Employees E
WHERE		E.FirstName LIKE '%TELL%';


SELECT		E.ID, E.FirstName
FROM		Employees E
WHERE		E.FirstName LIKE 'A%A';


SELECT		E.ID, E.FirstName
FROM		Employees E
WHERE		E.FirstName LIKE '_A%'

SELECT		E.ID, E.FirstName
FROM		Employees E
WHERE		E.FirstName LIKE '_A'

SELECT		E.ID, E.FirstName
FROM		Employees E
WHERE		E.FirstName LIKE '__A%'

SELECT		E.ID, E.FirstName
FROM		Employees E
WHERE		E.FirstName LIKE '__A'

SELECT		E.ID, E.FirstName
FROM		Employees E
WHERE		E.FirstName LIKE 'A__'

SELECT		E.ID, E.FirstName
FROM		Employees E
WHERE		E.FirstName LIKE 'A__%'


SELECT		E.ID, E.FirstName
FROM		Employees E
WHERE		E.FirstName LIKE 'A___%'

SELECT		E.ID, E.FirstName
FROM		Employees E
WHERE		E.FirstName LIKE 'A_%' OR
			E.FirstName LIKE 'B_%';






----------------		WildCards

SELECT * FROM Employees 
ORDER BY Employees.ID DESC;

INSERT INTO Employees (
						FirstName,	LastName,	Gendor,
						DateOfBirth,	CountryID,
						DepartmentID,	HireDate,	ExitDate,
						MonthlySalary,	BonusPerc
					   )
VALUES
(
 'Mohammad', 'Ali', 'M', '1990-01-01',
 1, 1, '2023-05-01', NULL, 1200.00, 0.05
);





SELECT * FROM Employees 
ORDER BY Employees.ID DESC;





INSERT INTO Employees
(
			FirstName,	LastName,	Gendor,
			DateOfBirth,	CountryID,
			DepartmentID,	HireDate,	ExitDate,
			MonthlySalary,	BonusPerc
)
VALUES
('Mohammed', 'Abu Hadhoud', 'M', '1991-06-15',
 1, 2, '2024-01-10', NULL, 1350.00, 0.1);




 SELECT * FROM Employees 
ORDER BY Employees.ID DESC;

---- How to search for these inserted 2 records

SELECT		E.ID, E.FirstName,
			E.LastName
FROM		Employees E
WHERE		E.FirstName = 'Mohammad' OR E.FirstName = 'Mohammed';



SELECT		E.ID, E.FirstName,
			E.LastName
FROM		Employees E
WHERE		E.FirstName LIKE 'MOHAMM[EAI]D';



SELECT		E.ID, E.FirstName,
			E.LastName
FROM		Employees E
WHERE		E.FirstName NOT LIKE 'MOHAMM[EAI]D';




select ID, FirstName, LastName from Employees
Where firstName like 'a%' or firstName like 'b%' or firstName like 'c%';


SELECT		E.ID, E.FirstName,
			E.LastName
FROM		Employees E
WHERE		E.FirstName  LIKE '[abc]%';




-- search for all employees that their first name start with any letter from a to e

SELECT		E.ID, E.FirstName,
			E.LastName
FROM		Employees E
WHERE		E.FirstName  LIKE '[a-e]%'
ORDER BY	E.FirstName;





---------------------						(Inner) Join

-- Use (JOIN) Statement if you want the (SELECT) to be executed on multiple tables.
USE MASTER;
RESTORE DATABASE Shop_Database
FROM DISK = 'E:\1-ProgrammingAdvices\DB-Courses\DB-Course-15\Database-DataSamples\Shop_Database.bak';
USE Shop_Database EXEC sp_changedbowner 'sa'


USE Shop_Database;

SELECT * FROM Customers;

SELECT * FROM Orders;

SELECT C.CustomerID, C.Name, O.Amount
FROM Customers C INNER JOIN 
						Orders O ON C.CustomerID = O.CustomerID;


SELECT C.CustomerID, C.Name , O.Amount
FROM Customers C JOIN 
					Orders O ON C.CustomerID = O.CustomerID;

SELECT C.CustomerID, C.Name , O.Amount
FROM Customers C JOIN 
					Orders O ON C.CustomerID = O.CustomerID
ORDER BY O.Amount DESC;



----

USE HR_Database;

SELECT Employees.ID, Employees.FirstName, Employees.LastName, Departments.Name AS [Department Name]
FROM   Employees INNER JOIN
             Departments ON Employees.DepartmentID = Departments.ID
ORDER BY Employees.ID DESC;


SELECT Employees.ID, Employees.FirstName, Employees.LastName, Departments.Name AS [Department Name]
FROM   Employees INNER JOIN
             Departments ON Employees.DepartmentID = Departments.ID
WHERE Departments.Name = 'IT'
ORDER BY Employees.ID DESC


SELECT Employees.ID, Employees.FirstName, Employees.LastName, Departments.Name AS [Department Name]
FROM   Employees INNER JOIN
             Departments ON Employees.DepartmentID = Departments.ID
WHERE Departments.Name = 'HR'
ORDER BY Employees.ID DESC



-- USING 3 INNER JOINS

SELECT			Employees.ID, Employees.FirstName, Employees.LastName, Departments.Name AS [Department Name], Countries.Name AS [Country Name]
FROM			Employees 
	INNER JOIN		Departments ON  Departments.ID = Employees.DepartmentID 
	INNER JOIN      Countries ON Countries.ID = Employees.CountryID;


SELECT Employees.ID, Employees.FirstName, Departments.Name AS [DepartmentName], Countries.Name AS [CountryName]
FROM   Countries INNER JOIN
             Employees ON Countries.ID = Employees.CountryID INNER JOIN
             Departments ON Employees.DepartmentID = Departments.ID




------------------------			SQL LEFT JOIN Keyword

-- [LEFT JOIN] is same as [LEFT OUTER JOIN] ---- As ----- [INNER JOIN] = [JOIN]

USE  Shop_Database;

SELECT Customers.CustomerID, Customers.Name, Orders.Amount
FROM   Customers INNER JOIN
             Orders ON Customers.CustomerID = Orders.CustomerID

SELECT Customers.CustomerID, Customers.Name, Orders.Amount
FROM   Customers LEFT OUTER JOIN
             Orders ON Customers.CustomerID = Orders.CustomerID

SELECT Customers.CustomerID, Customers.Name, Orders.Amount
FROM   Customers LEFT JOIN
             Orders ON Customers.CustomerID = Orders.CustomerID





-----------------------------------					  Right (Outer) Join + Full (Outer) Join

USE Shop_Database;

SELECT Customers.CustomerID, Customers.Name, Orders.Amount
FROM   Customers INNER JOIN
             Orders ON Customers.CustomerID = Orders.CustomerID



SELECT Customers.CustomerID, Customers.Name, Orders.Amount
FROM   Customers LEFT OUTER JOIN
             Orders ON Customers.CustomerID = Orders.CustomerID


SELECT  Orders.OrderID, Orders.Amount, Customers.CustomerID, Customers.Name
FROM   Customers RIGHT OUTER JOIN
             Orders ON Customers.CustomerID = Orders.CustomerID

SELECT		Customers.CustomerID, Customers.Name, Orders.OrderID, Orders.Amount
FROM		Customers FULL OUTER JOIN
            Orders ON Customers.CustomerID = Orders.CustomerID





------------------------		Views

USE HR_Database;

-- ACTIVE EMPLOYEES ; NOT RETIERED
SELECT	*
FROM	Employees E
WHERE	E.ExitDate IS NULL;

SELECT	*
FROM	Employees E
WHERE	NOT E.ExitDate IS NULL;

SELECT	*
FROM	Employees E
WHERE	E.ExitDate IS NOT NULL;

USE HR_Database;
GO
-- For recalling the script again and again we Create VIEW :
GO
CREATE VIEW ActiveEmployees AS
SELECT *
FROM dbo.Employees AS E
WHERE E.ExitDate IS NULL;

GO
CREATE VIEW KickedEmployees AS
SELECT *
FROM dbo.Employees AS E
WHERE E.ExitDate IS NOT NULL;




SELECT *
FROM dbo.Employees AS E
WHERE E.ExitDate IS NULL;
-- this is same as : 
SELECT		*
FROM		ActiveEmployees;



SELECT		*
FROM		KickedEmployees;
-- this is same as : 
SELECT *
FROM dbo.Employees AS E
WHERE E.ExitDate IS NOT NULL;



DROP VIEW ActiveEmployees; 



CREATE VIEW ShortDetailedEmployees AS
	SELECT		E.ID,
				E.FirstName + ' ' + E.LastName AS FullName,
				E.Gendor
	FROM		Employees E;


SELECT * FROM ShortDetailedEmployees;






-------------------------------				The SQL EXISTS Operator

USE Shop_Database;

SELECT	'Yes' as X
WHERE	EXISTS
(
	SELECT * FROM Orders O
	WHERE O.CustomerID = 3 AND O.Amount > 300
)



SELECT	'Yes' as X
WHERE	EXISTS
(
	SELECT * FROM Orders O
	WHERE O.CustomerID = 3 AND O.Amount > 600
)


SELECT * FROM Customers C
WHERE EXISTS
(
	SELECT * FROM ORDERS O
	WHERE O.CustomerID = C.CustomerID AND O.Amount < 600
);


SELECT * 
FROM Customers C
WHERE EXISTS (
    SELECT 1 
    FROM Orders O
    WHERE O.CustomerID = C.CustomerID 
      AND O.Amount < 600
);

SELECT		*
FROM		Customers C1
WHERE		EXISTS
(
	SELECT TOP 1 1 FROM Orders O
	WHERE C1.CustomerID = O.CustomerID AND Amount < 600
);

-- same as:

SELECT		*
FROM		Customers C1
WHERE		EXISTS
(
	SELECT TOP 1 R='Y' FROM Orders O
	WHERE C1.CustomerID = O.CustomerID AND Amount < 600
);






---------------------------------------			Union

USE HR_Database;

SELECT * FROM ActiveEmployees;

SELECT * FROM KickedEmployees;

-- RATHER THAN EXECUTING BOTH;; USE :

SELECT * FROM ActiveEmployees
UNION
SELECT * FROM KickedEmployees;



SELECT * FROM Departments;


-- ONLY DISTINCT IS RETURNED
SELECT * FROM Departments
UNION
SELECT * FROM Departments;


SELECT * FROM Departments
UNION ALL
SELECT * FROM Departments;


SELECT * FROM Departments
UNION ALL
SELECT * FROM Departments
UNION ALL
SELECT * FROM Departments
UNION ALL
SELECT * FROM Departments;







-------------------------------					The SQL CASE Expression

USE HR_Database;

SELECT		E.ID,	E.FirstName + ' ' + E.LastName AS [Full Name], 
			(CASE 
					WHEN E.Gendor = 'M' THEN 'Male'
					WHEN E.Gendor = 'F' THEN 'Female'
					ELSE 'Unknown'
			END) AS [Gender Titled]
FROM		Employees E;


SELECT		E.ID, E.FirstName, E.LastName, [Gender Titled] = 
				CASE 
					WHEN	E.Gendor ='M' THEN 'Male'
					WHEN	E.Gendor = 'F' THEN 'Female'
					ELSE	'Unknown'
				END,
			[Status] = 
				CASE
					WHEN		E.ExitDate IS NULL		THEN 'Active/Working Employee'
					WHEN		E.ExitDate IS NOT NULL	THEN 'Resigned/Fired Employee'
					ELSE		'UNKNOWN'
				END
FROM		Employees E
ORDER BY E.ExitDate DESC;



SELECT		E.ID , E.FirstName + ' ' + E.LastName AS [Full Name],
			[Gender Titled] = 
				CASE 
					WHEN	E.Gendor ='M' THEN 'Male'
					WHEN	E.Gendor = 'F' THEN 'Female'
					ELSE	'Unknown'
				END,
			E.MonthlySalary, 
			[NEW SALARY] = 
					CASE
						WHEN E.Gendor = 'M' THEN E.MonthlySalary * 1.2
						WHEN E.Gendor = 'F' THEN E.MonthlySalary * 1.4
					END
FROM		Employees E
ORDER BY E.MonthlySalary;








----------------------------------				SQL PRIMARY KEY Constraint


USE AhmadFirstDataBase;

CREATE TABLE PK_ConstraintTableCreation
(
	ID				INT NOT NULL PRIMARY KEY,
	FirstName		NVARCHAR(255) NOT NULL,
	MiddleName		NVARCHAR(255),
	LastName		NVARCHAR(255) NOT NULL,
	Age				INT
);

--DROP TABLE PK_ConstraintTableCreationg;

--	To allow naming of a PRIMARY KEY constraint, and for defining a PRIMARY KEY constraint on multiple columns, use the following SQL syntax:
CREATE TABLE PK_ConstMultipleCols
(
	ID				INT NOT NULL ,
	FirstName		NVARCHAR(255) NOT NULL,
	MiddleName		NVARCHAR(255),
	LastName		NVARCHAR(255) NOT NULL,
	Age				INT

	CONSTRAINT PK_ConstMultipleColsNewTble PRIMARY KEY (ID, LastName)
);


CREATE TABLE PK_ByAlteringTable
(
	ID				INT NOT NULL ,
	FirstName		NVARCHAR(255) NOT NULL,
	MiddleName		NVARCHAR(255),
	LastName		NVARCHAR(255) NOT NULL,
	Age				INT

);

ALTER TABLE PK_ByAlteringTable
ADD PRIMARY KEY (ID);


CREATE TABLE PK_ByAlteringTable2
(
	ID				INT NOT NULL ,
	FirstName		NVARCHAR(255) NOT NULL,
	MiddleName		NVARCHAR(255),
	LastName		NVARCHAR(255) NOT NULL,
	Age				INT

);

ALTER TABLE PK_ByAlteringTable2
ADD CONSTRAINT PK_PK_ByAlteringTable2 PRIMARY KEY (ID, LastName);

ALTER TABLE PK_ByAlteringTable2
DROP CONSTRAINT PK_PK_ByAlteringTable2;

-- ERROR ; ATTRIBUTE CAN HAVE NULL
ALTER TABLE PK_ByAlteringTable2
ADD CONSTRAINT PK_PK_ByAlteringTable2 PRIMARY KEY (Age);


SELECT * FROM sys.key_constraints
WHERE SYS.key_constraints.parent_object_id = OBJECT_ID('PK_ByAlteringTable2');









---------------------------------			SQL FOREIGN KEY on CREATE TABLE


CREATE TABLE People_PK
(
	ID			INT NOT NULL PRIMARY KEY,
	Name		NVARCHAR(200) NOT NULL
);

CREATE TABLE Orders_FK
(
	ID			INT NOT NULL PRIMARY KEY,
	OrderName		NVARCHAR(100) NOT NULL,
	PersonID		INT FOREIGN KEY REFERENCES People_PK(ID)
);


-----	To allow naming of a FOREIGN KEY constraint, 
-----		and for defining a FOREIGN KEY constraint on multiple columns, use the following SQL syntax:

CREATE TABLE People_PK2
(
	ID			INT NOT NULL PRIMARY KEY,
	Name		NVARCHAR(200) NOT NULL
);

CREATE TABLE Orders_FK2
(
	ID			INT NOT NULL,
	Name		NVARCHAR(200) NOT NULL,
	ItemsCount	INT NOT NULL

	PRIMARY KEY(ID),
	CONSTRAINT FK_OREDERS_PEOPLE FOREIGN KEY (ID) REFERENCES People_PK2(ID)
);


--	SQL FOREIGN KEY on ALTER TABLE

CREATE TABLE Orders_FK3
(
	ID			INT NOT NULL,
	Name		NVARCHAR(200) NOT NULL,
	ItemsCount	INT NOT NULL

	PRIMARY KEY(ID),
);

ALTER TABLE Orders_FK3
ADD FOREIGN KEY (ID) REFERENCES People_PK2(ID);

SELECT * FROM SYS.key_constraints
WHERE SYS.key_constraints.parent_object_id = OBJECT_ID('Orders_FK3');

ALTER TABLE Orders_FK3
DROP CONSTRAINT PK__Orders_F__3214EC271C936A89;

ALTER TABLE Orders_FK3
ADD PRIMARY KEY (ID);

SELECT * FROM SYS.foreign_keys
WHERE parent_object_id = OBJECT_ID('Orders_FK3');

ALTER TABLE Orders_FK3
DROP CONSTRAINT FK__Orders_FK3__ID__2CF2ADDF;





--------------------		SQL NOT NULL

CREATE TABLE Persons1 
(
   ID int NOT NULL,
   LastName varchar(255) NOT NULL,
   FirstName varchar(255) NOT NULL,
   Age int
);


CREATE TABLE Persons2
(
   ID int,
   LastName varchar(255),
   FirstName varchar(255),
   Age int
);



ALTER TABLE Persons2
ALTER COLUMN AGE INT NOT NULL;



ALTER TABLE Persons2
ALTER COLUMN ID INT NOT NULL;
  




  ---------------				SQL DEFAULT Constraint
CREATE TABLE MyCities
(
	ID				INT PRIMARY KEY,
	FirstName		NVARCHAR(100) NOT NULL,
	LastName		NVARCHAR(100) NOT NULL,
	City			NVARCHAR(100) DEFAULT 'Amman'

);

SELECT * FROM MyCities;



CREATE TABLE MY_ORDERS
(
	ID				INT NOT NULL,
	OrderNumber		INT NOT NULL,
	OrderDate		DATE DEFAULT GETDATE()
);

SELECT * FROM MY_ORDERS;


CREATE TABLE MyCities2
(
	ID				INT PRIMARY KEY,
	FirstName		NVARCHAR(100) NOT NULL,
	LastName		NVARCHAR(100) NOT NULL,
	City			NVARCHAR(100)

);

SELECT * FROM MyCities2;

ALTER TABLE MyCities2
ADD CONSTRAINT DF_MY_CITIES_2
DEFAULT 'Aqaba' FOR City;

SELECT * FROM MyCities2;

SELECT *
FROM sys.default_constraints
WHERE parent_object_id = OBJECT_ID('MyCities2');

ALTER TABLE MyCities2
DROP CONSTRAINT DF_MY_CITIES_2;


-- by mouse go to design of table then properties
SELECT * FROM MyCities2;




-------------------------------			  Check Constraint


CREATE TABLE MyPeople
(
	ID				INT PRIMARY KEY,
	FirstName		NVARCHAR(100) NOT NULL,
	LastName		NVARCHAR(100) NOT NULL,
	Age				INT CHECK (Age >= 18),
	City			NVARCHAR(100)
);

SELECT * FROM MyPeople;

CREATE TABLE MyPeople2
(
	ID				INT PRIMARY KEY,
	FirstName		NVARCHAR(100) NOT NULL,
	LastName		NVARCHAR(100) NOT NULL,
	Age				INT,
	City			NVARCHAR(100),
	CONSTRAINT CHK_PEOPLE2 CHECK (Age >= 18 AND City = 'Amman')
);




SELECT * FROM MyPeople2;


SELECT * FROM sys.check_constraints
WHERE	parent_object_id = OBJECT_ID('MyPeople2');


ALTER TABLE MyPeople2
DROP CONSTRAINT CHK_PEOPLE2;

SELECT * FROM MyPeople2;

SELECT * FROM SYS.default_constraints;

ALTER TABLE MyPeople2
ADD CONSTRAINT CHK_PEOPLE2
CHECK (Age >= 18 AND City = 'Amman')

-------- YOU CAN CHECKK ALL CONSTRAINTS

SELECT *
FROM sys.default_constraints
WHERE parent_object_id = OBJECT_ID('YourTableName');

SELECT *
FROM sys.check_constraints
WHERE parent_object_id = OBJECT_ID('YourTableName');

SELECT *
FROM sys.foreign_keys
WHERE parent_object_id = OBJECT_ID('YourTableName');


SELECT *
FROM sys.key_constraints
WHERE parent_object_id = OBJECT_ID('YourTableName') 
  AND type = 'PK';


SELECT *
FROM sys.key_constraints
WHERE parent_object_id = OBJECT_ID('YourTableName')
  AND type = 'U'; 











--------------------------------			SQL UNIQUE Constraint

CREATE TABLE UNQ_Person
(
	ID				INT UNIQUE,
	FirstName		NVARCHAR(20) NOT NULL,
	LastName		NVARCHAR(20) NOT NULL,
	CONSTRAINT UNQ_PERSON_CT UNIQUE (FirstName, LastName)
);

SELECT * FROM UNQ_Person;


CREATE TABLE UNQ_Person2
(
	ID				INT,
	FirstName		NVARCHAR(20) NOT NULL,
	LastName		NVARCHAR(20) NOT NULL
);

ALTER TABLE UNQ_Person2
ADD CONSTRAINT UNQ_PERSON3 UNIQUE (ID, FirstName, LastName);







CREATE TABLE UNQ_Person4
(
	ID				INT,
	FirstName		NVARCHAR(20) NOT NULL,
	LastName		NVARCHAR(20) NOT NULL
);

ALTER TABLE UNQ_Person4
ADD CONSTRAINT UNQ_PERSON4_ID UNIQUE (ID);

ALTER TABLE UNQ_Person4
ADD CONSTRAINT UNQ_PERSON4_FN UNIQUE (FirstName);

ALTER TABLE UNQ_Person4
ADD CONSTRAINT UNQ_PERSON4_LN UNIQUE (LastName);

SELECT * FROM UNQ_Person4

ALTER TABLE UNQ_PERSON4
DROP CONSTRAINT UNQ_PERSON4_LN ;






---------------------------------		  SQL Index
CREATE TABLE INDECIED_Person
(
	ID			int NOT NULL PRIMARY KEY,
	FirstName	nvarchar(100) NOT NULL,
	MiddleName	nvarchar(100) ,
	LastName	nvarchar(100) NOT NULL,
	Age			int
);

CREATE INDEX	IdxLastName
ON				INDECIED_Person(LastName);

DROP INDEX	INDECIED_Person.IdxLastName;

CREATE INDEX	IdxFullName
ON				INDECIED_Person(FirstName, MiddleName, LastName);


DROP INDEX	INDECIED_Person.IdxFullName;

```

</details>

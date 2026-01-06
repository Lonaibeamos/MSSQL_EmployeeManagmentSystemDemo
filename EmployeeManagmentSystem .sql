-- =====================================================
-- Cadila Pharmaceuticals Employee Management System
-- Enhanced for Gelan, Ethiopia Location
-- =====================================================

-- ALL THE DATA'S FOUND HERE INCLUDING THE STRUCTURE IS JUST IDEAL NOT ACTUAL !!!

-- 1 To Drop and Create Database cuz i had difficulties with it thats why i dropped and created it again 
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'CadilaPharmaceuticalsEMS')
    DROP DATABASE CadilaPharmaceuticalsEMS;
GO

CREATE DATABASE CadilaPharmaceuticalsEMS;
GO

-- 2 To Use Database
USE CadilaPharmaceuticalsEMS;
GO

-- 3 Departments - Found in Gelan location Sheger City,Ethiopia
CREATE TABLE Department (
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL,
    Description VARCHAR(255),
    Location VARCHAR(100) DEFAULT 'Gelan, Addis Ababa',
    PhoneExtension VARCHAR(20)
);
GO

-- 4 i Enhanced Positions with more roles
CREATE TABLE Position (
    PositionID INT IDENTITY(1,1) PRIMARY KEY,
    Title VARCHAR(50) NOT NULL,
    LevelName VARCHAR(30) CHECK(LevelName IN ('Junior','Mid','Senior','Lead','Manager','Director')),
    JobFamily VARCHAR(50),
    DepartmentID INT,
    MinimumSalary DECIMAL(10,2),
    MaximumSalary DECIMAL(10,2),
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
);
GO

-- 5 Employees with additional columns
CREATE TABLE Employee (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Gender CHAR(1) CHECK(Gender IN ('M','F')),
    DateOfBirth DATE,
    DepartmentID INT,
    PositionID INT,
    ManagerID INT NULL,
    JobTitle VARCHAR(50),
    Salary DECIMAL(15,2),
    MaritalStatus VARCHAR(20) DEFAULT 'Single',
    EmploymentType VARCHAR(50) DEFAULT 'Full-time',
    Status VARCHAR(50) DEFAULT 'Active',
    Email VARCHAR(100) UNIQUE NOT NULL,
    PhoneNumber VARCHAR(20),
    Address VARCHAR(200),
    City VARCHAR(50) DEFAULT 'Addis Ababa',
    HireDate DATE NOT NULL,
    TerminationDate DATE NULL,
    EmergencyContact VARCHAR(100),
    EmergencyPhone VARCHAR(20),
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID),
    FOREIGN KEY (PositionID) REFERENCES Position(PositionID),
    FOREIGN KEY (ManagerID) REFERENCES Employee(EmployeeID)
);
GO

-- 6 Enhanced Payroll with deductions
CREATE TABLE Payroll (
    PayrollRecordID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT NOT NULL,
    BaseSalary DECIMAL(10,2) NOT NULL,
    Allowances DECIMAL(10,2) DEFAULT 0,
    OvertimePay DECIMAL(10,2) DEFAULT 0,
    Bonus DECIMAL(10,2) DEFAULT 0,
    Tax DECIMAL(10,2) DEFAULT 0,
    Pension DECIMAL(10,2) DEFAULT 0,
    OtherDeductions DECIMAL(10,2) DEFAULT 0,
    GrossSalary AS (BaseSalary + Allowances + OvertimePay + Bonus),
    NetSalary AS (BaseSalary + Allowances + OvertimePay + Bonus - Tax - Pension - OtherDeductions),
    PayCycle DATE NOT NULL,
    PaymentMethod VARCHAR(50) DEFAULT 'Bank Transfer',
    BankName VARCHAR(100),
    AccountNumber VARCHAR(50),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);
GO

-- 7 Contact Table - Updated for Gelan
CREATE TABLE Contact (
    ContactID INT IDENTITY(1,1) PRIMARY KEY,
    ContactType VARCHAR(50),
    RelatedEmployeeID INT NULL,
    ContactName VARCHAR(100) NOT NULL,
    Phone VARCHAR(20),
    Email VARCHAR(100),
    Address VARCHAR(200),
    City VARCHAR(50),
    Country VARCHAR(50) DEFAULT 'Ethiopia',
    IsActive BIT DEFAULT 1,
    FOREIGN KEY (RelatedEmployeeID) REFERENCES Employee(EmployeeID)
);
GO

-- 8 New Table- Employee Qualifications
CREATE TABLE Qualification (
    QualificationID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT NOT NULL,
    Degree VARCHAR(100),
    FieldOfStudy VARCHAR(100),
    Institution VARCHAR(150),
    GraduationYear INT,
    CertificateNumber VARCHAR(50),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);
GO

-- 9 New Table: Attendance
CREATE TABLE Attendance (
    AttendanceID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT NOT NULL,
    Date DATE NOT NULL,
    TimeIn TIME,
    TimeOut TIME,
    Status VARCHAR(20),
    HoursWorked DECIMAL(5,2),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);
GO

-- =====================================================
-- INSERT DATA FOR CADILA PHARMACEUTICALS - GELAN, ETHIOPIA
-- =====================================================

-- Departments for Gelan Facility
INSERT INTO Department (DepartmentName, Description, Location, PhoneExtension)
VALUES
('Manufacturing','Drug production & packaging','Gelan Industrial Zone, Addis Ababa','201'),
('Quality Control','Lab testing & validation','Gelan Industrial Zone, Addis Ababa','202'),
('Quality Assurance','Compliance & documentation','Gelan Industrial Zone, Addis Ababa','203'),
('Research & Development','New product development','Gelan Industrial Zone, Addis Ababa','204'),
('HR & Admin','Employee relations & administration','Gelan Industrial Zone, Addis Ababa','205'),
('Finance & Accounts','Payroll & accounting','Gelan Industrial Zone, Addis Ababa','206'),
('Supply Chain','Logistics & procurement','Gelan Industrial Zone, Addis Ababa','207'),
('Sales & Marketing','Product promotion & sales','Gelan Industrial Zone, Addis Ababa','208'),
('IT & Systems','Technology infrastructure','Gelan Industrial Zone, Addis Ababa','209'),
('Maintenance','Equipment maintenance','Gelan Industrial Zone, Addis Ababa','210');
GO

-- Positions (30 positions across departments)
INSERT INTO Position (Title, LevelName, JobFamily, DepartmentID, MinimumSalary, MaximumSalary)
VALUES
-- Manufacturing
('Production Manager','Manager','Manufacturing',1,45000,85000),
('Production Supervisor','Senior','Manufacturing',1,35000,60000),
('Production Pharmacist','Mid','Manufacturing',1,30000,50000),
('Production Technician','Junior','Manufacturing',1,18000,35000),
('Packaging Supervisor','Senior','Manufacturing',1,32000,55000),

-- Quality Control
('QC Manager','Manager','Quality',2,48000,90000),
('QC Analyst','Senior','Quality',2,35000,65000),
('Lab Technician','Mid','Quality',2,25000,45000),
('Microbiologist','Mid','Quality',2,28000,52000),

-- Quality Assurance
('QA Manager','Manager','Quality',3,50000,95000),
('QA Officer','Senior','Quality',3,38000,70000),
('Documentation Specialist','Mid','Quality',3,30000,55000),

-- R&D
('R&D Director','Director','R&D',4,60000,120000),
('Formulation Scientist','Senior','R&D',4,40000,75000),
('Analytical Scientist','Mid','R&D',4,35000,65000),

-- HR
('HR Manager','Manager','HR',5,45000,85000),
('HR Officer','Mid','HR',5,30000,55000),
('Recruitment Specialist','Mid','HR',5,32000,58000),

-- Finance
('Finance Manager','Manager','Finance',6,50000,95000),
('Accountant','Senior','Finance',6,35000,65000),
('Payroll Officer','Mid','Finance',6,30000,55000),

-- Supply Chain
('Supply Chain Manager','Manager','Supply Chain',7,48000,90000),
('Procurement Officer','Senior','Supply Chain',7,35000,65000),
('Warehouse Supervisor','Mid','Supply Chain',7,30000,55000),

-- Sales
('Sales Manager','Manager','Sales',8,55000,100000),
('Sales Representative','Mid','Sales',8,25000,50000),
('Medical Representative','Mid','Sales',8,30000,60000),

-- IT
('IT Manager','Manager','IT',9,45000,85000),
('System Administrator','Senior','IT',9,35000,65000),

-- Maintenance
('Maintenance Engineer','Senior','Manufacturing',10,32000,60000),
('Equipment Technician','Mid','Manufacturing',10,25000,45000);
GO

-- Insert 70 Employees for Cadila Pharmaceuticals in Gelan
INSERT INTO Employee (FullName, Gender, DateOfBirth, DepartmentID, PositionID, ManagerID, JobTitle, Salary, MaritalStatus, EmploymentType, Status, Email, PhoneNumber, Address, City, HireDate, EmergencyContact, EmergencyPhone)
VALUES
-- Senior Management (5)
('Alemayehu Bekele','M','1978-05-15',4,13,NULL,'R&D Director',85000,'Married','Full-time','Active','alex.bekele@cadilaethiopia.com','+251911001001','Bole, Addis Ababa','Addis Ababa','2018-03-10','Marta Bekele','+251911101001'),
('Sofia Girma','F','1980-08-22',5,16,NULL,'HR Manager',65000,'Married','Full-time','Active','sofia.girma@cadilaethiopia.com','+251911001002','Gelan, Addis Ababa','Addis Ababa','2019-06-15','Samuel Girma','+251911101002'),
('Daniel Haile','M','1975-11-30',6,19,NULL,'Finance Manager',72000,'Married','Full-time','Active','daniel.haile@cadilaethiopia.com','+251911001003','CMC, Addis Ababa','Addis Ababa','2017-09-20','Ruth Haile','+251911101003'),
('Mekonnen Tesfaye','M','1976-03-12',1,1,NULL,'Production Manager',68000,'Married','Full-time','Active','mekonnen.tesfaye@cadilaethiopia.com','+251911001004','Gelan, Addis Ababa','Addis Ababa','2018-01-10','Hanna Tesfaye','+251911101004'),
('Elena Assefa','F','1982-07-25',2,6,NULL,'QC Manager',62000,'Single','Full-time','Active','elena.assefa@cadilaethiopia.com','+251911001005','Yeka, Addis Ababa','Addis Ababa','2019-04-22','Yohannes Assefa','+251911101005'),

-- Manufacturing Department (15 employees)
('Biniam Tekle','M','1990-02-18',1,2,4,'Production Supervisor',42000,'Married','Full-time','Active','biniam.tekle@cadilaethiopia.com','+251911001006','Gelan, Addis Ababa','Addis Ababa','2020-03-15','Sara Tekle','+251911101006'),
('Hirut Lemma','F','1992-06-30',1,3,4,'Production Pharmacist',38000,'Single','Full-time','Active','hirut.lemma@cadilaethiopia.com','+251911001007','Bole, Addis Ababa','Addis Ababa','2021-01-20','Lemma Hailu','+251911101007'),
('Kebede Abebe','M','1993-09-14',1,4,6,'Production Technician',22000,'Single','Full-time','Active','kebede.abebe@cadilaethiopia.com','+251911001008','Gelan, Addis Ababa','Addis Ababa','2022-05-10','Abebe Mulu','+251911101008'),
('Marta Solomon','F','1991-12-05',1,4,6,'Production Technician',21000,'Married','Full-time','Active','marta.solomon@cadilaethiopia.com','+251911001009','Addis Ketema, Addis Ababa','Addis Ababa','2021-08-15','Solomon Getu','+251911101009'),
('Samuel Getachew','M','1989-04-22',1,5,4,'Packaging Supervisor',36000,'Married','Full-time','Active','samuel.getachew@cadilaethiopia.com','+251911001010','Gelan, Addis Ababa','Addis Ababa','2019-11-30','Ruth Getachew','+251911101010'),
('Yordanos Tadesse','F','1994-08-19',1,4,6,'Production Technician',20000,'Single','Full-time','Active','yordanos.tadesse@cadilaethiopia.com','+251911001011','Gullele, Addis Ababa','Addis Ababa','2022-02-14','Tadesse Mekonnen','+251911101011'),
('Tewodros Mekuria','M','1990-11-11',1,3,4,'Production Pharmacist',37000,'Married','Full-time','Active','tewodros.mekuria@cadilaethiopia.com','+251911001012','Bole, Addis Ababa','Addis Ababa','2020-06-25','Selam Mekuria','+251911101012'),
('Aster G/Michael','F','1988-07-08',1,2,4,'Production Supervisor',41000,'Married','Full-time','Active','aster.gmichael@cadilaethiopia.com','+251911001013','Gelan, Addis Ababa','Addis Ababa','2019-09-12','G/Michael Haile','+251911101013'),
('Bereket Hailu','M','1995-03-25',1,4,6,'Production Technician',19000,'Single','Full-time','Active','bereket.hailu@cadilaethiopia.com','+251911001014','Yeka, Addis Ababa','Addis Ababa','2022-08-05','Hailu Asfaw','+251911101014'),
('Rahel Asrat','F','1992-10-30',1,4,13,'Packaging Assistant',19500,'Single','Full-time','Active','rahel.asrat@cadilaethiopia.com','+251911001015','Gelan, Addis Ababa','Addis Ababa','2021-12-10','Asrat Demissie','+251911101015'),
('Dawit Worku','M','1993-05-17',1,4,6,'Production Technician',20500,'Married','Full-time','Active','dawit.worku@cadilaethiopia.com','+251911001016','Addis Ketema, Addis Ababa','Addis Ababa','2022-03-22','Worku Alemu','+251911101016'),
('Selamawit Alemu','F','1991-09-14',1,3,4,'Production Pharmacist',38500,'Married','Full-time','Active','selamawit.alemu@cadilaethiopia.com','+251911001017','Gelan, Addis Ababa','Addis Ababa','2020-10-18','Alemu Tesfaye','+251911101017'),
('Nahom Bekele','M','1994-12-08',1,4,13,'Packaging Assistant',19200,'Single','Full-time','Active','nahom.bekele@cadilaethiopia.com','+251911001018','Gullele, Addis Ababa','Addis Ababa','2022-06-30','Bekele Hailu','+251911101018'),
('Mihret Teshome','F','1990-04-03',1,4,6,'Production Technician',21500,'Married','Full-time','Active','mihret.teshome@cadilaethiopia.com','+251911001019','Bole, Addis Ababa','Addis Ababa','2021-04-15','Teshome Girma','+251911101019'),
('Yohannes Tadesse','M','1987-06-28',1,3,4,'Production Pharmacist',39500,'Married','Full-time','Active','yohannes.tadesse@cadilaethiopia.com','+251911001020','Gelan, Addis Ababa','Addis Ababa','2019-05-20','Tadesse Mulu','+251911101020'),

-- Quality Control (10 employees)
('Tsion Mekonnen','F','1989-03-14',2,7,5,'QC Analyst',45000,'Married','Full-time','Active','tsion.mekonnen@cadilaethiopia.com','+251911001021','Yeka, Addis Ababa','Addis Ababa','2020-02-10','Mekonnen Haile','+251911101021'),
('Getnet Ayele','M','1991-08-09',2,8,5,'Lab Technician',32000,'Single','Full-time','Active','getnet.ayele@cadilaethiopia.com','+251911001022','Gelan, Addis Ababa','Addis Ababa','2021-06-18','Ayele Berhanu','+251911101022'),
('Eyerusalem Hailu','F','1993-11-25',2,8,5,'Lab Technician',31000,'Single','Full-time','Active','eyerusalem.hailu@cadilaethiopia.com','+251911001023','Bole, Addis Ababa','Addis Ababa','2022-01-12','Hailu Girma','+251911101023'),
('Mulugeta Assefa','M','1988-12-30',2,9,5,'Microbiologist',35000,'Married','Full-time','Active','mulugeta.assefa@cadilaethiopia.com','+251911001024','Gelan, Addis Ababa','Addis Ababa','2019-08-22','Assefa Lemma','+251911101024'),
('Birtukan Demissie','F','1990-07-19',2,7,5,'QC Analyst',44000,'Married','Full-time','Active','birtukan.demissie@cadilaethiopia.com','+251911001025','CMC, Addis Ababa','Addis Ababa','2020-11-05','Demissie Tekle','+251911101025'),
('Ashenafi Bekele','M','1992-04-12',2,8,5,'Lab Technician',30500,'Single','Full-time','Active','ashenafi.bekele@cadilaethiopia.com','+251911001026','Gelan, Addis Ababa','Addis Ababa','2021-09-14','Bekele Haile','+251911101026'),
('Elsa H/Mariam','F','1994-01-08',2,8,5,'Lab Technician',29800,'Single','Full-time','Active','elsa.hmariam@cadilaethiopia.com','+251911001027','Yeka, Addis Ababa','Addis Ababa','2022-03-25','H/Mariam G/Selassie','+251911101027'),
('Temesgen Worku','M','1989-06-22',2,9,5,'Microbiologist',35500,'Married','Full-time','Active','temesgen.worku@cadilaethiopia.com','+251911001028','Gelan, Addis Ababa','Addis Ababa','2020-04-30','Worku Alemu','+251911101028'),
('Kidan Fikadu','F','1991-10-15',2,7,5,'QC Analyst',43500,'Single','Full-time','Active','kidan.fikadu@cadilaethiopia.com','+251911001029','Bole, Addis Ababa','Addis Ababa','2021-02-20','Fikadu Teshome','+251911101029'),
('Abraham G/Egzihaber','M','1993-03-28',2,8,5,'Lab Technician',31500,'Single','Full-time','Active','abraham.gegzihaber@cadilaethiopia.com','+251911001030','Gelan, Addis Ababa','Addis Ababa','2022-07-08','G/Egzihaber Hailu','+251911101030'),

-- Quality Assurance (8 employees)
('Ruth Mengistu','F','1987-09-11',3,10,NULL,'QA Manager',58000,'Married','Full-time','Active','ruth.mengistu@cadilaethiopia.com','+251911001031','Gelan, Addis Ababa','Addis Ababa','2018-12-05','Mengistu Haile','+251911101031'),
('Solomon Tefera','M','1990-12-24',3,11,31,'QA Officer',42000,'Married','Full-time','Active','solomon.tefera@cadilaethiopia.com','+251911001032','Yeka, Addis Ababa','Addis Ababa','2020-07-19','Tefera Getu','+251911101032'),
('Marta Hailu','F','1992-05-07',3,12,31,'Documentation Specialist',35000,'Single','Full-time','Active','marta.hailu@cadilaethiopia.com','+251911001033','Gelan, Addis Ababa','Addis Ababa','2021-04-12','Hailu Assefa','+251911101033'),
('Dereje Asfaw','M','1991-08-30',3,11,31,'QA Officer',41500,'Married','Full-time','Active','dereje.asfaw@cadilaethiopia.com','+251911001034','Bole, Addis Ababa','Addis Ababa','2020-10-25','Asfaw Demissie','+251911101034'),
('Hanna Girma','F','1993-02-14',3,12,31,'Documentation Specialist',34000,'Single','Full-time','Active','hanna.girma@cadilaethiopia.com','+251911001035','Gelan, Addis Ababa','Addis Ababa','2022-01-08','Girma Tesfaye','+251911101035'),
('Yared Lemma','M','1989-11-09',3,11,31,'QA Officer',42500,'Married','Full-time','Active','yared.lemma@cadilaethiopia.com','+251911001036','CMC, Addis Ababa','Addis Ababa','2019-09-15','Lemma Hailu','+251911101036'),
('Seble Tilahun','F','1994-07-18',3,12,31,'Documentation Specialist',33500,'Single','Full-time','Active','seble.tilahun@cadilaethiopia.com','+251911001037','Yeka, Addis Ababa','Addis Ababa','2022-05-22','Tilahun Getachew','+251911101037'),
('Michael Berhanu','M','1990-04-03',3,11,31,'QA Officer',41800,'Married','Full-time','Active','michael.berhanu@cadilaethiopia.com','+251911001038','Gelan, Addis Ababa','Addis Ababa','2020-12-10','Berhanu Alemu','+251911101038'),

-- R&D (5 employees)
('Samuel Yohannes','M','1985-06-17',4,14,1,'Formulation Scientist',52000,'Married','Full-time','Active','samuel.yohannes@cadilaethiopia.com','+251911001039','Bole, Addis Ababa','Addis Ababa','2019-03-25','Yohannes Getu','+251911101039'),
('Aida Mohammed','F','1988-03-29',4,15,1,'Analytical Scientist',45000,'Married','Full-time','Active','aida.mohammed@cadilaethiopia.com','+251911001040','Gelan, Addis Ababa','Addis Ababa','2020-08-14','Mohammed Ali','+251911101040'),
('Teklu H/Mariam','M','1990-09-12',4,15,1,'Analytical Scientist',43000,'Single','Full-time','Active','teklu.hmariam@cadilaethiopia.com','+251911001041','Yeka, Addis Ababa','Addis Ababa','2021-05-30','H/Mariam G/Selassie','+251911101041'),
('Meseret Abebe','F','1992-12-05',4,14,1,'Formulation Scientist',48000,'Single','Full-time','Active','meseret.abebe@cadilaethiopia.com','+251911001042','Gelan, Addis Ababa','Addis Ababa','2022-02-18','Abebe Mulu','+251911101042'),
('Nebiyu Tadesse','M','1987-08-22',4,15,1,'Analytical Scientist',45500,'Married','Full-time','Active','nebiyu.tadesse@cadilaethiopia.com','+251911001043','CMC, Addis Ababa','Addis Ababa','2020-01-12','Tadesse Mekonnen','+251911101043'),

-- HR & Admin (6 employees)
('Liya Getachew','F','1989-04-18',5,17,2,'HR Officer',38000,'Married','Full-time','Active','liya.getachew@cadilaethiopia.com','+251911001044','Gelan, Addis Ababa','Addis Ababa','2020-06-22','Getachew Haile','+251911101044'),
('Beniam Hailu','M','1991-11-30',5,18,2,'Recruitment Specialist',40000,'Single','Full-time','Active','beniam.hailu@cadilaethiopia.com','+251911001045','Bole, Addis Ababa','Addis Ababa','2021-09-05','Hailu Asfaw','+251911101045'),
('Ruth Asfaw','F','1993-07-14',5,17,2,'HR Officer',36500,'Single','Full-time','Active','ruth.asfaw@cadilaethiopia.com','+251911001046','Yeka, Addis Ababa','Addis Ababa','2022-03-10','Asfaw Demissie','+251911101046'),
('Mikias Lemma','M','1990-02-25',5,18,2,'Recruitment Specialist',39500,'Married','Full-time','Active','mikias.lemma@cadilaethiopia.com','+251911001047','Gelan, Addis Ababa','Addis Ababa','2020-11-18','Lemma Hailu','+251911101047'),
('Saron Mekuria','F','1992-09-08',5,17,2,'Admin Assistant',28000,'Single','Full-time','Active','saron.mekuria@cadilaethiopia.com','+251911001048','Gelan, Addis Ababa','Addis Ababa','2021-12-03','Mekuria Getu','+251911101048'),
('Nati H/Giorgis','M','1994-05-21',5,18,2,'Recruitment Specialist',38500,'Single','Full-time','Active','nati.hgiorgis@cadilaethiopia.com','+251911001049','Addis Ketema, Addis Ababa','Addis Ababa','2022-06-28','H/Giorgis Michael','+251911101049'),

-- Finance & Accounts (6 employees)
('Tigist Lemma','F','1988-12-10',6,20,3,'Accountant',42000,'Married','Full-time','Active','tigist.lemma@cadilaethiopia.com','+251911001050','Gelan, Addis Ababa','Addis Ababa','2019-08-15','Lemma Tesfaye','+251911101050'),
('Kaleb Getu','M','1990-06-28',6,21,3,'Payroll Officer',35000,'Married','Full-time','Active','kaleb.getu@cadilaethiopia.com','+251911001051','Bole, Addis Ababa','Addis Ababa','2020-09-22','Getu Haile','+251911101051'),
('Mekdes Hailu','F','1992-03-17',6,20,3,'Accountant',40500,'Single','Full-time','Active','mekdes.hailu@cadilaethiopia.com','+251911001052','Yeka, Addis Ababa','Addis Ababa','2021-11-08','Hailu Girma','+251911101052'),
('Abel Assefa','M','1991-09-04',6,21,3,'Payroll Officer',34500,'Married','Full-time','Active','abel.assefa@cadilaethiopia.com','+251911001053','Gelan, Addis Ababa','Addis Ababa','2020-12-30','Assefa Lemma','+251911101053'),
('Rahel Tekle','F','1993-11-22',6,20,3,'Accountant',39800,'Single','Full-time','Active','rahel.tekle@cadilaethiopia.com','+251911001054','Gelan, Addis Ababa','Addis Ababa','2022-04-18','Tekle Hailu','+251911101054'),
('Samuel G/Selassie','M','1989-08-09',6,21,3,'Payroll Officer',35500,'Married','Full-time','Active','samuel.gselassie@cadilaethiopia.com','+251911001055','CMC, Addis Ababa','Addis Ababa','2020-02-14','G/Selassie Michael','+251911101055'),

-- Supply Chain (5 employees)
('Hana Mohammed','F','1986-07-19',7,22,NULL,'Supply Chain Manager',58000,'Married','Full-time','Active','hana.mohammed@cadilaethiopia.com','+251911001056','Gelan, Addis Ababa','Addis Ababa','2018-11-20','Mohammed Ali','+251911101056'),
('Biniyam Tadesse','M','1990-01-24',7,23,56,'Procurement Officer',42000,'Single','Full-time','Active','biniyam.tadesse@cadilaethiopia.com','+251911001057','Bole, Addis Ababa','Addis Ababa','2020-10-05','Tadesse Mekonnen','+251911101057'),
('Meklit Getachew','F','1992-04-09',7,24,56,'Warehouse Supervisor',38000,'Married','Full-time','Active','meklit.getachew@cadilaethiopia.com','+251911001058','Gelan, Addis Ababa','Addis Ababa','2021-06-30','Getachew Haile','+251911101058'),
('Asrat Demissie','M','1991-11-15',7,23,56,'Procurement Officer',41500,'Married','Full-time','Active','asrat.demissie@cadilaethiopia.com','+251911001059','Yeka, Addis Ababa','Addis Ababa','2020-12-12','Demissie Tekle','+251911101059'),
('Sofia Hailu','F','1993-08-28',7,24,56,'Warehouse Assistant',28000,'Single','Full-time','Active','sofia.hailu@cadilaethiopia.com','+251911001060','Gelan, Addis Ababa','Addis Ababa','2022-03-05','Hailu Asfaw','+251911101060'),

-- Sales & Marketing (5 employees)
('Yonas Getu','M','1987-05-12',8,25,NULL,'Sales Manager',65000,'Married','Full-time','Active','yonas.getu@cadilaethiopia.com','+251911001061','Bole, Addis Ababa','Addis Ababa','2019-04-18','Getu Haile','+251911101061'),
('Martha Tefera','F','1990-10-03',8,26,61,'Sales Representative',35000,'Single','Full-time','Active','martha.tefera@cadilaethiopia.com','+251911001062','Gelan, Addis Ababa','Addis Ababa','2021-01-25','Tefera Getu','+251911101062'),
('Dawit H/Mariam','M','1992-07-19',8,27,61,'Medical Representative',42000,'Married','Full-time','Active','dawit.hmariam@cadilaethiopia.com','+251911001063','Yeka, Addis Ababa','Addis Ababa','2022-05-08','H/Mariam G/Selassie','+251911101063'),
('Elilta Assefa','F','1991-03-26',8,26,61,'Sales Representative',36500,'Married','Full-time','Active','elilta.assefa@cadilaethiopia.com','+251911001064','Gelan, Addis Ababa','Addis Ababa','2020-08-14','Assefa Lemma','+251911101064'),
('Nathaniel Lemma','M','1993-12-08',8,27,61,'Medical Representative',40500,'Single','Full-time','Active','nathaniel.lemma@cadilaethiopia.com','+251911001065','CMC, Addis Ababa','Addis Ababa','2022-09-20','Lemma Hailu','+251911101065'),

-- IT & Systems (4 employees)
('Bethelhem Tekle','F','1989-09-14',9,28,NULL,'IT Manager',52000,'Married','Full-time','Active','bethelhem.tekle@cadilaethiopia.com','+251911001066','Gelan, Addis Ababa','Addis Ababa','2020-03-10','Tekle Hailu','+251911101066'),
('Elias Getachew','M','1991-02-28',9,29,66,'System Administrator',42000,'Single','Full-time','Active','elias.getachew@cadilaethiopia.com','+251911001067','Bole, Addis Ababa','Addis Ababa','2021-07-22','Getachew Haile','+251911101067'),
('Hana Yohannes','F','1993-06-12',9,29,66,'IT Support Specialist',38000,'Single','Full-time','Active','hana.yohannes@cadilaethiopia.com','+251911001068','Yeka, Addis Ababa','Addis Ababa','2022-02-15','Yohannes Getu','+251911101068'),
('Mikael Asfaw','M','1990-11-05',9,29,66,'System Administrator',41500,'Married','Full-time','Active','mikael.asfaw@cadilaethiopia.com','+251911001069','Gelan, Addis Ababa','Addis Ababa','2020-11-30','Asfaw Demissie','+251911101069'),

-- Maintenance (5 employees)
('Solomon Hailu','M','1988-04-17',10,30,NULL,'Maintenance Engineer',45000,'Married','Full-time','Active','solomon.hailu@cadilaethiopia.com','+251911001070','Gelan, Addis Ababa','Addis Ababa','2019-09-25','Hailu Asfaw','+251911101070'),
('Rahel Getu','F','1992-08-09',10,31,70,'Equipment Technician',32000,'Single','Full-time','Active','rahel.getu@cadilaethiopia.com','+251911001071','Bole, Addis Ababa','Addis Ababa','2021-10-12','Getu Haile','+251911101071'),
('Yosef Tadesse','M','1991-12-24',10,31,70,'Equipment Technician',33500,'Married','Full-time','Active','yosef.tadesse@cadilaethiopia.com','+251911001072','Gelan, Addis Ababa','Addis Ababa','2020-12-05','Tadesse Mekonnen','+251911101072'),
('Sara Assefa','F','1994-03-08',10,31,70,'Maintenance Assistant',25000,'Single','Full-time','Active','sara.assefa@cadilaethiopia.com','+251911001073','Yeka, Addis Ababa','Addis Ababa','2022-06-18','Assefa Lemma','+251911101073'),
('Daniel G/Egzihaber','M','1990-07-30',10,31,70,'Equipment Technician',34000,'Married','Full-time','Active','daniel.gegzihaber@cadilaethiopia.com','+251911001074','Gelan, Addis Ababa','Addis Ababa','2020-04-22','G/Egzihaber Hailu','+251911101074');
GO

-- Insert Payroll records for December 2025
INSERT INTO Payroll (EmployeeID, BaseSalary, Allowances, OvertimePay, Bonus, Tax, Pension, OtherDeductions, PayCycle, PaymentMethod, BankName, AccountNumber)
VALUES
(1, 85000, 8000, 2000, 5000, 12000, 4250, 500, '2025-12-31', 'Bank Transfer', 'Commercial Bank of Ethiopia', '100023456789'),
(2, 65000, 6000, 1500, 3000, 9000, 3250, 400, '2025-12-31', 'Bank Transfer', 'Dashen Bank', '200034567890'),
(3, 72000, 7000, 1800, 4000, 10500, 3600, 450, '2025-12-31', 'Bank Transfer', 'Awash Bank', '300045678901'),
(4, 68000, 6500, 2200, 3500, 9800, 3400, 420, '2025-12-31', 'Bank Transfer', 'Bank of Abyssinia', '400056789012'),
(5, 62000, 5800, 1200, 2800, 8500, 3100, 380, '2025-12-31', 'Bank Transfer', 'Nib International Bank', '500067890123'),
(6, 42000, 3500, 800, 1500, 5500, 2100, 250, '2025-12-31', 'Bank Transfer', 'Commercial Bank of Ethiopia', '100123456788'),
(7, 38000, 3000, 600, 1200, 4800, 1900, 200, '2025-12-31', 'Bank Transfer', 'Dashen Bank', '200234567899');
GO

-- Insert Contacts for Gelan Facility
INSERT INTO Contact (ContactType, RelatedEmployeeID, ContactName, Phone, Email, Address, City, Country, IsActive)
VALUES
-- Company Contacts
('Company', NULL, 'Cadila Pharmaceuticals Ethiopia HQ', '+251-11-550-1234', 'info@cadilaethiopia.com', 'Gelan Industrial Zone, Addis Ababa', 'Addis Ababa', 'Ethiopia', 1),
('Company', NULL, 'Cadila Gelan Manufacturing Plant', '+251-11-550-1235', 'gelanplant@cadilaethiopia.com', 'Gelan Industrial Zone, Plot No. 45', 'Addis Ababa', 'Ethiopia', 1),
('Company', NULL, 'Cadila Quality Control Lab', '+251-11-550-1236', 'qclab@cadilaethiopia.com', 'Gelan Industrial Zone, Building C', 'Addis Ababa', 'Ethiopia', 1),

-- Branch Contacts (Note: Not Hawassa)
('Branch', NULL, 'Cadila Addis Ababa Distribution Center', '+251-11-550-1237', 'distribution@cadilaethiopia.com', 'Bole, Atlas Area', 'Addis Ababa', 'Ethiopia', 1),
('Branch', NULL, 'Cadila Mekelle Branch', '+251-34-441-1234', 'mekelle@cadilaethiopia.com', 'Industrial Area, Mekelle', 'Mekelle', 'Ethiopia', 1),
('Branch', NULL, 'Cadila Dire Dawa Branch', '+251-25-111-2233', 'diredawa@cadilaethiopia.com', 'Commercial Area, Dire Dawa', 'Dire Dawa', 'Ethiopia', 1),

-- Emergency Contacts for Senior Staff
('Employee Emergency', 1, 'Marta Bekele', '+251-91-234-5678', NULL, 'Bole Area, Addis Ababa', 'Addis Ababa', 'Ethiopia', 1),
('Employee Emergency', 2, 'Samuel Girma', '+251-92-345-6789', NULL, 'Gelan Area, Addis Ababa', 'Addis Ababa', 'Ethiopia', 1),
('Employee Emergency', 3, 'Ruth Haile', '+251-93-456-7890', NULL, 'CMC Area, Addis Ababa', 'Addis Ababa', 'Ethiopia', 1),

-- Government Agencies
('Government Agency', NULL, 'Ethiopian Food & Drug Authority', '+251-11-551-4321', 'efda@efda.gov.et', 'Kirkos, Addis Ababa', 'Addis Ababa', 'Ethiopia', 1),
('Government Agency', NULL, 'Ministry of Health', '+251-11-551-0000', 'info@moh.gov.et', 'Arada, Addis Ababa', 'Addis Ababa', 'Ethiopia', 1),

-- Key Suppliers
('Supplier', NULL, 'Medtech Pharmaceuticals Ltd', '+251-11-552-3344', 'orders@medtechpharma.et', 'Bole, Addis Ababa', 'Addis Ababa', 'Ethiopia', 1),
('Supplier', NULL, 'Ethio Chemical Supplies', '+251-11-553-4455', 'sales@ethiochemicals.et', 'Gelan Industrial Zone', 'Addis Ababa', 'Ethiopia', 1);
GO

-- Insert Sample Qualifications
INSERT INTO Qualification (EmployeeID, Degree, FieldOfStudy, Institution, GraduationYear, CertificateNumber)
VALUES
(1, 'PhD', 'Pharmaceutical Sciences', 'Addis Ababa University', 2010, 'PHD-AAU-2010-001'),
(1, 'MSc', 'Drug Development', 'University of Gondar', 2005, 'MSC-UG-2005-045'),
(2, 'MSc', 'Human Resource Management', 'Addis Ababa University', 2012, 'MSC-AAU-2012-123'),
(3, 'MSc', 'Accounting & Finance', 'Addis Ababa University', 2008, 'MSC-AAU-2008-078'),
(4, 'BPharm', 'Pharmacy', 'University of Gondar', 2003, 'BPHARM-UG-2003-056'),
(5, 'MSc', 'Analytical Chemistry', 'Addis Ababa University', 2015, 'MSC-AAU-2015-189'),
(6, 'BSc', 'Chemical Engineering', 'Bahir Dar University', 2013, 'BSC-BDU-2013-234');
GO

-- Insert Sample Attendance for December 2025
INSERT INTO Attendance (EmployeeID, Date, TimeIn, TimeOut, Status, HoursWorked)
VALUES
(1, '2025-12-01', '08:30:00', '17:15:00', 'Present', 8.75),
(1, '2025-12-02', '08:45:00', '17:30:00', 'Present', 8.75),
(2, '2025-12-01', '08:25:00', '17:00:00', 'Present', 8.58),
(2, '2025-12-02', '08:35:00', '17:10:00', 'Present', 8.58),
(3, '2025-12-01', '08:20:00', '16:55:00', 'Present', 8.58),
(3, '2025-12-02', '09:15:00', '17:30:00', 'Late', 8.25),
(4, '2025-12-01', '08:30:00', '17:00:00', 'Present', 8.5),
(4, '2025-12-02', '08:30:00', '12:30:00', 'Half Day', 4.0),
(5, '2025-12-01', '08:40:00', '17:20:00', 'Present', 8.67),
(5, '2025-12-02', NULL, NULL, 'On Leave', 0);
GO

-- =====================================================
-- CREATE USEFUL VIEWS
-- =====================================================

-- View: Employee Directory with Department and Position
CREATE VIEW vw_EmployeeDirectory AS
SELECT 
    e.EmployeeID,
    e.FullName,
    e.Gender,
    e.DateOfBirth,
    DATEDIFF(YEAR, e.DateOfBirth, GETDATE()) AS Age,
    d.DepartmentName,
    p.Title AS PositionTitle,
    p.LevelName,
    e.JobTitle,
    e.Salary,
    e.MaritalStatus,
    e.EmploymentType,
    e.Status,
    e.Email,
    e.PhoneNumber,
    e.City,
    e.HireDate,
    DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsOfService,
    m.FullName AS ManagerName
FROM Employee e
LEFT JOIN Department d ON e.DepartmentID = d.DepartmentID
LEFT JOIN Position p ON e.PositionID = p.PositionID
LEFT JOIN Employee m ON e.ManagerID = m.EmployeeID;
GO

-- To View: Department Summary
CREATE VIEW vw_DepartmentSummary AS
SELECT 
    d.DepartmentID,
    d.DepartmentName,
    d.Location,
    COUNT(e.EmployeeID) AS TotalEmployees,
    AVG(e.Salary) AS AverageSalary,
    MIN(e.Salary) AS MinSalary,
    MAX(e.Salary) AS MaxSalary,
    SUM(e.Salary) AS TotalSalaryBudget
FROM Department d
LEFT JOIN Employee e ON d.DepartmentID = e.DepartmentID
WHERE e.Status = 'Active'
GROUP BY d.DepartmentID, d.DepartmentName, d.Location;
GO

-- To View: Monthly Payroll Summary
CREATE VIEW vw_PayrollSummary AS
SELECT 
    p.PayCycle,
    COUNT(p.EmployeeID) AS EmployeesPaid,
    SUM(p.BaseSalary) AS TotalBaseSalary,
    SUM(p.Allowances) AS TotalAllowances,
    SUM(p.OvertimePay) AS TotalOvertime,
    SUM(p.Bonus) AS TotalBonus,
    SUM(p.Tax) AS TotalTax,
    SUM(p.Pension) AS TotalPension,
    SUM(p.GrossSalary) AS TotalGrossSalary,
    SUM(p.NetSalary) AS TotalNetSalary
FROM Payroll p
GROUP BY p.PayCycle;
GO

-- =====================================================
-- CREATE STORED PROCEDURES
-- =====================================================

-- 1) Recreate / update the Employee Directory view so it includes DepartmentID
CREATE OR ALTER VIEW vw_EmployeeDirectory AS
SELECT 
    e.EmployeeID,
    e.FullName,
    e.Gender,
    e.DateOfBirth,
    DATEDIFF(YEAR, e.DateOfBirth, GETDATE()) AS Age,
    e.DepartmentID,                     -- <-- ensure DepartmentID is present
    d.DepartmentName,
    e.PositionID,
    p.Title AS PositionTitle,
    p.LevelName,
    e.JobTitle,
    e.Salary,
    e.MaritalStatus,
    e.EmploymentType,
    e.Status,
    e.Email,
    e.PhoneNumber,
    e.City,
    e.HireDate,
    DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsOfService,
    m.FullName AS ManagerName
FROM Employee e
LEFT JOIN Department d ON e.DepartmentID = d.DepartmentID
LEFT JOIN Position p ON e.PositionID = p.PositionID
LEFT JOIN Employee m ON e.ManagerID = m.EmployeeID;
GO

-- 2) Recreate / update the stored procedure that filters by DepartmentID
CREATE OR ALTER PROCEDURE sp_GetEmployeesByDepartment
    @DepartmentID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @DepartmentID IS NULL
    BEGIN
        SELECT * FROM vw_EmployeeDirectory
        ORDER BY DepartmentName, FullName;
    END
    ELSE
    BEGIN
        SELECT * FROM vw_EmployeeDirectory
        WHERE DepartmentID = @DepartmentID
        ORDER BY FullName;
    END
END;
GO

-- Optional: quick test (returns employees in department 1 and all employees)
-- SELECT * FROM vw_EmployeeDirectory WHERE DepartmentID = 1;
-- EXEC sp_GetEmployeesByDepartment;           -- all
-- EXEC sp_GetEmployeesByDepartment @DepartmentID = 1;  -- by dept

-- Stored Procedure: Calculate Monthly Payroll
CREATE PROCEDURE sp_CalculateMonthlyPayroll
    @PayCycle DATE
AS
BEGIN
    SELECT 
        e.EmployeeID,
        e.FullName,
        d.DepartmentName,
        e.Salary AS BaseSalary,
        -- Calculate allowances based on position level
        CASE 
            WHEN p.LevelName IN ('Manager', 'Director') THEN e.Salary * 0.15
            WHEN p.LevelName = 'Senior' THEN e.Salary * 0.10
            WHEN p.LevelName = 'Mid' THEN e.Salary * 0.08
            ELSE e.Salary * 0.05
        END AS Allowances,
        -- Placeholder for overtime calculation (would come from attendance system)
        0 AS OvertimePay,
        -- Bonus calculation example
        CASE 
            WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 5 THEN e.Salary * 0.10
            WHEN DATEDIFF(YEAR, e.HireDate, GETDATE()) >= 3 THEN e.Salary * 0.05
            ELSE 0
        END AS Bonus,
        -- Tax calculation (simplified)
        e.Salary * 0.15 AS Tax,
        -- Pension contribution
        e.Salary * 0.07 AS Pension,
        @PayCycle AS PayCycle
    FROM Employee e
    JOIN Department d ON e.DepartmentID = d.DepartmentID
    JOIN Position p ON e.PositionID = p.PositionID
    WHERE e.Status = 'Active'
    ORDER BY d.DepartmentName, e.FullName;
END;
GO

-- =====================================================
-- CREATE INDEXES FOR PERFORMANCE
-- =====================================================

CREATE INDEX IX_Employee_DepartmentID ON Employee(DepartmentID);
CREATE INDEX IX_Employee_PositionID ON Employee(PositionID);
CREATE INDEX IX_Employee_ManagerID ON Employee(ManagerID);
CREATE INDEX IX_Employee_Status ON Employee(Status);
CREATE INDEX IX_Employee_Email ON Employee(Email);
CREATE INDEX IX_Payroll_EmployeeID ON Payroll(EmployeeID);
CREATE INDEX IX_Payroll_PayCycle ON Payroll(PayCycle);
CREATE INDEX IX_Attendance_EmployeeID_Date ON Attendance(EmployeeID, Date);
CREATE INDEX IX_Qualification_EmployeeID ON Qualification(EmployeeID);
GO

-- =====================================================
-- SAMPLE QUERIES FOR REPORTING
-- =====================================================

-- Query 1: Employee Count by Department
SELECT 
    d.DepartmentName,
    COUNT(e.EmployeeID) AS EmployeeCount,
    FORMAT(AVG(e.Salary), 'C', 'et-ET') AS AverageSalary
FROM Department d
LEFT JOIN Employee e ON d.DepartmentID = e.DepartmentID
WHERE e.Status = 'Active' OR e.Status IS NULL
GROUP BY d.DepartmentName
ORDER BY EmployeeCount DESC;
GO

-- Query 2: Gender Distribution
SELECT 
    Gender,
    COUNT(*) AS Count,
    FORMAT(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 'N2') AS Percentage
FROM Employee
WHERE Status = 'Active' OR Status IS NULL
GROUP BY Gender;
GO

-- Query 3: Employees by Position Level
SELECT 
    p.LevelName,
    COUNT(e.EmployeeID) AS EmployeeCount,
    FORMAT(AVG(e.Salary), 'C', 'et-ET') AS AverageSalary
FROM Position p
LEFT JOIN Employee e ON p.PositionID = e.PositionID
WHERE e.Status = 'Active' OR e.Status IS NULL
GROUP BY p.LevelName
ORDER BY 
    CASE p.LevelName
        WHEN 'Director' THEN 1
        WHEN 'Manager' THEN 2
        WHEN 'Lead' THEN 3
        WHEN 'Senior' THEN 4
        WHEN 'Mid' THEN 5
        WHEN 'Junior' THEN 6
        ELSE 7
    END;
GO

-- Query 4: Longest Serving Employees
SELECT TOP 10
    FullName,
    DepartmentName,
    PositionTitle,
    HireDate,
    YearsOfService
FROM vw_EmployeeDirectory
WHERE Status = 'Active'
ORDER BY YearsOfService DESC;
GO

-- Query 5: for the Upcoming Employee Birthdays (next 30 days)
SELECT 
    FullName,
    DateOfBirth,
    DepartmentName,
    DATEDIFF(YEAR, DateOfBirth, GETDATE()) AS Age,
    DATENAME(month, DateOfBirth) AS BirthMonth,
    DAY(DateOfBirth) AS BirthDay
FROM vw_EmployeeDirectory
WHERE Status = 'Active'
    AND MONTH(DateOfBirth) = MONTH(GETDATE())
    AND DAY(DateOfBirth) BETWEEN DAY(GETDATE()) AND DAY(DATEADD(DAY, 30, GETDATE()))
ORDER BY DAY(DateOfBirth);
GO

-- Query 6: Contact List for Emergency
SELECT 
    e.FullName AS EmployeeName,
    e.EmergencyContact,
    e.EmergencyPhone,
    d.DepartmentName,
    e.JobTitle
FROM Employee e
JOIN Department d ON e.DepartmentID = d.DepartmentID
WHERE e.Status = 'Active'
ORDER BY d.DepartmentName, e.FullName;
GO

-- Query 7: Monthly Salary Expenditure by Department
SELECT 
    d.DepartmentName,
    FORMAT(SUM(e.Salary), 'C', 'et-ET') AS MonthlySalaryExpenditure,
    COUNT(e.EmployeeID) AS EmployeeCount
FROM Department d
JOIN Employee e ON d.DepartmentID = e.DepartmentID
WHERE e.Status = 'Active'
GROUP BY d.DepartmentName
ORDER BY SUM(e.Salary) DESC;
GO

-- =====================================================
-- VERIFICATION QUERIES
-- =====================================================

-- to Check the employee count
SELECT 'Total Employees' AS Description, COUNT(*) AS Count FROM Employee
UNION ALL
SELECT 'Active Employees', COUNT(*) FROM Employee WHERE Status = 'Active'
UNION ALL
SELECT 'Departments', COUNT(*) FROM Department
UNION ALL
SELECT 'Positions', COUNT(*) FROM Position;
GO

-- to Check for the department distribution
SELECT 
    d.DepartmentName,
    COUNT(e.EmployeeID) AS EmployeeCount
FROM Department d
LEFT JOIN Employee e ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName
ORDER BY EmployeeCount DESC;
GO
-- Runing checks for common data issues


-- =====================================================
-- CORRECTED VERIFICATION SECTION
-- =====================================================

-- Check employee count
SELECT 'Total Employees' AS Description, COUNT(*) AS Count FROM Employee
UNION ALL
SELECT 'Active Employees', COUNT(*) FROM Employee WHERE Status = 'Active'
UNION ALL
SELECT 'Departments', COUNT(*) FROM Department
UNION ALL
SELECT 'Positions', COUNT(*) FROM Position;
GO

-- Check department distribution
SELECT 
    d.DepartmentName,
    COUNT(e.EmployeeID) AS EmployeeCount
FROM Department d
LEFT JOIN Employee e ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName
ORDER BY EmployeeCount DESC;
GO

-- Check for any data issues (FIXED VERSION)
SELECT 
    'Employees without Department' AS Issue,
    COUNT(*) AS IssueCount
FROM Employee 
WHERE DepartmentID IS NULL

--UNION ALL

SELECT 
    'Employees without Position' AS Issue,
    COUNT(*) AS IssueCount
FROM Employee 
WHERE PositionID IS NULL

--UNION ALL

-- Check department distribution
SELECT 
    d.DepartmentName,
    COUNT(e.EmployeeID) AS EmployeeCount
FROM Department d
LEFT JOIN Employee e ON d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName
ORDER BY EmployeeCount DESC;
GO

-- Check for duplicate emails (CORRECTED VERSION)
SELECT 
    'Duplicate Emails' AS Issue,
    COUNT(*) AS IssueCount
FROM (
    SELECT Email
    FROM Employee
    GROUP BY Email
    HAVING COUNT(*) > 1
) AS Duplicates;
GO



-- Compute summary counts into variables and print a summary report
DECLARE 
    @TotalEmployees INT,
    @TotalDepartments INT,
    @TotalPositions INT,
    @ActiveEmployees INT,
    @EmployeesWithoutDept INT,
    @EmployeesWithoutPosition INT,
    @DuplicateEmails INT;

SELECT @TotalEmployees = COUNT(*) FROM Employee;
SELECT @TotalDepartments = COUNT(*) FROM Department;
SELECT @TotalPositions = COUNT(*) FROM Position;
SELECT @ActiveEmployees = COUNT(*) FROM Employee WHERE Status = 'Active';
SELECT @EmployeesWithoutDept = COUNT(*) FROM Employee WHERE DepartmentID IS NULL;
SELECT @EmployeesWithoutPosition = COUNT(*) FROM Employee WHERE PositionID IS NULL;
SELECT @DuplicateEmails = COUNT(*) 
FROM (
    SELECT Email
    FROM Employee
    GROUP BY Email
    HAVING COUNT(*) > 1
) AS Dups;

--  the summary (like select from above like line 742 up to 778)
PRINT '=====================================================';
PRINT 'Cadila Pharmaceuticals Gelan Database Setup Complete';
PRINT '=====================================================';
PRINT 'Total Employees Inserted: ' + CAST(@TotalEmployees AS VARCHAR(10));
PRINT 'Active Employees: ' + CAST(@ActiveEmployees AS VARCHAR(10));
PRINT 'Total Departments: ' + CAST(@TotalDepartments AS VARCHAR(10));
PRINT 'Total Positions: ' + CAST(@TotalPositions AS VARCHAR(10));
PRINT 'Employees without Department: ' + CAST(@EmployeesWithoutDept AS VARCHAR(10));
PRINT 'Employees without Position: ' + CAST(@EmployeesWithoutPosition AS VARCHAR(10));
PRINT 'Duplicate Emails (count of duplicated email values): ' + CAST(@DuplicateEmails AS VARCHAR(10));
PRINT 'Location: Gelan Industrial Zone, Addis Ababa, Ethiopia';
PRINT '=====================================================';
GO

-- quix-fixes i did for the data issues that might/migh not occur

-- List employees missing department:
PRINT '=== Employees without Department Assignment ===';
SELECT 
    EmployeeID,
    FullName,
    Email,
    'Missing Department' AS Issue
FROM Employee
WHERE DepartmentID IS NULL;

-- List employees missing position:
PRINT '=== Employees without Position Assignment ===';
SELECT 
    EmployeeID,
    FullName,
    Email,
    'Missing Position' AS Issue
FROM Employee
WHERE PositionID IS NULL;

-- Show duplicated email values and the employees:
PRINT '=== Duplicate Emails Found ===';
SELECT 
    e.EmployeeID,
    e.FullName,
    e.Email,
    'Duplicate Email' AS Issue
FROM Employee e
WHERE e.Email IN (
    SELECT Email
    FROM Employee
    GROUP BY Email
    HAVING COUNT(*) > 1
)
ORDER BY e.Email, e.EmployeeID;
GO

-- =====================================================
-- ADDITIONAL DATA INTEGRITY CHECKS
-- =====================================================

-- Check for employees with invalid manager references
PRINT '=== Employees with Invalid Manager References ===';
SELECT 
    e.EmployeeID,
    e.FullName,
    e.ManagerID,
    'Invalid Manager ID' AS Issue
FROM Employee e
WHERE e.ManagerID IS NOT NULL 
AND e.ManagerID NOT IN (SELECT EmployeeID FROM Employee);
GO

-- Check for employees with invalid department references
PRINT '=== Employees with Invalid Department References ===';
SELECT 
    e.EmployeeID,
    e.FullName,
    e.DepartmentID,
    'Invalid Department ID' AS Issue
FROM Employee e
WHERE e.DepartmentID IS NOT NULL 
AND e.DepartmentID NOT IN (SELECT DepartmentID FROM Department);
GO

-- Check for employees with invalid position references
PRINT '=== Employees with Invalid Position References ===';
SELECT 
    e.EmployeeID,
    e.FullName,
    e.PositionID,
    'Invalid Position ID' AS Issue
FROM Employee e
WHERE e.PositionID IS NOT NULL 
AND e.PositionID NOT IN (SELECT PositionID FROM Position);
GO

-- Check salary ranges against position minimum/maximum

PRINT '=== Employees with Salaries Outside Position Range ===';
SELECT 
    e.EmployeeID,
    e.FullName,
    e.JobTitle,
    e.Salary,
    p.Title AS PositionTitle,
    p.MinimumSalary,
    p.MaximumSalary,
    CASE 
        WHEN e.Salary < p.MinimumSalary THEN 'Below Minimum'
        WHEN e.Salary > p.MaximumSalary THEN 'Above Maximum'
    END AS Issue
FROM Employee e
JOIN Position p ON e.PositionID = p.PositionID
WHERE e.Salary < p.MinimumSalary OR e.Salary > p.MaximumSalary;
GO

-- Check for future hire dates
PRINT '=== Employees with Future Hire Dates ===';
SELECT 
    EmployeeID,
    FullName,
    HireDate,
    'Future Hire Date' AS Issue
FROM Employee
WHERE HireDate > GETDATE();
GO

-- Check for invalid birth dates (too old or future)
PRINT '=== Employees with Invalid Birth Dates ===';
SELECT 
    EmployeeID,
    FullName,
    DateOfBirth,
    CASE 
        WHEN DateOfBirth > GETDATE() THEN 'Future Birth Date'
        WHEN DATEDIFF(YEAR, DateOfBirth, GETDATE()) > 100 THEN 'Over 100 Years Old'
        WHEN DATEDIFF(YEAR, DateOfBirth, GETDATE()) < 18 THEN 'Under 18 Years Old'
    END AS Issue
FROM Employee
WHERE DateOfBirth > GETDATE() 
   OR DATEDIFF(YEAR, DateOfBirth, GETDATE()) > 100
   OR DATEDIFF(YEAR, DateOfBirth, GETDATE()) < 18;
GO

-- Check for missing essential information
PRINT '=== Employees Missing Essential Information ===';
SELECT 
    EmployeeID,
    FullName,
    Email,
    CASE 
        WHEN PhoneNumber IS NULL THEN 'Missing Phone'
        WHEN Address IS NULL THEN 'Missing Address'
        WHEN EmergencyContact IS NULL THEN 'Missing Emergency Contact'
        WHEN EmergencyPhone IS NULL THEN 'Missing Emergency Phone'
    END AS MissingInfo
FROM Employee
WHERE PhoneNumber IS NULL 
   OR Address IS NULL 
   OR EmergencyContact IS NULL 
   OR EmergencyPhone IS NULL;
GO

-- =====================================================
-- DATABASE SUMMARY REPORT
-- =====================================================

PRINT '=====================================================';
PRINT 'DATABASE SUMMARY REPORT';
PRINT '=====================================================';
PRINT '';

-- Department Summary
PRINT 'DEPARTMENT SUMMARY:';
SELECT 
    d.DepartmentName,
    COUNT(e.EmployeeID) AS EmployeeCount,
    FORMAT(AVG(e.Salary), 'C', 'en-US') AS AvgSalary,
    FORMAT(MIN(e.Salary), 'C', 'en-US') AS MinSalary,
    FORMAT(MAX(e.Salary), 'C', 'en-US') AS MaxSalary
FROM Department d
LEFT JOIN Employee e ON d.DepartmentID = e.DepartmentID 
    AND e.Status = 'Active'
GROUP BY d.DepartmentName, d.DepartmentID
ORDER BY EmployeeCount DESC;
PRINT '';

-- Position Level Summary
PRINT 'POSITION LEVEL SUMMARY:';
SELECT 
    p.LevelName,
    COUNT(e.EmployeeID) AS EmployeeCount,
    FORMAT(AVG(e.Salary), 'C', 'en-US') AS AvgSalary
FROM Position p
LEFT JOIN Employee e ON p.PositionID = e.PositionID 
    AND e.Status = 'Active'
GROUP BY p.LevelName
ORDER BY 
    CASE p.LevelName
        WHEN 'Director' THEN 1
        WHEN 'Manager' THEN 2
        WHEN 'Lead' THEN 3
        WHEN 'Senior' THEN 4
        WHEN 'Mid' THEN 5
        WHEN 'Junior' THEN 6
        ELSE 7
    END;
PRINT '';

-- Gender Distribution
PRINT 'GENDER DISTRIBUTION:';
SELECT 
    Gender,
    COUNT(*) AS Count,
    FORMAT(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Employee WHERE Status = 'Active'), 'N1') + '%' AS Percentage
FROM Employee
WHERE Status = 'Active'
GROUP BY Gender;
PRINT '';

-- Employment Type Distribution
PRINT 'EMPLOYMENT TYPE DISTRIBUTION:';
SELECT 
    EmploymentType,
    COUNT(*) AS Count,
    FORMAT(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Employee WHERE Status = 'Active'), 'N1') + '%' AS Percentage
FROM Employee
WHERE Status = 'Active'
GROUP BY EmploymentType;
PRINT '';

-- Marital Status Distribution
PRINT 'MARITAL STATUS DISTRIBUTION:';
SELECT 
    MaritalStatus,
    COUNT(*) AS Count,
    FORMAT(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Employee), 'N1') + '%' AS Percentage
FROM Employee
GROUP BY MaritalStatus;
PRINT '';

-- Service Years Analysis
PRINT 'SERVICE YEARS ANALYSIS:';
WITH ServiceYears AS (
    SELECT 
        CASE 
            WHEN Years < 1 THEN 'Less than 1 year'
            WHEN Years BETWEEN 1 AND 3 THEN '1-3 years'
            WHEN Years BETWEEN 4 AND 7 THEN '4-7 years'
            WHEN Years BETWEEN 8 AND 15 THEN '8-15 years'
            ELSE 'More than 15 years'
        END AS ServiceRange,
        EmployeeID
    FROM (
        SELECT 
            EmployeeID,
            DATEDIFF(YEAR, HireDate, GETDATE()) AS Years
        FROM Employee
        WHERE Status = 'Active'
    ) AS T
)
SELECT 
    ServiceRange,
    COUNT(*) AS EmployeeCount,
    FORMAT(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Employee WHERE Status = 'Active'), 'N1') + '%' AS Percentage
FROM ServiceYears
GROUP BY ServiceRange
ORDER BY 
    CASE ServiceRange
        WHEN 'Less than 1 year' THEN 1
        WHEN '1-3 years' THEN 2
        WHEN '4-7 years' THEN 3
        WHEN '8-15 years' THEN 4
        ELSE 5
    END;
PRINT '';

-- Age Distribution
PRINT 'AGE DISTRIBUTION:';
WITH AgeGroups AS (
    SELECT 
        CASE 
            WHEN Age < 25 THEN 'Under 25'
            WHEN Age BETWEEN 25 AND 34 THEN '25-34'
            WHEN Age BETWEEN 35 AND 44 THEN '35-44'
            WHEN Age BETWEEN 45 AND 54 THEN '45-54'
            WHEN Age >= 55 THEN '55+'
        END AS AgeGroup,
        EmployeeID
    FROM (
        SELECT 
            EmployeeID,
            DATEDIFF(YEAR, DateOfBirth, GETDATE()) AS Age
        FROM Employee
        WHERE Status = 'Active' AND DateOfBirth IS NOT NULL
    ) AS T
)
SELECT 
    AgeGroup,
    COUNT(*) AS EmployeeCount,
    FORMAT(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Employee WHERE Status = 'Active' AND DateOfBirth IS NOT NULL), 'N1') + '%' AS Percentage
FROM AgeGroups
GROUP BY AgeGroup
ORDER BY 
    CASE AgeGroup
        WHEN 'Under 25' THEN 1
        WHEN '25-34' THEN 2
        WHEN '35-44' THEN 3
        WHEN '45-54' THEN 4
        ELSE 5
    END;
PRINT '';

-- Top 10 Highest Paid Employees
PRINT 'TOP 10 HIGHEST PAID EMPLOYEES:';
SELECT TOP 10
    e.FullName,
    d.DepartmentName,
    e.JobTitle,
    p.LevelName,
    FORMAT(e.Salary, 'C', 'en-US') AS Salary,
    e.HireDate
FROM Employee e
JOIN Department d ON e.DepartmentID = d.DepartmentID
JOIN Position p ON e.PositionID = p.PositionID
WHERE e.Status = 'Active'
ORDER BY e.Salary DESC;
PRINT '';

-- Top 10 Longest Serving Employees
PRINT 'TOP 10 LONGEST SERVING EMPLOYEES:';
SELECT TOP 10
    e.FullName,
    d.DepartmentName,
    e.JobTitle,
    e.HireDate,
    DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsOfService,
    FORMAT(e.Salary, 'C', 'en-US') AS CurrentSalary
FROM Employee e
JOIN Department d ON e.DepartmentID = d.DepartmentID
WHERE e.Status = 'Active'
ORDER BY e.HireDate ASC;
PRINT '';

-- Monthly Salary Expenditure
PRINT 'MONTHLY SALARY EXPENDITURE:';
SELECT 
    FORMAT(SUM(Salary), 'C', 'en-US') AS TotalMonthlySalary,
    FORMAT(AVG(Salary), 'C', 'en-US') AS AverageSalary,
    COUNT(*) AS TotalEmployees
FROM Employee
WHERE Status = 'Active';
PRINT '';

PRINT '=====================================================';
PRINT 'ALL CHECKS COMPLETED SUCCESSFULLY!';
PRINT 'Database is ready for use.';
PRINT '=====================================================';
GO

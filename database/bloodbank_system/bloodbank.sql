--Section-1 
--Q-1: Create a database named 'BloodBankDB'
CREATE DATABASE BloodBankDB;
--Q-2
USE BloodBankDB;
--Q-3
CREATE DATABASE BloodBankDB_Backup;
--Q-4
USE BloodBankDB;
--Q-5
ALTER DATABASE BloodBankDB SET RECOVERY FULL;

--Section-2
--Q-6
CREATE TABLE BloodGroups (
    BloodGroupID INT IDENTITY(1,1) PRIMARY KEY,
    BloodType VARCHAR(5) NOT NULL,
    RhFactor CHAR(1) NOT NULL
);
--Q-7
CREATE TABLE Donors (
    DonorID INT IDENTITY(1001,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Gender CHAR(1) NOT NULL,
    BloodGroupID INT FOREIGN KEY REFERENCES BloodGroups(BloodGroupID)
);
--Q-8
CREATE TABLE ContactInformation (
    ContactID INT IDENTITY(1,1) PRIMARY KEY,
    DonorID INT UNIQUE FOREIGN KEY REFERENCES Donors(DonorID),
    Phone VARCHAR(15) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Address VARCHAR(200),
    City VARCHAR(50),
    State VARCHAR(50),
    ZipCode VARCHAR(10)
);
--Q-9
CREATE TABLE MedicalStaff (
    StaffID INT IDENTITY(5001,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Position VARCHAR(50) NOT NULL,
    Specialization VARCHAR(100),
    HireDate DATE NOT NULL,
    Salary DECIMAL(10,2) CHECK (Salary > 0),
    IsActive BIT DEFAULT 1
);
--Q-10
CREATE TABLE Hospitals (
    HospitalID INT IDENTITY(2001,1) PRIMARY KEY,
    HospitalName VARCHAR(100) NOT NULL UNIQUE,
    Address VARCHAR(200) NOT NULL,
    City VARCHAR(50) NOT NULL,
    State VARCHAR(50) NOT NULL,
    Phone VARCHAR(15) NOT NULL,
    Email VARCHAR(100),
    EstablishedDate DATE,
    BedCapacity INT CHECK (BedCapacity > 0)
);

-- Q-11
CREATE TABLE Patients (
    PatientID INT IDENTITY(3001,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Gender CHAR(1) NOT NULL,
    BloodGroupID INT FOREIGN KEY REFERENCES BloodGroups(BloodGroupID),
    HospitalID INT FOREIGN KEY REFERENCES Hospitals(HospitalID),
    AdmissionDate DATETIME DEFAULT GETDATE(),
    IsEmergency BIT DEFAULT 0
);
-- Q-12
CREATE TABLE DonationCenters (
    CenterID INT IDENTITY(4001,1) PRIMARY KEY,
    CenterName VARCHAR(100) NOT NULL,
    Address VARCHAR(200) NOT NULL,
    City VARCHAR(50) NOT NULL,
    OperatingHours VARCHAR(50),
    Capacity INT CHECK (Capacity > 0),
    ManagerStaffID INT FOREIGN KEY REFERENCES MedicalStaff(StaffID)
);

-- Q-13
CREATE TABLE Appointments (
    AppointmentID INT IDENTITY(1,1) PRIMARY KEY,
    DonorID INT NOT NULL FOREIGN KEY REFERENCES Donors(DonorID),
    CenterID INT NOT NULL FOREIGN KEY REFERENCES DonationCenters(CenterID),
    AppointmentDate DATETIME NOT NULL,
    Status VARCHAR(20) CHECK (Status IN ('Scheduled', 'Completed', 'Cancelled', 'NoShow')) DEFAULT 'Scheduled',
    CreatedDate DATETIME DEFAULT GETDATE()
);

-- Q-14
CREATE TABLE DonorMedicalHistory (
    MedicalHistoryID INT IDENTITY(1,1) PRIMARY KEY,
    DonorID INT NOT NULL FOREIGN KEY REFERENCES Donors(DonorID),
    RecordDate DATE NOT NULL,
    Weight DECIMAL(5,2) CHECK (Weight > 0),
    BloodPressure VARCHAR(10),
    HemoglobinLevel DECIMAL(4,2) CHECK (HemoglobinLevel > 0),
    HasChronicIllness BIT DEFAULT 0,
    IsEligibleToDonate BIT DEFAULT 1,
    Notes TEXT
);

-- Q-15
CREATE TABLE BloodDonations (
    DonationID INT IDENTITY(10001,1) PRIMARY KEY,
    DonorID INT NOT NULL FOREIGN KEY REFERENCES Donors(DonorID),
    AppointmentID INT FOREIGN KEY REFERENCES Appointments(AppointmentID),
    StaffID INT NOT NULL FOREIGN KEY REFERENCES MedicalStaff(StaffID),
    CenterID INT NOT NULL FOREIGN KEY REFERENCES DonationCenters(CenterID),
    DonationDate DATETIME NOT NULL DEFAULT GETDATE(),
    BloodGroupID INT NOT NULL FOREIGN KEY REFERENCES BloodGroups(BloodGroupID),
    QuantityML INT CHECK (QuantityML BETWEEN 250 AND 500) DEFAULT 450,
    DonationType VARCHAR(20) CHECK (DonationType IN ('Whole Blood', 'Plasma', 'Platelets', 'Double Red Cells'))
);
--Section-3
-- Q-16
CREATE TABLE BloodInventory (
    InventoryID INT IDENTITY(20001,1) PRIMARY KEY,
    DonationID INT NOT NULL UNIQUE FOREIGN KEY REFERENCES BloodDonations(DonationID),
    BloodGroupID INT NOT NULL FOREIGN KEY REFERENCES BloodGroups(BloodGroupID),
    BloodComponent VARCHAR(30) CHECK (BloodComponent IN ('Whole Blood', 'RBC', 'Plasma', 'Platelets', 'Cryoprecipitate')),
    QuantityML INT CHECK (QuantityML > 0),
    CollectionDate DATE NOT NULL,
    ExpiryDate DATE NOT NULL,
    StorageLocation VARCHAR(50),
    Status VARCHAR(20) CHECK (Status IN ('Available', 'Reserved', 'Issued', 'Expired', 'Discarded')) DEFAULT 'Available'
);

-- Q-17
CREATE TABLE BloodTesting (
    TestID INT IDENTITY(30001,1) PRIMARY KEY,
    DonationID INT NOT NULL FOREIGN KEY REFERENCES BloodDonations(DonationID),
    TestDate DATETIME NOT NULL DEFAULT GETDATE(),
    TestedByStaffID INT NOT NULL FOREIGN KEY REFERENCES MedicalStaff(StaffID),
    HIV BIT DEFAULT 0,
    HepB BIT DEFAULT 0,
    HepC BIT DEFAULT 0,
    Syphilis BIT DEFAULT 0,
    Malaria BIT DEFAULT 0,
    TestResult VARCHAR(20) CHECK (TestResult IN ('Pass', 'Fail', 'Pending')) DEFAULT 'Pending',
    ResultDate DATETIME,
    Notes VARCHAR(500)
);

-- Q-18
CREATE TABLE BloodRequests (
    RequestID INT IDENTITY(40001,1) PRIMARY KEY,
    PatientID INT NOT NULL FOREIGN KEY REFERENCES Patients(PatientID),
    HospitalID INT NOT NULL FOREIGN KEY REFERENCES Hospitals(HospitalID),
    RequestedByStaffID INT NOT NULL FOREIGN KEY REFERENCES MedicalStaff(StaffID),
    BloodGroupID INT NOT NULL FOREIGN KEY REFERENCES BloodGroups(BloodGroupID),
    BloodComponent VARCHAR(30) NOT NULL,
    QuantityRequired INT CHECK (QuantityRequired > 0),
    RequestDate DATETIME DEFAULT GETDATE(),
    RequiredByDate DATETIME NOT NULL,
    Priority VARCHAR(20) CHECK (Priority IN ('Low', 'Medium', 'High', 'Critical')) DEFAULT 'Medium',
    Status VARCHAR(20) CHECK (Status IN ('Pending', 'Approved', 'Fulfilled', 'Cancelled')) DEFAULT 'Pending',
    Reason VARCHAR(200)
);

-- Q-19
CREATE TABLE BloodIssuance (
    IssuanceID INT IDENTITY(50001,1) PRIMARY KEY,
    RequestID INT NOT NULL FOREIGN KEY REFERENCES BloodRequests(RequestID),
    InventoryID INT NOT NULL FOREIGN KEY REFERENCES BloodInventory(InventoryID),
    IssuedByStaffID INT NOT NULL FOREIGN KEY REFERENCES MedicalStaff(StaffID),
    IssuedDate DATETIME DEFAULT GETDATE(),
    QuantityIssued INT CHECK (QuantityIssued > 0),
    ReceivedByStaffID INT,
    Notes VARCHAR(300)
);

-- Q-20
CREATE TABLE DonorBlacklist (
    BlacklistID INT IDENTITY(1,1) PRIMARY KEY,
    DonorID INT NOT NULL UNIQUE FOREIGN KEY REFERENCES Donors(DonorID),
    BlacklistDate DATE NOT NULL DEFAULT GETDATE(),
    Reason VARCHAR(500) NOT NULL,
    BlacklistedByStaffID INT NOT NULL FOREIGN KEY REFERENCES MedicalStaff(StaffID),
    IsPermanent BIT DEFAULT 0,
    ExpiryDate DATE
);

-- Q-21
CREATE TABLE Equipment (
    EquipmentID INT IDENTITY(6001,1) PRIMARY KEY,
    EquipmentName VARCHAR(100) NOT NULL,
    EquipmentType VARCHAR(50) NOT NULL,
    CenterID INT FOREIGN KEY REFERENCES DonationCenters(CenterID),
    PurchaseDate DATE,
    LastMaintenanceDate DATE,
    NextMaintenanceDate DATE,
    Status VARCHAR(20) CHECK (Status IN ('Operational', 'Under Maintenance', 'Out of Service')) DEFAULT 'Operational',
    Cost MONEY CHECK (Cost > 0)
);

-- Q-22
CREATE TABLE Notifications (
    NotificationID INT IDENTITY(1,1) PRIMARY KEY,
    DonorID INT FOREIGN KEY REFERENCES Donors(DonorID),
    NotificationType VARCHAR(30) CHECK (NotificationType IN ('Appointment Reminder', 'Eligibility', 'Blood Drive', 'Thank You', 'Emergency Request')),
    Message VARCHAR(500) NOT NULL,
    SentDate DATETIME DEFAULT GETDATE(),
    IsRead BIT DEFAULT 0,
    DeliveryMethod VARCHAR(20) CHECK (DeliveryMethod IN ('Email', 'SMS', 'Push', 'Phone'))
);

-- Q-23
CREATE TABLE BloodDrives (
    DriveID INT IDENTITY(7001,1) PRIMARY KEY,
    DriveName VARCHAR(100) NOT NULL,
    OrganizedBy VARCHAR(100),
    Location VARCHAR(200) NOT NULL,
    StartDate DATETIME NOT NULL,
    EndDate DATETIME NOT NULL,
    CoordinatorStaffID INT FOREIGN KEY REFERENCES MedicalStaff(StaffID),
    TargetDonations INT CHECK (TargetDonations > 0),
    ActualDonations INT DEFAULT 0 CHECK (ActualDonations >= 0),
    Status VARCHAR(20) CHECK (Status IN ('Planned', 'Active', 'Completed', 'Cancelled')) DEFAULT 'Planned'
);

-- Q-24
CREATE TABLE DonationIncentives (
    IncentiveID INT IDENTITY(1,1) PRIMARY KEY,
    DonationID INT NOT NULL FOREIGN KEY REFERENCES BloodDonations(DonationID),
    IncentiveType VARCHAR(50) CHECK (IncentiveType IN ('Certificate', 'Gift Card', 'TShirt', 'Meal Voucher', 'Tax Receipt')),
    IncentiveValue DECIMAL(10,2) DEFAULT 0,
    IssuedDate DATE DEFAULT GETDATE(),
    Description VARCHAR(200)
);

-- Q-25
CREATE TABLE AuditLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    TableName VARCHAR(50) NOT NULL,
    Operation VARCHAR(20) CHECK (Operation IN ('INSERT', 'UPDATE', 'DELETE')),
    PerformedByStaffID INT FOREIGN KEY REFERENCES MedicalStaff(StaffID),
    PerformedDate DATETIME DEFAULT GETDATE(),
    OldValue VARCHAR(MAX),
    NewValue VARCHAR(MAX),
    Description VARCHAR(500)
);

--Section-4
-- Q-26
SET IDENTITY_INSERT BloodGroups ON;

INSERT INTO BloodGroups (BloodGroupID, BloodType, RhFactor) VALUES
(1, 'A', '+'),
(2, 'A', '-'),
(3, 'B', '+'),
(4, 'B', '-'),
(5, 'AB', '+'),
(6, 'AB', '-'),
(7, 'O', '+'),
(8, 'O', '-');

SET IDENTITY_INSERT BloodGroups OFF;
-- Q-27
INSERT INTO MedicalStaff (FirstName, LastName, Position, Specialization, HireDate, Salary, IsActive) VALUES
('John', 'Smith', 'Doctor', 'Cardiology', '2015-03-10', 90000.00, 1),
('Emily', 'Davis', 'Nurse', 'Pediatrics', '2018-07-15', 60000.00, 1),
('Michael', 'Brown', 'Lab Technician', 'Blood Testing', '2020-01-20', 50000.00, 1),
('Sarah', 'Johnson', 'Doctor', 'Hematology', '2012-09-05', 95000.00, 1),
('David', 'Wilson', 'Nurse', 'Emergency Care', '2019-06-12', 62000.00, 1);

--Q-28
INSERT INTO Hospitals (HospitalName, Address, City, State, Phone, Email, EstablishedDate, BedCapacity) VALUES
('City Health Hospital', '123 Main St', 'New York', 'NY', '212-555-0101', 'contact@cityhealth.com', '1995-05-20', 250),
('Green Valley Medical Center', '456 Elm St', 'Los Angeles', 'CA', '310-555-0202', 'info@greenvalley.com', '2002-08-15', 300),
('Riverfront General Hospital', '789 River Rd', 'Chicago', 'IL', '312-555-0303', 'admin@riverfront.com', '1988-11-10', 200);
-- Q-29
INSERT INTO DonationCenters (CenterName, Address, City, OperatingHours, Capacity, ManagerStaffID) VALUES
('Downtown Blood Center', '101 Center St', 'New York', '09:00-18:00', 50, 5001),
('Westside Donation Hub', '202 West St', 'Los Angeles', '08:00-17:00', 40, 5002),
('Lakeside Donation Center', '303 Lake Ave', 'Chicago', '10:00-19:00', 60, 5003);
-- Q-30
INSERT INTO Donors (FirstName, LastName, DateOfBirth, Gender, BloodGroupID) VALUES
('Alice', 'Taylor', '1990-01-15', 'F', 1),
('Bob', 'Anderson', '1985-06-22', 'M', 3),
('Catherine', 'Moore', '1992-03-10', 'F', 5),
('Daniel', 'Thomas', '1988-11-30', 'M', 7),
('Evelyn', 'Martinez', '1995-05-25', 'F', 2),
('Frank', 'Harris', '1991-08-18', 'M', 4),
('Grace', 'Clark', '1987-12-05', 'F', 6),
('Henry', 'Lewis', '1989-02-28', 'M', 8),
('Isabella', 'Walker', '1993-09-12', 'F', 1),
('Jack', 'Hall', '1986-04-03', 'M', 7);
--Q-31
INSERT INTO ContactInformation (DonorID, Phone, Email, Address, City, State, ZipCode) VALUES
(1001, '212-555-1010', 'alice.taylor@email.com', '12 Park Ave', 'New York', 'NY', '10001'),
(1002, '212-555-1020', 'bob.anderson@email.com', '34 Oak St', 'Los Angeles', 'CA', '90001'),
(1003, '212-555-1030', 'catherine.moore@email.com', '56 Pine Rd', 'Chicago', 'IL', '60601'),
(1004, '212-555-1040', 'daniel.thomas@email.com', '78 Maple Ave', 'New York', 'NY', '10002'),
(1005, '212-555-1050', 'evelyn.martinez@email.com', '90 Cedar St', 'Los Angeles', 'CA', '90002');
--Q-32
-- 1. Drop the UNIQUE constraint
ALTER TABLE ContactInformation
DROP CONSTRAINT UQ__ContactI__A9D10534F7EB3EF0;

-- 2. Insert donors 6-10 without emails
INSERT INTO ContactInformation (DonorID, Phone, Address, City, State, ZipCode) VALUES
(1006, '212-555-1060', '11 Birch Rd', 'Chicago', 'IL', '60602'),
(1007, '212-555-1070', '22 Walnut St', 'New York', 'NY', '10003'),
(1008, '212-555-1080', '33 Chestnut Ave', 'Los Angeles', 'CA', '90003'),
(1009, '212-555-1090', '44 Spruce St', 'Chicago', 'IL', '60603'),
(1010, '212-555-1100', '55 Aspen Rd', 'New York', 'NY', '10004');

-- Q-33
INSERT INTO Appointments (DonorID, CenterID, AppointmentDate) VALUES
(1001, 4001, '2025-12-15 10:00'),
(1002, 4002, '2025-12-16 11:00'),
(1003, 4003, '2025-12-17 12:00'),
(1004, 4001, '2025-12-18 09:30'),
(1005, 4002, '2025-12-19 14:00');

-- Q-34
INSERT INTO DonorMedicalHistory (DonorID, RecordDate, Weight, BloodPressure, HemoglobinLevel, HasChronicIllness, IsEligibleToDonate, Notes) VALUES
(1001, '2025-12-01', 65.5, '120/80', 14.2, 0, 1, 'Healthy donor'),
(1002, '2025-12-02', 78.0, '130/85', 13.5, 0, 1, 'Regular donor'),
(1003, '2025-12-03', 58.2, '110/70', 12.8, 0, 1, 'No medical issues');

-- Q-35
INSERT INTO BloodDonations (DonorID, AppointmentID, StaffID, CenterID, DonationDate, BloodGroupID, DonationType) VALUES
(1001, 1, 5001, 4001, '2025-12-15', 1, 'Whole Blood'),
(1002, 2, 5002, 4002, '2025-12-16', 3, 'Plasma'),
(1003, 3, 5003, 4003, '2025-12-17', 5, 'Platelets'),
(1004, 4, 5004, 4001, '2025-12-18', 7, 'Whole Blood'),
(1005, 5, 5005, 4002, '2025-12-19', 2, 'Double Red Cells');

--Q-36
INSERT INTO Patients (FirstName, LastName, DateOfBirth, Gender, BloodGroupID, HospitalID, IsEmergency) VALUES
('Liam', 'King', '1982-02-10', 'M', 1, 2001, 0),
('Mia', 'Scott', '1990-07-15', 'F', 3, 2002, 1),
('Noah', 'Green', '1985-09-20', 'M', 5, 2003, 0),
('Olivia', 'Adams', '1992-03-05', 'F', 7, 2001, 1),
('Ethan', 'Baker', '1988-12-12', 'M', 2, 2002, 0);

-- Q-37
ALTER TABLE BloodInventory
DROP CONSTRAINT UQ__BloodInv__C5082EDAF3E7C09F;

INSERT INTO BloodInventory (DonationID, BloodGroupID, BloodComponent, QuantityML, CollectionDate, ExpiryDate, StorageLocation, Status) VALUES
(10001, 1, 'Whole Blood', 450, '2025-12-15', DATEADD(DAY,42,'2025-12-15'), 'Freezer A1', 'Available'),
(10001, 1, 'Plasma', 450, '2025-12-15', DATEADD(YEAR,1,'2025-12-15'), 'Freezer B1', 'Available'),
(10002, 3, 'Whole Blood', 450, '2025-12-16', DATEADD(DAY,42,'2025-12-16'), 'Freezer A2', 'Available'),
(10002, 3, 'RBC', 450, '2025-12-16', DATEADD(DAY,42,'2025-12-16'), 'Freezer B2', 'Available'),
(10003, 5, 'Platelets', 450, '2025-12-17', DATEADD(DAY,5,'2025-12-17'), 'Fridge C1', 'Available'),
(10003, 5, 'Cryoprecipitate', 450, '2025-12-17', DATEADD(DAY,365,'2025-12-17'), 'Freezer C1', 'Available'),
(10004, 7, 'Whole Blood', 450, '2025-12-18', DATEADD(DAY,42,'2025-12-18'), 'Freezer A3', 'Available'),
(10004, 7, 'Platelets', 450, '2025-12-18', DATEADD(DAY,5,'2025-12-18'), 'Fridge C2', 'Available'),
(10005, 2, 'RBC', 450, '2025-12-19', DATEADD(DAY,42,'2025-12-19'), 'Freezer B3', 'Available'),
(10005, 2, 'Plasma', 450, '2025-12-19', DATEADD(YEAR,1,'2025-12-19'), 'Freezer B4', 'Available');

--Q-38
INSERT INTO BloodTesting (DonationID, TestedByStaffID, HIV, HepB, HepC, Syphilis, Malaria, TestResult, ResultDate, Notes) VALUES
(10001, 5003, 0, 0, 0, 0, 0, 'Pass', '2025-12-15', 'All tests cleared'),
(10002, 5003, 0, 0, 0, 0, 0, 'Pass', '2025-12-16', 'All tests cleared'),
(10003, 5003, 0, 0, 0, 0, 0, 'Pass', '2025-12-17', 'All tests cleared'),
(10004, 5003, 0, 0, 0, 0, 0, 'Pass', '2025-12-18', 'All tests cleared'),
(10005, 5003, 0, 1, 0, 0, 0, 'Fail', '2025-12-19', 'Hepatitis B positive');

--Q-39
INSERT INTO BloodRequests (PatientID, HospitalID, RequestedByStaffID, BloodGroupID, BloodComponent, QuantityRequired, RequiredByDate, Priority, Reason) VALUES
(3001, 2001, 5001, 1, 'Whole Blood', 450, '2025-12-20', 'High', 'Surgery'),
(3002, 2002, 5002, 3, 'Plasma', 300, '2025-12-21', 'Critical', 'Trauma Case'),
(3003, 2003, 5003, 5, 'Platelets', 200, '2025-12-22', 'Medium', 'Cancer Treatment'),
(3004, 2001, 5004, 7, 'RBC', 500, '2025-12-23', 'High', 'Blood Loss'),
(3005, 2002, 5005, 2, 'Plasma', 350, '2025-12-24', 'Low', 'Routine transfusion');

SELECT InventoryID, BloodComponent, QuantityML, Status
FROM BloodInventory
WHERE Status = 'Available';


--Q-40
INSERT INTO BloodIssuance (RequestID, InventoryID, IssuedByStaffID, QuantityIssued, ReceivedByStaffID, Notes) VALUES
(40001, 20007, 5001, 450, 5002, 'Issued successfully'),
(40002, 20008, 5002, 300, 5003, 'Issued successfully'),
(40003, 20009, 5003, 200, 5004, 'Issued successfully');

--Section-5
--Q-41
INSERT INTO DonorBlacklist (DonorID, BlacklistDate, Reason, BlacklistedByStaffID, IsPermanent, ExpiryDate) VALUES
(1001, GETDATE(), 'Tested positive for infection', 5001, 1, NULL),  -- Permanent
(1002, GETDATE(), 'Temporary health issue', 5002, 0, DATEADD(MONTH, 6, GETDATE()));  -- Temporary, 6 months expiry

-- Q-42
INSERT INTO Equipment (EquipmentName, EquipmentType, CenterID, PurchaseDate, LastMaintenanceDate, NextMaintenanceDate, Status, Cost) VALUES
('Centrifuge Model X', 'Centrifuge', 4001, '2023-01-15', '2025-06-01', '2026-06-01', 'Operational', 5000),
('Refrigerator Model A', 'Refrigerator', 4002, '2022-03-20', '2025-07-10', '2026-07-10', 'Operational', 3000),
('Blood Testing Machine', 'Testing Machine', 4003, '2024-02-12', '2025-08-05', '2026-08-05', 'Operational', 8000),
('Plasma Freezer', 'Freezer', 4001, '2023-11-05', '2025-09-01', '2026-09-01', 'Under Maintenance', 4500),
('Sterilizer Unit', 'Sterilizer', 4002, '2021-07-18', '2025-05-20', '2026-05-20', 'Operational', 2000);

-- Q-43
INSERT INTO Notifications (DonorID, NotificationType, Message, DeliveryMethod) VALUES
(1001, 'Appointment Reminder', 'Your appointment is scheduled for tomorrow.', 'SMS'),
(1002, 'Eligibility', 'You are eligible to donate again.', 'Email'),
(1003, 'Blood Drive', 'Join our upcoming blood drive event.', 'Push'),
(1004, 'Thank You', 'Thank you for your recent donation!', 'Email'),
(1005, 'Emergency Request', 'Urgent request: O+ blood needed.', 'SMS'),
(1006, 'Appointment Reminder', 'Reminder: donation tomorrow.', 'Push'),
(1007, 'Eligibility', 'You can donate again in 8 weeks.', 'Email'),
(1008, 'Blood Drive', 'Participate in our city-wide donation drive.', 'SMS'),
(1009, 'Thank You', 'We appreciate your support!', 'Push'),
(1010, 'Emergency Request', 'Critical blood needed at nearby hospital.', 'Email');

--Q-44
INSERT INTO BloodDrives (DriveName, OrganizedBy, Location, StartDate, EndDate, CoordinatorStaffID, TargetDonations, ActualDonations, Status) VALUES
('Winter Blood Drive', 'City Health Hospital', 'Community Hall, New York', '2025-01-10', '2025-01-15', 5001, 200, 210, 'Completed'),
('Spring Blood Drive', 'Green Valley Medical Center', 'Downtown Plaza, Los Angeles', '2026-03-01', '2026-03-05', 5002, 300, 0, 'Planned');

-- Q-45
INSERT INTO DonationIncentives (DonationID, IncentiveType, IncentiveValue, Description) VALUES
(10001, 'Certificate', 0, 'Certificate of appreciation for donation.'),
(10002, 'Gift Card', 25.00, 'Gift card for participation in donation.'),
(10003, 'Meal Voucher', 15.00, 'Meal voucher after donation.');

--Q-46
INSERT INTO AuditLog (TableName, Operation, PerformedByStaffID, OldValue, NewValue, Description) VALUES
('Donors', 'INSERT', 5001, NULL, 'DonorID=1011, Name=Sam Green', 'New donor added'),
('BloodDonations', 'UPDATE', 5002, 'QuantityML=450', 'QuantityML=500', 'Donation quantity updated'),
('BloodInventory', 'DELETE', 5003, 'InventoryID=20005', NULL, 'Removed expired blood unit'),
('MedicalStaff', 'UPDATE', 5004, 'Salary=60000', 'Salary=65000', 'Staff salary updated'),
('Patients', 'INSERT', 5005, NULL, 'PatientID=3010, Name=Anna Lee', 'New patient registered');

--Q-47
INSERT INTO Donors (FirstName, LastName, DateOfBirth, Gender, BloodGroupID) VALUES
('Lara', 'Mitchell', '1994-05-10', 'F', 1),
('Tom', 'Evans', '1987-11-20', 'M', 3),
('Nina', 'Parker', '1991-08-15', 'F', 5),
('Ryan', 'Campbell', '1989-12-25', 'M', 7),
('Olga', 'Reed', '1992-04-05', 'F', 2);

-- Q-48
INSERT INTO Appointments (DonorID, CenterID, AppointmentDate, Status) VALUES
(1011, 4001, '2025-11-01 10:00', 'Completed'),
(1012, 4002, '2025-11-02 11:30', 'Completed'),
(1013, 4003, '2025-11-03 09:00', 'Completed');

-- Q-49
INSERT INTO BloodInventory (DonationID, BloodGroupID, BloodComponent, QuantityML, CollectionDate, ExpiryDate, StorageLocation, Status) VALUES
(10004, 7, 'Platelets', 450, '2025-01-01', '2025-01-06', 'Fridge C2', 'Expired'),
(10005, 2, 'RBC', 450, '2025-02-01', '2025-03-15', 'Freezer B3', 'Expired'),
(10003, 5, 'Cryoprecipitate', 450, '2024-12-01', '2025-01-01', 'Freezer C1', 'Expired');

-- Q-50
INSERT INTO BloodRequests 
(PatientID, HospitalID, RequestedByStaffID, BloodGroupID, BloodComponent, QuantityRequired, RequiredByDate, Priority, Reason) 
VALUES
(3002, 2002, 5002, 3, 'RBC', 500, '2025-12-20', 'Critical', 'Emergency transfusion for accident');

--Section-6
-- Q-51
ALTER TABLE Donors
ADD LastDonationDate DATE NULL;

-- Q-52
ALTER TABLE Donors
ADD TotalDonations INT DEFAULT 0;

-- Q-53
ALTER TABLE Hospitals
ADD AccreditationStatus VARCHAR(30) DEFAULT 'Accredited';

-- Q-54
ALTER TABLE BloodInventory
ADD Temperature DECIMAL(4,2);

-- Q-55
ALTER TABLE MedicalStaff
ADD LicenseNumber VARCHAR(50) NULL;

-- Create a unique index only for non-NULL values
CREATE UNIQUE INDEX UQ_MedicalStaff_LicenseNumber
ON MedicalStaff(LicenseNumber)
WHERE LicenseNumber IS NOT NULL;


-- Q-56: Modify Phone column in ContactInformation to VARCHAR(20)
ALTER TABLE ContactInformation
ALTER COLUMN Phone VARCHAR(20);

-- Q-57: Add CHECK constraint on Gender in Patients
ALTER TABLE Patients
ADD CONSTRAINT CHK_Patients_Gender CHECK (Gender IN ('M','F','O'));

-- Q-58: Add DonorConsentForm to BloodDonations
ALTER TABLE BloodDonations
ADD DonorConsentForm BIT DEFAULT 0;

-- Q-59: Add Website to Hospitals
ALTER TABLE Hospitals
ADD Website VARCHAR(100);

-- Q-60: Add EmailContact to DonationCenters
ALTER TABLE DonationCenters
ADD EmailContact VARCHAR(100);

--Section-7
-- Q-61
UPDATE Donors
SET LastDonationDate = GETDATE()
WHERE DonorID = 1001;

-- Q-62
UPDATE Donors
SET LastDonationDate = CAST(GETDATE() AS DATE)
WHERE DonorID = 1001;

-- Q-63
UPDATE MedicalStaff
SET Salary = Salary * 1.05;

--Q-64
UPDATE Appointments
SET Status = 'Completed'
WHERE AppointmentID = 1;

-- Q-65
UPDATE BloodInventory
SET Status = 'Expired'
WHERE ExpiryDate < GETDATE();

-- Q-66
UPDATE BloodRequests
SET Status = 'Fulfilled',
    Priority = 'Low'
WHERE RequestID = 40001;

-- Q-67
UPDATE Patients
SET IsEmergency = 1
WHERE AdmissionDate >= DATEADD(DAY, -1, GETDATE());

-- Q-68
UPDATE ContactInformation
SET Email = 'newemail@example.com',
    Phone = '555-999-8888'
WHERE DonorID = 1002;

-- Q-69
UPDATE Equipment
SET NextMaintenanceDate = DATEADD(MONTH, 6, LastMaintenanceDate);

-- Q-70
UPDATE BloodDrives
SET ActualDonations = 25
WHERE Status = 'Completed';

--Section-8
-- Q-71
SELECT * 
FROM Donors;

-- Q-72
SELECT * 
FROM BloodGroups;

-- Q-73
SELECT FirstName, LastName
FROM Donors;

-- Q-74
SELECT DonationID, DonationDate, QuantityML
FROM BloodDonations;

-- Q-75
SELECT *
FROM Donors
WHERE BloodGroupID = 1;

-- Q-76
SELECT *
FROM Patients
WHERE IsEmergency = 1;

-- Q-77
SELECT DonorID, FirstName, LastName, DateOfBirth
FROM Donors
WHERE Gender = 'F';

-- Q-78
SELECT *
FROM BloodInventory
WHERE Status = 'Available';

-- Q-79
SELECT *
FROM Appointments
WHERE Status = 'Scheduled';

-- Q-80
SELECT HospitalName, City
FROM Hospitals
WHERE State = 'CA';

-- Q-81
SELECT DISTINCT BloodGroupID
FROM Donors;

-- Q-82
SELECT DISTINCT City
FROM Hospitals;

-- Q-83
SELECT COUNT(*) AS TotalDonors
FROM Donors;

-- Q-84
SELECT COUNT(*) AS TotalDonations
FROM BloodDonations;

-- Q-85
SELECT COUNT(*) AS AvailableUnits
FROM BloodInventory
WHERE Status = 'Available';

--Section-9
-- Q-86
SELECT * 
FROM Donors
ORDER BY LastName ASC;

-- Q-87
SELECT *
FROM BloodDonations
ORDER BY DonationDate DESC;

-- Q-88
SELECT *
FROM Patients
ORDER BY AdmissionDate DESC;

-- Q-89
SELECT FirstName, LastName
FROM Donors
WHERE BloodGroupID = 1 AND Gender = 'M';

-- Q-90
SELECT *
FROM BloodRequests
WHERE Priority IN ('Critical', 'High');

-- Q-91
SELECT *
FROM Appointments
WHERE Status <> 'Cancelled';

-- Q-92
SELECT *
FROM Donors
WHERE BloodGroupID = 7 AND Gender = 'F'
ORDER BY LastName;

-- Q-93
SELECT *
FROM BloodInventory
WHERE Status IN ('Available', 'Reserved')
ORDER BY ExpiryDate ASC;

-- Q-94
SELECT *
FROM MedicalStaff
WHERE IsActive = 1 AND Salary > 50000
ORDER BY Salary DESC;

-- Q-95
SELECT FirstName, LastName, DateOfBirth
FROM Donors
WHERE DateOfBirth > '1990-01-01'
ORDER BY DateOfBirth;

-- Q-96
SELECT *
FROM BloodRequests
WHERE Status = 'Pending' AND Priority IN ('High', 'Critical')
ORDER BY RequestDate;

-- Q-97
SELECT DISTINCT BloodComponent
FROM BloodInventory
WHERE Status = 'Available';

-- Q-98
SELECT COUNT(*) AS TotalDoctors
FROM MedicalStaff
WHERE Position = 'Doctor';



-- Q-99
SELECT HospitalName, City, BedCapacity
FROM Hospitals
WHERE BedCapacity > 100
ORDER BY BedCapacity DESC;

-- Q-100
SELECT *
FROM Donors
WHERE LastDonationDate IS NULL OR LastDonationDate < DATEADD(MONTH, -3, GETDATE());

--Section-10
-- Q-101
SELECT TOP 5 DonationID, DonorID, DonationDate, QuantityML
FROM BloodDonations
ORDER BY DonationDate DESC;

-- Q-102
SELECT BG.BloodType, BG.RhFactor, COUNT(D.DonorID) AS TotalDonors
FROM BloodGroups BG
LEFT JOIN Donors D ON BG.BloodGroupID = D.BloodGroupID
GROUP BY BG.BloodType, BG.RhFactor;

-- Q-103
SELECT DC.CenterName, COUNT(A.AppointmentID) AS TotalAppointments
FROM DonationCenters DC
LEFT JOIN Appointments A ON DC.CenterID = A.CenterID
GROUP BY DC.CenterName;

-- Q-104
SELECT BloodGroupID, SUM(QuantityML) AS TotalQuantityML
FROM BloodInventory
GROUP BY BloodGroupID;

-- Q-105
SELECT Position, AVG(Salary) AS AverageSalary
FROM MedicalStaff
GROUP BY Position;

-- Q-106
SELECT D.FirstName, D.LastName, BG.BloodType, BG.RhFactor
FROM Donors D
JOIN BloodGroups BG ON D.BloodGroupID = BG.BloodGroupID;

-- Q-107
SELECT BD.DonationID, D.FirstName, D.LastName, BG.BloodType, BD.DonationDate
FROM BloodDonations BD
JOIN Donors D ON BD.DonorID = D.DonorID
JOIN BloodGroups BG ON BD.BloodGroupID = BG.BloodGroupID;

-- Q-108
SELECT A.AppointmentID, D.FirstName, D.LastName, DC.CenterName, A.AppointmentDate, A.Status
FROM Appointments A
JOIN Donors D ON A.DonorID = D.DonorID
JOIN DonationCenters DC ON A.CenterID = DC.CenterID;

-- Q-109
SELECT BR.*, P.FirstName AS PatientFirstName, P.LastName AS PatientLastName,
       H.HospitalName, H.City, H.State
FROM BloodRequests BR
JOIN Patients P ON BR.PatientID = P.PatientID
JOIN Hospitals H ON BR.HospitalID = H.HospitalID;

-- Q-110
SELECT BI.IssuanceID, P.FirstName AS PatientFirstName, P.LastName AS PatientLastName,
       H.HospitalName, BInv.BloodComponent, BI.QuantityIssued, BI.IssuedDate
FROM BloodIssuance BI
JOIN BloodRequests BR ON BI.RequestID = BR.RequestID
JOIN Patients P ON BR.PatientID = P.PatientID
JOIN Hospitals H ON BR.HospitalID = H.HospitalID
JOIN BloodInventory BInv ON BI.InventoryID = BInv.InventoryID;

-- Q-111
SELECT BloodComponent, SUM(QuantityML) AS TotalQuantity
FROM BloodInventory
WHERE Status = 'Available'
GROUP BY BloodComponent;

-- Q-112
SELECT DonorID, COUNT(DonationID) AS TotalDonations
FROM BloodDonations
GROUP BY DonorID
HAVING COUNT(DonationID) > 1;

-- Q-113
SELECT BloodGroupID, COUNT(*) AS DonorCount
FROM Donors
GROUP BY BloodGroupID
HAVING COUNT(*) > 2;

-- Q-114
SELECT BI.InventoryID, BG.BloodType, BI.BloodComponent, BI.QuantityML,
       BI.CollectionDate, BI.ExpiryDate
FROM BloodInventory BI
JOIN BloodDonations BD ON BI.DonationID = BD.DonationID
JOIN BloodGroups BG ON BD.BloodGroupID = BG.BloodGroupID
WHERE BI.Status = 'Expired';

-- Q-115
SELECT DC.CenterName, COUNT(BD.DonationID) AS TotalDonations
FROM DonationCenters DC
LEFT JOIN BloodDonations BD ON DC.CenterID = BD.CenterID
GROUP BY DC.CenterName
ORDER BY TotalDonations DESC;

--Section-11
-- Q-116
SELECT D.DonorID, D.FirstName, D.LastName
FROM Donors D
JOIN Appointments A ON D.DonorID = A.DonorID
LEFT JOIN BloodDonations BD ON D.DonorID = BD.DonorID
WHERE BD.DonorID IS NULL;

-- Q-117
SELECT *
FROM BloodRequests
WHERE Status <> 'Fulfilled';

-- Q-118
SELECT IncentiveType, SUM(IncentiveValue) AS TotalValue
FROM DonationIncentives
GROUP BY IncentiveType;

-- Q-119
SELECT D.DonorID, D.FirstName, D.LastName,
       COUNT(BD.DonationID) AS TotalDonations
FROM Donors D
LEFT JOIN BloodDonations BD ON D.DonorID = BD.DonorID
GROUP BY D.DonorID, D.FirstName, D.LastName;

-- Q-120
SELECT H.HospitalID, H.HospitalName,
       COUNT(P.PatientID) AS TotalPatients
FROM Hospitals H
LEFT JOIN Patients P ON H.HospitalID = P.HospitalID
GROUP BY H.HospitalID, H.HospitalName;

-- Q-121
SELECT *
FROM BloodInventory
WHERE ExpiryDate BETWEEN CAST(GETDATE() AS DATE)
                     AND DATEADD(DAY, 7, CAST(GETDATE() AS DATE));

-- Q-122
SELECT DonorID, FirstName, LastName, LastDonationDate
FROM Donors
WHERE LastDonationDate IS NULL
   OR LastDonationDate < DATEADD(DAY, -56, CAST(GETDATE() AS DATE));

-- Q-123
SELECT BG.BloodType, BG.RhFactor,
       SUM(BR.QuantityRequired) AS TotalRequested
FROM BloodRequests BR
JOIN BloodGroups BG ON BR.BloodGroupID = BG.BloodGroupID
GROUP BY BG.BloodType, BG.RhFactor
ORDER BY TotalRequested DESC;

-- Q-124
SELECT MS.StaffID, MS.FirstName, MS.LastName,
       COUNT(BD.DonationID) AS DonationsHandled
FROM MedicalStaff MS
JOIN BloodDonations BD ON MS.StaffID = BD.StaffID
GROUP BY MS.StaffID, MS.FirstName, MS.LastName
HAVING COUNT(BD.DonationID) > 2;

-- Q-125
SELECT D.DonorID, D.FirstName, D.LastName,
       BL.Reason, BL.BlacklistDate, BL.IsPermanent
FROM DonorBlacklist BL
JOIN Donors D ON BL.DonorID = D.DonorID;

--Section-12

-- Q-126
SELECT *
FROM Donors
WHERE BloodGroupID = (
    SELECT TOP 1 BloodGroupID
    FROM Donors
    GROUP BY BloodGroupID
    ORDER BY COUNT(*) DESC
);

-- Q-127
SELECT *
FROM BloodDonations
WHERE QuantityML > (
    SELECT AVG(QuantityML)
    FROM BloodDonations
);

-- Q-128
SELECT *
FROM Hospitals
WHERE HospitalID IN (
    SELECT HospitalID
    FROM Patients
    GROUP BY HospitalID
    HAVING COUNT(*) > (
        SELECT AVG(PatientCount)
        FROM (
            SELECT HospitalID, COUNT(*) AS PatientCount
            FROM Patients
            GROUP BY HospitalID
        ) AS T
    )
);

-- Q-129
SELECT *
FROM BloodRequests BR
WHERE RequiredByDate < (
    SELECT MIN(ExpiryDate)
    FROM BloodInventory
    WHERE BloodGroupID = BR.BloodGroupID
);

-- Q-130
SELECT *
FROM Donors
WHERE DonorID NOT IN (
    SELECT DonorID
    FROM BloodDonations
);

-- Q-131
SELECT *
FROM BloodGroups
WHERE BloodGroupID NOT IN (
    SELECT BloodGroupID
    FROM BloodRequests
);

-- Q-132
SELECT *
FROM BloodDonations BD
WHERE DonationDate = (
    SELECT MAX(DonationDate)
    FROM BloodDonations
    WHERE DonorID = BD.DonorID
);

-- Q-133
SELECT *
FROM BloodInventory BI
WHERE QuantityML > (
    SELECT AVG(QuantityML)
    FROM BloodInventory
    WHERE BloodComponent = BI.BloodComponent
);

-- Q-134
SELECT *
FROM MedicalStaff MS
WHERE Salary > (
    SELECT AVG(Salary)
    FROM MedicalStaff
    WHERE Position = MS.Position
);

-- Q-135: 
SELECT BD.*
FROM BloodDonations BD
WHERE BD.DonationID IN (
    SELECT DonationID
    FROM BloodTesting
    WHERE TestResult = 'Pass'
);

--Section-13
-- Q-136
--UPDATE BloodDonations 
--SET AppointmentID = NULL 
--WHERE AppointmentID = 1;

DELETE FROM Appointments WHERE AppointmentID = 1;
-- Q-137
DELETE FROM Notifications WHERE IsRead = 1;
-- Q-138
DELETE FROM BloodInventory 
WHERE Status = 'Expired' 
AND ExpiryDate < GETDATE();


-- Q-139
DELETE FROM Appointments WHERE Status = 'Cancelled';

-- Q-140
DELETE FROM BloodDrives WHERE DriveID = 7001;

-- Q-141
DELETE FROM AuditLog 
WHERE PerformedDate < DATEADD(YEAR, -1, GETDATE());

-- Q-142
DELETE FROM Equipment WHERE Status = 'Out of Service';

-- Q-143
DELETE FROM Notifications 
WHERE SentDate < DATEADD(DAY, -30, GETDATE());

-- Q-144
DELETE FROM DonationIncentives WHERE IncentiveID = 1;

-- Q-145
DELETE FROM BloodTesting 
WHERE TestResult = 'Pending' 
AND TestDate < DATEADD(DAY, -7, GETDATE());

--Section-14 ------------------------------------
-- Q-146
CREATE TABLE TempTable (
    TempID INT IDENTITY(1,1) PRIMARY KEY,
    TempName VARCHAR(50) NOT NULL,
    TempValue INT,
    CreatedDate DATETIME DEFAULT GETDATE()
);

-- Q-147
DROP TABLE TempTable;

-- Q-148
CREATE DATABASE TestDB;

--Q-149
USE master;
DROP DATABASE TestDB;
USE BloodBankDB; 

-- Q-150
USE master;
DROP DATABASE BloodBankDB_Backup;
USE BloodBankDB;

--Section-15 
--Q-151
SELECT DISTINCT 
    d.DonorID,
    d.FirstName,
    d.LastName,
    bg.BloodType,
    bg.RhFactor,
    d.LastDonationDate,
    DATEDIFF(DAY, d.LastDonationDate, GETDATE()) AS DaysSinceLastDonation
FROM Donors d
INNER JOIN BloodGroups bg ON d.BloodGroupID = bg.BloodGroupID
INNER JOIN BloodRequests br ON bg.BloodGroupID = br.BloodGroupID
WHERE br.Priority = 'Critical'
    AND br.Status IN ('Pending', 'Approved')
    AND (d.LastDonationDate IS NULL OR d.LastDonationDate < DATEADD(DAY, -60, GETDATE()))
    AND d.DonorID NOT IN (SELECT DonorID FROM DonorBlacklist)
ORDER BY d.LastDonationDate DESC;

--Q-152
WITH RequestedBlood AS (
    SELECT 
        br.BloodGroupID,
        bg.BloodType,
        bg.RhFactor,
        SUM(br.QuantityRequired) AS TotalRequired
    FROM BloodRequests br
    INNER JOIN BloodGroups bg ON br.BloodGroupID = bg.BloodGroupID
    WHERE br.Status IN ('Pending', 'Approved')
    GROUP BY br.BloodGroupID, bg.BloodType, bg.RhFactor
),
AvailableBlood AS (
    SELECT 
        bi.BloodGroupID,
        SUM(bi.QuantityML) AS TotalAvailable
    FROM BloodInventory bi
    WHERE bi.Status = 'Available'
    GROUP BY bi.BloodGroupID
)
SELECT 
    r.BloodGroupID,
    r.BloodType,
    r.RhFactor,
    r.TotalRequired,
    ISNULL(a.TotalAvailable, 0) AS TotalAvailable,
    CASE 
        WHEN ISNULL(a.TotalAvailable, 0) < r.TotalRequired THEN 'SHORTAGE'
        ELSE 'SUFFICIENT'
    END AS InventoryStatus,
    r.TotalRequired - ISNULL(a.TotalAvailable, 0) AS ShortageAmount
FROM RequestedBlood r
LEFT JOIN AvailableBlood a ON r.BloodGroupID = a.BloodGroupID
WHERE ISNULL(a.TotalAvailable, 0) < r.TotalRequired
ORDER BY ShortageAmount DESC;

--Q-153
SELECT 
    dc.CenterID,
    dc.CenterName,
    dc.City
FROM DonationCenters dc
LEFT JOIN BloodDonations bd ON dc.CenterID = bd.CenterID
WHERE bd.DonationID IS NULL
ORDER BY dc.CenterName;

--Q-154
WITH CompatibleMatches AS (
    SELECT 
        d.DonorID,
        d.FirstName AS DonorFirstName,
        d.LastName AS DonorLastName,
        dg.BloodType AS DonorBloodType,
        dg.RhFactor AS DonorRhFactor,
        p.PatientID,
        p.FirstName AS PatientFirstName,
        p.LastName AS PatientLastName,
        pg.BloodType AS PatientBloodType,
        pg.RhFactor AS PatientRhFactor,
        -- Compatibility rules
        CASE 
            -- O- is universal donor
            WHEN dg.BloodType = 'O' AND dg.RhFactor = '-' THEN 'Universal Donor'
            -- AB+ is universal receiver
            WHEN pg.BloodType = 'AB' AND pg.RhFactor = '+' THEN 'Universal Receiver'
            -- Same blood type
            WHEN dg.BloodType = pg.BloodType AND dg.RhFactor = pg.RhFactor THEN 'Exact Match'
            -- Compatible Rh factor (Rh- can donate to Rh+, but not vice versa)
            WHEN dg.BloodType = pg.BloodType AND dg.RhFactor = '-' AND pg.RhFactor = '+' THEN 'Rh Compatible'
            -- O can donate to A, B, AB (with Rh compatibility)
            WHEN dg.BloodType = 'O' AND dg.RhFactor = '-' THEN 'O- to All'
            WHEN dg.BloodType = 'O' AND dg.RhFactor = '+' AND pg.RhFactor = '+' THEN 'O+ to Rh+'
            -- A can donate to A and AB
            WHEN dg.BloodType = 'A' AND pg.BloodType IN ('A', 'AB') THEN 'A to A/AB'
            -- B can donate to B and AB
            WHEN dg.BloodType = 'B' AND pg.BloodType IN ('B', 'AB') THEN 'B to B/AB'
            ELSE 'Not Compatible'
        END AS Compatibility
    FROM Donors d
    INNER JOIN BloodGroups dg ON d.BloodGroupID = dg.BloodGroupID
    CROSS JOIN Patients p
    INNER JOIN BloodGroups pg ON p.BloodGroupID = pg.BloodGroupID
    WHERE p.IsEmergency = 1  -- Only for emergency patients
)
SELECT *
FROM CompatibleMatches
WHERE Compatibility NOT LIKE 'Not Compatible'
ORDER BY 
    CASE 
        WHEN Compatibility = 'Universal Donor' THEN 1
        WHEN Compatibility = 'Exact Match' THEN 2
        WHEN Compatibility = 'Rh Compatible' THEN 3
        ELSE 4
    END,
    DonorLastName;

--Q-155
SELECT 
    d.DonorID,
    d.FirstName,
    d.LastName,
    COUNT(DISTINCT a.AppointmentID) AS TotalAppointments,
    COUNT(DISTINCT bd.DonationID) AS TotalDonations,
    COUNT(DISTINCT CASE WHEN a.Status = 'Completed' THEN a.AppointmentID END) AS CompletedAppointments,
    COUNT(DISTINCT CASE WHEN a.Status = 'NoShow' THEN a.AppointmentID END) AS NoShowAppointments,
    CASE 
        WHEN COUNT(DISTINCT a.AppointmentID) = 0 THEN 0
        ELSE ROUND((COUNT(DISTINCT bd.DonationID) * 100.0 / COUNT(DISTINCT a.AppointmentID)), 2)
    END AS DonationEfficiencyPercent
FROM Donors d
LEFT JOIN Appointments a ON d.DonorID = a.DonorID
LEFT JOIN BloodDonations bd ON d.DonorID = bd.DonorID
GROUP BY d.DonorID, d.FirstName, d.LastName
HAVING COUNT(DISTINCT a.AppointmentID) > 0
ORDER BY DonationEfficiencyPercent DESC;

-- Question 156: Find hospitals that have requested blood but never received any issuance
SELECT 
    h.HospitalID,
    h.HospitalName,
    h.City,
    COUNT(DISTINCT br.RequestID) AS TotalRequests,
    COUNT(DISTINCT bi.IssuanceID) AS TotalIssuances
FROM Hospitals h
INNER JOIN BloodRequests br ON h.HospitalID = br.HospitalID
LEFT JOIN BloodIssuance bi ON br.RequestID = bi.RequestID
GROUP BY h.HospitalID, h.HospitalName, h.City
HAVING COUNT(DISTINCT bi.IssuanceID) = 0
ORDER BY TotalRequests DESC;

--Q-157
WITH CenterPerformance AS (
    SELECT 
        dc.CenterID,
        dc.CenterName,
        dc.City,
        COUNT(DISTINCT bd.DonationID) AS TotalDonations,
        COUNT(DISTINCT a.AppointmentID) AS TotalAppointments,
        COUNT(DISTINCT CASE WHEN a.Status = 'Completed' THEN a.AppointmentID END) AS CompletedAppointments,
        SUM(bd.QuantityML) AS TotalBloodML
    FROM DonationCenters dc
    LEFT JOIN Appointments a ON dc.CenterID = a.CenterID
    LEFT JOIN BloodDonations bd ON dc.CenterID = bd.CenterID
    GROUP BY dc.CenterID, dc.CenterName, dc.City
)
SELECT TOP 5 *,
    CASE 
        WHEN TotalAppointments = 0 THEN 0
        ELSE ROUND((CompletedAppointments * 100.0 / TotalAppointments), 2)
    END AS SuccessRatePercent,
    RANK() OVER (ORDER BY TotalDonations DESC) AS Rank_Donations,
    RANK() OVER (ORDER BY 
        CASE 
            WHEN TotalAppointments = 0 THEN 0
            ELSE ROUND((CompletedAppointments * 100.0 / TotalAppointments), 2)
        END DESC
    ) AS Rank_SuccessRate
FROM CenterPerformance
WHERE TotalAppointments > 0
ORDER BY TotalDonations DESC, SuccessRatePercent DESC;

--Q-158
SELECT 
    d.DonorID,
    d.FirstName,
    d.LastName,
    ci.Phone,
    ci.Email,
    d.LastDonationDate,
    DATEDIFF(DAY, d.LastDonationDate, GETDATE()) AS DaysSinceLastDonation,
    bg.BloodType,
    bg.RhFactor
FROM Donors d
INNER JOIN BloodGroups bg ON d.BloodGroupID = bg.BloodGroupID
INNER JOIN ContactInformation ci ON d.DonorID = ci.DonorID
LEFT JOIN DonorBlacklist db ON d.DonorID = db.DonorID
WHERE bg.BloodType = 'O' 
    AND bg.RhFactor = '-'
    AND db.DonorID IS NULL  -- Not blacklisted
    AND (d.LastDonationDate IS NULL OR d.LastDonationDate < DATEADD(DAY, -56, GETDATE()))
    AND EXISTS (
        SELECT 1 
        FROM BloodRequests br
        INNER JOIN BloodGroups brg ON br.BloodGroupID = brg.BloodGroupID
        WHERE brg.BloodType = 'O' 
            AND brg.RhFactor = '-'
            AND br.Priority = 'Critical'
            AND br.Status IN ('Pending', 'Approved')
    )
ORDER BY DaysSinceLastDonation DESC;

--Q-159
SELECT 
    bi.InventoryID,
    bi.DonationID,
    bg.BloodType,
    bg.RhFactor,
    bi.BloodComponent,
    bi.CollectionDate,
    bi.ExpiryDate,
    DATEDIFF(DAY, bi.CollectionDate, bi.ExpiryDate) AS DaysDifference,
    CASE 
        WHEN bi.CollectionDate > bi.ExpiryDate THEN 'ERROR: Collection after expiry'
        WHEN DATEDIFF(DAY, bi.CollectionDate, bi.ExpiryDate) < 0 THEN 'ERROR: Negative shelf life'
        ELSE 'OK'
    END AS DataIssue
FROM BloodInventory bi
INNER JOIN BloodGroups bg ON bi.BloodGroupID = bg.BloodGroupID
WHERE bi.CollectionDate > bi.ExpiryDate
    OR DATEDIFF(DAY, bi.CollectionDate, bi.ExpiryDate) < 0
ORDER BY DataIssue, bi.CollectionDate DESC;

--Q-160
SELECT 
    bi.BloodComponent,
    COUNT(DISTINCT di.IncentiveID) AS TotalIncentives,
    SUM(di.IncentiveValue) AS TotalIncentiveValue,
    AVG(di.IncentiveValue) AS AverageIncentiveValue,
    MIN(di.IncentiveValue) AS MinIncentiveValue,
    MAX(di.IncentiveValue) AS MaxIncentiveValue
FROM BloodDonations bd
INNER JOIN BloodInventory bi ON bd.DonationID = bi.DonationID
LEFT JOIN DonationIncentives di ON bd.DonationID = di.DonationID
WHERE di.IncentiveValue > 0
GROUP BY bi.BloodComponent
ORDER BY TotalIncentiveValue DESC;

-- Q-161
SELECT 
    bi.InventoryID,
    bg.BloodType,
    bg.RhFactor,
    bi.BloodComponent,
    bi.QuantityML,
    bi.CollectionDate,
    bi.ExpiryDate,
    DATEDIFF(DAY, GETDATE(), bi.ExpiryDate) AS DaysUntilExpiry,
    bi.StorageLocation
FROM BloodInventory bi
INNER JOIN BloodGroups bg ON bi.BloodGroupID = bg.BloodGroupID
WHERE bi.Status = 'Available'
    AND bi.ExpiryDate BETWEEN GETDATE() AND DATEADD(DAY, 7, GETDATE())
    AND NOT EXISTS (
        SELECT 1 
        FROM BloodIssuance bis
        WHERE bis.InventoryID = bi.InventoryID
    )
ORDER BY DaysUntilExpiry, bi.ExpiryDate;

--Q-162
WITH DuplicateEmails AS (
    SELECT 
        Email,
        COUNT(*) AS DuplicateCount,
        STRING_AGG(CONCAT(DonorID, ': ', FirstName, ' ', LastName), '; ') AS DonorList
    FROM (
        SELECT 
            d.DonorID,
            d.FirstName,
            d.LastName,
            ci.Email
        FROM Donors d
        INNER JOIN ContactInformation ci ON d.DonorID = ci.DonorID
        WHERE ci.Email IS NOT NULL AND ci.Email != ''
    ) AS EmailData
    GROUP BY Email
    HAVING COUNT(*) > 1
),
DuplicatePhones AS (
    SELECT 
        Phone,
        COUNT(*) AS DuplicateCount,
        STRING_AGG(CONCAT(DonorID, ': ', FirstName, ' ', LastName), '; ') AS DonorList
    FROM (
        SELECT 
            d.DonorID,
            d.FirstName,
            d.LastName,
            ci.Phone
        FROM Donors d
        INNER JOIN ContactInformation ci ON d.DonorID = ci.DonorID
    ) AS PhoneData
    GROUP BY Phone
    HAVING COUNT(*) > 1
)
SELECT 
    'Email' AS ContactType,
    Email AS ContactInfo,
    DuplicateCount,
    DonorList
FROM DuplicateEmails
UNION ALL
SELECT 
    'Phone' AS ContactType,
    Phone AS ContactInfo,
    DuplicateCount,
    DonorList
FROM DuplicatePhones
ORDER BY ContactType, DuplicateCount DESC;

--Q-163 
SELECT 
    YEAR(bd.DonationDate) AS DonationYear,
    MONTH(bd.DonationDate) AS DonationMonth,
    DATENAME(MONTH, bd.DonationDate) AS MonthName,
    bg.BloodType,
    bg.RhFactor,
    COUNT(bd.DonationID) AS DonationCount,
    SUM(bd.QuantityML) AS TotalML,
    COUNT(DISTINCT bd.DonorID) AS UniqueDonors
FROM BloodDonations bd
INNER JOIN BloodGroups bg ON bd.BloodGroupID = bg.BloodGroupID
WHERE YEAR(bd.DonationDate) = YEAR(GETDATE())
GROUP BY 
    YEAR(bd.DonationDate),
    MONTH(bd.DonationDate),
    DATENAME(MONTH, bd.DonationDate),
    bg.BloodType,
    bg.RhFactor
ORDER BY 
    DonationYear DESC,
    DonationMonth,
    bg.BloodType,
    bg.RhFactor;

--Q-164
WITH StaffWorkload AS (
    SELECT 
        ms.StaffID,
        ms.FirstName,
        ms.LastName,
        ms.Position,
        COUNT(DISTINCT bd.DonationID) AS TotalDonations,
        COUNT(DISTINCT bd.CenterID) AS DifferentCenters,
        AVG(COUNT(DISTINCT bd.DonationID)) OVER (PARTITION BY ms.Position) AS AvgDonationsForPosition
    FROM MedicalStaff ms
    INNER JOIN BloodDonations bd ON ms.StaffID = bd.StaffID
    WHERE ms.IsActive = 1
    GROUP BY ms.StaffID, ms.FirstName, ms.LastName, ms.Position
)
SELECT 
    StaffID,
    FirstName,
    LastName,
    Position,
    TotalDonations,
    AvgDonationsForPosition,
    DifferentCenters,
    ROUND((TotalDonations * 100.0 / AvgDonationsForPosition), 2) AS WorkloadPercentage
FROM StaffWorkload
WHERE TotalDonations > AvgDonationsForPosition
    AND DifferentCenters > 3
ORDER BY WorkloadPercentage DESC;

--Q-165
SELECT TOP 10
    d.DonorID,
    d.FirstName,
    d.LastName,
    bg.BloodType,
    bg.RhFactor,
    COUNT(DISTINCT bd.DonationID) AS TotalDonations,
    COUNT(DISTINCT CASE WHEN a.Status = 'Completed' THEN a.AppointmentID END) AS CompletedAppointments,
    COUNT(DISTINCT CASE WHEN a.Status = 'NoShow' THEN a.AppointmentID END) AS MissedAppointments,
    -- Calculate loyalty score
    (COUNT(DISTINCT bd.DonationID) * 10) + 
    (COUNT(DISTINCT CASE WHEN a.Status = 'Completed' THEN a.AppointmentID END) * 5) -
    (COUNT(DISTINCT CASE WHEN a.Status = 'NoShow' THEN a.AppointmentID END) * 3) AS LoyaltyScore,
    d.LastDonationDate,
    DATEDIFF(DAY, d.LastDonationDate, GETDATE()) AS DaysSinceLastDonation
FROM Donors d
INNER JOIN BloodGroups bg ON d.BloodGroupID = bg.BloodGroupID
LEFT JOIN BloodDonations bd ON d.DonorID = bd.DonorID
LEFT JOIN Appointments a ON d.DonorID = a.DonorID
GROUP BY 
    d.DonorID, 
    d.FirstName, 
    d.LastName, 
    bg.BloodType, 
    bg.RhFactor,
    d.LastDonationDate
ORDER BY LoyaltyScore DESC, TotalDonations DESC;

--Section-16
-- Q-166
SELECT TOP 1
    bg.BloodType,
    bg.RhFactor,
    COUNT(bd.DonationID) AS TotalDonations,
    SUM(bd.QuantityML) AS TotalML,
    DATENAME(MONTH, GETDATE()) AS MonthName,
    YEAR(GETDATE()) AS Year
FROM BloodDonations bd
INNER JOIN BloodGroups bg ON bd.BloodGroupID = bg.BloodGroupID
WHERE MONTH(bd.DonationDate) = MONTH(GETDATE())
    AND YEAR(bd.DonationDate) = YEAR(GETDATE())
GROUP BY bg.BloodType, bg.RhFactor
ORDER BY TotalDonations DESC;
-- Q-167
SELECT 
    d.DonorID,
    d.FirstName,
    d.LastName,
    bg.BloodType,
    bg.RhFactor,
    COUNT(bd.DonationID) AS TotalDonations,
    SUM(bd.QuantityML) AS TotalMLDonated,
    MIN(bd.DonationDate) AS FirstDonation,
    MAX(bd.DonationDate) AS LastDonation,
    DATEDIFF(DAY, MIN(bd.DonationDate), MAX(bd.DonationDate)) AS DaysBetweenFirstLast
FROM Donors d
INNER JOIN BloodGroups bg ON d.BloodGroupID = bg.BloodGroupID
INNER JOIN BloodDonations bd ON d.DonorID = bd.DonorID
GROUP BY d.DonorID, d.FirstName, d.LastName, bg.BloodType, bg.RhFactor
HAVING COUNT(bd.DonationID) >= 3
ORDER BY TotalDonations DESC, TotalMLDonated DESC;
-- Q-168
SELECT 
    bi.BloodComponent,
    COUNT(bi.InventoryID) AS TotalUnits,
    SUM(CASE WHEN bi.Status = 'Available' THEN 1 ELSE 0 END) AS AvailableUnits,
    SUM(CASE WHEN bi.Status = 'Expired' THEN 1 ELSE 0 END) AS ExpiredUnits,
    SUM(CASE WHEN bi.Status = 'Issued' THEN 1 ELSE 0 END) AS IssuedUnits,
    SUM(CASE WHEN bi.Status = 'Reserved' THEN 1 ELSE 0 END) AS ReservedUnits,
    SUM(CASE WHEN bi.Status = 'Discarded' THEN 1 ELSE 0 END) AS DiscardedUnits,
    SUM(bi.QuantityML) AS TotalML,
    AVG(DATEDIFF(DAY, bi.CollectionDate, bi.ExpiryDate)) AS AvgShelfLifeDays
FROM BloodInventory bi
GROUP BY bi.BloodComponent
ORDER BY TotalUnits DESC;
-- Q-169
SELECT 
    h.HospitalID,
    h.HospitalName,
    h.City,
    h.State,
    COUNT(br.RequestID) AS TotalRequests,
    COUNT(CASE WHEN br.Status = 'Fulfilled' THEN 1 END) AS FulfilledRequests,
    COUNT(CASE WHEN br.Status = 'Pending' THEN 1 END) AS PendingRequests,
    COUNT(CASE WHEN br.Status = 'Approved' THEN 1 END) AS ApprovedRequests,
    COUNT(CASE WHEN br.Status = 'Cancelled' THEN 1 END) AS CancelledRequests,
    SUM(br.QuantityRequired) AS TotalRequestedML,
    SUM(bi.QuantityIssued) AS TotalIssuedML,
    CASE 
        WHEN COUNT(br.RequestID) = 0 THEN 0
        ELSE ROUND((COUNT(CASE WHEN br.Status = 'Fulfilled' THEN 1 END) * 100.0 / COUNT(br.RequestID)), 2)
    END AS FulfillmentRate,
    AVG(DATEDIFF(DAY, br.RequestDate, br.RequiredByDate)) AS AvgResponseTimeDays
FROM Hospitals h
LEFT JOIN BloodRequests br ON h.HospitalID = br.HospitalID
LEFT JOIN BloodIssuance bi ON br.RequestID = bi.RequestID
GROUP BY h.HospitalID, h.HospitalName, h.City, h.State
ORDER BY TotalRequests DESC, FulfillmentRate DESC;
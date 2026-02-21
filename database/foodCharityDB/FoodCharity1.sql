-- =====================================================
-- FOOD CHARITY DATABASE SYSTEM - COMPLETE ASSIGNMENT
-- =====================================================
-- This script i used follows a similar structure of the Blood Bank assignment
-- and is adapted for a Food Charity organization in Ethiopia.
-- and i used like 180 and all 180 Step are implemented with Ethiopian data.

-- SECTION 1: DATABASE CREATION AND MANAGEMENT (Step 1-5)
-- =====================================================
use master
DROP DATABASE IF EXISTS FoodCharityDB;
-- Step 1: Creating a new database named 'FoodCharityDB'
CREATE DATABASE FoodCharityDB;
GO

-- Step 2: Switch to use the FoodCharityDB database
USE FoodCharityDB;
GO

-- Step 3: Create another database named 'FoodCharityDB_Backup' for backup purposes
CREATE DATABASE FoodCharityDB_Backup;
GO

-- Step 4: Switch back to FoodCharityDB database again its not necessary this step btw, but i did it just to uh ensure we are in the correct database for subsequent operations
USE FoodCharityDB;
GO

-- Step 5: Alter the FoodCharityDB database to set recovery model to FULL
ALTER DATABASE FoodCharityDB SET RECOVERY FULL;
GO

-- =====================================================
-- SECTION 2: TABLE CREATION - CORE TABLES (Step 6-20)
-- =====================================================

-- Step 6: Create a table named 'MealTypes' 
CREATE TABLE MealTypes (
    MealTypeID INT IDENTITY(1,1) PRIMARY KEY,
    MealName NVARCHAR(50) NOT NULL UNIQUE,
    Description NVARCHAR(200)
);

-- Step 7: Create a table named 'Staff' 
CREATE TABLE Staff (
    StaffID INT IDENTITY(5001,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Role NVARCHAR(50) NOT NULL CHECK (Role IN ('Coordinator', 'Volunteer', 'Cook', 'Driver', 'Admin')),
    HireDate DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    Shift NVARCHAR(20) CHECK (Shift IN ('Morning', 'Afternoon', 'Evening')),
    Salary DECIMAL(10,2) CHECK (Salary >= 0),
    LastMealServedDate DATE NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    ContactInfoID INT NULL  -- will be updated later
);

-- Step 8: Create a table named 'Recipients'
CREATE TABLE Recipients (
    RecipientID INT IDENTITY(3001,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Age INT CHECK (Age >= 0),
    Gender CHAR(1) CHECK (Gender IN ('M', 'F', 'O')),
    Address NVARCHAR(200),
    TotalMealsServed INT NOT NULL DEFAULT 0,
    LastMealReceivedDate DATE NULL,
    HealthNotes NVARCHAR(500),
    IsActive BIT NOT NULL DEFAULT 1,
    RegistrationDate DATE NOT NULL DEFAULT GETDATE()
);

-- Step 9: Create a table named 'Donors' 
CREATE TABLE Donors (
    DonorID INT IDENTITY(1001,1) PRIMARY KEY,
    DonorName NVARCHAR(100) NOT NULL,
    DonorType NVARCHAR(20) CHECK (DonorType IN ('Individual', 'Organization')),
    TotalContribution DECIMAL(12,2) NOT NULL DEFAULT 0 CHECK (TotalContribution >= 0),
    LastDonationDate DATE NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    TaxID NVARCHAR(20) NULL  -- for organizations
);

-- Step 10: Create a table named 'ContactInformation' 
CREATE TABLE ContactInformation (
    ContactID INT IDENTITY(1,1) PRIMARY KEY,
    PersonType NVARCHAR(20) NOT NULL CHECK (PersonType IN ('Staff', 'Donor', 'Recipient')),
    PersonID INT NOT NULL,
    Phone NVARCHAR(20),
    Email NVARCHAR(100),
    Address NVARCHAR(200),
    City NVARCHAR(50),
    State NVARCHAR(50),
    ZipCode NVARCHAR(10),
    CONSTRAINT UQ_PersonType_PersonID UNIQUE (PersonType, PersonID),
    CONSTRAINT CK_Email_Format CHECK (Email LIKE '%_@__%.__%')
);

-- Step 11: Create a table named 'DistributionCenters' 
CREATE TABLE DistributionCenters (
    CenterID INT IDENTITY(4001,1) PRIMARY KEY,
    CenterName NVARCHAR(100) NOT NULL,
    Address NVARCHAR(200) NOT NULL,
    City NVARCHAR(50) NOT NULL,
    OperatingHours NVARCHAR(50),
    Capacity INT CHECK (Capacity > 0),
    ManagerStaffID INT FOREIGN KEY REFERENCES Staff(StaffID)
);

-- Step 12: Create a table named 'FoodInventory' 
CREATE TABLE FoodInventory (
    FoodID INT IDENTITY(2001,1) PRIMARY KEY,
    FoodName NVARCHAR(100) NOT NULL UNIQUE,
    Quantity DECIMAL(10,2) NOT NULL CHECK (Quantity >= 0),
    Unit NVARCHAR(20) NOT NULL,
    ExpirationDate DATE NULL,
    Supplier NVARCHAR(100),
    LastUpdated DATETIME NOT NULL DEFAULT GETDATE(),
    MinThreshold DECIMAL(10,2) DEFAULT 10,
    StorageLocation NVARCHAR(50) DEFAULT 'Warehouse A',
    Temperature DECIMAL(4,2) NULL  -- for cold storage
);

-- Step 13: Create a table named 'MealDistribution' 
CREATE TABLE MealDistribution (
    DistributionID INT IDENTITY(10001,1) PRIMARY KEY,
    RecipientID INT NOT NULL FOREIGN KEY REFERENCES Recipients(RecipientID),
    MealTypeID INT NOT NULL FOREIGN KEY REFERENCES MealTypes(MealTypeID),
    StaffID INT NOT NULL FOREIGN KEY REFERENCES Staff(StaffID),
    CenterID INT NOT NULL FOREIGN KEY REFERENCES DistributionCenters(CenterID),
    DistributionDate DATETIME NOT NULL DEFAULT GETDATE(),
    Quantity INT NOT NULL CHECK (Quantity > 0)
);

-- Step 14: Create a table named 'Attendance' 
CREATE TABLE Attendance (
    AttendanceID INT IDENTITY(1,1) PRIMARY KEY,
    StaffID INT NOT NULL FOREIGN KEY REFERENCES Staff(StaffID),
    AttendanceDate DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    Status NVARCHAR(20) NOT NULL CHECK (Status IN ('Present', 'Absent', 'Leave')),
    CONSTRAINT UQ_Attendance_StaffDate UNIQUE (StaffID, AttendanceDate)
);

-- Step 15: Create a table named 'FoodOrders'
CREATE TABLE FoodOrders (
    OrderID INT IDENTITY(50001,1) PRIMARY KEY,
    FoodID INT NOT NULL FOREIGN KEY REFERENCES FoodInventory(FoodID),
    Quantity DECIMAL(10,2) NOT NULL CHECK (Quantity > 0),
    OrderDate DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    Supplier NVARCHAR(100) NOT NULL,
    Status NVARCHAR(20) NOT NULL DEFAULT 'Pending' CHECK (Status IN ('Pending', 'Shipped', 'Received', 'Cancelled'))
);

-- Step 16: Create a table named 'DonationIncentives' 
CREATE TABLE DonationIncentives (
    IncentiveID INT IDENTITY(1,1) PRIMARY KEY,
    DonorID INT NOT NULL FOREIGN KEY REFERENCES Donors(DonorID),
    IncentiveType NVARCHAR(50) CHECK (IncentiveType IN ('Certificate', 'Gift Card', 'TShirt', 'Meal Voucher', 'Tax Receipt')),
    IncentiveValue DECIMAL(10,2) DEFAULT 0,
    IssuedDate DATE NOT NULL DEFAULT GETDATE(),
    Description NVARCHAR(200)
);

-- Step 17: Create a table named 'Notifications' 
CREATE TABLE Notifications (
    NotificationID INT IDENTITY(1,1) PRIMARY KEY,
    RecipientID INT NULL FOREIGN KEY REFERENCES Recipients(RecipientID),
    StaffID INT NULL FOREIGN KEY REFERENCES Staff(StaffID),
    NotificationType NVARCHAR(30) CHECK (NotificationType IN ('Appointment Reminder', 'Meal Ready', 'Blood Drive', 'Thank You', 'Emergency')),
    Message NVARCHAR(500) NOT NULL,
    SentDate DATETIME NOT NULL DEFAULT GETDATE(),
    IsRead BIT NOT NULL DEFAULT 0,
    DeliveryMethod NVARCHAR(20) CHECK (DeliveryMethod IN ('Email', 'SMS', 'Push', 'Phone')),
    CONSTRAINT CK_Notification_RecipientOrStaff CHECK (
        (RecipientID IS NOT NULL AND StaffID IS NULL) OR
        (RecipientID IS NULL AND StaffID IS NOT NULL)
    )
);

-- Step 18: Create a table named 'EventSchedules' 
CREATE TABLE EventSchedules (
    EventID INT IDENTITY(7001,1) PRIMARY KEY,
    EventName NVARCHAR(100) NOT NULL,
    EventDate DATE NOT NULL,
    Location NVARCHAR(200) NOT NULL,
    CoordinatorID INT NOT NULL FOREIGN KEY REFERENCES Staff(StaffID),
    ExpectedRecipients INT CHECK (ExpectedRecipients > 0),
    ActualRecipients INT DEFAULT 0 CHECK (ActualRecipients >= 0),
    Status NVARCHAR(20) DEFAULT 'Planned' CHECK (Status IN ('Planned', 'Active', 'Completed', 'Cancelled'))
);

-- Step 19: Create a table named 'VolunteerShifts'
CREATE TABLE VolunteerShifts (
    ShiftID INT IDENTITY(1,1) PRIMARY KEY,
    StaffID INT NOT NULL FOREIGN KEY REFERENCES Staff(StaffID),
    ShiftDate DATE NOT NULL,
    ShiftType NVARCHAR(20) NOT NULL CHECK (ShiftType IN ('Morning', 'Afternoon', 'Evening')),
    CONSTRAINT UQ_VolunteerShifts_StaffDateShift UNIQUE (StaffID, ShiftDate, ShiftType)
);

-- Step 20: Create a table named 'Assets' 
CREATE TABLE Assets (
    AssetID INT IDENTITY(6001,1) PRIMARY KEY,
    AssetName NVARCHAR(100) NOT NULL,
    AssetType NVARCHAR(50) NOT NULL,
    CenterID INT NULL FOREIGN KEY REFERENCES DistributionCenters(CenterID),
    PurchaseDate DATE,
    LastMaintenanceDate DATE,
    NextMaintenanceDate AS DATEADD(MONTH, 6, LastMaintenanceDate) PERSISTED,
    Status NVARCHAR(20) DEFAULT 'Operational' CHECK (Status IN ('Operational', 'Under Maintenance', 'Out of Service')),
    Cost MONEY CHECK (Cost > 0)
);

-- =====================================================
-- SECTION 3: ADDITIONAL TABLES (Step 21-25)
-- =====================================================

-- Step 21: Create a table named 'AuditLog' 
CREATE TABLE AuditLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    TableName NVARCHAR(50) NOT NULL,
    Operation NVARCHAR(20) CHECK (Operation IN ('INSERT', 'UPDATE', 'DELETE')),
    PerformedByStaffID INT NULL FOREIGN KEY REFERENCES Staff(StaffID),
    PerformedDate DATETIME NOT NULL DEFAULT GETDATE(),
    OldValue NVARCHAR(MAX),
    NewValue NVARCHAR(MAX),
    Description NVARCHAR(500)
);

-- Step 22: Create a table named 'DonorBlacklist' 
CREATE TABLE DonorBlacklist (
    BlacklistID INT IDENTITY(1,1) PRIMARY KEY,
    DonorID INT NOT NULL UNIQUE FOREIGN KEY REFERENCES Donors(DonorID),
    BlacklistDate DATE NOT NULL DEFAULT GETDATE(),
    Reason NVARCHAR(500) NOT NULL,
    BlacklistedByStaffID INT NOT NULL FOREIGN KEY REFERENCES Staff(StaffID),
    IsPermanent BIT NOT NULL DEFAULT 0,
    ExpiryDate DATE NULL
);

-- Step 23: Create a table named 'RecipientHealthHistory' 
CREATE TABLE RecipientHealthHistory (
    HealthHistoryID INT IDENTITY(1,1) PRIMARY KEY,
    RecipientID INT NOT NULL FOREIGN KEY REFERENCES Recipients(RecipientID),
    RecordDate DATE NOT NULL,
    Weight DECIMAL(5,2) CHECK (Weight > 0),
    BloodPressure NVARCHAR(10),
    HemoglobinLevel DECIMAL(4,2) CHECK (HemoglobinLevel > 0),
    HasChronicIllness BIT NOT NULL DEFAULT 0,
    Notes NVARCHAR(MAX)
);

-- Step 24: Create a table named 'FoodQualityChecks' 
CREATE TABLE FoodQualityChecks (
    CheckID INT IDENTITY(1,1) PRIMARY KEY,
    FoodID INT NOT NULL FOREIGN KEY REFERENCES FoodInventory(FoodID),
    CheckDate DATETIME NOT NULL DEFAULT GETDATE(),
    CheckedByStaffID INT NOT NULL FOREIGN KEY REFERENCES Staff(StaffID),
    IsSpoiled BIT NOT NULL DEFAULT 0,
    IsContaminated BIT NOT NULL DEFAULT 0,
    CheckResult NVARCHAR(20) DEFAULT 'Pass' CHECK (CheckResult IN ('Pass', 'Fail', 'Pending')),
    ResultDate DATETIME,
    Notes NVARCHAR(500)
);

-- Step 25: Create a table named 'FoodIssuance' 
CREATE TABLE FoodIssuance (
    IssuanceID INT IDENTITY(1,1) PRIMARY KEY,
    DistributionID INT NOT NULL FOREIGN KEY REFERENCES MealDistribution(DistributionID),
    FoodID INT NOT NULL FOREIGN KEY REFERENCES FoodInventory(FoodID),
    QuantityUsed DECIMAL(10,2) NOT NULL CHECK (QuantityUsed > 0),
    IssuedByStaffID INT NOT NULL FOREIGN KEY REFERENCES Staff(StaffID),
    IssuedDate DATETIME NOT NULL DEFAULT GETDATE()
);

-- =====================================================
-- SECTION 4: DATA INSERTION - BASIC (Step 26-40)
-- =====================================================

-- Step 26: Insert MealTypes (5 types)
INSERT INTO MealTypes (MealName, Description) VALUES
('Breakfast', 'Firfir, bread, tea or coffee'),
('Lunch', 'Injera with shiro or lentils, vegetables'),
('Dinner', 'Injera with tibs, key wat, or vegetarian combo'),
('Snack', 'Kolo, popcorn, or fruit'),
('Holiday Special', 'Doro wat, kitfo, or special festive dish');

-- Step 27: Insert 5 medical staff members (actually food charity staff)
INSERT INTO Staff (FirstName, LastName, Role, HireDate, Shift, Salary, IsActive) VALUES
('Alemitu', 'Bekele', 'Coordinator', '2020-01-15', 'Morning', 45000, 1),
('Yonas', 'Desta', 'Volunteer', '2021-03-10', 'Afternoon', 0, 1),
('Tigist', 'Haile', 'Cook', '2019-11-20', 'Morning', 32000, 1),
('Biruk', 'Tadesse', 'Driver', '2022-02-01', 'Evening', 28000, 1),
('Meron', 'Assefa', 'Admin', '2018-06-05', 'Morning', 52000, 1);

-- Step 28: Insert 3 distribution centers with managers (using StaffID from above) - we have 5 staff, so we can assign 3 as managers
INSERT INTO DistributionCenters (CenterName, Address, City, OperatingHours, Capacity, ManagerStaffID) VALUES
('Addis Ketema Center', 'Kebele 02, Addis Ketema', 'Addis Ababa', '8AM-6PM', 200, 5001),
('Bole Community Kitchen', 'Kebele 08, Bole', 'Addis Ababa', '7AM-8PM', 300, 5005),
('Kirkos Food Bank', 'Kebele 12, Kirkos', 'Addis Ababa', '9AM-5PM', 150, 5003);

-- Step 29: Insert 3 more staff (so we have 8 total) to be managers
INSERT INTO Staff (FirstName, LastName, Role, HireDate, Shift, Salary, IsActive) VALUES
('Dawit', 'Mekonnen', 'Volunteer', '2023-01-10', 'Morning', 0, 1),
('Hana', 'Gebre', 'Cook', '2020-09-12', 'Afternoon', 33000, 1),
('Solomon', 'Berhan', 'Coordinator', '2021-07-19', 'Morning', 47000, 1);

-- Step 30: Insert 10 donors with ALL column values
INSERT INTO Donors (DonorName, DonorType, TotalContribution, LastDonationDate, TaxID) VALUES
('Ethiopian Iddir Association', 'Organization', 150000, '2025-05-10', 'ET12345'),
('Dashen Bank Foundation', 'Organization', 500000, '2025-06-01', 'ET67890'),
('Gebrehiwot Tsegaye', 'Individual', 25000, '2025-06-15', NULL),
('Addis Ababa Chamber of Commerce', 'Organization', 120000, '2025-04-22', 'ET54321'),
('Azeb Mesfin', 'Individual', 7500, '2025-05-30', NULL),
('Holy Trinity Church', 'Organization', 80000, '2025-05-05', 'ET98765'),
('Tekle Berhan', 'Individual', 30000, '2025-06-18', NULL),
('Ethio-telecom', 'Organization', 220000, '2025-05-12', 'ET11223'),
('Meron Tesfaye', 'Individual', 5000, '2025-04-28', NULL),
('United Way Ethiopia', 'Organization', 350000, '2025-06-20', 'ET44556');

-- Step 31: Insert contact information for the first 5 donors (ALL columns)
INSERT INTO ContactInformation (PersonType, PersonID, Phone, Email, Address, City, State, ZipCode) VALUES
('Donor', 1001, '+251-911-111111', 'info@iddirunion.et', 'Merkato', 'Addis Ababa', 'Addis Ababa', '1000'),
('Donor', 1002, '+251-911-222222', 'foundation@dashenbank.et', 'Bole', 'Addis Ababa', 'Addis Ababa', '1001'),
('Donor', 1003, '+251-921-333333', 'gebrehiwot.t@email.et', 'Kazanchis', 'Addis Ababa', 'Addis Ababa', '1002'),
('Donor', 1004, '+251-911-444444', 'chamber@addischamber.org', 'Mexico', 'Addis Ababa', 'Addis Ababa', '1003'),
('Donor', 1005, '+251-921-555555', 'azeb.mesfin@email.et', 'Piassa', 'Addis Ababa', 'Addis Ababa', '1004');

-- Step 32: Insert contact information for donors 6-10 (without email)
INSERT INTO ContactInformation (PersonType, PersonID, Phone, Address, City, State, ZipCode) VALUES
('Donor', 1006, '+251-911-666666', 'Piazza', 'Addis Ababa', 'Addis Ababa', '1005'),
('Donor', 1007, '+251-921-777777', 'CMC', 'Addis Ababa', 'Addis Ababa', '1006'),
('Donor', 1008, '+251-911-888888', 'Churchill Ave', 'Addis Ababa', 'Addis Ababa', '1007'),
('Donor', 1009, '+251-921-999999', 'Bambis', 'Addis Ababa', 'Addis Ababa', '1008'),
('Donor', 1010, '+251-911-000000', 'Old Airport', 'Addis Ababa', 'Addis Ababa', '1009');

-- Step 33: Insert 5 recipients (to have data for distributions)
INSERT INTO Recipients (FirstName, LastName, Age, Gender, Address, HealthNotes) VALUES
('Abebech', 'Gobena', 62, 'F', 'Kebele 08, Bole', 'Diabetic'),
('Tsegaye', 'Mekuria', 45, 'M', 'Kebele 03, Lideta', 'Hypertension'),
('Askale', 'Tefera', 28, 'F', 'Kebele 12, Kirkos', NULL),
('Belaynesh', 'Zewde', 55, 'F', 'Kebele 05, Yeka', 'Gluten intolerance'),
('Chala', 'Jemal', 33, 'M', 'Woreda 02, Adama', NULL);

-- Step 34: Insert 5 food inventory items
INSERT INTO FoodInventory (FoodName, Quantity, Unit, ExpirationDate, Supplier, MinThreshold) VALUES
('Teff (white)', 800, 'kg', '2026-01-01', 'Ethiopia Grain Trade', 100),
('Injera (ready-made)', 500, 'pieces', '2025-07-05', 'Addis Bakeries', 50),
('Shiro powder', 300, 'kg', '2025-12-15', 'Local Millers Co-op', 30),
('Berbere', 150, 'kg', '2025-11-20', 'Ethio Spices', 20),
('Chicken (doro)', 200, 'kg', '2025-07-20', 'ELFORA', 30);

-- Step 35: Insert 5 meal distributions (using default DistributionDate)
INSERT INTO MealDistribution (RecipientID, MealTypeID, StaffID, CenterID, Quantity) VALUES
(3001, 1, 5001, 4001, 1),
(3002, 2, 5002, 4002, 1),
(3003, 3, 5003, 4003, 1),
(3004, 1, 5004, 4001, 1),
(3005, 2, 5005, 4002, 1);

-- Step 36: Insert 5 attendance records for today (default date)
INSERT INTO Attendance (StaffID, Status) VALUES
(5001, 'Present'),
(5002, 'Present'),
(5003, 'Absent'),
(5004, 'Present'),
(5005, 'Leave');

-- Step 37: Insert 5 food orders
INSERT INTO FoodOrders (FoodID, Quantity, Supplier, Status) VALUES
(2001, 200, 'Ethiopia Grain Trade', 'Received'),
(2002, 100, 'Addis Bakeries', 'Received'),
(2003, 50, 'Local Millers Co-op', 'Shipped'),
(2004, 30, 'Ethio Spices', 'Pending'),
(2005, 80, 'ELFORA', 'Received');

-- Step 38: Insert 5 donation incentives
INSERT INTO DonationIncentives (DonorID, IncentiveType, IncentiveValue, Description) VALUES
(1001, 'Certificate', 0, 'Certificate of Appreciation'),
(1002, 'Gift Card', 500, 'Gift card for local restaurant'),
(1003, 'TShirt', 0, 'Charity T-shirt'),
(1004, 'Meal Voucher', 200, 'Meal voucher for two'),
(1005, 'Tax Receipt', 7500, 'Tax receipt for donation');

-- Step 39: Insert 5 notifications
INSERT INTO Notifications (RecipientID, StaffID, NotificationType, Message, DeliveryMethod) VALUES
(3001, NULL, 'Meal Ready', 'Your meal is ready for pickup at Addis Ketema Center.', 'SMS'),
(3002, NULL, 'Emergency', 'Urgent: Please come for meal today.', 'Phone'),
(NULL, 5001, 'Thank You', 'Thank you for coordinating yesterday''s event.', 'Email'),
(NULL, 5002, 'Appointment Reminder', 'Reminder: Your shift starts at 8 AM tomorrow.', 'Push'),
(3003, NULL, 'Blood Drive', 'Free health checkup at Bole Center.', 'SMS');

-- Step 40: Insert 5 event schedules
INSERT INTO EventSchedules (EventName, EventDate, Location, CoordinatorID, ExpectedRecipients) VALUES
('Enkutatash Food Drive', '2025-09-11', 'Meskel Square', 5001, 500),
('Meskel Festival Dinner', '2025-09-27', 'St. George Church', 5003, 300),
('Weekly Distribution', '2025-07-05', 'Addis Ketema', 5001, 150),
('Ganna Meal', '2026-01-07', 'Bole Community Hall', 5005, 400),
('Timket Breakfast', '2026-01-19', 'Jan Meda', 5003, 600);

-- =====================================================
-- SECTION 5: MORE DATA INSERTION (Step 41-50)
-- =====================================================

-- Step 41: Insert 2 donors into blacklist
INSERT INTO DonorBlacklist (DonorID, Reason, BlacklistedByStaffID, IsPermanent, ExpiryDate) VALUES
(1006, 'Fraudulent donation claims', 5001, 1, NULL),
(1007, 'Repeated no-show for appointments', 5001, 0, '2025-12-31');

-- Step 42: Insert 5 equipment items (assets)
INSERT INTO Assets (AssetName, AssetType, CenterID, PurchaseDate, LastMaintenanceDate, Status, Cost) VALUES
('Refrigerator', 'Cooling', 4001, '2022-01-15', '2025-01-15', 'Operational', 15000),
('Delivery Van', 'Vehicle', 4002, '2021-06-01', '2025-03-10', 'Operational', 800000),
('Industrial Stove', 'Cooking', 4003, '2023-02-20', '2024-12-01', 'Operational', 45000),
('Freezer', 'Cooling', 4001, '2020-11-05', '2024-11-05', 'Under Maintenance', 20000),
('Food Trailer', 'Mobile', 4002, '2024-05-10', NULL, 'Operational', 350000);

-- Step 43: Insert 5 more notifications (to have total 10)
INSERT INTO Notifications (RecipientID, StaffID, NotificationType, Message, DeliveryMethod) VALUES
(3004, NULL, 'Appointment Reminder', 'Your meal is scheduled for tomorrow.', 'Email'),
(3005, NULL, 'Thank You', 'Thank you for being a loyal recipient.', 'SMS'),
(NULL, 5003, 'Emergency', 'Need extra hands at Kirkos Center today.', 'Push'),
(NULL, 5004, 'Blood Drive', 'Volunteer appreciation lunch at 1 PM.', 'Email'),
(NULL, 5005, 'Meal Ready', 'New supply of food arrived.', 'Phone');

-- Step 44: Insert 2 blood drive events (actually food drives)
INSERT INTO EventSchedules (EventName, EventDate, Location, CoordinatorID, ExpectedRecipients, Status) VALUES
('Summer Food Drive', '2025-07-15', 'City Park', 5002, 200, 'Planned'),
('Thanksgiving Dinner', '2025-11-25', 'Community Center', 5001, 300, 'Planned');

-- Step 45: Insert incentives for 3 more donations (we have no donations table, so use DonationIncentives)
INSERT INTO DonationIncentives (DonorID, IncentiveType, IncentiveValue, Description) VALUES
(1006, 'Gift Card', 300, 'Gift card for supermarket'),
(1007, 'Certificate', 0, 'Certificate of Honor'),
(1008, 'Tax Receipt', 220000, 'Tax receipt');

-- Step 46: Insert 5 audit log entries
INSERT INTO AuditLog (TableName, Operation, PerformedByStaffID, Description) VALUES
('Donors', 'INSERT', 5005, 'Inserted new donor 1001'),
('Recipients', 'UPDATE', 5001, 'Updated health notes for recipient 3001'),
('FoodInventory', 'DELETE', 5003, 'Removed expired item'),
('Staff', 'INSERT', 5005, 'Added new volunteer'),
('EventSchedules', 'UPDATE', 5002, 'Changed event date');

-- Step 47: Insert 5 more donors with only required fields
INSERT INTO Donors (DonorName, DonorType) VALUES
('Meklit Hailu', 'Individual'),
('Addis Ababa University', 'Organization'),
('Tadesse Woldemariam', 'Individual'),
('Selam Children Home', 'Organization'),
('Zerihun Assefa', 'Individual');

-- Step 48: Insert 3 volunteer shifts with status 'Completed'? Actually shift status not needed; we insert shifts.
INSERT INTO VolunteerShifts (StaffID, ShiftDate, ShiftType) VALUES
(5002, '2025-07-01', 'Morning'),
(5002, '2025-07-01', 'Afternoon'),
(5006, '2025-07-02', 'Evening');

-- Step 49: Insert food inventory items that are already expired
-- Status column not yet added, so insert without Status
INSERT INTO FoodInventory (FoodName, Quantity, Unit, ExpirationDate, Supplier, MinThreshold) VALUES
('Yogurt', 50, 'cups', '2025-01-01', 'Lame Dairy', 10),
('Milk', 30, 'liters', '2025-02-15', 'Lame Dairy', 5);

-- Step 50:  For simplicity, we'll add a request in EventSchedules with high expected.
INSERT INTO EventSchedules (EventName, EventDate, Location, CoordinatorID, ExpectedRecipients, Status) VALUES
('Emergency Flood Relief', '2025-07-10', 'Adama', 5001, 1000, 'Planned');

-- =====================================================
-- SECTION 6: ALTERING TABLES (Step 51-60)
-- =====================================================

-- Step 51: Alter the Donors table to add LastDonationDate (already exists, but we can add a new column if needed)
ALTER TABLE Donors ADD LastDonationDate2 DATE NULL; -- Example
-- But we already have LastDonationDate, so we'll add a different column: PreferredContactMethod
ALTER TABLE Donors ADD PreferredContactMethod NVARCHAR(20) NULL;

-- Step 52: Alter the Donors table to add TotalDonations (already have TotalContribution, so add another)
ALTER TABLE Donors ADD NumberOfDonations INT DEFAULT 0;

-- Step 53: Alter the DistributionCenters table to add AccreditationStatus
ALTER TABLE DistributionCenters ADD AccreditationStatus NVARCHAR(30) DEFAULT 'Accredited';

-- Step 54: Alter the Staff table to add LicenseNumber (Unique)
-- First add the column
ALTER TABLE Staff ADD LicenseNumber NVARCHAR(50);
GO

-- Then add the UNIQUE constraint (allows multiple NULLs)
-- Drop the failed constraint if it was partially created
ALTER TABLE Staff DROP CONSTRAINT IF EXISTS UQ_Staff_LicenseNumber;
GO

-- Create a filtered unique index
CREATE UNIQUE NONCLUSTERED INDEX UQ_Staff_LicenseNumber 
ON Staff(LicenseNumber) 
WHERE LicenseNumber IS NOT NULL;
GO
-- Step 56: Alter the ContactInformation table to modify Phone column to VARCHAR(20)
ALTER TABLE ContactInformation ALTER COLUMN Phone NVARCHAR(20);

-- Step 57: Alter the Recipients table to add CHECK constraint on Gender (already had)
-- Already have.

-- Step 58: Alter the MealDistribution table to add ConsentForm
ALTER TABLE MealDistribution ADD ConsentForm BIT DEFAULT 0;

-- Step 59: Alter the DistributionCenters table to add Website
ALTER TABLE DistributionCenters ADD Website NVARCHAR(100);

-- Step 60: Alter the DistributionCenters table to add EmailContact (already have email in ContactInfo? but separate)
ALTER TABLE DistributionCenters ADD EmailContact NVARCHAR(100);

-- =====================================================
-- SECTION 7: UPDATING DATA (Step 61-70)
-- =====================================================

-- Step 61: Update a SINGLE donor's LastDonationDate to today for DonorID 1001
UPDATE Donors SET LastDonationDate = GETDATE() WHERE DonorID = 1001;

-- Step 62: Update MULTIPLE donors' NumberOfDonations increment by 1 for DonorID between 1001 and 1005
UPDATE Donors SET NumberOfDonations = NumberOfDonations + 1 WHERE DonorID BETWEEN 1001 AND 1005;

-- Step 63: Update ALL medical staff members' Salary by 5%
UPDATE Staff SET Salary = Salary * 1.05 WHERE Role IN ('Coordinator', 'Cook', 'Driver', 'Admin') AND Salary > 0;

-- Step 64: Update a specific appointment status (we don't have appointments; update attendance status)
UPDATE Attendance SET Status = 'Present' WHERE AttendanceID = 1;

-- Step 65: Update food inventory items: set Status (if we had) to Expired where ExpirationDate < GETDATE()
-- We don't have status, so we can add a Status column first.
ALTER TABLE FoodInventory ADD Status NVARCHAR(20) DEFAULT 'Available' CHECK (Status IN ('Available', 'Reserved', 'Issued', 'Expired', 'Discarded'));
GO

-- Now update expired items
UPDATE FoodInventory SET Status = 'Expired' WHERE ExpirationDate < GETDATE();
GO
-- Step 66: Update a specific food request (not exist) - we update event status instead
UPDATE EventSchedules SET Status = 'Completed' WHERE EventID = 7001;

-- Step 67: Update multiple recipients (no emergency flag, but we can update health notes)
UPDATE Recipients SET HealthNotes = 'Needs special attention' WHERE RecipientID IN (3001, 3002);

-- Step 68: Update a donor's contact information (using ContactInformation)
UPDATE ContactInformation SET Email = 'newemail@test.com', Phone = '+251-911-123456' WHERE PersonType = 'Donor' AND PersonID = 1001;

-- Step 69: Update equipment maintenance dates (set NextMaintenanceDate is computed, so update LastMaintenanceDate)
UPDATE Assets SET LastMaintenanceDate = GETDATE() WHERE AssetID = 6001;

-- Step 70: Update blood drive actual donations (event actual recipients)
UPDATE EventSchedules SET ActualRecipients = 120 WHERE EventID = 7002;

-- =====================================================
-- SECTION 8: BASIC SELECT QUERIES (Step 71-85)
-- =====================================================

-- Step 71: Select ALL columns from the Donors table
SELECT * FROM Donors;

-- Step 72: Select ALL columns from MealTypes table
SELECT * FROM MealTypes;

-- Step 73: Select ONLY FirstName and LastName from all Recipients
SELECT FirstName, LastName FROM Recipients;

-- Step 74: Select ONLY DistributionID, DistributionDate, Quantity from MealDistribution
SELECT DistributionID, DistributionDate, Quantity FROM MealDistribution;

-- Step 75: Select ALL columns from Recipients where MealTypeID? Not applicable. Instead, from Recipients where TotalMealsServed > 0
SELECT * FROM Recipients WHERE TotalMealsServed > 0;

-- Step 76: Select ALL recipients who are emergency cases (if we had flag) - we don't, so skip or use HealthNotes containing 'emergency'
SELECT * FROM Recipients WHERE HealthNotes LIKE '%emergency%';

-- Step 77: Select DonorID, DonorName, TotalContribution from Donors where DonorType = 'Individual'
SELECT DonorID, DonorName, TotalContribution FROM Donors WHERE DonorType = 'Individual';

-- Step 78: Select ALL food inventory items with Status 'Available'
SELECT * FROM FoodInventory WHERE Status = 'Available';

-- Step 79: Select ALL columns from Attendance where Status = 'Present'
SELECT * FROM Attendance WHERE Status = 'Present';

-- Step 80: Select CenterName and City from DistributionCenters where City = 'Addis Ababa'
SELECT CenterName, City FROM DistributionCenters WHERE City = 'Addis Ababa';

-- Step 81: Select DISTINCT BloodGroupID? Not applicable. Select DISTINCT Role from Staff
SELECT DISTINCT Role FROM Staff;

-- Step 82: Select DISTINCT City from DistributionCenters
SELECT DISTINCT City FROM DistributionCenters;

-- Step 83: Select COUNT(*) as TotalDonors from Donors
SELECT COUNT(*) AS TotalDonors FROM Donors;

-- Step 84: Select COUNT(*) as TotalDistributions from MealDistribution
SELECT COUNT(*) AS TotalDistributions FROM MealDistribution;

-- Step 85: Select COUNT(*) as AvailableFoodItems from FoodInventory where Status = 'Available'
SELECT COUNT(*) AS AvailableFoodItems FROM FoodInventory WHERE Status = 'Available';

-- =====================================================
-- SECTION 9: INTERMEDIATE SELECT QUERIES (Step 86-100)
-- =====================================================

-- Step 86: Select all donors ordered by LastDonationDate descending
SELECT * FROM Donors ORDER BY LastDonationDate DESC;

-- Step 87: Select all meal distributions ordered by DistributionDate descending
SELECT * FROM MealDistribution ORDER BY DistributionDate DESC;

-- Step 88: Select all recipients ordered by Age descending (oldest first)
SELECT * FROM Recipients ORDER BY Age DESC;

-- Step 89: Select FirstName, LastName from Staff where Role = 'Cook' AND Salary > 30000
SELECT FirstName, LastName FROM Staff WHERE Role = 'Cook' AND Salary > 30000;

-- Step 90: Select all events where Status = 'Planned' OR Status = 'Active'
SELECT * FROM EventSchedules WHERE Status IN ('Planned', 'Active');

-- Step 91: Select all notifications where IsRead = 0
SELECT * FROM Notifications WHERE IsRead = 0;

-- Step 92: Select all donors where DonorType = 'Organization' AND TotalContribution > 100000 ORDER BY TotalContribution DESC
SELECT * FROM Donors WHERE DonorType = 'Organization' AND TotalContribution > 100000 ORDER BY TotalContribution DESC;

-- Step 93: Select all food inventory where Status = 'Available' OR Status = 'Reserved' ORDER BY ExpirationDate
SELECT * FROM FoodInventory WHERE Status IN ('Available', 'Reserved') ORDER BY ExpirationDate;

-- Step 94: Select all staff where IsActive = 1 AND Salary > 40000 ORDER BY Salary DESC
SELECT * FROM Staff WHERE IsActive = 1 AND Salary > 40000 ORDER BY Salary DESC;

-- Step 95: Select FirstName, LastName, Age from Recipients where Age > 50 ORDER BY Age
SELECT FirstName, LastName, Age FROM Recipients WHERE Age > 50 ORDER BY Age;

-- Step 96: Select all food orders where Status = 'Pending' AND OrderDate < DATEADD(DAY, -7, GETDATE())
SELECT * FROM FoodOrders WHERE Status = 'Pending' AND OrderDate < DATEADD(DAY, -7, GETDATE());

-- Step 97: Select DISTINCT ShiftType from VolunteerShifts
SELECT DISTINCT ShiftType FROM VolunteerShifts;

-- Step 98: Select COUNT(*) as FemaleRecipients from Recipients where Gender = 'F'
SELECT COUNT(*) AS FemaleRecipients FROM Recipients WHERE Gender = 'F';

-- Step 99: Select CenterName, Capacity from DistributionCenters where Capacity > 150 ORDER BY Capacity DESC
SELECT CenterName, Capacity FROM DistributionCenters WHERE Capacity > 150 ORDER BY Capacity DESC;

-- Step 100: Select all donors where LastDonationDate IS NULL OR LastDonationDate < DATEADD(MONTH, -6, GETDATE())
SELECT * FROM Donors WHERE LastDonationDate IS NULL OR LastDonationDate < DATEADD(MONTH, -6, GETDATE());

-- =====================================================
-- SECTION 10: ADVANCED SELECT QUERIES (Step 101-115)
-- =====================================================

-- Step 101: Select TOP 5 most recent meal distributions
SELECT TOP 5 DistributionID, RecipientID, DistributionDate, Quantity FROM MealDistribution ORDER BY DistributionDate DESC;

-- Step 102: Select all meal types and COUNT how many distributions each has
SELECT mt.MealName, COUNT(md.DistributionID) AS DistributionCount
FROM MealTypes mt
LEFT JOIN MealDistribution md ON mt.MealTypeID = md.MealTypeID
GROUP BY mt.MealName;

-- Step 103: Select all distribution centers and COUNT how many distributions each has
SELECT dc.CenterName, COUNT(md.DistributionID) AS DistributionCount
FROM DistributionCenters dc
LEFT JOIN MealDistribution md ON dc.CenterID = md.CenterID
GROUP BY dc.CenterName;

-- Step 104: Select SUM of all food quantities in inventory grouped by FoodName
SELECT FoodName, SUM(Quantity) AS TotalQuantity FROM FoodInventory GROUP BY FoodName;

-- Step 105: Select AVG salary of staff grouped by Role
SELECT Role, AVG(Salary) AS AvgSalary FROM Staff GROUP BY Role;

-- Step 106: Select all donors with their contact information
SELECT d.DonorID, d.DonorName, c.Phone, c.Email, c.City
FROM Donors d
LEFT JOIN ContactInformation c ON c.PersonType = 'Donor' AND c.PersonID = d.DonorID;

-- Step 107: Select all meal distributions with recipient names and meal types
SELECT md.DistributionID, r.FirstName + ' ' + r.LastName AS RecipientName, mt.MealName, md.DistributionDate
FROM MealDistribution md
JOIN Recipients r ON md.RecipientID = r.RecipientID
JOIN MealTypes mt ON md.MealTypeID = mt.MealTypeID;

-- Step 108: Select all volunteer shifts with staff names and center names (if we had center in shifts, we don't, so join with staff)
SELECT vs.ShiftID, s.FirstName + ' ' + s.LastName AS StaffName, vs.ShiftDate, vs.ShiftType
FROM VolunteerShifts vs
JOIN Staff s ON vs.StaffID = s.StaffID;

-- Step 109: Select all events with coordinator names
SELECT e.EventName, e.EventDate, e.Location, s.FirstName + ' ' + s.LastName AS Coordinator
FROM EventSchedules e
JOIN Staff s ON e.CoordinatorID = s.StaffID;

-- Step 110: Select all food issuances with complete information (distribution, food, staff)
SELECT fi.IssuanceID, md.DistributionID, f.FoodName, fi.QuantityUsed, s.FirstName + ' ' + s.LastName AS IssuedBy
FROM FoodIssuance fi
JOIN MealDistribution md ON fi.DistributionID = md.DistributionID
JOIN FoodInventory f ON fi.FoodID = f.FoodID
JOIN Staff s ON fi.IssuedByStaffID = s.StaffID;

-- Step 111: Select total quantity of each food component (just food name) in inventory, only Available status
SELECT FoodName, SUM(Quantity) AS TotalAvailable FROM FoodInventory WHERE Status = 'Available' GROUP BY FoodName;

-- Step 112: Select all donors who have donated more than once (if we had donations table, but we don't. Use NumberOfDonations)
SELECT DonorName, NumberOfDonations FROM Donors WHERE NumberOfDonations > 1;

-- Step 113: Select meal types that have more than 2 distributions
SELECT mt.MealName, COUNT(md.DistributionID) AS DistCount
FROM MealTypes mt
JOIN MealDistribution md ON mt.MealTypeID = md.MealTypeID
GROUP BY mt.MealName
HAVING COUNT(md.DistributionID) > 2;

-- Step 114: Select all expired food inventory items with details
SELECT FoodName, Quantity, ExpirationDate FROM FoodInventory WHERE Status = 'Expired' ORDER BY ExpirationDate;

-- Step 115: Select distribution centers with the most distributions
SELECT dc.CenterName, COUNT(md.DistributionID) AS TotalDistributions
FROM DistributionCenters dc
LEFT JOIN MealDistribution md ON dc.CenterID = md.CenterID
GROUP BY dc.CenterName
ORDER BY TotalDistributions DESC;

-- =====================================================
-- SECTION 11: COMPLEX QUERIES (Step 116-125)
-- =====================================================

-- Step 116: Select all donors who have never donated (NumberOfDonations = 0)
SELECT * FROM Donors WHERE NumberOfDonations = 0;

-- Step 117: Select all food requests that haven't been fulfilled yet (we don't have requests, so use FoodOrders with status not 'Received')
SELECT * FROM FoodOrders WHERE Status != 'Received';

-- Step 118: Select total value of incentives given, grouped by IncentiveType
SELECT IncentiveType, SUM(IncentiveValue) AS TotalValue FROM DonationIncentives GROUP BY IncentiveType;

-- Step 119: Select all donors with their total number of donations (including 0)
SELECT d.DonorID, d.DonorName, COALESCE(COUNT(di.IncentiveID), 0) AS IncentiveCount
FROM Donors d
LEFT JOIN DonationIncentives di ON d.DonorID = di.DonorID
GROUP BY d.DonorID, d.DonorName;

-- Step 120: Select all distribution centers and count how many staff they have (if we had staff assigned to centers, we don't; instead count events per center)
SELECT dc.CenterName, COUNT(e.EventID) AS EventCount
FROM DistributionCenters dc
LEFT JOIN EventSchedules e ON dc.CenterID = e.CoordinatorID  -- not a direct relation, just for demo
GROUP BY dc.CenterName;

-- Step 121: Select food inventory items that will expire in the next 7 days
SELECT FoodName, Quantity, ExpirationDate FROM FoodInventory
WHERE ExpirationDate BETWEEN GETDATE() AND DATEADD(DAY, 7, GETDATE());

-- Step 122: Select donors who are eligible to donate again (LastDonationDate > 6 months ago or NULL)
SELECT * FROM Donors WHERE LastDonationDate IS NULL OR LastDonationDate < DATEADD(MONTH, -6, GETDATE());

-- Step 123: Select the most requested food items (if we had requests) - use FoodOrders quantity sum
SELECT FoodID, SUM(Quantity) AS TotalOrdered FROM FoodOrders GROUP BY FoodID ORDER BY TotalOrdered DESC;

-- Step 124: Select staff who have performed more than 2 distributions
SELECT s.StaffID, s.FirstName, s.LastName, COUNT(md.DistributionID) AS Distributions
FROM Staff s
JOIN MealDistribution md ON s.StaffID = md.StaffID
GROUP BY s.StaffID, s.FirstName, s.LastName
HAVING COUNT(md.DistributionID) > 2;

-- Step 125: Select donors who are blacklisted
SELECT d.DonorID, d.DonorName, db.Reason, db.BlacklistDate
FROM Donors d
JOIN DonorBlacklist db ON d.DonorID = db.DonorID;

-- =====================================================
-- SECTION 12: SUBQUERIES (Step 126-135)
-- =====================================================

-- Step 126: Select all donors whose TotalContribution is greater than the average contribution
SELECT * FROM Donors WHERE TotalContribution > (SELECT AVG(TotalContribution) FROM Donors);

-- Step 127: Select all recipients who received more meals than the average
SELECT * FROM Recipients WHERE TotalMealsServed > (SELECT AVG(TotalMealsServed) FROM Recipients);

-- Step 128: Select all food items with quantity less than the min threshold
SELECT * FROM FoodInventory WHERE Quantity < MinThreshold;

-- Step 129: Select staff whose salary > average salary of their role
SELECT * FROM Staff s1
WHERE Salary > (SELECT AVG(Salary) FROM Staff s2 WHERE s2.Role = s1.Role);

-- Step 130: Select distributions where quantity > average quantity
SELECT * FROM MealDistribution WHERE Quantity > (SELECT AVG(Quantity) FROM MealDistribution);

-- Step 131: Select donors who have never donated (NumberOfDonations = 0)
SELECT * FROM Donors WHERE NumberOfDonations = 0;

-- Step 132: Select the most recent distribution for each recipient
SELECT r.RecipientID, r.FirstName, r.LastName, md.DistributionDate, md.Quantity
FROM Recipients r
JOIN MealDistribution md ON r.RecipientID = md.RecipientID
WHERE md.DistributionDate = (SELECT MAX(DistributionDate) FROM MealDistribution md2 WHERE md2.RecipientID = r.RecipientID);

-- Step 133: Select events where coordinator manages multiple events
SELECT * FROM EventSchedules e1
WHERE (SELECT COUNT(*) FROM EventSchedules e2 WHERE e2.CoordinatorID = e1.CoordinatorID) > 1;

-- Step 134: Select staff who have served meals in all meal types
SELECT s.StaffID, s.FirstName, s.LastName
FROM Staff s
WHERE NOT EXISTS (
    SELECT MealTypeID FROM MealTypes
    EXCEPT
    SELECT DISTINCT MealTypeID FROM MealDistribution WHERE StaffID = s.StaffID
);

-- Step 135: Select recipients whose last meal was more than 3 days ago
SELECT * FROM Recipients
WHERE LastMealReceivedDate < DATEADD(DAY, -3, GETDATE());

-- =====================================================
-- SECTION 13: DELETING DATA (Step 136-145)
-- =====================================================

-- Step 136: Delete a SINGLE appointment record (we have no appointments, delete a notification)
DELETE FROM Notifications WHERE NotificationID = 1;

-- Step 137: Delete all notifications that have been read (IsRead = 1)
DELETE FROM Notifications WHERE IsRead = 1;

-- Step 138: Delete all expired food inventory items (Status = 'Expired')
DELETE FROM FoodInventory WHERE Status = 'Expired';

-- Step 139: Delete all cancelled appointments (none, so delete events with Status 'Cancelled')
DELETE FROM EventSchedules WHERE Status = 'Cancelled';

-- Step 140: Delete a specific blood drive event (delete event with EventID = 7001)
DELETE FROM EventSchedules WHERE EventID = 7001;

-- Step 141: Delete all audit log entries older than 1 year
DELETE FROM AuditLog WHERE PerformedDate < DATEADD(YEAR, -1, GETDATE());

-- Step 142: Delete equipment that is 'Out of Service'
DELETE FROM Assets WHERE Status = 'Out of Service';

-- Step 143: Delete all notifications older than 30 days
DELETE FROM Notifications WHERE SentDate < DATEADD(DAY, -30, GETDATE());

-- Step 144: Delete a specific incentive record (IncentiveID = 1)
DELETE FROM DonationIncentives WHERE IncentiveID = 1;

-- Step 145: Delete food quality checks where CheckResult = 'Pending' and CheckDate > 7 days ago
DELETE FROM FoodQualityChecks WHERE CheckResult = 'Pending' AND CheckDate < DATEADD(DAY, -7, GETDATE());

-- =====================================================
-- SECTION 14: DROPPING TABLES AND DATABASES (Step 146-150)
-- =====================================================

-- Step 146: Create a test table named 'TempTable' with any structure
CREATE TABLE TempTable (ID INT, Name NVARCHAR(50));
GO

-- Step 147: Drop the TempTable you just created
DROP TABLE TempTable;
GO

-- Step 148: Create a test database named 'TestDB'
CREATE DATABASE TestDB;
GO

-- Step 149: Drop the TestDB database
DROP DATABASE TestDB;
GO

-- Step 150: Drop the FoodCharityDB_Backup database
DROP DATABASE FoodCharityDB_Backup;
GO

-- =====================================================
-- SECTION 15: CHALLENGE Step (Step 151-165)
-- =====================================================

-- Step 151: Find donors who have the same meal type preference as most critical events?
-- We don't have meal preferences, so we'll find donors with high contributions who haven't donated recently.
SELECT * FROM Donors
WHERE TotalContribution > 100000 AND (LastDonationDate IS NULL OR LastDonationDate < DATEADD(MONTH, -3, GETDATE()));

-- Step 152: Show food shortage: list food items where total required (based on expected recipients) exceeds inventory
-- Estimate required: assume each recipient needs 0.5 kg of staple food. Compare with inventory.
SELECT f.FoodName, f.Quantity, 
       (SELECT SUM(ExpectedRecipients) * 0.5 FROM EventSchedules WHERE EventDate > GETDATE()) AS EstimatedRequirement
FROM FoodInventory f
WHERE f.Quantity < (SELECT SUM(ExpectedRecipients) * 0.5 FROM EventSchedules WHERE EventDate > GETDATE());

-- Step 153: Find all distribution centers that have never had any distributions
SELECT * FROM DistributionCenters
WHERE CenterID NOT IN (SELECT DISTINCT CenterID FROM MealDistribution);

-- Step 154: Find potential donor-recipient matches: donors who could sponsor recipients based on health notes
-- Example: donors with high contributions could be matched with recipients who have special needs.
SELECT d.DonorName, r.FirstName + ' ' + r.LastName AS RecipientName, r.HealthNotes
FROM Donors d
CROSS JOIN Recipients r
WHERE r.HealthNotes IS NOT NULL AND d.TotalContribution > 50000;

-- Step 155: Calculate "distribution efficiency" for each staff: distributions per day worked
SELECT s.StaffID, s.FirstName, s.LastName,
       COUNT(DISTINCT md.DistributionID) AS TotalDistributions,
       COUNT(DISTINCT a.AttendanceDate) AS DaysWorked,
       COUNT(DISTINCT md.DistributionID) * 1.0 / NULLIF(COUNT(DISTINCT a.AttendanceDate), 0) AS Efficiency
FROM Staff s
LEFT JOIN MealDistribution md ON s.StaffID = md.StaffID
LEFT JOIN Attendance a ON s.StaffID = a.StaffID AND a.Status = 'Present'
GROUP BY s.StaffID, s.FirstName, s.LastName;

-- Step 156: Find events that have requested food but never received any issuance (no link, so find events with no actual recipients)
SELECT * FROM EventSchedules WHERE ActualRecipients = 0;

-- Step 157: Identify the best performing distribution center (most distributions, highest success rate)
SELECT CenterID, COUNT(*) AS TotalDists
FROM MealDistribution
GROUP BY CenterID
ORDER BY TotalDists DESC;

-- Step 158: Find donors who should be contacted for urgent donations: they have high contributions, not blacklisted, last donation > 6 months
SELECT d.*
FROM Donors d
LEFT JOIN DonorBlacklist db ON d.DonorID = db.DonorID
WHERE db.DonorID IS NULL
  AND (d.LastDonationDate IS NULL OR d.LastDonationDate < DATEADD(MONTH, -6, GETDATE()))
  AND d.TotalContribution > 50000;

-- Step 159: Detect data issues: Find FoodInventory records where ExpirationDate is before LastUpdated
SELECT * FROM FoodInventory WHERE ExpirationDate < CAST(LastUpdated AS DATE);

-- Step 160: Calculate revenue potential from incentives: total incentive value per donor type
SELECT d.DonorType, SUM(di.IncentiveValue) AS TotalIncentiveValue
FROM Donors d
JOIN DonationIncentives di ON d.DonorID = di.DonorID
GROUP BY d.DonorType;

-- Step 161: Find "at-risk" inventory: food items that are available, expire in less than 7 days, and not reserved
SELECT * FROM FoodInventory
WHERE Status = 'Available'
  AND ExpirationDate BETWEEN GETDATE() AND DATEADD(DAY, 7, GETDATE())
  AND FoodID NOT IN (SELECT DISTINCT FoodID FROM FoodIssuance WHERE IssuedDate > GETDATE() - 30); -- simplistic

-- Step 162: Identify duplicate contact information: same email or phone
SELECT Email, COUNT(*) FROM ContactInformation WHERE Email IS NOT NULL GROUP BY Email HAVING COUNT(*) > 1;
SELECT Phone, COUNT(*) FROM ContactInformation WHERE Phone IS NOT NULL GROUP BY Phone HAVING COUNT(*) > 1;

-- Step 163: Generate a monthly donation report: count of donations per month (from MealDistribution)
SELECT YEAR(DistributionDate) AS Year, MONTH(DistributionDate) AS Month, COUNT(*) AS TotalMeals
FROM MealDistribution
GROUP BY YEAR(DistributionDate), MONTH(DistributionDate)
ORDER BY Year, Month;

-- Step 164: Find staff who are overworked: handled more than average distributions and worked in more than 2 centers
SELECT s.StaffID, s.FirstName, s.LastName, COUNT(DISTINCT md.CenterID) AS CentersWorked, COUNT(md.DistributionID) AS TotalDists
FROM Staff s
JOIN MealDistribution md ON s.StaffID = md.StaffID
GROUP BY s.StaffID, s.FirstName, s.LastName
HAVING COUNT(md.DistributionID) > (SELECT AVG(DistCount) FROM (SELECT StaffID, COUNT(*) AS DistCount FROM MealDistribution GROUP BY StaffID) AS t)
   AND COUNT(DISTINCT md.CenterID) > 2;

-- Step 165: Create a donor loyalty score: 10 points per donation (NumberOfDonations), 5 points per incentive, 1 point per 1000 Birr contribution
SELECT DonorID, DonorName,
       (NumberOfDonations * 10) + 
       (SELECT COUNT(*) * 5 FROM DonationIncentives di WHERE di.DonorID = d.DonorID) +
       (TotalContribution / 1000) AS LoyaltyScore
FROM Donors d
ORDER BY LoyaltyScore DESC;

-- =====================================================
-- SECTION 16: CREATIVE QUERIES (Step 166-180)
-- =====================================================

-- Step 166: Meal of the Month (most distributed meal type in current month)
SELECT TOP 1 mt.MealName, COUNT(*) AS MealCount
FROM MealTypes mt
JOIN MealDistribution md ON mt.MealTypeID = md.MealTypeID
WHERE MONTH(md.DistributionDate) = MONTH(GETDATE()) AND YEAR(md.DistributionDate) = YEAR(GETDATE())
GROUP BY mt.MealName
ORDER BY MealCount DESC;

-- Step 167: Recipient appreciation: recipients who have received 50+ meals
SELECT * FROM Recipients WHERE TotalMealsServed >= 50;

-- Step 168: Inventory health dashboard: total available, near expiry, low stock by category
SELECT 
    (SELECT SUM(Quantity) FROM FoodInventory WHERE Status = 'Available') AS TotalAvailable,
    (SELECT COUNT(*) FROM FoodInventory WHERE ExpirationDate BETWEEN GETDATE() AND DATEADD(DAY, 7, GETDATE())) AS NearExpiryCount,
    (SELECT COUNT(*) FROM FoodInventory WHERE Quantity < MinThreshold) AS LowStockCount;

-- Step 169: Supplier performance: which suppliers have the most orders delivered on time
SELECT Supplier, 
       COUNT(CASE WHEN Status = 'Received' THEN 1 END) AS ReceivedCount,
       COUNT(*) AS TotalOrders,
       (COUNT(CASE WHEN Status = 'Received' THEN 1 END) * 100.0 / COUNT(*)) AS SuccessRate
FROM FoodOrders
GROUP BY Supplier
ORDER BY SuccessRate DESC;

-- Step 170: Staff productivity: distributions per staff per day (last 30 days)
SELECT s.FirstName, s.LastName, 
       COUNT(md.DistributionID) / 30.0 AS AvgDailyDistributions
FROM Staff s
LEFT JOIN MealDistribution md ON s.StaffID = md.StaffID AND md.DistributionDate > DATEADD(DAY, -30, GETDATE())
GROUP BY s.StaffID, s.FirstName, s.LastName
ORDER BY AvgDailyDistributions DESC;

-- Step 171: Donor retention: donors who donated in consecutive years (if we had multiple donations)
-- Not enough data, so skip or simplify.

-- Step 172: Recipient demographics: age groups and meal preferences
SELECT 
    CASE 
        WHEN Age < 18 THEN 'Child'
        WHEN Age BETWEEN 18 AND 35 THEN 'Young Adult'
        WHEN Age BETWEEN 36 AND 60 THEN 'Adult'
        ELSE 'Senior'
    END AS AgeGroup,
    mt.MealName,
    COUNT(*) AS MealCount
FROM Recipients r
JOIN MealDistribution md ON r.RecipientID = md.RecipientID
JOIN MealTypes mt ON md.MealTypeID = mt.MealTypeID
GROUP BY CASE WHEN Age < 18 THEN 'Child' WHEN Age BETWEEN 18 AND 35 THEN 'Young Adult' WHEN Age BETWEEN 36 AND 60 THEN 'Adult' ELSE 'Senior' END, mt.MealName
ORDER BY AgeGroup, MealCount DESC;

-- Step 173: Event impact: meals distributed per event (assuming events are linked to distributions via date/location)
-- We can link events to distributions by date and location (approximate)
SELECT e.EventName, COUNT(md.DistributionID) AS MealsServed
FROM EventSchedules e
LEFT JOIN MealDistribution md ON CAST(md.DistributionDate AS DATE) = e.EventDate
GROUP BY e.EventName;

-- Step 174: Volunteer availability: volunteers not assigned to any shift
SELECT * FROM Staff
WHERE Role = 'Volunteer'
  AND StaffID NOT IN (SELECT DISTINCT StaffID FROM VolunteerShifts WHERE ShiftDate >= GETDATE());

-- Step 175: Financial report: total donations per month
SELECT YEAR(LastDonationDate) AS Year, MONTH(LastDonationDate) AS Month, SUM(TotalContribution) AS MonthlyDonations
FROM Donors
WHERE LastDonationDate IS NOT NULL
GROUP BY YEAR(LastDonationDate), MONTH(LastDonationDate)
ORDER BY Year, Month;

-- Step 176: Meal variety: number of different meal types served per week
SELECT DATEPART(WEEK, DistributionDate) AS WeekNumber, COUNT(DISTINCT MealTypeID) AS DistinctMealTypes
FROM MealDistribution
GROUP BY DATEPART(WEEK, DistributionDate)
ORDER BY WeekNumber;

-- Step 177: Recipient satisfaction: based on health notes improvement (if we had multiple records)
-- Not enough data, so skip.

-- Step 178: Emergency response: meals served to recipients with emergency flag (none, so use health notes containing 'urgent')
SELECT COUNT(*) AS EmergencyMeals
FROM MealDistribution md
JOIN Recipients r ON md.RecipientID = r.RecipientID
WHERE r.HealthNotes LIKE '%urgent%';

-- Step 179: Shows how many people enrolled as recipients each year (based on their RegistrationDate).
SELECT 
    YEAR(RegistrationDate) AS Year,
    COUNT(*) AS NewRecipients
FROM Recipients
GROUP BY YEAR(RegistrationDate)
ORDER BY Year;
--Step 180: Counts donors who made a donation in a given year
SELECT 
    YEAR(LastDonationDate) AS Year,
    COUNT(*) AS ActiveDonors
FROM Donors
WHERE LastDonationDate IS NOT NULL
GROUP BY YEAR(LastDonationDate)
ORDER BY Year;
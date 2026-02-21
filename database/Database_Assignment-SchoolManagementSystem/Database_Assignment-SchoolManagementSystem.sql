/*
    DataBase Assignment The 280 Queestions With Data , Answer 
    
*/
CREATE DATABASE SchoolManagementSystem;
GO

USE SchoolManagementSystem;
GO

CREATE TABLE Schools (
    SchoolID INT PRIMARY KEY IDENTITY(1,1),
    SchoolName VARCHAR(100) NOT NULL,
    Location VARCHAR(100) NOT NULL,
    EstablishedYear INT,
);

CREATE TABLE Students (
    StudentID INT PRIMARY KEY IDENTITY(1,1),
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    FullName AS (FirstName + ' ' + LastName) PERSISTED, -- Computed column for full name
    DateOfBirth DATE,
    EnrollmentDate DATE DEFAULT GETDATE(),
    SchoolID INT FOREIGN KEY REFERENCES Schools(SchoolID)
);

CREATE TABLE Courses (
    CourseID INT PRIMARY KEY IDENTITY(1,1),
    CourseName VARCHAR(100) NOT NULL,
    Credits INT NOT NULL,
    Description VARCHAR(255),
    SchoolID INT FOREIGN KEY REFERENCES Schools(SchoolID) -- Courses can be school-specific
);

-- Create Instructors table
CREATE TABLE Instructors (
    InstructorID INT PRIMARY KEY IDENTITY(1,1),
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    FullName AS (FirstName + ' ' + LastName) PERSISTED, -- Computed column for full name
    HireDate DATE,
    Department VARCHAR(50),
    SchoolID INT FOREIGN KEY REFERENCES Schools(SchoolID)
);

CREATE TABLE ClassRooms (
    RoomID INT PRIMARY KEY IDENTITY(1,1),
    RoomNumber VARCHAR(20) NOT NULL,
    Capacity INT NOT NULL,
    Building VARCHAR(50),
    SchoolID INT FOREIGN KEY REFERENCES Schools(SchoolID)
);

CREATE TABLE LabRooms (
    LabID INT PRIMARY KEY IDENTITY(1,1),
    LabNumber VARCHAR(20) NOT NULL,
    Capacity INT NOT NULL,
    Equipment VARCHAR(255),
    SchoolID INT FOREIGN KEY REFERENCES Schools(SchoolID)
);

CREATE TABLE Registrations (
    RegistrationID INT PRIMARY KEY IDENTITY(1,1),
    StudentID INT FOREIGN KEY REFERENCES Students(StudentID),
    CourseID INT FOREIGN KEY REFERENCES Courses(CourseID),
    Semester VARCHAR(20) NOT NULL, -- e.g., 'Fall', 'Spring'
    Year INT NOT NULL,
    RegistrationDate DATE DEFAULT GETDATE(),
    Status VARCHAR(20) DEFAULT 'Enrolled' -- e.g., 'Enrolled', 'Dropped'
);

CREATE TABLE Grades (
    GradeID INT PRIMARY KEY IDENTITY(1,1),
    StudentID INT FOREIGN KEY REFERENCES Students(StudentID),
    CourseID INT FOREIGN KEY REFERENCES Courses(CourseID),
    Grade DECIMAL(5,2) NOT NULL, -- e.g., 85.50
    LetterGrade AS (CASE 
                        WHEN Grade >= 90 THEN 'A' 
                        WHEN Grade >= 80 THEN 'B' 
                        WHEN Grade >= 70 THEN 'C' 
                        WHEN Grade >= 60 THEN 'D' 
                        ELSE 'F' 
                    END) PERSISTED, -- Computed column for letter grade
    GradeDate DATE DEFAULT GETDATE()
);
GO

USE SchoolManagementSystem;
GO

--TRUNCATE TABLE Schools;
INSERT INTO Schools (SchoolName, Location, EstablishedYear)
VALUES
('Riverside High'         ,'Amsterdam'         ,1998),
('Zuidas Academy'         ,'Amsterdam'         ,2012),
('North Holland International','Haarlem'       ,2004),
('Delft Technical College' ,'Delft'            ,1987),
('Utrecht Science School' ,'Utrecht'           ,1995),
('Rotterdam Maritime HS'  ,'Rotterdam'         ,2001),
('Eindhoven Tech Academy' ,'Eindhoven'         ,2010),
('Groningen North College','Groningen'         ,1992),
('Leiden Classical School','Leiden'            ,2006),
('The Hague Euro School'  ,'Den Haag'          ,2008),
('Tilburg Business HS'    ,'Tilburg'           ,2003),
('Almere Modern College'  ,'Almere'            ,2015),
('Breda Arts & Design'    ,'Breda'             ,1999),
('Nijmegen Green School'  ,'Nijmegen'          ,2007),
('Zwolle Regional HS'     ,'Zwolle'            ,2000),
('Enschede Innovation HS' ,'Enschede'          ,2011),
('Apeldoorn Forest School','Apeldoorn'         ,2005),
('Arnhem River College'   ,'Arnhem'            ,1996),
('Maastricht South HS'    ,'Maastricht'        ,2009),
('Amersfoort Unity School','Amersfoort'        ,2014);
GO

--TRUNCATE TABLE Students;
INSERT INTO Students (FirstName, LastName, DateOfBirth, SchoolID)
SELECT TOP 150
    fn.FirstName,
    ln.LastName,
    DATEADD(DAY, -(ABS(CHECKSUM(NEWID())) % 3650 + 4383), '2025-09-01'),
    1 + (ABS(CHECKSUM(NEWID())) % 20)
FROM (
    VALUES
    ('Lars'),('Emma'),('Noah'),('Sophie'),('Sem'),('Julia'),('Liam'),('Mila'),('Luca'),('Tess'),
    ('Finn'),('Sara'),('Thijs'),('Lot'),('Mees'),('Fleur'),('Noud'),('Yara'),('Cas'),('Lina'),
    ('Daan'),('Zo�'),('Luuk'),('Floor'),('Jelle'),('Isabel'),('Thomas'),('Lotte'),('Sam'),('Nova'),
    ('Tim'),('Elin'),('Jesse'),('Myrthe'),('Max'),('Roos'),('Sven'),('Amber'),('Bas'),('Lieve'),
    ('Gijs'),('Mara'),('Hidde'),('Fien'),('Milan'),('Esmee'),('Joris'),('Liv'),('Stijn'),('Noor'),
    ('Ruben'),('Lina'),('Teun'),('Elise'),('Nick'),('Hanna'),('Floris'),('Pien'),('Jasmijn'),('Merel'),
    ('Bram'),('Isis'),('Kees'),('Vera'),('Wout'),('Lune'),('Tuur'),('Fenne'),('Boaz'),('Saar'),
    ('Guus'),('Mevrouw'),('Jip'),('Sterre'),('Pim'),('Nova'),('Olaf'),('Maeve'),('Kian'),('Liza'),
    ('Johan'),('Fabi�nne'),('Sander'),('Evi'),('Mats'),('Freek'),('Rens'),('Lara'),('Duco'),('Nienke'),
    ('Bart'),('Linde'),('Jurre'),('Minke'),('Koen'),('Zara'),('Ties'),('Fay'),('Jochem'),('Elodie'),
    ('Dirk'),('Sterre'),('Maarten'),('Lien'),('Jort'),('Fien'),('Seb'),('Mila'),('Luuk'),('Yenthe')
) fn(FirstName)
CROSS JOIN (
    VALUES
    ('de Jong'),('Jansen'),('de Vries'),('van Dijk'),('Bakker'),('Visser'),('Smit'),('Meijer'),
    ('de Boer'),('Mulder'),('de Groot'),('Bos'),('Vermeulen'),('van den Berg'),('van Dijk'),
    ('Hendriks'),('Dekker'),('Hoogendoorn'),('Janssen'),('Verhoeven'),('van der Linden'),
    ('van Beek'),('van der Meer'),('van Leeuwen'),('Claassen'),('Willems'),('van der Wal'),
    ('Groen'),('van der Velde'),('Schouten'),('van der Heijden'),('Kramer'),('van Dongen'),
    ('Veenstra'),('Post'),('van der Horst'),('de Haan'),('Kuipers'),('Blok'),('van Dam'),
    ('Hermans'),('van den Akker'),('Sanders'),('Peeters'),('van der Horst'),('Molenaar')
) ln(LastName)
ORDER BY NEWID()
OPTION (MAXDOP 1);   
GO

--TRUNCATE TABLE Courses;
INSERT INTO Courses (CourseName, Credits, Description, SchoolID)
VALUES
('Mathematics A'        ,4 ,'Advanced algebra & calculus'     ,NULL),
('Mathematics B'        ,5 ,'Calculus & analytic geometry'     ,NULL),
('Physics 1'            ,4 ,'Mechanics & waves'                ,NULL),
('Physics 2'            ,5 ,'Electricity & magnetism'          ,NULL),
('Chemistry A'          ,4 ,'General & inorganic chemistry'    ,NULL),
('Chemistry B'          ,5 ,'Organic & biochemistry'           ,NULL),
('Biology A'            ,4 ,'Cell biology & genetics'          ,NULL),
('Biology B'            ,5 ,'Ecology & evolution'              ,NULL),
('Dutch Language'       ,4 ,'Literature & writing'             ,NULL),
('English B'            ,4 ,'Advanced English'                 ,NULL),
('German B'             ,4 ,'Intermediate German'              ,NULL),
('French B'             ,4 ,'Intermediate French'              ,NULL),
('History A'            ,3 ,'Modern European history'          ,NULL),
('History B'            ,4 ,'World history 1900�present'       ,NULL),
('Geography'            ,4 ,'Human & physical geography'       ,NULL),
('Economics'            ,4 ,'Micro & macro economics'          ,NULL),
('Business Economics'   ,4 ,'Entrepreneurship & accounting'    ,NULL),
('Informatics'          ,5 ,'Programming & algorithms'         ,NULL),
('Art & Design'         ,3 ,'Visual arts & design'             ,NULL),
('Music'                ,3 ,'Music theory & practice'          ,NULL),
('Physical Education'   ,2 ,'Sports & fitness'                 ,NULL),
('Philosophy'           ,3 ,'Introduction to philosophy'       ,NULL),
('Social Studies'       ,3 ,'Sociology & politics'             ,NULL),
('Statistics'           ,4 ,'Probability & data analysis'      ,NULL),
('Astronomy'            ,3 ,'Introduction to astronomy'        ,NULL),
('Psychology'           ,3 ,'Basic psychology'                 ,NULL),
('Law & Society'        ,3 ,'Introduction to law'              ,NULL),
('Entrepreneurship'     ,4 ,'Starting a business'              ,NULL),
('Digital Skills'       ,3 ,'Office & web tools'                ,NULL),
('Media & Communication',4 ,'Journalism & media literacy'      ,NULL),
('Sustainable Development',4,'Environment & society'           ,NULL),
('Robotics'             ,5 ,'Robotics & automation'            ,NULL),
('Data Science Intro'   ,4 ,'Python for data analysis'         ,NULL),
('Machine Learning Basics',5,'Supervised & unsupervised'       ,NULL),
('Cyber Security'       ,4 ,'Network & information security'   ,NULL),
('Biotechnology'        ,4 ,'Genetic engineering basics'       ,NULL),
('Environmental Chemistry',4,'Pollution & green chemistry'     ,NULL),
('Advanced Calculus'    ,5 ,'Multivariable calculus'           ,NULL),
('Linear Algebra'       ,5 ,'Matrices & vector spaces'         ,NULL),
('Mechanics & Materials',5 ,'Engineering mechanics'            ,NULL),
('Thermodynamics'       ,5 ,'Heat & energy transfer'           ,NULL),
('Electronics'          ,5 ,'Analog & digital circuits'        ,NULL),
('Dutch Literature'     ,4 ,'17th�21st century literature'     ,NULL),
('English Literature'   ,4 ,'British & American classics'      ,NULL),
('Drama & Theater'      ,3 ,'Acting & stage production'        ,NULL),
('Dance'                ,3 ,'Contemporary & classical dance'   ,NULL),
('Visual Communication' ,4 ,'Graphic design & typography'      ,NULL),
('Photography'          ,3 ,'Digital & analog photography'     ,NULL),
('Fashion Design'       ,4 ,'Fashion sketching & textiles'     ,NULL),
('Architecture Intro'   ,4 ,'Basics of architectural design'   ,NULL);
GO

--TRUNCATE TABLE Instructors;
INSERT INTO Instructors (FirstName, LastName, HireDate, Department, SchoolID)
VALUES
('Anna'     ,'de Vries'    ,'2015-08-01','Mathematics'      ,NULL),
('Mark'     ,'Jansen'      ,'2012-09-01','Physics'          ,NULL),
('Sophie'   ,'Bakker'      ,'2018-01-15','Chemistry'        ,NULL),
('Thomas'   ,'Mulder'      ,'2010-03-20','Biology'          ,NULL),
('Laura'    ,'Visser'      ,'2016-11-05','Dutch Language'   ,NULL),
('Erik'     ,'Smit'        ,'2014-06-10','English'          ,NULL),
('Lisa'     ,'de Boer'     ,'2019-02-28','History'          ,NULL),
('Pieter'   ,'van Dijk'    ,'2013-09-12','Geography'        ,NULL),
('Marieke'  ,'Hoogendoorn' ,'2017-04-01','Economics'        ,NULL),
('Jeroen'   ,'Verhoeven'   ,'2011-10-15','Informatics'      ,NULL),
('Femke'    ,'van Beek'    ,'2020-01-10','Art & Design'     ,NULL),
('Bas'      ,'van Leeuwen' ,'2015-07-22','Music'            ,NULL),
('Niels'    ,'Claassen'    ,'2018-03-05','Physical Education',NULL),
('Eline'    ,'Willems'     ,'2016-12-01','Philosophy'       ,NULL),
('Koen'     ,'Groen'       ,'2019-08-19','Social Studies'   ,NULL),
('Sara'     ,'van der Wal' ,'2014-05-30','Statistics'       ,NULL),
('Tim'      ,'Kuipers'     ,'2021-02-14','Astronomy'        ,NULL),
('Noor'     ,'Blok'        ,'2017-11-08','Psychology'       ,NULL),
('Jesse'    ,'Hermans'     ,'2020-06-25','Law & Society'    ,NULL),
('Mila'     ,'van Dam'     ,'2013-04-03','Entrepreneurship' ,NULL),
('Sem'      ,'Sanders'     ,'2018-09-17','Digital Skills'   ,NULL),
('Fleur'    ,'Peeters'     ,'2015-10-12','Media'            ,NULL),
('Luca'     ,'van der Horst','2019-01-20','Sustainable Dev' ,NULL),
('Yara'     ,'Molenaar'    ,'2022-03-08','Robotics'         ,NULL),
('Finn'     ,'Dekker'      ,'2016-07-14','Data Science'     ,NULL),
('Tess'     ,'van der Linden','2021-11-30','Cyber Security' ,NULL),
('Noah'     ,'van der Meer' ,'2014-02-09','Biotechnology'   ,NULL),
('Julia'    ,'van der Heijden','2017-05-16','Advanced Math' ,NULL),
('Liam'     ,'Kramer'      ,'2020-08-21','Electronics'      ,NULL),
('Mila'     ,'van Dongen'  ,'2018-12-04','Dutch Literature' ,NULL),
('Sem'      ,'Veenstra'    ,'2015-03-27','English Lit'      ,NULL),
('Emma'     ,'Post'        ,'2019-09-10','Drama'            ,NULL),
('Lars'     ,'van der Horst','2022-01-15','Dance'           ,NULL),
('Sophie'   ,'Kuipers'     ,'2016-06-08','Photography'      ,NULL),
('Noah'     ,'Blok'        ,'2021-04-19','Fashion Design'   ,NULL);
GO

--TRUNCATE TABLE ClassRooms;
INSERT INTO ClassRooms (RoomNumber, Capacity, Building, SchoolID)
VALUES
('A101',32,'A',NULL),('A102',28,'A',NULL),('A201',40,'A',NULL),('A202',36,'A',NULL),
('B101',30,'B',NULL),('B102',25,'B',NULL),('B201',45,'B',NULL),('B202',38,'B',NULL),
('C101',34,'C',NULL),('C102',30,'C',NULL),('C201',42,'C',NULL),('C202',35,'C',NULL),
('D101',28,'D',NULL),('D102',24,'D',NULL),('D201',39,'D',NULL),('D202',33,'D',NULL),
('E101',31,'E',NULL),('E102',27,'E',NULL),('E201',44,'E',NULL),('E202',37,'E',NULL);
GO

--TRUNCATE TABLE LabRooms;
INSERT INTO LabRooms (LabNumber, Capacity, Equipment, SchoolID)
VALUES
('L01',20,'Computers & projectors'         ,NULL),
('L02',18,'Chemistry benches + fume hoods' ,NULL),
('L03',16,'Microscopes + biology kits'     ,NULL),
('L04',22,'Physics experiment stations'    ,NULL),
('L05',15,'Robotics & Arduino kits'        ,NULL),
('L06',24,'3D printers + CAD computers'    ,NULL),
('L07',19,'Electronics workstations'       ,NULL),
('L08',17,'Darkroom + photo equipment'     ,NULL),
('L09',21,'Music instruments + studio'     ,NULL),
('L10',14,'Art & design tables'            ,NULL),
('L11',23,'Computers + data analysis SW'   ,NULL),
('L12',20,'Chemistry + safety gear'        ,NULL),
('L13',18,'Biology wet lab'                ,NULL),
('L14',16,'Physics optics & electricity'   ,NULL),
('L15',22,'Fabrication lab (wood/metal)'   ,NULL),
('L16',19,'Sewing machines + textiles'     ,NULL),
('L17',17,'Dance & movement studio'        ,NULL),
('L18',24,'Theater rehearsal space'        ,NULL),
('L19',15,'Greenhouse & plant lab'         ,NULL),
('L20',21,'Environmental monitoring equip' ,NULL),
('L21',18,'Cyber security workstations'    ,NULL),
('L22',20,'High-performance computing'     ,NULL),
('L23',16,'Astronomy simulation + telescopes',NULL),
('L24',19,'Psychology observation rooms'   ,NULL),
('L25',22,'Fashion atelier & sewing'       ,NULL);
GO

--TRUNCATE TABLE Registrations;
WITH student_course AS (
    SELECT 
        s.StudentID,
        c.CourseID,
        ROW_NUMBER() OVER (PARTITION BY s.StudentID ORDER BY NEWID()) AS rn,
        CASE WHEN ABS(CHECKSUM(NEWID())) % 100 < 75 THEN 1 ELSE 0 END AS enroll
    FROM Students s
    CROSS JOIN Courses c
)
INSERT INTO Registrations (StudentID, CourseID, Semester, Year, Status)
SELECT 
    StudentID,
    CourseID,
    CASE WHEN ABS(CHECKSUM(NEWID())) % 2 = 0 THEN 'Fall' ELSE 'Spring' END,
    2024 + (ABS(CHECKSUM(NEWID())) % 2),
    'Enrolled'
FROM student_course
WHERE rn <= 6          
  AND enroll = 1
  AND StudentID % 7 <> 0;  
GO

--TRUNCATE TABLE Grades;
INSERT INTO Grades (StudentID, CourseID, Grade)
SELECT 
    r.StudentID,
    r.CourseID,
    ROUND(50 + ABS(CHECKSUM(NEWID())) % 51.0, 1)   
FROM Registrations r
WHERE ABS(CHECKSUM(NEWID())) % 100 <= 75;  
GO

SELECT * FROM Schools;
GO

SELECT * FROM Students;
GO

SELECT * FROM Courses;
GO

SELECT * FROM Instructors;
GO

SELECT * FROM ClassRooms;
GO

SELECT * FROM LabRooms;
GO

SELECT * FROM Registrations;
GO

SELECT * FROM Grades;
GO



-- =============================================================
-- Answer For The 250  Question
-- =============================================================





/* =========================
    Section 1: Basic SELECT, WHERE, ORDER BY, DISTINCT, IN, BETWEEN
   ========================= */

-- 1. Students in School 1
SELECT FullName, SchoolID
FROM Students
WHERE SchoolID = 1;

-- 2. Unique course names ordered by credits (high to low)
SELECT DISTINCT CourseName , Credits
FROM Courses
ORDER BY Credits DESC;

-- 3. Instructors hired between 2010 and 2015
SELECT FullName
FROM Instructors
WHERE HireDate BETWEEN '2010-01-01' AND '2015-01-01';

-- 4. Classrooms with capacity greater than 25
SELECT *
FROM ClassRooms
WHERE Capacity > 25
ORDER BY RoomNumber;

-- 5. Students in School 2 or 3
SELECT StudentID, DateOfBirth
FROM Students
WHERE SchoolID IN (2,3);

-- 6. Lab rooms that have computers
SELECT *
FROM LabRooms
WHERE Equipment LIKE '%Computers%'
ORDER BY Capacity ASC;

-- 7. Registrations enrolled in 2023
SELECT *
FROM Registrations
WHERE Status = 'Enrolled' AND Year = 2023;

-- 8. Grades above 80
SELECT StudentID, CourseID, Grade
FROM Grades
WHERE Grade > 80
ORDER BY Grade DESC;

-- 9. Schools established after 2000
SELECT SchoolName, EstablishedYear
FROM Schools
WHERE EstablishedYear > 2000
ORDER BY EstablishedYear;

-- 10. Unique semesters between 2023 and 2024
SELECT DISTINCT Semester
FROM Registrations
WHERE Year BETWEEN 2023 AND 2024;

-- 11. Students born before 2005
SELECT FullName
FROM Students
WHERE DateOfBirth < '2005-01-01';

-- 12. Instructors in School 1 or 2
SELECT InstructorID, Department
FROM Instructors
WHERE SchoolID IN (1,2);

-- 13. Course descriptions with 3–4 credits
SELECT Description
FROM Courses
WHERE Credits BETWEEN 3 AND 4;

-- 14. Lab rooms where capacity is not 20
SELECT LabID, SchoolID
FROM LabRooms
WHERE Capacity <> 20;

-- 15. Registrations for students 1–5 in Fall
SELECT RegistrationID
FROM Registrations
WHERE StudentID IN (1,2,3,4,5) AND Semester = 'Fall';

-- 16. Letter grades for scores between 70 and 89
SELECT LetterGrade
FROM Grades
WHERE Grade BETWEEN 70 AND 89;

-- 17. Unique classroom buildings
SELECT DISTINCT Building
FROM ClassRooms
ORDER BY Building;

-- 18. Student enrollments after 2020
SELECT EnrollmentDate
FROM Students
WHERE EnrollmentDate > '2020-01-01'
ORDER BY EnrollmentDate;

-- 19. Instructors in Math or Science departments
SELECT FullName
FROM Instructors
WHERE Department IN ('Math','Science');

-- 20. Courses with '101' in the name
SELECT CourseID, CourseName
FROM Courses
WHERE CourseName LIKE '%101%';

-- 21. Schools with more than 2 students
SELECT *
FROM Schools
WHERE SchoolID IN (
    SELECT SchoolID
    FROM Students
    GROUP BY SchoolID
    HAVING COUNT(*) > 2
);

-- 22. Unique registration statuses
SELECT DISTINCT Status
FROM Registrations
ORDER BY Status;

-- 23. Grades recorded after Jan 1, 2023
SELECT *
FROM Grades
WHERE GradeDate > '2023-01-01'
ORDER BY GradeDate DESC;

-- 24. Lab rooms with capacity between 15 and 25
SELECT *
FROM LabRooms
WHERE Capacity BETWEEN 15 AND 25;

-- 25. Students registered in courses 1, 3, or 5
SELECT StudentID
FROM Registrations
WHERE CourseID IN (1,3,5);

-- 26. Instructor hire dates before 2015
SELECT HireDate
FROM Instructors
WHERE HireDate < '2015-01-01'
ORDER BY HireDate;

-- 27. Unique school locations
SELECT DISTINCT Location
FROM Schools;

-- 28. Spring registrations not dropped
SELECT *
FROM Registrations
WHERE Semester = 'Spring' AND Status <> 'Dropped';

-- 29. Course credits greater than 2
SELECT Credits
FROM Courses
WHERE Credits > 2
ORDER BY CourseName;

-- 30. Students with last names starting with D
SELECT *
FROM Students
WHERE LastName LIKE 'D%';

-- 31. Grades with letter A or B
SELECT *
FROM Grades
WHERE LetterGrade IN ('A','B');

-- 32. Classrooms in Building A or B
SELECT *
FROM ClassRooms
WHERE Building IN ('A','B')
ORDER BY Capacity;

-- 33. Unique lab equipment types
SELECT DISTINCT Equipment
FROM LabRooms;

-- 34. Registrations between 2023 and 2024
SELECT *
FROM Registrations
WHERE RegistrationDate BETWEEN '2023-01-01' AND '2024-12-31';

-- 35. Instructors hired from 2010 onwards
SELECT *
FROM Instructors
WHERE HireDate >= '2010-01-01'
ORDER BY HireDate;

-- 36. Students in School 3
SELECT FullName
FROM Students
WHERE SchoolID = 3;

-- 37. Courses with 'basic' in description
SELECT *
FROM Courses
WHERE Description LIKE '%basic%';

-- 38. Unique registration years (latest first)
SELECT DISTINCT Year
FROM Registrations
ORDER BY Year DESC;

-- 39. Grades between 80 and 90
SELECT StudentID, CourseID
FROM Grades
WHERE Grade BETWEEN 80 AND 90;

-- 40. Lab rooms ending with number 1
SELECT *
FROM LabRooms
WHERE LabNumber LIKE '%1';

-- 41. Students named John or Jane
SELECT *
FROM Students
WHERE FirstName IN ('John','Jane');

-- 42. Classrooms with capacity 30 or 35
SELECT *
FROM ClassRooms
WHERE Capacity IN (30,35);

-- 43. Unique instructor departments
SELECT DISTINCT Department
FROM Instructors;

-- 44. Registrations in 2024
SELECT *
FROM Registrations
WHERE Year = 2024
ORDER BY StudentID;

-- 45. Schools established between 1980 and 2000
SELECT *
FROM Schools
WHERE EstablishedYear BETWEEN 1980 AND 2000;

-- 46. Instructors with 'S' in last name
SELECT FullName
FROM Instructors
WHERE LastName LIKE '%S%';

-- 47. Grades that are not F
SELECT *
FROM Grades
WHERE LetterGrade <> 'F';

-- 48. Unique course IDs from grades
SELECT DISTINCT CourseID
FROM Grades
ORDER BY CourseID;

-- 49. Students born in 2005
SELECT *
FROM Students
WHERE YEAR(DateOfBirth) = 2005;

-- 50. Lab rooms where equipment starts with C
SELECT *
FROM LabRooms
WHERE Equipment LIKE 'C%';



/* =========================
   Section 2: Aggregate Functions, GROUP BY, HAVING
   ========================= */

-- 1. Average grade per student > 80
SELECT StudentID, AVG(Grade) AS AvgGrade
FROM Grades
GROUP BY StudentID
HAVING AVG(Grade) > 80;

-- 2. Total credits per school
SELECT SchoolID, SUM(Credits) AS TotalCredits
FROM Courses
GROUP BY SchoolID;

-- 3. Minimum hire date per department
SELECT Department, MIN(HireDate) AS MinHireDate
FROM Instructors
GROUP BY Department;

-- 4. Maximum classroom capacity per building >30
SELECT Building, MAX(Capacity) AS MaxCapacity
FROM ClassRooms
GROUP BY Building
HAVING MAX(Capacity) > 30;

-- 5. Average grade per course <85
SELECT CourseID, AVG(Grade) AS AvgGrade
FROM Grades
GROUP BY CourseID
HAVING AVG(Grade) < 85;

-- 6. Sum of lab capacities per school
SELECT SchoolID, SUM(Capacity) AS TotalCapacity
FROM LabRooms
GROUP BY SchoolID;

-- 7. Count registrations per semester >5
SELECT Semester, COUNT(*) AS TotalRegs
FROM Registrations
GROUP BY Semester
HAVING COUNT(*) > 5;

-- 8. Maximum grade per student
SELECT StudentID, MAX(Grade) AS MaxGrade
FROM Grades
GROUP BY StudentID;

-- 9. Average course credits per school >3
SELECT SchoolID, AVG(Credits) AS AvgCredits
FROM Courses
GROUP BY SchoolID
HAVING AVG(Credits) > 3;

-- 10. Minimum classroom capacity per school
SELECT SchoolID, MIN(Capacity) AS MinCapacity
FROM ClassRooms
GROUP BY SchoolID;

-- 11. Total grades entries per course >1
SELECT CourseID, COUNT(*) AS TotalGrades
FROM Grades
GROUP BY CourseID
HAVING COUNT(*) > 1;

-- 12. Sum of grades per student
SELECT StudentID, SUM(Grade) AS TotalGrade
FROM Grades
GROUP BY StudentID;

-- 13. Average hire year per school
SELECT SchoolID, AVG(YEAR(HireDate)) AS AvgHireYear
FROM Instructors
GROUP BY SchoolID;

-- 14. Max equipment length per school >10
SELECT SchoolID, MAX(LEN(Equipment)) AS MaxEquipmentLength
FROM LabRooms
GROUP BY SchoolID
HAVING MAX(LEN(Equipment)) > 10;

-- 15. Count students per school >=3
SELECT SchoolID, COUNT(*) AS TotalStudents
FROM Students
GROUP BY SchoolID
HAVING COUNT(*) >=3;

-- 16. Minimum grade per course
SELECT CourseID, MIN(Grade) AS MinGrade
FROM Grades
GROUP BY CourseID;

-- 17. Average classroom capacity per building
SELECT Building, AVG(Capacity) AS AvgCapacity
FROM ClassRooms
GROUP BY Building;

-- 18. Sum of course credits per school >10
SELECT SchoolID, SUM(Credits) AS TotalCredits
FROM Courses
GROUP BY SchoolID
HAVING SUM(Credits) > 10;

-- 19. Count of 'Enrolled' registrations per year >4
SELECT Year, COUNT(*) AS TotalEnrolled
FROM Registrations
WHERE Status = 'Enrolled'
GROUP BY Year
HAVING COUNT(*) > 4;

-- 20. Max date of birth per school
SELECT SchoolID, MAX(DateOfBirth) AS MaxDOB
FROM Students
GROUP BY SchoolID;

-- 21. Average grade >70 per student, having avg>85
SELECT StudentID, AVG(Grade) AS AvgGrade
FROM Grades
WHERE Grade > 70
GROUP BY StudentID
HAVING AVG(Grade) > 85;

-- 22. Total labs per school
SELECT SchoolID, COUNT(*) AS TotalLabs
FROM LabRooms
GROUP BY SchoolID;

-- 23. Minimum credits per school <3
SELECT SchoolID, MIN(Credits) AS MinCredits
FROM Courses
GROUP BY SchoolID
HAVING MIN(Credits) <3;

-- 24. Count instructors per department >1
SELECT Department, COUNT(*) AS TotalInstructors
FROM Instructors
GROUP BY Department
HAVING COUNT(*) >1;

-- 25. Sum of lab capacities with 'Computers'
SELECT SchoolID, SUM(Capacity) AS TotalCapacity
FROM LabRooms
WHERE Equipment LIKE '%Computers%'
GROUP BY SchoolID;

-- 26. Average grade per letter grade
SELECT LetterGrade, AVG(Grade) AS AvgGrade
FROM Grades
GROUP BY LetterGrade;

-- 27. Max enrollment date per school
SELECT SchoolID, MAX(EnrollmentDate) AS MaxEnroll
FROM Students
GROUP BY SchoolID;

-- 28. Count of courses per school >=3
SELECT SchoolID, COUNT(*) AS TotalCourses
FROM Courses
GROUP BY SchoolID
HAVING COUNT(*) >=3;

-- 29. Min hire date per school
SELECT SchoolID, MIN(HireDate) AS MinHire
FROM Instructors
GROUP BY SchoolID;

-- 30. Total registrations per student >1
SELECT StudentID, COUNT(*) AS TotalRegs
FROM Registrations
GROUP BY StudentID
HAVING COUNT(*) >1;

-- 31. Average classroom capacity per school >25
SELECT SchoolID, AVG(Capacity) AS AvgCapacity
FROM ClassRooms
GROUP BY SchoolID
HAVING AVG(Capacity) >25;

-- 32. Sum of grades per course
SELECT CourseID, SUM(Grade) AS TotalGrades
FROM Grades
GROUP BY CourseID;

-- 33. Count of 'Dropped' registrations per semester
SELECT Semester, COUNT(*) AS DroppedCount
FROM Registrations
WHERE Status = 'Dropped'
GROUP BY Semester;

-- 34. Max grade date per student > '2023-01-01'
SELECT StudentID, MAX(GradeDate) AS MaxGradeDate
FROM Grades
GROUP BY StudentID
HAVING MAX(GradeDate) > '2023-01-01';

-- 35. Average credits for courses with '101' in name
SELECT SchoolID, AVG(Credits) AS AvgCredits
FROM Courses
WHERE CourseName LIKE '%101%'
GROUP BY SchoolID;

-- 36. Min lab capacity per equipment type
SELECT Equipment, MIN(Capacity) AS MinCapacity
FROM LabRooms
GROUP BY Equipment;

-- 37. Count of students born in 2005 per school
SELECT SchoolID, COUNT(*) AS TotalStudents
FROM Students
WHERE YEAR(DateOfBirth) = 2005
GROUP BY SchoolID;

-- 38. Sum of classroom capacities >20 per building, having sum>50
SELECT Building, SUM(Capacity) AS TotalCapacity
FROM ClassRooms
WHERE Capacity > 20
GROUP BY Building
HAVING SUM(Capacity) >50;

-- 39. Average grade per year (from GradeDate)
SELECT YEAR(GradeDate) AS Year, AVG(Grade) AS AvgGrade
FROM Grades
GROUP BY YEAR(GradeDate);

-- 40. Max course credits per school
SELECT SchoolID, MAX(Credits) AS MaxCredits
FROM Courses
GROUP BY SchoolID;

-- 41. Count of grades per letter grade >2
SELECT LetterGrade, COUNT(*) AS TotalGrades
FROM Grades
GROUP BY LetterGrade
HAVING COUNT(*) >2;

-- 42. Total instructors per school
SELECT SchoolID, COUNT(*) AS TotalInstructors
FROM Instructors
GROUP BY SchoolID;

-- 43. Min registration date per semester
SELECT Semester, MIN(RegistrationDate) AS MinRegDate
FROM Registrations
GROUP BY Semester;

-- 44. Average total students per location
SELECT Location, AVG(TotalStudents) AS AvgStudents
FROM (
    SELECT sc.SchoolID, sc.Location, COUNT(*) AS TotalStudents
    FROM Students s
    JOIN Schools sc ON s.SchoolID = sc.SchoolID
    GROUP BY sc.SchoolID, sc.Location
) AS Sub
GROUP BY Location;


-- 45. Sum of grades for students in school 1 per course
SELECT CourseID, SUM(Grade) AS TotalGrade
FROM Grades
WHERE StudentID IN (SELECT StudentID FROM Students WHERE SchoolID =1)
GROUP BY CourseID;

-- 46. Count of lab rooms per capacity >1
SELECT Capacity, COUNT(*) AS TotalLabs
FROM LabRooms
GROUP BY Capacity
HAVING COUNT(*) >1;

-- 47. Max room number length per building
SELECT Building, MAX(LEN(RoomNumber)) AS MaxRoomLen
FROM ClassRooms
GROUP BY Building;

-- 48. Average grade for 'A' letters per student
SELECT StudentID, AVG(Grade) AS AvgGrade
FROM Grades
WHERE LetterGrade='A'
GROUP BY StudentID;

-- 49. Total courses with credits >3 per school
SELECT SchoolID, COUNT(*) AS TotalCourses
FROM Courses
WHERE Credits >3
GROUP BY SchoolID;

-- 50. Minimum established year per location
SELECT Location, MIN(EstablishedYear) AS MinYear
FROM Schools
GROUP BY Location;



/* =========================
   Section 3: Joins (Inner, Left, Right, Full)
   ========================= */

-- 1. Inner join students and schools for student full name and school name
SELECT s.FullName, sc.SchoolName
FROM Students s
INNER JOIN Schools sc ON s.SchoolID = sc.SchoolID;

-- 2. Left join registrations with courses to list all registrations with course names
SELECT r.RegistrationID, c.CourseName
FROM Registrations r
LEFT JOIN Courses c ON r.CourseID = c.CourseID;

-- 3. Inner join grades and students where grade >80
SELECT g.Grade, s.FullName
FROM Grades g
INNER JOIN Students s ON g.StudentID = s.StudentID
WHERE g.Grade > 80;

-- 4. Right join instructors and schools to show all schools with instructors
SELECT i.FullName, sc.SchoolName
FROM Instructors i
RIGHT JOIN Schools sc ON i.SchoolID = sc.SchoolID;

-- 5. Full join classrooms and schools
SELECT cr.RoomNumber, sc.SchoolName
FROM ClassRooms cr
FULL OUTER JOIN Schools sc ON cr.SchoolID = sc.SchoolID;

-- 6. Students enrolled in 'Mathematics 101'
SELECT s.FullName, c.CourseName
FROM Students s
INNER JOIN Registrations r ON s.StudentID = r.StudentID
INNER JOIN Courses c ON r.CourseID = c.CourseID
WHERE c.CourseName = 'Mathematics 101';

-- 7. Left join courses and grades, average grades
SELECT c.CourseName, AVG(g.Grade) AS AvgGrade
FROM Courses c
LEFT JOIN Grades g ON c.CourseID = g.CourseID
GROUP BY c.CourseName;

-- 8. Inner join instructors and courses on SchoolID
SELECT i.FullName, c.CourseName, i.SchoolID
FROM Instructors i
INNER JOIN Courses c ON i.SchoolID = c.SchoolID;

-- 9. Join registrations and grades for students with grades
SELECT r.StudentID, r.CourseID, g.Grade
FROM Registrations r
INNER JOIN Grades g ON r.StudentID = g.StudentID AND r.CourseID = g.CourseID;

-- 10. Right join lab rooms and schools
SELECT l.LabNumber, sc.SchoolName
FROM LabRooms l
RIGHT JOIN Schools sc ON l.SchoolID = sc.SchoolID;

-- 11. Full join students and grades
SELECT s.FullName, g.Grade
FROM Students s
FULL OUTER JOIN Grades g ON s.StudentID = g.StudentID;

-- 12. Count enrollments per school
SELECT sc.SchoolName, COUNT(r.RegistrationID) AS TotalEnrollments
FROM Schools sc
INNER JOIN Students s ON sc.SchoolID = s.SchoolID
INNER JOIN Registrations r ON s.StudentID = r.StudentID
GROUP BY sc.SchoolName;

-- 13. Courses with no enrollments
SELECT c.CourseName
FROM Courses c
LEFT JOIN Registrations r ON c.CourseID = r.CourseID
WHERE r.RegistrationID IS NULL;

-- 14. Average grades per school
SELECT sc.SchoolName, AVG(g.Grade) AS AvgGrade
FROM Grades g
INNER JOIN Students s ON g.StudentID = s.StudentID
INNER JOIN Schools sc ON s.SchoolID = sc.SchoolID
GROUP BY sc.SchoolName;

-- 15. Instructor full names and school locations
SELECT i.FullName, sc.Location
FROM Instructors i
INNER JOIN Schools sc ON i.SchoolID = sc.SchoolID;

-- 16. Right join courses and grades
SELECT g.Grade, c.CourseName
FROM Courses c
RIGHT JOIN Grades g ON c.CourseID = g.CourseID;

-- 17. Full join lab rooms and classrooms to compare capacities
SELECT l.LabNumber, cr.RoomNumber, COALESCE(l.SchoolID, cr.SchoolID) AS SchoolID
FROM LabRooms l
FULL OUTER JOIN ClassRooms cr ON l.SchoolID = cr.SchoolID;

-- 18. Students with max grade per course
SELECT c.CourseName, s.FullName, MAX(g.Grade) AS MaxGrade
FROM Grades g
INNER JOIN Students s ON g.StudentID = s.StudentID
INNER JOIN Courses c ON g.CourseID = c.CourseID
GROUP BY c.CourseName, s.FullName;

-- 19. Left join registrations and students
SELECT s.FullName, r.RegistrationID
FROM Students s
LEFT JOIN Registrations r ON s.StudentID = r.StudentID;

-- 20. Full enrollment details for school 1
SELECT s.FullName, c.CourseName, r.Semester, r.Year
FROM Schools sc
INNER JOIN Students s ON sc.SchoolID = s.SchoolID
INNER JOIN Registrations r ON s.StudentID = r.StudentID
INNER JOIN Courses c ON r.CourseID = c.CourseID
WHERE sc.SchoolID = 1;

-- 21. Grades only for enrolled students
SELECT g.Grade, r.Status
FROM Grades g
INNER JOIN Registrations r ON g.StudentID = r.StudentID AND g.CourseID = r.CourseID;

-- 22. Schools without instructors
SELECT sc.SchoolName
FROM Schools sc
RIGHT JOIN Instructors i ON sc.SchoolID = i.SchoolID
WHERE i.InstructorID IS NULL;

-- 23. Potential teaching assignments
SELECT c.CourseName, i.FullName, COALESCE(c.SchoolID, i.SchoolID) AS SchoolID
FROM Courses c
FULL OUTER JOIN Instructors i ON c.SchoolID = i.SchoolID;

-- 24. Students ordered by school and name
SELECT s.FullName, sc.SchoolName
FROM Students s
INNER JOIN Schools sc ON s.SchoolID = sc.SchoolID
ORDER BY sc.SchoolName, s.FullName;

-- 25. Count grades per student
SELECT s.FullName, COUNT(g.GradeID) AS TotalGrades
FROM Students s
LEFT JOIN Grades g ON s.StudentID = g.StudentID
GROUP BY s.FullName;

-- 26. Course enrollments per school
SELECT sc.SchoolName, c.CourseName, COUNT(r.RegistrationID) AS TotalEnrollments
FROM Schools sc
INNER JOIN Courses c ON sc.SchoolID = c.SchoolID
INNER JOIN Registrations r ON c.CourseID = r.CourseID
GROUP BY sc.SchoolName, c.CourseName;

-- 27. Sum lab capacities per location
SELECT sc.Location, SUM(l.Capacity) AS TotalLabCapacity
FROM LabRooms l
INNER JOIN Schools sc ON l.SchoolID = sc.SchoolID
GROUP BY sc.Location;

-- 28. Students without registrations
SELECT s.FullName
FROM Students s
RIGHT JOIN Registrations r ON s.StudentID = r.StudentID
WHERE r.RegistrationID IS NULL;

-- 29. Full join instructors and courses, partial department match
SELECT c.CourseName, i.FullName
FROM Courses c
FULL OUTER JOIN Instructors i ON c.SchoolID = i.SchoolID
WHERE i.Department LIKE '%' + c.CourseName + '%';

-- 30. Average grade per course name
SELECT c.CourseName, AVG(g.Grade) AS AvgGrade
FROM Grades g
INNER JOIN Courses c ON g.CourseID = c.CourseID
INNER JOIN Students s ON g.StudentID = s.StudentID
GROUP BY c.CourseName;

-- 31. Left join classrooms and lab rooms
SELECT cr.RoomNumber, l.LabNumber, cr.SchoolID
FROM ClassRooms cr
LEFT JOIN LabRooms l ON cr.SchoolID = l.SchoolID;

-- 32. Full report on student performance per school
SELECT s.FullName, sc.SchoolName, c.CourseName, g.Grade
FROM Students s
INNER JOIN Schools sc ON s.SchoolID = sc.SchoolID
INNER JOIN Registrations r ON s.StudentID = r.StudentID
INNER JOIN Courses c ON r.CourseID = c.CourseID
INNER JOIN Grades g ON s.StudentID = g.StudentID AND c.CourseID = g.CourseID;

-- 33. Instructor-student pairs per school
SELECT i.FullName AS Instructor, s.FullName AS Student
FROM Instructors i
INNER JOIN Students s ON i.SchoolID = s.SchoolID;

-- 34. Right join courses and registrations with registration count >1
SELECT c.CourseName, COUNT(r.RegistrationID) AS TotalEnroll
FROM Courses c
RIGHT JOIN Registrations r ON c.CourseID = r.CourseID
GROUP BY c.CourseName
HAVING COUNT(r.RegistrationID) >1;

-- 35. Schools without classrooms
SELECT sc.SchoolName, cr.RoomNumber
FROM Schools sc
FULL OUTER JOIN ClassRooms cr ON sc.SchoolID = cr.SchoolID
WHERE cr.RoomID IS NULL;

-- 36. Grades ordered descending with student full name
SELECT s.FullName, g.Grade
FROM Grades g
INNER JOIN Students s ON g.StudentID = s.StudentID
ORDER BY g.Grade DESC;

-- 37. Enrollments without grades
SELECT r.RegistrationID, s.FullName
FROM Registrations r
LEFT JOIN Grades g ON r.StudentID = g.StudentID AND r.CourseID = g.CourseID
INNER JOIN Students s ON r.StudentID = s.StudentID
WHERE g.GradeID IS NULL;

-- 38. Courses per school grouped
SELECT sc.SchoolName, COUNT(c.CourseID) AS TotalCourses
FROM Schools sc
INNER JOIN Instructors i ON sc.SchoolID = i.SchoolID
INNER JOIN Courses c ON sc.SchoolID = c.SchoolID
GROUP BY sc.SchoolName;

-- 39. Lab rooms and classrooms with matching capacity
SELECT l.LabNumber, cr.RoomNumber, l.Capacity
FROM LabRooms l
INNER JOIN ClassRooms cr ON l.SchoolID = cr.SchoolID AND l.Capacity = cr.Capacity;

-- 40. Sum grades per student (right join)
SELECT s.FullName, SUM(g.Grade) AS TotalGrade
FROM Students s
RIGHT JOIN Grades g ON s.StudentID = g.StudentID
GROUP BY s.FullName;

-- 41. Average grade per course with full join
SELECT c.CourseName, AVG(g.Grade) AS AvgGrade
FROM Courses c
FULL OUTER JOIN Grades g ON c.CourseID = g.CourseID
GROUP BY c.CourseName;

-- 42. Count enrolled students per school
SELECT sc.SchoolName, COUNT(r.RegistrationID) AS TotalEnroll
FROM Registrations r
INNER JOIN Students s ON r.StudentID = s.StudentID
INNER JOIN Schools sc ON s.SchoolID = sc.SchoolID
GROUP BY sc.SchoolName;

-- 43. Instructors without school (FK prevents, but query)
SELECT i.FullName, sc.SchoolName
FROM Instructors i
LEFT JOIN Schools sc ON i.SchoolID = sc.SchoolID
WHERE sc.SchoolID IS NULL;

-- 44. Grades for courses like 'Math%'
SELECT g.Grade, g.StudentID, c.CourseName
FROM Grades g
INNER JOIN Courses c ON g.CourseID = c.CourseID
WHERE c.CourseName LIKE 'Math%';

-- 45. Classrooms with school, order by capacity desc
SELECT cr.RoomNumber, sc.SchoolName, cr.Capacity
FROM ClassRooms cr
INNER JOIN Schools sc ON cr.SchoolID = sc.SchoolID
ORDER BY sc.Location, cr.Capacity DESC;

-- 46. Count labs per school (right join)
SELECT sc.SchoolName, COUNT(l.LabID) AS TotalLabs
FROM LabRooms l
RIGHT JOIN Schools sc ON l.SchoolID = sc.SchoolID
GROUP BY sc.SchoolName;

-- 47. Dropped statuses using full join
SELECT s.FullName, r.Status
FROM Students s
FULL OUTER JOIN Registrations r ON s.StudentID = r.StudentID
WHERE r.Status = 'Dropped';

-- 48. Department-course matches per school
SELECT i.FullName, c.CourseName, sc.SchoolName
FROM Instructors i
INNER JOIN Courses c ON i.SchoolID = c.SchoolID
INNER JOIN Schools sc ON i.SchoolID = sc.SchoolID
WHERE c.CourseName LIKE '%' + i.Department + '%';

-- 49. Left join grades and registrations, avg grade>80
SELECT r.StudentID, r.CourseID, AVG(g.Grade) AS AvgGrade
FROM Registrations r
LEFT JOIN Grades g ON r.StudentID = g.StudentID AND r.CourseID = g.CourseID
GROUP BY r.StudentID, r.CourseID
HAVING AVG(g.Grade) > 80;

-- 50. Full report on school 1 using multiple joins
SELECT 
    s.FullName, 
    sc.SchoolName, 
    c.CourseName, 
    g.Grade,       -- Use g.Grade, not r.Grade
    g.LetterGrade, -- Optional: include letter grade
    r.Semester, 
    r.Year
FROM Students s
INNER JOIN Schools sc ON s.SchoolID = sc.SchoolID
INNER JOIN Registrations r ON s.StudentID = r.StudentID
INNER JOIN Courses c ON r.CourseID = c.CourseID
INNER JOIN Grades g ON s.StudentID = g.StudentID AND c.CourseID = g.CourseID
WHERE sc.SchoolID = 1;

/* =========================
    Section 4: String Functions, LIKE, HAVING
   ========================= */

-- 1. Upper case student full names where last name starts with D
SELECT UPPER(FullName) AS StudentName
FROM Students
WHERE LastName LIKE 'D%';

-- 2. Lower case course names where description contains 'basic'
SELECT LOWER(CourseName) AS CourseName
FROM Courses
WHERE Description LIKE '%basic%';

-- 3. Group students by upper case first name, count >1
SELECT UPPER(FirstName) AS FirstName, COUNT(*) AS CountStudents
FROM Students
GROUP BY UPPER(FirstName)
HAVING COUNT(*) > 1;

-- 4. Lower case instructor full names where department starts with M
SELECT LOWER(FullName) AS InstructorName
FROM Instructors
WHERE Department LIKE 'M%';

-- 5. Registrations where semester = 'FALL' and status starts with E
SELECT *
FROM Registrations
WHERE UPPER(Semester) = 'FALL' AND Status LIKE 'E%';

-- 6. Group grades by lower case letter grade, average grade >80
SELECT LOWER(LetterGrade) AS LetterGrade, AVG(Grade) AS AvgGrade
FROM Grades
GROUP BY LOWER(LetterGrade)
HAVING AVG(Grade) > 80;

-- 7. Upper case school names where location contains 'York'
SELECT UPPER(SchoolName) AS SchoolName
FROM Schools
WHERE Location LIKE '%York%';

-- 8. Lower case equipment in labs where lab number ends with '1'
SELECT LOWER(Equipment) AS Equipment
FROM LabRooms
WHERE LabNumber LIKE '%1';

-- 9. Group classrooms by upper case building, max capacity >30
SELECT UPPER(Building) AS Building, MAX(Capacity) AS MaxCapacity
FROM ClassRooms
GROUP BY UPPER(Building)
HAVING MAX(Capacity) > 30;

-- 10. Upper case last names where full name contains 'John'
SELECT UPPER(LastName) AS LastName
FROM Students
WHERE FullName LIKE '%John%';

-- 11. Lower case course descriptions where name starts with 'Math'
SELECT LOWER(Description) AS Description
FROM Courses
WHERE CourseName LIKE 'Math%';

-- 12. Group instructors by lower case department, min hire date < '2015-01-01'
SELECT LOWER(Department) AS Department, MIN(HireDate) AS MinHireDate
FROM Instructors
GROUP BY LOWER(Department)
HAVING MIN(HireDate) < '2015-01-01';

-- 13. Upper case room numbers where building starts with 'B'
SELECT UPPER(RoomNumber) AS RoomNumber
FROM ClassRooms
WHERE Building LIKE 'B%';

-- 14. Labs with lower case equipment containing 'comp'
SELECT LOWER(Equipment) AS Equipment
FROM LabRooms
WHERE LOWER(Equipment) LIKE '%comp%';

-- 15. Group registrations by upper case status, count >5
SELECT UPPER(Status) AS Status, COUNT(*) AS CountRegistrations
FROM Registrations
GROUP BY UPPER(Status)
HAVING COUNT(*) > 5;

-- 16. Lower case letter grades where grade like '8%'
SELECT LOWER(LetterGrade) AS LetterGrade
FROM Grades
WHERE CAST(Grade AS VARCHAR) LIKE '8%';

-- 17. Upper case school locations where name contains 'High'
SELECT UPPER(Location) AS Location
FROM Schools
WHERE SchoolName LIKE '%High%';

-- 18. Group students by lower case initial of last name, count >1
SELECT LOWER(LEFT(LastName,1)) AS LastNameInitial, COUNT(*) AS CountStudents
FROM Students
GROUP BY LOWER(LEFT(LastName,1))
HAVING COUNT(*) > 1;

-- 19. Upper case instructor departments where full name contains 'Scott'
SELECT UPPER(Department) AS Department
FROM Instructors
WHERE FullName LIKE '%Scott%';

-- 20. Lower case course names grouped by school, avg credits >3
SELECT LOWER(CourseName) AS CourseName, SchoolID
FROM Courses
GROUP BY LOWER(CourseName), SchoolID
HAVING AVG(Credits) > 3;

-- 21. Grades where letter grade = 'A' and student last name starts with 'S'
SELECT g.*
FROM Grades g
INNER JOIN Students s ON g.StudentID = s.StudentID
WHERE UPPER(g.LetterGrade) = 'A' AND s.LastName LIKE 'S%';

-- 22. Upper case equipment where capacity >20 and equipment contains 'kit'
SELECT UPPER(Equipment) AS Equipment
FROM LabRooms
WHERE Capacity > 20 AND Equipment LIKE '%kit%';

-- 23. Group labs by lower case school location, sum capacity >40
SELECT LOWER(s.Location) AS Location, SUM(l.Capacity) AS TotalCapacity
FROM LabRooms l
INNER JOIN Schools s ON l.SchoolID = s.SchoolID
GROUP BY LOWER(s.Location)
HAVING SUM(l.Capacity) > 40;

-- 24. Lower case full names of students born like '2005%'
SELECT LOWER(FullName) AS FullName
FROM Students
WHERE CONVERT(VARCHAR, DateOfBirth, 112) LIKE '2005%';

-- 25. Upper case statuses where semester starts with 'S' and year=2024
SELECT UPPER(Status) AS Status
FROM Registrations
WHERE Semester LIKE 'S%' AND Year = 2024;

-- 26. Group courses by upper case first letter of name, max credits >3
SELECT UPPER(LEFT(CourseName,1)) AS FirstLetter, MAX(Credits) AS MaxCredits
FROM Courses
GROUP BY UPPER(LEFT(CourseName,1))
HAVING MAX(Credits) > 3;

-- 27. Lower case building names where room number contains '10'
SELECT LOWER(Building) AS Building
FROM ClassRooms
WHERE RoomNumber LIKE '%10%';

-- 28. Instructors with upper case department containing 'SCIENCE'
SELECT *
FROM Instructors
WHERE UPPER(Department) LIKE '%SCIENCE%';

-- 29. Group registrations by lower case semester, min registration date > '2023-01-01'
SELECT LOWER(Semester) AS Semester, MIN(RegistrationDate) AS MinRegDate
FROM Registrations
GROUP BY LOWER(Semester)
HAVING MIN(RegistrationDate) > '2023-01-01';

-- 30. Upper case letter grades grouped by course, count >2
SELECT UPPER(LetterGrade) AS LetterGrade, CourseID, COUNT(*) AS CountGrades
FROM Grades
GROUP BY UPPER(LetterGrade), CourseID
HAVING COUNT(*) > 2;

-- 31. Lower case school names containing 'academy'
SELECT LOWER(SchoolName) AS SchoolName
FROM Schools
WHERE SchoolName LIKE '%academy%';

-- 32. Upper case equipment ending with 's'
SELECT UPPER(Equipment) AS Equipment
FROM LabRooms
WHERE Equipment LIKE '%s';

-- 33. Group students by upper case month of birth, avg year =2005
SELECT MONTH(DateOfBirth) AS BirthMonth, AVG(YEAR(DateOfBirth)) AS AvgYear
FROM Students
GROUP BY MONTH(DateOfBirth)
HAVING AVG(YEAR(DateOfBirth)) = 2005;

-- 34. Lower case full names where instructor last name starts with 'B'
SELECT LOWER(FullName) AS InstructorName
FROM Instructors
WHERE LastName LIKE 'B%';

-- 35. Courses with upper case description containing 'INTRO'
SELECT *
FROM Courses
WHERE UPPER(Description) LIKE '%INTRO%';

-- 36. Group classrooms by lower case first char of room number, avg capacity >25
SELECT LOWER(LEFT(RoomNumber,1)) AS RoomPrefix, AVG(Capacity) AS AvgCapacity
FROM ClassRooms
GROUP BY LOWER(LEFT(RoomNumber,1))
HAVING AVG(Capacity) > 25;

-- 37. Upper case statuses for registrations like '2023%' in year
SELECT UPPER(Status) AS Status
FROM Registrations
WHERE CAST(Year AS VARCHAR) LIKE '2023%';

-- 38. Lower case departments where hire date like '201%-01%'
SELECT LOWER(Department) AS Department
FROM Instructors
WHERE CONVERT(VARCHAR, HireDate, 120) LIKE '201%-01%';

-- 39. Group labs by upper case equipment, min capacity <20
SELECT UPPER(Equipment) AS Equipment, MIN(Capacity) AS MinCapacity
FROM LabRooms
GROUP BY UPPER(Equipment)
HAVING MIN(Capacity) < 20;

-- 40. Upper case course names with credits >3 and name like '%10%'
SELECT UPPER(CourseName) AS CourseName
FROM Courses
WHERE Credits > 3 AND CourseName LIKE '%10%';

-- 41. Lower case locations grouped by established year, count >1
SELECT LOWER(Location) AS Location, COUNT(*) AS CountSchools
FROM Schools
GROUP BY LOWER(Location), EstablishedYear
HAVING COUNT(*) > 1;

-- 42. Students with full name containing a space, in upper
SELECT UPPER(FullName) AS FullName
FROM Students
WHERE FullName LIKE '% %';

-- 43. Group grades by lower case letter grade, sum grade >200
SELECT LOWER(LetterGrade) AS LetterGrade, SUM(Grade) AS TotalGrade
FROM Grades
GROUP BY LOWER(LetterGrade)
HAVING SUM(Grade) > 200;

-- 44. Upper case building where capacity starts with '3'
SELECT UPPER(Building) AS Building
FROM ClassRooms
WHERE CAST(Capacity AS VARCHAR) LIKE '3%';

-- 45. Lower case equipment like '_o%' (second char o)
SELECT LOWER(Equipment) AS Equipment
FROM LabRooms
WHERE Equipment LIKE '_o%';

-- 46. Group instructors by upper case last name length, max hire year >2010
SELECT LEN(LastName) AS LastNameLength, MAX(YEAR(HireDate)) AS MaxHireYear
FROM Instructors
GROUP BY LEN(LastName)
HAVING MAX(YEAR(HireDate)) > 2010;

-- 47. Lower case semester where status starts with E or D
SELECT LOWER(Semester) AS Semester
FROM Registrations
WHERE Status LIKE 'E%';

-- 48. Upper case course descriptions containing 'fund'
SELECT UPPER(Description) AS Description
FROM Courses
WHERE Description LIKE '%fund%';

-- 49. Group registrations by lower case year string, avg student ID >5
SELECT LOWER(CAST(Year AS VARCHAR)) AS YearString, AVG(StudentID) AS AvgStudentID
FROM Registrations
GROUP BY LOWER(CAST(Year AS VARCHAR))
HAVING AVG(StudentID) > 5;

-- 50. Upper case full names where date of birth like '2004%'
SELECT UPPER(FullName) AS FullName
FROM Students
WHERE CONVERT(VARCHAR, DateOfBirth, 112) LIKE '2004%';


/* ===============================
   Section 5: Mixed Complex Queries
   =============================== */

-- Q1: Add Email column
ALTER TABLE Students ADD Email VARCHAR(100);

-- Q2: Update email for student 1
UPDATE Students SET Email = 'john.doe@example.com' WHERE StudentID = 1;

-- Q3: Change Credits datatype
ALTER TABLE Courses ALTER COLUMN Credits DECIMAL(3,1);

-- Q4: Add 5 points where grade <70
UPDATE Grades SET Grade = Grade + 5 WHERE Grade < 70;

-- Q5: Drop Department column
ALTER TABLE Instructors DROP COLUMN Department;

-- Q6: Update school 1 location
UPDATE Schools
SET Location = 'New York City'
WHERE SchoolID = 1;

-- Q7: Add CHECK constraint on Status
ALTER TABLE Registrations
ADD CONSTRAINT CHK_Status CHECK (Status IN ('Enrolled','Dropped'));

-- Q8: Set status Completed where grade exists
ALTER TABLE Registrations
DROP CONSTRAINT CHK_Status;

ALTER TABLE Registrations
ADD CONSTRAINT CHK_Status
CHECK (Status IN ('Enrolled', 'Dropped', 'Completed'));

UPDATE Registrations
SET Status = 'Completed'
WHERE EXISTS (
    SELECT 1
    FROM Grades g
    WHERE g.StudentID = Registrations.StudentID
      AND g.CourseID = Registrations.CourseID
);

-- Q9: Make Grade NOT NULL with default 0
ALTER TABLE Grades DROP COLUMN LetterGrade;

ALTER TABLE Grades
ADD CONSTRAINT DF_Grade DEFAULT 0 FOR Grade;

ALTER TABLE Grades
ALTER COLUMN Grade DECIMAL(5,2) NOT NULL;

ALTER TABLE Grades
ADD LetterGrade AS (
    CASE 
        WHEN Grade >= 90 THEN 'A'
        WHEN Grade >= 80 THEN 'B'
        WHEN Grade >= 70 THEN 'C'
        WHEN Grade >= 60 THEN 'D'
        ELSE 'F'
    END
);


-- Q10: Update hire date for instructor 1
UPDATE Instructors SET HireDate = GETDATE() WHERE InstructorID = 1;

-- Q11: Rename Location to City
EXEC sp_rename 'Schools.Location', 'City', 'COLUMN';

-- Q12: Update enrollment date for school 2 students
UPDATE Students SET EnrollmentDate = '2023-01-01' WHERE SchoolID = 2;

-- Q13: Unique RoomNumber per School
ALTER TABLE ClassRooms ADD CONSTRAINT UQ_Room UNIQUE (RoomNumber, SchoolID);

-- Q14: Credits = 5 where name like Science
UPDATE Courses SET Credits = 5 WHERE CourseName LIKE 'Science%';

-- Q15: Drop Equipment column
ALTER TABLE LabRooms DROP COLUMN Equipment;

-- Q16: Set grade = 100 where letter grade A
UPDATE Grades SET Grade = 100 WHERE LetterGrade = 'A';

-- Q17: Change DateOfBirth to DATETIME
ALTER TABLE Students ALTER COLUMN DateOfBirth DATETIME;

-- Q18: Set registration year to 2025 for Spring
UPDATE Registrations SET Year = 2025 WHERE Semester = 'Spring';

-- Q19: Add PassFail computed column
ALTER TABLE Grades
ADD PassFail AS (CASE WHEN Grade>=60 THEN 'Pass' ELSE 'Fail' END) PERSISTED;

-- Q20: Update last name where department = Math
UPDATE Instructors SET LastName = 'Updated' WHERE Department = 'Mathematics';


/* ===============================
   COMPLEX SELECT QUERIES
   =============================== */

-- Q21: Avg grade per school >85
SELECT sc.SchoolName, AVG(g.Grade) AvgGrade
FROM Grades g
JOIN Students s ON g.StudentID=s.StudentID
JOIN Schools sc ON s.SchoolID=sc.SchoolID
GROUP BY sc.SchoolName
HAVING AVG(g.Grade)>85
ORDER BY AvgGrade DESC;

-- Q22: Students name like J%, sum grades >150
SELECT s.FullName, SUM(g.Grade) Total
FROM Students s JOIN Grades g ON s.StudentID=g.StudentID
WHERE s.FullName LIKE 'J%'
GROUP BY s.FullName
HAVING SUM(g.Grade)>150;

-- Q23: Courses without registrations like 101
SELECT c.CourseName
FROM Courses c LEFT JOIN Registrations r ON c.CourseID=r.CourseID
WHERE r.CourseID IS NULL AND c.CourseName LIKE '%101%';

-- Q24: Max grade per department >90
SELECT i.Department, MAX(g.Grade)
FROM Instructors i
JOIN Courses c ON i.SchoolID=c.SchoolID
JOIN Grades g ON c.CourseID=g.CourseID
GROUP BY i.Department
HAVING MAX(g.Grade)>90;

-- Q25: Distinct upper names city A-N
SELECT DISTINCT UPPER(s.FullName)
FROM Students s JOIN Schools sc ON s.SchoolID=sc.SchoolID
WHERE sc.City BETWEEN 'A' AND 'N';

-- Q26: Count enrollments per course >2
SELECT c.CourseName, COUNT(r.StudentID)
FROM Courses c JOIN Registrations r ON c.CourseID=r.CourseID
GROUP BY c.CourseName
HAVING COUNT(r.StudentID)>2
ORDER BY COUNT(r.StudentID);

-- Q27: Labs capacity 20 or 25, school name like high
SELECT l.LabNumber, sc.SchoolName
FROM LabRooms l JOIN Schools sc ON l.SchoolID=sc.SchoolID
WHERE l.Capacity IN (20,25) AND LOWER(sc.SchoolName) LIKE '%high%';

-- Q28: Avg credits per instructor school <4
SELECT i.SchoolID, AVG(c.Credits)
FROM Instructors i JOIN Courses c ON i.SchoolID=c.SchoolID
GROUP BY i.SchoolID
HAVING AVG(c.Credits)<4;

-- Q29: Min hire date per school with >3 students
SELECT sc.SchoolName, MIN(i.HireDate)
FROM Schools sc JOIN Instructors i ON sc.SchoolID=i.SchoolID
JOIN Students s ON sc.SchoolID=s.SchoolID
GROUP BY sc.SchoolName
HAVING COUNT(s.StudentID)>3;

-- Q30: Subquery average grade per student
SELECT s.FullName,
(SELECT AVG(Grade) FROM Grades g WHERE g.StudentID=s.StudentID) AvgGrade
FROM Students s;

-- Q31: Students with A grades in Bio courses
SELECT s.FullName, c.CourseName
FROM Students s JOIN Grades g ON s.StudentID=g.StudentID
JOIN Courses c ON g.CourseID=c.CourseID
WHERE g.LetterGrade='A' AND c.CourseName LIKE 'Bio%'
ORDER BY s.FullName;

-- Q32: Sum grades per semester >500
SELECT r.Semester, SUM(g.Grade)
FROM Registrations r JOIN Grades g
ON r.StudentID=g.StudentID AND r.CourseID=g.CourseID
GROUP BY r.Semester
HAVING SUM(g.Grade)>500;

-- Q33: Distinct upper course names credits 2-4 with >1 registration
SELECT DISTINCT UPPER(c.CourseName)
FROM Courses c
WHERE c.Credits BETWEEN 2 AND 4
AND (SELECT COUNT(*) FROM Registrations r WHERE r.CourseID=c.CourseID)>1;

-- Q34: Left join unmatched names like son
SELECT s.FullName
FROM Students s LEFT JOIN Grades g ON s.StudentID=g.StudentID
WHERE s.FullName LIKE '%son%' AND g.StudentID IS NULL
ORDER BY s.FullName DESC;

-- Q35: Max classroom capacity per building >35
SELECT LOWER(Building), MAX(Capacity)
FROM ClassRooms
GROUP BY Building
HAVING MAX(Capacity)>35;

-- Q36: Students in school 1 or 2 avg >80
SELECT s.FullName, AVG(g.Grade)
FROM Students s JOIN Grades g ON s.StudentID=g.StudentID
WHERE s.SchoolID IN (1,2)
GROUP BY s.FullName
HAVING AVG(g.Grade)>80;

-- Q37: Full join where status like En%
SELECT DISTINCT r.RegistrationID
FROM Registrations r
FULL JOIN Grades g ON r.StudentID=g.StudentID AND r.CourseID=g.CourseID
WHERE r.Status LIKE 'En%';

-- Q38: Count labs per equipment like comp =2
SELECT Equipment, COUNT(*) AS LabCount
FROM LabRooms
WHERE Equipment LIKE '%comp%'
GROUP BY Equipment
HAVING COUNT(*) = 2;


-- Q39: Students with avg grade >85
SELECT s.FullName
FROM Students s
WHERE s.StudentID IN (
SELECT g.StudentID FROM Grades g GROUP BY g.StudentID HAVING AVG(g.Grade)>85);

-- Q40: Right join schools & students order by dob
SELECT LOWER(s.FullName), s.DateOfBirth
FROM Students s RIGHT JOIN Schools sc ON s.SchoolID=sc.SchoolID
ORDER BY s.DateOfBirth;

-- Q41: Grades 70-90, min <75 per letter
SELECT g.LetterGrade, MIN(g.Grade)
FROM Grades g JOIN Courses c ON g.CourseID=c.CourseID
WHERE g.Grade BETWEEN 70 AND 90
GROUP BY g.LetterGrade
HAVING MIN(g.Grade)<75;

-- Q42: Upper department where instructor name like _i%
SELECT UPPER(i.Department), sc.SchoolName
FROM Instructors i JOIN Schools sc ON i.SchoolID=sc.SchoolID
WHERE i.FirstName LIKE '_i%';

-- Q43: Years sum grades >100
SELECT r.Year, SUM(g.Grade)
FROM Registrations r JOIN Grades g
ON r.StudentID=g.StudentID AND r.CourseID=g.CourseID
GROUP BY r.Year
HAVING SUM(g.Grade)>100;

-- Q44: Left join nulls ids 1,3,5
SELECT s.FullName
FROM Students s LEFT JOIN Grades g ON s.StudentID=g.StudentID
WHERE s.StudentID IN (1,3,5) AND g.StudentID IS NULL
ORDER BY s.FullName;

-- Q45: Avg grade per school between 80 and 90
SELECT sc.SchoolName, AVG(g.Grade)
FROM Grades g JOIN Students s ON g.StudentID=s.StudentID
JOIN Schools sc ON s.SchoolID=sc.SchoolID
GROUP BY sc.SchoolName
HAVING AVG(g.Grade) BETWEEN 80 AND 90;

-- Q46: Full join instructors & courses desc like prog
SELECT LOWER(i.FirstName), c.Description
FROM Instructors i FULL JOIN Courses c ON i.SchoolID=c.SchoolID
WHERE c.Description LIKE '%prog%';

-- Q47: Count students per city >2
SELECT sc.City, COUNT(s.StudentID)
FROM Schools sc JOIN Students s ON sc.SchoolID=s.SchoolID
GROUP BY sc.City
HAVING COUNT(s.StudentID)>2
ORDER BY COUNT(s.StudentID) DESC;

-- Q48: Max-min grade diff >10 per student
SELECT s.FullName, MAX(g.Grade), MIN(g.Grade)
FROM Students s JOIN Grades g ON s.StudentID=g.StudentID
GROUP BY s.FullName
HAVING MAX(g.Grade)-MIN(g.Grade)>10;

-- Q49: Equipment like tools, capacity 15-25, upper school name
SELECT UPPER(sc.SchoolName) AS SchoolName, l.Capacity
FROM LabRooms l
JOIN Schools sc ON l.SchoolID = sc.SchoolID
WHERE l.Equipment LIKE '%tools%'
  AND l.Capacity BETWEEN 15 AND 25;

-- Q50: Sum credits by semester & school >10
SELECT UPPER(r.Semester), sc.SchoolName, SUM(c.Credits)
FROM Registrations r
JOIN Courses c ON r.CourseID=c.CourseID
JOIN Students s ON r.StudentID=s.StudentID
JOIN Schools sc ON s.SchoolID=sc.SchoolID
GROUP BY r.Semester, sc.SchoolName
HAVING SUM(c.Credits)>10
ORDER BY SUM(c.Credits) DESC;


/*  =========================
        LIKE + Wildcards – Pattern Matching (Questions 1–10)
    ========================= */

-- 1. Students whose first name starts with 'J' or 'S' and has exactly 4 letters
SELECT * 
FROM Students
WHERE (FirstName LIKE 'J___' OR FirstName LIKE 'S___');

-- 2. Courses containing "Science" (case insensitive)
SELECT * 
FROM Courses
WHERE CourseName LIKE '%Science%';

-- 3. Students whose last name ends with "sen" or "man"
SELECT * 
FROM Students
WHERE LastName LIKE '%sen' OR LastName LIKE '%man';

-- 4. Instructors whose full name has "de " somewhere in the middle
SELECT * 
FROM Instructors
WHERE FullName LIKE '%de %';

-- 5. Lab equipment containing both "computers" and "projector"
SELECT * 
FROM LabRooms
WHERE Equipment LIKE '%computers%' AND Equipment LIKE '%projector%';

-- 6. Students whose first name starts with vowel and is longer than 4
SELECT * 
FROM Students
WHERE FirstName LIKE '[AEIOU]%' AND LEN(FirstName) > 4;

-- 7. Courses that start with a digit or contain a digit
SELECT * 
FROM Courses
WHERE CourseName LIKE '[0-9]%' OR CourseName LIKE '%[0-9]%';

-- 8. Last names not starting with 'v', 'd', or 'J'
SELECT * 
FROM Students
WHERE LastName NOT LIKE '[vdJ]%';

-- 9. Registrations with semester exactly 4 chars starting with 'F' or 'S'
SELECT * 
FROM Registrations
WHERE LEN(Semester) = 4 AND Semester LIKE '[FS]___';

-- 10. Room numbers with exactly one digit in the middle
SELECT * 
FROM ClassRooms
WHERE RoomNumber LIKE '_[0-9]_';



/*  =========================
        LIKE + Functions + Conditions (Questions 11–20)
    ========================= */

-- 11. Students whose first and last name start with same letter
SELECT * 
FROM Students
WHERE LEFT(FirstName,1) = LEFT(LastName,1);

-- 12. Course names where second character is a vowel
SELECT * 
FROM Courses
WHERE CourseName LIKE '_[AEIOU]%';

-- 13. Instructors hired in years containing "201"
SELECT * 
FROM Instructors
WHERE CONVERT(varchar, HireDate, 120) LIKE '%201%';

-- 14. Grades 'A' or 'B' and numeric grade ending with '.5' or '.0'
SELECT * 
FROM Grades
WHERE LetterGrade IN ('A','B') AND (CAST(Grade AS varchar) LIKE '%.5' OR CAST(Grade AS varchar) LIKE '%.0');

-- 15. School names with at least two words
SELECT * 
FROM Schools
WHERE SchoolName LIKE '% %';

-- 16. Students born in months starting with 'J'
SELECT * 
FROM Students
WHERE DATENAME(month, DateOfBirth) LIKE 'J%';

-- 17. Last names with double letters
SELECT * 
FROM Students
WHERE LastName LIKE '%aa%' OR LastName LIKE '%bb%' OR LastName LIKE '%cc%' 
   OR LastName LIKE '%dd%' OR LastName LIKE '%ee%' OR LastName LIKE '%ff%' 
   OR LastName LIKE '%gg%' OR LastName LIKE '%hh%' OR LastName LIKE '%ii%' 
   OR LastName LIKE '%jj%' OR LastName LIKE '%kk%' OR LastName LIKE '%ll%' 
   OR LastName LIKE '%mm%' OR LastName LIKE '%nn%' OR LastName LIKE '%oo%' 
   OR LastName LIKE '%pp%' OR LastName LIKE '%qq%' OR LastName LIKE '%rr%' 
   OR LastName LIKE '%ss%' OR LastName LIKE '%tt%' OR LastName LIKE '%uu%' 
   OR LastName LIKE '%vv%' OR LastName LIKE '%ww%' OR LastName LIKE '%xx%' 
   OR LastName LIKE '%yy%' OR LastName LIKE '%zz%';

-- 18. Courses with "introduction" but not "advanced"
SELECT * 
FROM Courses
WHERE Description LIKE '%introduction%' AND Description NOT LIKE '%advanced%';

-- 19. First names with only one type of vowel repeated (partial solution)
SELECT * 
FROM Students
WHERE FirstName LIKE '%a%' AND FirstName NOT LIKE '%e%' AND FirstName NOT LIKE '%i%' 
  AND FirstName NOT LIKE '%o%' AND FirstName NOT LIKE '%u%';
-- (Repeat for other vowels for full coverage)

-- 20. Students with full name length 10–14 and exactly one space
SELECT * 
FROM Students
WHERE LEN(FullName) BETWEEN 10 AND 14 
  AND FullName LIKE '% %' AND FullName NOT LIKE '% % %';


/*  =========================
        LIKE in JOIN / Subquery / HAVING (Questions 21–30)
    ========================= */

-- 21. Students and their courses where course name contains student's first name
SELECT s.FullName, c.CourseName
FROM Students s
JOIN Registrations r ON s.StudentID = r.StudentID
JOIN Courses c ON r.CourseID = c.CourseID
WHERE c.CourseName LIKE '%' + s.FirstName + '%';

-- 22. Instructors whose department name appears in any course description
SELECT i.FullName, i.Department
FROM Instructors i
WHERE EXISTS (
    SELECT 1
    FROM Courses c
    WHERE c.Description LIKE '%' + i.Department + '%'
);

-- 23. Schools where at least one student has last name starting with same letter as school
SELECT DISTINCT sc.SchoolName
FROM Schools sc
WHERE EXISTS (
    SELECT 1
    FROM Students s
    WHERE s.SchoolID = sc.SchoolID
      AND s.LastName LIKE LEFT(sc.SchoolName,1) + '%'
);

-- 24. Count of courses per school containing "intro" or "basic"
SELECT c.SchoolID, COUNT(*) AS CourseCount
FROM Courses c
WHERE c.Description LIKE '%intro%' OR c.Description LIKE '%basic%'
GROUP BY c.SchoolID
HAVING COUNT(*) > 0;

-- 25. Students registered in at least two courses with "Math" in name
SELECT r.StudentID
FROM Registrations r
JOIN Courses c ON r.CourseID = c.CourseID
WHERE c.CourseName LIKE '%Math%'
GROUP BY r.StudentID
HAVING COUNT(DISTINCT r.CourseID) >= 2;

-- 26. Classrooms whose room number matches any lab number pattern
SELECT cr.*
FROM ClassRooms cr
JOIN LabRooms lr ON cr.RoomNumber LIKE '%' + SUBSTRING(lr.LabNumber,2,2) + '%';

-- 27. Students whose last name is a substring of any instructor last name
SELECT s.*
FROM Students s
WHERE EXISTS (
    SELECT 1
    FROM Instructors i
    WHERE i.LastName LIKE '%' + s.LastName + '%'
);

-- 28. Courses with no registrations from students whose first name starts with M or N
SELECT c.*
FROM Courses c
WHERE NOT EXISTS (
    SELECT 1
    FROM Registrations r
    JOIN Students s ON r.StudentID = s.StudentID
    WHERE r.CourseID = c.CourseID
      AND s.FirstName LIKE '[MN]%'
);

-- 29. Average grade per course where course name starts and ends with same letter
SELECT c.CourseName, AVG(g.Grade) AS AvgGrade
FROM Courses c
JOIN Grades g ON c.CourseID = g.CourseID
WHERE LEFT(c.CourseName,1) = RIGHT(c.CourseName,1)
GROUP BY c.CourseName;

-- 30. Top 5 most common ending letter of student last names for students passed in Bio/Chem
SELECT TOP 5 RIGHT(s.LastName,1) AS EndingLetter, COUNT(*) AS CountLetter
FROM Students s
JOIN Grades g ON s.StudentID = g.StudentID
JOIN Courses c ON g.CourseID = c.CourseID
WHERE g.LetterGrade >= 'D'
  AND (c.CourseName LIKE '%Bio%' OR c.CourseName LIKE '%Chem%')
GROUP BY RIGHT(s.LastName,1)
ORDER BY COUNT(*) DESC;

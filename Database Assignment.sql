-- Database: Student Attendance Management System (SAMS)
CREATE DATABASE SAMS
GO

--Create Tables
use SAMS
CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName  VARCHAR(50) NOT NULL,
    Gender    CHAR(1),
    Phone     VARCHAR(15)
)

CREATE TABLE Courses (
    CourseID       VARCHAR(10) PRIMARY KEY,
    CourseName     VARCHAR(100) NOT NULL,
    Credits        INT,
    InstructorName VARCHAR(100)
)

CREATE TABLE Attendance (
    AttendanceID   INT IDENTITY (1, 1) PRIMARY KEY,
    AttendanceDate DATE NOT NULL,
    Status         VARCHAR(10) NOT NULL CHECK (Status IN ('Present', 'Absent')),
    StudentID      INT NOT NULL,
    CourseID       VARCHAR(10) NOT NULL,
    
    CONSTRAINT FK_Student FOREIGN KEY (StudentID) REFERENCES Students(StudentID) ON DELETE CASCADE,
    CONSTRAINT FK_Course  FOREIGN KEY (CourseID)  REFERENCES Courses(CourseID)  ON DELETE CASCADE
)
GO

-- Insert Sample Data
use SAMS
INSERT INTO Students (StudentID, FirstName, LastName, Gender, Phone) VALUES 
(1001, 'Abebe', 'Tola', 'M', '09***4'),
(1002, 'Hanna', 'Mulugeta', 'F', '09***5'),
(1003, 'Fetiya', 'Mohammed', 'F', '09***6'),
(1004, 'Akram,', 'Jemal', 'M', '09***7');

INSERT INTO Courses (CourseID, CourseName, Credits, InstructorName) VALUES 
('CS101', 'Database Systems', 4, 'Dr. Solomon'),
('CS102', 'Data Structures', 3, 'Abebech T.');

INSERT INTO Attendance (AttendanceDate, Status, StudentID, CourseID) VALUES 
('2025-11-15', 'Present', 1001, 'CS101'),
('2025-11-15', 'Absent',  1002, 'CS101'),
('2025-11-15', 'Present', 1003, 'CS101'),
('2025-11-15', 'Present', 1004, 'CS101'),
('2025-11-16', 'Present', 1001, 'CS101'),
('2025-11-16', 'Present', 1002, 'CS101'),
('2025-11-16', 'Absent',  1003, 'CS101');
GO

-- Queries
use SAMS
SELECT 
    A.AttendanceDate, 
    S.FirstName + ' ' + S.LastName AS StudentName, 
    C.CourseName, 
    A.Status
FROM Attendance A
JOIN Students S ON A.StudentID = S.StudentID
JOIN Courses C ON A.CourseID = C.CourseID
ORDER BY A.AttendanceDate;

SELECT 
    S.FirstName, 
    S.LastName,
    COUNT(CASE WHEN A.Status = 'Present' THEN 1 END) AS Days_Present,
    COUNT(A.AttendanceID) AS Total_Classes,
    CAST(COUNT(CASE WHEN A.Status = 'Present' THEN 1 END) * 100.0 / COUNT(A.AttendanceID) AS DECIMAL(5,2)) AS [Attendance_Percent]
FROM Students S
JOIN Attendance A ON S.StudentID = A.StudentID
GROUP BY S.FirstName, S.LastName;
GO
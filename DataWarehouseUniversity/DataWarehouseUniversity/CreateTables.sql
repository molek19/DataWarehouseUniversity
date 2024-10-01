--CREATE DATABASE UniversityDW
--Go

USE UniversityDW
Go

CREATE TABLE DimTeacher(
TeacherKey INTEGER IDENTITY(1,1) PRIMARY KEY,
TeacherID Varchar(8),
Name Varchar(20),
Surname Varchar(20),
ScientificDegree Varchar(20),
isCurrent Varchar(3)
);

GO

CREATE TABLE DimStudent(
StudentKey INTEGER IDENTITY(1,1) PRIMARY KEY,
StudentID Varchar(8),
Name Varchar(20),
Surname Varchar(20),
City Varchar(50),
ECTS_debit_range Varchar(10),
isActive Varchar(3),
Math_result_range Varchar(4),
Physics_result_range Varchar(4),
Polish_result_range Varchar(4),
English_result_range Varchar(4),
First_choice Varchar(30),
Second_choice Varchar(30),
Recruitment_points_range Varchar(4)
);

GO

CREATE TABLE DimMajor(
MajorKey INTEGER IDENTITY(1,1) PRIMARY KEY,
MajorID Varchar(8),
Name Varchar(30),
DegreeName Varchar(20),
Faculty Varchar(50)
);

GO

CREATE TABLE DimCourse(
CourseKey INTEGER IDENTITY(1,1) PRIMARY KEY,
CourseID Varchar(10),
Name Varchar(50),
Semester INT,
ECTS int
);

GO

CREATE TABLE DimAssessment_Description(
AssessmentDesID int IDENTITY(1,1) PRIMARY KEY,
AssessmentTypeCourse Varchar(13),
AssessmentTypeTeacher Varchar(13)
);

GO

CREATE TABLE DimTeaching_Description(
TeachingDesID int IDENTITY(1,1) PRIMARY KEY,
Type Varchar(10),
isCompleted Varchar(3)
);

GO

CREATE TABLE DimStudyingDescription(
StudyingDesID int IDENTITY(1,1) PRIMARY KEY,
Graduated Varchar(3),
WasFirstChoice Varchar(3)
);

GO

CREATE TABLE DimDate(
DateID int IDENTITY(1,1) PRIMARY KEY,
Date date,
DayNo AS DAY(Date) PERSISTED,
MonthNo AS MONTH(Date) PERSISTED,
Month VARCHAR(20),
YearNo AS YEAR(Date) PERSISTED,
SemesterNo int,
Term Varchar(6)
);

GO

CREATE TRIGGER trg_InsertMonthName
ON DimDate
AFTER INSERT
AS
BEGIN
    UPDATE DimDate
    SET Month = 
        CASE 
            WHEN inserted.MonthNo = 1 THEN 'January'
            WHEN inserted.MonthNo = 2 THEN 'February'
            WHEN inserted.MonthNo = 3 THEN 'March'
            WHEN inserted.MonthNo = 4 THEN 'April'
            WHEN inserted.MonthNo = 5 THEN 'May'
            WHEN inserted.MonthNo = 6 THEN 'June'
            WHEN inserted.MonthNo = 7 THEN 'July'
            WHEN inserted.MonthNo = 8 THEN 'August'
            WHEN inserted.MonthNo = 9 THEN 'September'
            WHEN inserted.MonthNo = 10 THEN 'October'
            WHEN inserted.MonthNo = 11 THEN 'November'
            WHEN inserted.MonthNo = 12 THEN 'December'
        END
    FROM DimDate
    INNER JOIN inserted ON DimDate.DateID = inserted.DateID;
END;

GO

CREATE TABLE FTeachingHeld(
FK_StudentID int FOREIGN KEY REFERENCES DimStudent(StudentKey), 
FK_TeacherID int FOREIGN KEY REFERENCES DimTeacher(TeacherKey), 
FK_CourseID int FOREIGN KEY REFERENCES DimCourse(CourseKey), 
FK_DateID int FOREIGN KEY REFERENCES DimDate(DateID), 
FK_TeachingDesID int FOREIGN KEY REFERENCES DimTeaching_Description(TeachingDesID), 
Grade int,
Points int,
CONSTRAINT CompPKTeaching PRIMARY KEY (FK_StudentID, FK_TeacherID, FK_CourseID, FK_DateID, FK_TeachingDesID)
);

GO

CREATE TABLE FStudying(
FK_MajorID int FOREIGN KEY REFERENCES DimMajor(MajorKey), 
FK_StudentID int FOREIGN KEY REFERENCES DimStudent(StudentKey), 
FK_DateID int FOREIGN KEY REFERENCES DimDate(DateID), 
FK_Studying_DesID int FOREIGN KEY REFERENCES DimStudyingDescription(StudyingDesID)
CONSTRAINT CompPKStudying PRIMARY KEY(FK_MajorID, FK_StudentID, FK_DateID)
);

GO

CREATE TABLE FAssessment(
FK_CourseID int FOREIGN KEY REFERENCES DimCourse(CourseKey),
FK_StudentID int FOREIGN KEY REFERENCES DimStudent(StudentKey),
FK_TeacherID int FOREIGN KEY REFERENCES DimTeacher(TeacherKey),
FK_AssessmentDesID int FOREIGN KEY REFERENCES DimAssessment_Description(AssessmentDesID),
Course_Assessment_Value int,
Techer_Assessment_Value int,
AttendenceRateConsultations int,
CONSTRAINT CompPKAssessment PRIMARY KEY(FK_CourseID, FK_StudentID, FK_TeacherID, FK_AssessmentDesID)
);

GO

CREATE TABLE tempAssessment(
FK_CourseID varchar(10),
FK_StudentID varchar(10),
FK_TeacherID varchar(10),
FK_AssessmentDesID int,
Course_Assessment_Value int,
Techer_Assessment_Value int,
AttendenceRateConsultations int

);

GO

CREATE TABLE tempStudying(
FK_MajorID varchar(10), 
FK_StudentID varchar(10), 
FK_DateID int, 
FK_Studying_DesID int
);

GO

CREATE TABLE tempTeaching(
FK_StudentID varchar(10), 
FK_TeacherID varchar(10), 
FK_CourseID varchar(10), 
FK_DateID int,
FK_TeachingDesID int,
Grade int,
Points int
);

GO






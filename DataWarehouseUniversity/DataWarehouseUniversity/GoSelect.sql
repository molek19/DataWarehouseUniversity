USE UniversityDW

Go

SELECT * FROM dbo.DimTeacher;
SELECT * FROM dbo.DimMajor;
SELECT * FROM dbo.DimCourse;
SELECT * FROM dbo.DimStudent;
SELECT * FROM dbo.DimTeaching_Description;
SELECT * FROM dbo.DimAssessment_Description;
SELECT * FROM dbo.FAssessment;
SELECT * FROM dbo.DimStudyingDescription;
SELECT * FROM dbo.FStudying;
SELECT * FROM dbo.DimDate;
SELECT * FROM dbo.FTeachingHeld;
SELECT * FROM dbo.tempAssessment ORDER BY FK_AssessmentDesID;

SELECT * FROM DimTeacher WHERE TeacherID = '0230ab8c';
SELECT * FROM DimTeacher WHERE TeacherID = '03df4a32';
SELECT * FROM DimTeacher WHERE TeacherID = '57849a7c'; -- nauczyciele zmienieni w SCD

--1, 266, 531, 796
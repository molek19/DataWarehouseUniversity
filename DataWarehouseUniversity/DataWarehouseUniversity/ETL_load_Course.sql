USE UniversityDW
GO

If (object_id('vETLDimAuthorsData') is not null) Drop View vETLDimCourse;
go
CREATE VIEW vETLDimCourse
AS
SELECT DISTINCT
	[CourseID],
	[Name],
	[Semester],
	[ECTS]
FROM University.dbo.Course;
go

MERGE INTO DimCourse as TT
	USING vETLDimCourse as ST
		ON TT.CourseID = ST.CourseID
		AND TT.Name = ST.Name
		AND TT.Semester = ST.Semester
		AND TT.ECTS = ST.ECTS
			WHEN Not Matched
			AND NOT EXISTS (
				SELECT 1
				FROM DimCourse
				WHERE CourseID = ST.CourseID
				AND Name = ST.Name
				AND Semester = ST.Semester
				AND ECTS = ST.ECTS
			)
			THEN
				INSERT (CourseID, Name, Semester, ECTS)
				Values (ST.CourseID, ST.Name, ST.Semester, ST.ECTS)
			WHEN Not Matched By Source
			THEN
				DELETE
			;

Drop View vETLDimCourse;
USE UniversityDW
GO

If (object_id('vETLDimAuthorsData') is not null) Drop View vETLDimAuthorsData;
go
CREATE VIEW vETLDimTeacher
AS
SELECT DISTINCT
	[TeacherID],
	[Name],
	[Surname],
	[ScientificDegree],
	'1' as isCurrent --na 1 0 zmienic
FROM University.dbo.Teacher;
go

MERGE INTO DimTeacher as TT
	USING vETLDimTeacher as ST
		ON TT.TeacherID = ST.TeacherID
		AND TT.Name = ST.Name
		AND TT.Surname = ST.Surname
		AND TT.ScientificDegree = ST.ScientificDegree
		AND TT.isCurrent = ST.isCurrent
			WHEN Not Matched BY TARGET
			AND NOT EXISTS (
				SELECT 1
				FROM DimTeacher
				WHERE TeacherID = ST.TeacherID
				AND Name = ST.Name
				AND Surname = ST.Surname
				AND ScientificDegree = ST.ScientificDegree
				AND isCurrent = ST.isCurrent
			
			)
			THEN
				INSERT (TeacherID, Name, Surname, ScientificDegree, isCurrent)
				Values (ST.TeacherID, ST.Name, ST.Surname, ST.ScientificDegree, ST.isCurrent)
			WHEN NOT MATCHED BY SOURCE
			THEN
				DELETE;

Drop View vETLDimTeacher;
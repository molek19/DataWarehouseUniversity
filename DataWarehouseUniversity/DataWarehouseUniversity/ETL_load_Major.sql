USE UniversityDW
GO

If (object_id('vETLDimMajor') is not null) Drop View vETLDimMajor;
go
CREATE VIEW vETLDimMajor
AS
SELECT A.MajorID, A.Name,A.DegreeName, 'Faculty of science' AS FacultyName
FROM University.dbo.Major A;
go

MERGE INTO DimMajor as TT
	USING vETLDimMajor as ST
		ON TT.MajorID = ST.MajorID
		AND TT.Name = ST.Name
		AND TT.DegreeName = ST.DegreeName
		AND TT.Faculty = ST.FacultyName
			WHEN Not Matched BY TARGET
			AND NOT EXISTS (
				SELECT 1
				FROM DimMajor
				WHERE MajorID = ST.MajorID
				AND Name = ST.Name
				AND DegreeName = ST.DegreeName
				AND Faculty = ST.FacultyName
			)
			THEN
				INSERT (MajorID, Name, DegreeName, Faculty)
				Values (ST.MajorID, ST.Name, ST.DegreeName, ST.FacultyName)
			WHEN Not Matched By Source
			Then
				DELETE
			;
Drop View vETLDimMajor;
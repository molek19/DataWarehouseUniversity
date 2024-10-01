USE UniversityDW
GO

If (object_id('vETLDimTeachingDesc') is not null) Drop View vETLDimTeachingDesc;
go
CREATE VIEW vETLDimTeachingDesc
AS
SELECT
	ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) as RowNumber,
	[Type], 
	CASE
		WHEN [IsCompleted]=1 THEN 'yes'
		ELSE 'no'
	END AS [isCompleted]
FROM University.dbo.Teaching;
go

INSERT INTO DimTeaching_Description (Type, isCompleted)
SELECT ST.Type, ST.isCompleted
FROM vETLDimTeachingDesc ST
WHERE ST.RowNumber NOT IN (
    SELECT TeachingDesID
    FROM DimTeaching_Description
);

Drop View vETLDimTeachingDesc;
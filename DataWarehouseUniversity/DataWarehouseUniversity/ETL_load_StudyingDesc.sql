USE UniversityDW
GO

If (object_id('vETLDimStudyingDesc') is not null) Drop View vETLDimStudyingDesc;
go
CREATE VIEW vETLDimStudyingDesc
AS
SELECT 
	ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) as RowNumber,
    CASE
        WHEN COUNT (CASE WHEN t.IsCompleted = '1' THEN 1 END) = COUNT(*) THEN 'yes'
        ELSE 'no'
    END AS [Graduated],
	CASE
		WHEN r.[First_choice] LIKE '%[0-9]%' THEN 'no'
		ELSE 'yes'
	END AS [WasFirstChoice]
FROM 
    University.dbo.Student s
JOIN 
    University.dbo.Major dc ON s.FK_Major = dc.MajorID
LEFT JOIN 
    University.dbo.Course c ON dc.MajorID = c.FK_Major
LEFT JOIN 
    University.dbo.Teaching t ON s.StudentID = t.FK_Student AND c.CourseID = t.FK_Course
JOIN
	University.dbo.Recruitment r ON s.StudentID=r.FK_student
GROUP BY s.StudentID,r.First_choice;

go

INSERT INTO DimStudyingDescription(Graduated, WasFirstChoice)
SELECT ST.Graduated, ST.WasFirstChoice
FROM vETLDimStudyingDesc ST
WHERE ST.RowNumber NOT IN (
    SELECT StudyingDesID
    FROM DimStudyingDescription
);

Drop View vETLDimStudyingDesc;

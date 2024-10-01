USE UniversityDW
GO

If (object_id('vETLDimAssessmentDescription') is not null) Drop View vETLDimAssessmentDescription;
go
CREATE VIEW vETLDimAssessmentDescription
AS
SELECT
	ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) as RowNumber,
	CASE
		WHEN [Course_Assessment_Value]=1 THEN 'very bad'
		WHEN [Course_Assessment_Value]=2 THEN 'not that bad'
		WHEN [Course_Assessment_Value]=3 THEN 'mediocre'
		WHEN [Course_Assessment_Value]=4 THEN 'good'
		WHEN [Course_Assessment_Value]=5 THEN 'extraordinary'
	END AS [AssessmentTypeCourse],
	CASE
		WHEN [Techer_Assessment_Value]=1 THEN 'very bad'
		WHEN [Techer_Assessment_Value]=2 THEN 'not that bad'
		WHEN [Techer_Assessment_Value]=3 THEN 'mediocre'
		WHEN [Techer_Assessment_Value]=4 THEN 'good'
		WHEN [Techer_Assessment_Value]=5 THEN 'extraordinary'
	END AS [AssessmentTypeTeacher]
FROM UniversityDW.dbo.tempAssessment;
go

INSERT INTO DimAssessment_Description (AssessmentTypeCourse, AssessmentTypeTeacher)
SELECT ST.AssessmentTypeCourse, ST.AssessmentTypeTeacher
FROM vETLDimAssessmentDescription ST
WHERE ST.RowNumber NOT IN (
    SELECT AssessmentDesID
    FROM DimAssessment_Description
);



Drop View vETLDimAssessmentDescription;

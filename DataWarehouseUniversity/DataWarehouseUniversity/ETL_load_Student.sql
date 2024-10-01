USE UniversityDW
GO

If (object_id('vETLDimStudent') is not null) Drop View vETLDimStudent;
go
CREATE VIEW vETLDimStudent
AS
SELECT
	A.[StudentID],
	A.[Name],
	A.[Surname],
	A.[City],
	CASE
		WHEN A.[ECTS_debit] < 15 THEN 'low'
		WHEN A.[ECTS_debit] BETWEEN 15 AND 25 THEN 'mid'
		ELSE 'high'
	END AS [ECTS_debit_range],
	CASE
		WHEN A.[ECTS_debit] >= 25 THEN 'no'
		ELSE'yes'
	END AS [isActive],
	CASE
		WHEN B.[Math_result]<40 THEN 'low'
		WHEN B.[Math_result] BETWEEN 40 AND 80 THEN 'mid'
		ELSE 'high'
	END AS [Math_result_range],
	CASE
		WHEN B.[Physics_result]<40 THEN 'low'
		WHEN B.[Physics_result] BETWEEN 40 AND 80 THEN 'mid'
		ELSE 'high'
	END AS [Physics_result_range],
	CASE
		WHEN B.[Polish_result]<40 THEN 'low'
		WHEN B.[Polish_result] BETWEEN 40 AND 80 THEN 'mid'
		ELSE 'high'
	END AS [Polish_result_range],
	CASE
		WHEN B.[English_result]<40 THEN 'low'
		WHEN B.[English_result] BETWEEN 40 AND 80 THEN 'mid'
		ELSE 'high'
	END AS [English_result_range],
	B.[First_choice],
	B.[Second_choice],
	CASE
		WHEN B.[Recruitment_points]<150 THEN 'low'
		WHEN B.[Recruitment_points] BETWEEN 150 AND 300 THEN 'mid'
		ELSE 'high'
	END AS [Recruitment_points_range]
FROM University.dbo.Student A
JOIN University.dbo.Recruitment AS B ON (A.StudentID=B.FK_Student);
go

MERGE INTO DimStudent as TT
	USING vETLDimStudent as ST
		ON TT.StudentID = ST.StudentID
		AND TT.Name = ST.Name
		AND TT.Surname = ST.Surname
		AND TT.City = ST.City
		AND TT.ECTS_debit_range = ST.ECTS_debit_range
		AND TT.isActive = ST.isActive
		AND TT.Math_result_range = ST.Math_result_range
		AND TT.Physics_result_range = ST.Physics_result_range
		AND TT.Polish_result_range = ST.Polish_result_range
		AND TT.English_result_range = ST.English_result_range
		AND TT.First_choice = ST.First_choice
		AND TT.Second_choice = ST.Second_choice
		AND TT.Recruitment_points_range = ST.Recruitment_points_range
			WHEN Not Matched BY TARGET
			AND NOT EXISTS (
				SELECT 1
				FROM DimStudent
				WHERE StudentID = ST.StudentID
				AND Name = ST.Name
				AND Surname = ST.Surname
				AND City = ST.City
				AND ECTS_debit_range = ST.ECTS_debit_range
				AND isActive = ST.isActive
				AND Math_result_range = ST.Math_result_range
				AND Physics_result_range = ST.Physics_result_range
				AND Polish_result_range = ST.Polish_result_range
				AND English_result_range = ST.English_result_range
				AND First_choice = ST.First_choice
				AND Second_choice = ST.Second_choice
				AND Recruitment_points_range = ST.Recruitment_points_range
			)
				THEN
					INSERT (StudentID, Name, Surname, City, ECTS_debit_range, isActive, Math_result_range, Physics_result_range, Polish_result_range, English_result_range, First_choice, Second_choice, Recruitment_points_range)
					Values (ST.StudentID, ST.Name, ST.Surname, ST.City, ST.ECTS_debit_range, ST.isActive, ST.Math_result_range, ST.Physics_result_range, ST.Polish_result_range, ST.English_result_range, ST.First_choice, ST.Second_choice, ST.Recruitment_points_range)
			WHEN Not Matched By Source
			THEN
				DELETE
			;
Drop View vETLDimStudent;
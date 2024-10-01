USE UniversityDW

go


If (object_id('vETLFTeachingHeld') is not null) Drop View vETLFTeachingHeld;
go

CREATE VIEW vETLFTeachingHeld
AS
SELECT DISTINCT
    t.[FK_Student] AS FK_StudentID,
    t.[FK_Teacher] AS FK_TeacherID,
    t.[FK_Course] AS FK_CourseID,
    CASE
        WHEN m.[StartYear] <= 2022 THEN (CAST((RAND(CHECKSUM(NEWID())) * (1325 - 1 + 1)) AS INT) + 1)
        ELSE (CAST((RAND(CHECKSUM(NEWID())) * (1590 - 1325 + 1)) AS INT) + 1325)
    END AS FK_DateID,
    ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS FK_TeachingDesID,
    t.Grade AS Grade,
    t.Points AS Points
FROM University.dbo.Teaching t
JOIN University.dbo.Course c ON t.FK_Course = c.CourseID
LEFT JOIN University.dbo.Major m ON c.FK_Major = m.MajorID;
go



MERGE INTO tempTeaching as TT
	USING vETLFTeachingHeld as ST
		ON TT.FK_StudentID = ST.FK_StudentID
		AND TT.FK_TeacherID = ST.FK_TeacherID
		AND TT.FK_CourseID = ST.FK_CourseID
		AND TT.FK_DateID = ST.FK_DateID
		AND TT.FK_TeachingDesID = ST.FK_TeachingDesID
		AND TT.Grade = ST.Grade
		AND TT.Points = ST.Points
			WHEN NOT MATCHED BY TARGET 
				AND NOT EXISTS (
					SELECT 1 FROM tempTeaching
					WHERE FK_StudentID = ST.FK_StudentID
					AND FK_TeacherID = ST.FK_TeacherID
					AND FK_CourseID = ST.FK_CourseID
					AND FK_DateID = ST.FK_DateID
					AND FK_TeachingDesID = ST.FK_TeachingDesID
					AND Grade = ST.Grade
					AND Points = ST.Points
				)
				THEN
					INSERT (FK_StudentID, FK_TeacherID, FK_CourseID, FK_DateID, FK_TeachingDesID, Grade, Points)
					Values (ST.FK_StudentID, ST.FK_TeacherID, ST.FK_CourseID, ST.FK_DateID, ST.FK_TeachingDesID, ST.Grade, ST.Points
					)
			WHEN Not Matched By Source
			Then
				DELETE
			;


UPDATE tempTeaching
SET 
    FK_StudentID = (SELECT StudentKey FROM DimStudent WHERE tempTeaching.FK_StudentID = DimStudent.StudentID),
    FK_TeacherID = (SELECT TeacherKey FROM DimTeacher WHERE tempTeaching.FK_TeacherID = DimTeacher.TeacherID),
	FK_CourseID = (SELECT CourseKey FROM DimCourse WHERE tempTeaching.FK_CourseID = DimCourse.CourseID)

MERGE INTO FTeachingHeld as TT
	USING tempTeaching as ST
		ON TT.FK_StudentID = ST.FK_StudentID
		AND TT.FK_TeacherID = ST.FK_TeacherID
		AND TT.FK_CourseID = ST.FK_CourseID
		AND TT.FK_DateID = ST.FK_DateID
		AND TT.FK_TeachingDesID = ST.FK_TeachingDesID
		AND TT.Grade = ST.Grade
		AND TT.Points = ST.Points
		WHEN NOT MATCHED BY TARGET 
				AND NOT EXISTS (
					SELECT 1 FROM FTeachingHeld
					WHERE FK_StudentID = ST.FK_StudentID
					AND FK_TeacherID = ST.FK_TeacherID
					AND FK_CourseID = ST.FK_CourseID
					AND FK_DateID = ST.FK_DateID
					AND FK_TeachingDesID = ST.FK_TeachingDesID
					AND Grade = ST.Grade
					AND Points = ST.Points
				)
				THEN
					INSERT (FK_StudentID, FK_TeacherID, FK_CourseID, FK_DateID, FK_TeachingDesID, Grade, Points)
					Values (ST.FK_StudentID, ST.FK_TeacherID, ST.FK_CourseID, ST.FK_DateID, ST.FK_TeachingDesID, ST.Grade, ST.Points
					)
			WHEN Not Matched By Source
			Then
				DELETE
			;
DROP VIEW vETLFTeachingHeld;
--SELECT * FROM vETLFTeachingHeld;
--SELECT * FROM tempStudying;

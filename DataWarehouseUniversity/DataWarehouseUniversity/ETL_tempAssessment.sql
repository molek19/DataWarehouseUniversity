USE UniversityDW

go

If (object_id('vETLFAssessment') is not null) Drop View vETLFAssessment;
go
CREATE VIEW vETLFAssessment
AS
SELECT
    A.CourseName as FK_CourseID,
    A.FK_Student as FK_StudentID,
    A.FK_Teacher FK_TeacherID,
	ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) as FK_AssessmentDesID,
	A.Course_assessment as Course_Assessment_Value,
    A.Teacher_assessment as Teacher_Assessment_Value,
    C.Attendance_rate as AttendanceRateConsultations
FROM University.dbo.Assessment A
JOIN University.dbo.Consultations C ON A.FK_Teacher=C.FK_Teacher;
go

MERGE INTO tempAssessment as TT
	USING vETLFAssessment as ST
		ON TT.FK_CourseID = ST.FK_CourseID
		AND TT.FK_StudentID = ST.FK_StudentID
		AND TT.FK_TeacherID = ST.FK_TeacherID
		AND TT.FK_AssessmentDesID = ST.FK_AssessmentDesID
		AND TT.Course_Assessment_Value = ST.Course_Assessment_Value
		AND TT.Techer_Assessment_Value = ST.Teacher_Assessment_Value
		AND TT.AttendenceRateConsultations = ST.AttendanceRateConsultations
			WHEN NOT MATCHED BY TARGET 
			AND NOT EXISTS (
				SELECT 1 FROM tempAssessment
				WHERE FK_CourseID = ST.FK_CourseID
				AND FK_StudentID = ST.FK_StudentID
				AND FK_TeacherID = ST.FK_TeacherID
				AND FK_AssessmentDesID = ST.FK_AssessmentDesID
				AND Course_Assessment_Value = ST.Course_Assessment_Value
				AND Teacher_Assessment_Value = ST.Teacher_Assessment_Value
				AND AttendanceRateConsultations = ST.AttendanceRateConsultations
			)
			THEN
				INSERT (FK_CourseID, FK_StudentID, FK_TeacherID, FK_AssessmentDesID, Course_Assessment_Value, Techer_Assessment_Value, AttendenceRateConsultations)
				VALUES (ST.FK_CourseID, ST.FK_StudentID, ST.FK_TeacherID, ST.FK_AssessmentDesID, ST.Course_Assessment_Value, ST.Teacher_Assessment_Value, ST.AttendanceRateConsultations)
			WHEN Not Matched By Source
			Then
				DELETE
				;
UPDATE tempAssessment
SET 
    FK_CourseID = (SELECT CourseKey FROM DimCourse WHERE tempAssessment.FK_CourseID = DimCourse.CourseID),
    FK_TeacherID = (SELECT TeacherKey FROM DimTeacher WHERE tempAssessment.FK_TeacherID = DimTeacher.TeacherID),
    FK_StudentID = (SELECT StudentKey FROM DimStudent WHERE tempAssessment.FK_StudentID = DimStudent.StudentID)


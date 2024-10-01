USE UniversityDW
GO

MERGE INTO FAssessment as TT
	USING tempAssessment as ST
		ON TT.FK_CourseID = ST.FK_CourseID
		AND TT.FK_StudentID = ST.FK_StudentID
		AND TT.FK_TeacherID = ST.FK_TeacherID
		AND TT.FK_AssessmentDesID = ST.FK_AssessmentDesID
		AND TT.Course_Assessment_Value = ST.Course_Assessment_Value
		AND TT.Techer_Assessment_Value = ST.Techer_Assessment_Value
		AND TT.AttendenceRateConsultations = ST.AttendenceRateConsultations
			WHEN Not Matched BY TARGET
			AND NOT EXISTS (
				SELECT 1
				FROM FAssessment
				WHERE FK_CourseID = ST.FK_CourseID
				AND FK_StudentID = ST.FK_StudentID
				AND FK_TeacherID = ST.FK_TeacherID
				AND FK_AssessmentDesID = ST.FK_AssessmentDesID
				AND Course_Assessment_Value = ST.Course_Assessment_Value
				AND Techer_Assessment_Value = ST.Techer_Assessment_Value
				AND AttendenceRateConsultations = ST.AttendenceRateConsultations
			)
			THEN
				INSERT (FK_CourseID, FK_StudentID, FK_TeacherID, FK_AssessmentDesID, Course_Assessment_Value, Techer_Assessment_Value, AttendenceRateConsultations)
				Values (ST.FK_CourseID, ST.FK_StudentID, ST.FK_TeacherID, ST.FK_AssessmentDesID, ST.Course_Assessment_Value, ST.Techer_Assessment_Value, ST.AttendenceRateConsultations)
			WHEN Not Matched By Source
			Then
				DELETE
			;

Drop View vETLFAssessment;

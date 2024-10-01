USE UniversityDW

go

INSERT INTO DimTeacher(TeacherID, Name, Surname, ScientificDegree, isCurrent)
VALUES
('0230ab8c', 'Melissa', 'Green', 'Doctor', '1' ),
('03df4a32', 'Joy', 'Anderson', 'Doctor', '1'),
('57849a7c', 'Steve', 'Price', 'Master', '1');

UPDATE DimTeacher
SET
	isCurrent = '0' WHERE TeacherID = '0230ab8c' AND ScientificDegree = 'Master';

UPDATE DimTeacher
SET
	isCurrent = '0' WHERE TeacherID = '03df4a32' AND ScientificDegree = 'Master';

UPDATE DimTeacher
SET
	isCurrent = '0' WHERE TeacherID = '57849a7c' AND ScientificDegree = 'Doctor';

UPDATE DimStudent
SET isActive = 'no'
FROM DimStudent s
INNER JOIN FStudying t ON s.StudentKey = t.FK_StudentID
INNER JOIN DimStudyingDescription d ON t.FK_Studying_DesID = d.StudyingDesID
WHERE d.Graduated = 'yes';

UPDATE FTeachingHeld
SET FK_TeacherID = '551'
WHERE FK_TeacherID = '1';

UPDATE FTeachingHeld
SET FK_TeacherID = '552'
WHERE FK_TeacherID = '5';

UPDATE FTeachingHeld
SET FK_TeacherID = '553'
WHERE FK_TeacherID = '154';

UPDATE FAssessment
SET FK_TeacherID = '551'
WHERE FK_TeacherID = '1';

UPDATE FAssessment
SET FK_TeacherID = '552'
WHERE FK_TeacherID = '5';

UPDATE FAssessment
SET FK_TeacherID = '553'
WHERE FK_TeacherID = '154';


DROP TABLE tempAssessment;
DROP TABLE tempStudying;
DROP TABLE tempTeaching;
DROP TRIGGER trg_InsertMonthName;




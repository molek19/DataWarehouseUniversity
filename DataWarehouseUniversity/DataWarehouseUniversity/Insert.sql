USE UniversityDW

GO

INSERT INTO DimTeacher(TeacherID, Name, Surname, ScientificDegree, isCurrent)
VALUES
('869eab51', 'Nancy', 'Peterson', 'Bachelor', 'Yes' ),
('7c4ea33d', 'Eugene', 'Norris', 'Bachelor', 'No');

INSERT INTO DimStudent(StudentID, Name, Surname, City, ECTS_debit_range, isActive,Math_result_range, Physics_result_range, Polish_result_range, English_result_range, First_choice, Second_choice, Recruitment_points_range)
VALUES
('a4360ef0', 'Marcus', 'Castillo','Andersonstad', 'No', 'Yes', 'Mid', 'Mid', 'Low', 'Mid', 'M72020', 'M72020', 'High' ),
('72dc3b3c', 'Connie', 'Thomas', 'Brookschester', 'Low', 'Yes', 'High', 'Low', 'Mid', 'High', 'M152018', 'M152018', 'High');

INSERT INTO DimMajor(MajorID, Name, DegreeName, Faculty)
VALUES
('M12018', 'Mechanical Engineering', 'Engineer', 'Faculty of Mechanical Engineering'),
('M22018', 'Electrical Engineering', 'Engineer', 'Faculty of Electrical Engineering');

INSERT INTO DimCourse(CourseID, Name, Semester, ECTS)
VALUES
('C1VIB2018', 'Vibration and Control', 5, 6),
('C1ENG2018', 'Engineering Optimization', 6, 8);

INSERT INTO DimAssessment_Description(AssessmentType)
VALUES
('very bad'),
('mediocre');

INSERT INTO DimTeaching_Description(Type, isCompleted)
VALUES
('stationary', 'Yes'),
('hybrid', 'No');

INSERT INTO DimStudyingDescription(Graduated, WasFirstChoice)
VALUES
('No', 'No'),
('No', 'Yes');

INSERT INTO DimDate(Date,SemesterNo,Term)
VALUES
('05-05-2022',4,'summer'),
('04-12-2022',5,'winter');

INSERT INTO FTeachingHeld(FK_StudentID, FK_TeacherID, FK_CourseID, FK_DateID, FK_TeachingDesID, Grade, Points)
VALUES
(1, 1, 1, 1, 1, 5, 97),
(2, 2, 2, 2, 2, 3, 52);

INSERT INTO FStudying(FK_MajorID, FK_StudentID, FK_DateID)
VALUES
(1, 1, 1),
(2, 2, 2);

INSERT INTO FAssessment(FK_CourseID, FK_StudentID, FK_TeacherID, FK_AssessmentDesID, Course_Assessment_Value, Techer_Assessment_Value, AttendenceRateConsultations)
VALUES
(1, 1, 1, 1, 3, 5, 80),
(2, 2, 2, 2, 4, 1, 25);

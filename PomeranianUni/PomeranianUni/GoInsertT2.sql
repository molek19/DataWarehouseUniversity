USE University;
BULK INSERT dbo.Major FROM 'C:\Users\48668\OneDrive\Pulpit\Data Engeneering\Fourth Semester\Data Warehouses\Task2\gajdowskii3\major_data_T2.bulk' WITH (FIELDTERMINATOR='|');
BULK INSERT dbo.Course FROM 'C:\Users\48668\OneDrive\Pulpit\Data Engeneering\Fourth Semester\Data Warehouses\Task2\gajdowskii3\course_data_T2.bulk' WITH (FIELDTERMINATOR='|');
BULK INSERT dbo.Teacher FROM 'C:\Users\48668\OneDrive\Pulpit\Data Engeneering\Fourth Semester\Data Warehouses\Task2\gajdowskii3\teacher_data_T2.bulk' WITH (FIELDTERMINATOR='|');
BULK INSERT dbo.Student FROM 'C:\Users\48668\OneDrive\Pulpit\Data Engeneering\Fourth Semester\Data Warehouses\Task2\gajdowskii3\student_data_T2.bulk' WITH (FIELDTERMINATOR='|');
BULK INSERT dbo.Teaching FROM 'C:\Users\48668\OneDrive\Pulpit\Data Engeneering\Fourth Semester\Data Warehouses\Task2\gajdowskii3\teaching_data_T2.bulk' WITH (FIELDTERMINATOR='|');
BULK INSERT dbo.Recruitment FROM 'C:\Users\48668\OneDrive\Pulpit\Data Engeneering\Fourth Semester\Data Warehouses\Task2\gajdowskii3\excel_data_recruitment_T2.csv' WITH (FIELDTERMINATOR='\t',ROWTERMINATOR = '\n');
BULK INSERT dbo.Consultations FROM 'C:\Users\48668\OneDrive\Pulpit\Data Engeneering\Fourth Semester\Data Warehouses\Task2\gajdowskii3\excel_data_consultation_T2.csv' WITH (FIELDTERMINATOR='\t',ROWTERMINATOR = '\n');
BULK INSERT dbo.Assessment FROM 'C:\Users\48668\OneDrive\Pulpit\Data Engeneering\Fourth Semester\Data Warehouses\Task2\gajdowskii3\excel_data_survey_T2.csv' WITH (FIELDTERMINATOR='\t',ROWTERMINATOR = '\n');



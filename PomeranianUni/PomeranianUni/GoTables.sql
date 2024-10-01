--CREATE DATABASE University
--Go

USE University
Go

create table Faculty(
	FacultyID varchar(9) primary key,
	Name varchar(50) not null
)
Go

create table Major(
	MajorID varchar(10) primary key,
	Name varchar(50) not null,
	DegreeName varchar(9) not null,
	StartYear int not null,
	FK_Faculty varchar(9) foreign key references Faculty
)
Go

create table Course(
	CourseID varchar(10) primary key,
	Name varchar(50) not null,
	Semester integer,
	ECTS integer not null,
	FK_Major varchar(10) foreign key references Major
)
Go


create table Teacher(
	TeacherID varchar(10) primary key,
	Name varchar(20) not null,
	Surname varchar(30) not null,
	ScientificDegree varchar(9)
)
Go


create table Student(
	StudentID varchar(10) primary key,
	Name varchar(30) not null,	
	Surname varchar(30) not null,
	City varchar(50),
	ECTS_debit integer not null,
	FK_Major varchar(10) foreign key references Major
)
Go


create table Publications(
	PublicationID varchar(10) primary key,
	Description varchar(100) not null,
	DateOfPublicity varchar(15) not null,
	Status varchar(9),
	FK_Teacher varchar(10) foreign key references Teacher,
	FK_Faculty varchar(9) foreign key references Faculty
)
Go


create table Teaching(
	FK_Course varchar(10) foreign key references Course,
	FK_Student varchar(10) foreign key references Student,
	FK_Teacher varchar(10) foreign key references Teacher,
	Hours datetime,
	Grade float,
	IsCompleted integer,
	Points integer,
	Type varchar(10),
	primary key ("FK_Course", "FK_Student","FK_Teacher")
)
Go

create table Recruitment(
	FK_Student varchar(10) foreign key references Student,
	City varchar(50),
	Math_result int,
	Physics_result int,
	Polish_result int,
	English_result int,
	First_choice varchar(50),
	Second_choice varchar (50),
	Recruitment_points int
)

create table Consultations(
	CourseName varchar(50),
	FK_Teacher varchar(10) foreign key references Teacher,
	FK_Student varchar(10) foreign key references Student,
	Attendance_rate int
)

create table Assessment(
	FK_Student varchar(10) foreign key references Student,
	CourseName varchar(50),
	FK_Teacher varchar(10) foreign key references Teacher,
	Teacher_assessment int,
	Course_assessment int,
	MajorName varchar(50)
)




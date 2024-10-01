USE UniversityDW
--1, 266, 531, 796
go

If (object_id('vETLFStudying') is not null) Drop View vETLFStudying;
go
CREATE VIEW vETLFStudying
AS
WITH RandomDates1 AS (
    SELECT
        CASE 
            WHEN ABS(CHECKSUM(NEWID())) % 6 = 0 THEN 1   -- 25% szansy na rok 2018
            WHEN ABS(CHECKSUM(NEWID())) % 6 = 1 THEN 266    -- 25% szansy na rok 2019
            WHEN ABS(CHECKSUM(NEWID())) % 6 = 2 THEN 531   -- 25% szansy na rok 2020
			WHEN ABS(CHECKSUM(NEWID())) % 6 = 3 THEN 796
			WHEN ABS(CHECKSUM(NEWID())) % 6 = 4 THEN 1061
            ELSE 1326                                       -- Pozosta³e 25% szansy na rok 2021
        END as RandomDate1ID
)
SELECT DISTINCT
    s.[FK_Major] as FK_MajorID,
    s.[StudentID] as FK_StudentID,
    CASE
        WHEN m.[StartYear] <= 2022 THEN rd.RandomDate1ID  -- Jeœli rok rozpoczêcia <= 2022, u¿yj RandomDateID
        ELSE 1061  -- W przeciwnym razie, u¿yj innej wartoœci (tutaj 999, ale mo¿esz zmieniæ na odpowiedni¹)
    END as FK_DateID,
    ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) as FK_Studying_DesID
FROM 
    University.dbo.Student s
    CROSS JOIN RandomDates1 rd
    LEFT JOIN University.dbo.Major m ON s.FK_Major = m.MajorID;

go



MERGE INTO tempStudying as TT
	USING vETLFStudying as ST
		ON TT.FK_MajorID = ST.FK_MajorID
		AND TT.FK_StudentID = ST.FK_StudentID
		AND TT.FK_DateID = ST.FK_DateID
		AND TT.FK_Studying_DesID = ST.FK_Studying_DesID
			WHEN Not Matched BY TARGET
			AND NOT EXISTS (
				SELECT 1
				FROM tempStudying
				WHERE FK_MajorID = ST.FK_MajorID
				AND FK_StudentID = ST.FK_StudentID
				AND FK_DateID = ST.FK_DateID
				AND FK_Studying_DesID = ST.FK_Studying_DesID
			    )
				THEN
					INSERT (FK_MajorID, FK_StudentID, FK_DateID, FK_Studying_DesID)
					Values (ST.FK_MajorID, ST.FK_StudentID, ST.FK_DateID, ST.FK_Studying_DesID)
				WHEN Not Matched By Source
				Then
					DELETE
				;


UPDATE tempStudying
SET 
    FK_MajorID = (SELECT MajorKey FROM DimMajor WHERE tempStudying.FK_MajorID = DimMajor.MajorID),
    FK_StudentID = (SELECT StudentKey FROM DimStudent WHERE tempStudying.FK_StudentID = DimStudent.StudentID)

MERGE INTO FStudying as TT
	USING tempStudying as ST
		ON TT.FK_MajorID = ST.FK_MajorID
		AND TT.FK_StudentID = ST.FK_StudentID
		AND TT.FK_DateID = ST.FK_DateID
		AND TT.FK_Studying_DesID = ST.FK_Studying_DesID
			WHEN Not Matched BY TARGET
			AND NOT EXISTS (
				SELECT 1
				FROM FStudying
				WHERE FK_MajorID = ST.FK_MajorID
				AND FK_StudentID = ST.FK_StudentID
				AND FK_DateID = ST.FK_DateID
				AND FK_Studying_DesID = ST.FK_Studying_DesID
			    )
				THEN
					INSERT (FK_MajorID, FK_StudentID, FK_DateID, FK_Studying_DesID)
					Values (ST.FK_MajorID, ST.FK_StudentID, ST.FK_DateID, ST.FK_Studying_DesID)
				WHEN Not Matched By Source
				Then
					DELETE
				;
DROP VIEW vETLFStudying;
--SELECT * FROM vETLFStudying;
--SELECT * FROM tempStudying;

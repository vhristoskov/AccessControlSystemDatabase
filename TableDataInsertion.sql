insert into Department
values 
('iOS Developing'),
('Quality Assurance'),
('Finance'),
('.NET Developing'),
('Sales'),
('Marketing'),
('Document Control'),
('Information Services'),
('Java Developing'),
('Android Developing')

-- =============================================
-- Fill In @placeName  = Entrance Door 
-- for every one of departments
-- with help of CURSOR statement
-- =============================================

DECLARE @departmName varchar(50),
		@floorNum int

--Creating the cursor 
DECLARE Departments CURSOR FOR
SELECT name from Department

SET @floorNum = 1

OPEN Departments 
FETCH Departments INTO @departmName

WHILE @@FETCH_STATUS = 0
BEGIN
	exec [dbo].addPlaceToDepartment
		@departmentName = @departmName,
		@placeCity = 'Sofia',
		@placeName = 'Entrance Door',
		@placeStreet = 'Malinova Dolina, 12',
		@placeBuildingName = 'Mall Malinka',
		@placeBuldingFloor = @floorNum
	
	SET @floorNum = @floorNum + 1

	FETCH Departments INTO @departmName
END

CLOSE Departments
DEALLOCATE Departments


select * from Address


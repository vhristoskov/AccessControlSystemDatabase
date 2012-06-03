create table Department
(
	departmID smallint identity  CONSTRAINT dep_PK PRIMARY KEY,
	name varchar(50) not null

);

create table Address
(
	addrID int identity CONSTRAINT addr_PK PRIMARY KEY ,
	city varchar(30) CONSTRAINT city_valid CHECK (city like '%[^0-9]%') not null,
	street varchar(40) not null,
	buildingName varchar(15),
	[floor] tinyint CONSTRAINT floor_valid CHECK([floor] not like '%[^0-9]%') not null,
	postcode varchar(15) not null
);

create table Employee
(

	egn char(10) CONSTRAINT emp_PK PRIMARY KEY not null,
	name varchar(50) not null,
	birthDate date not null,
	hireDate date not null,
	gender char(1) 
		CONSTRAINT gender_valid CHECK(gender in ('F', 'f', 'M', 'm')),
	position varchar(30)
		CONSTRAINT position_valid CHECK(position like '%[^0-9]%') not null,
	departmID smallint
		CONSTRAINT empl_dep_FK REFERENCES Department(departmID) not null,
	addrID INT 
		CONSTRAINT empl_add_FK REFERENCES Address(addrID) not null,
	CONSTRAINT hireDate_valid CHECK(datediff(year, birthdate, hireDate) >= 18) 
	
	/* Datediff returns the count (signed integer)
	 * of the specified datepart boundaries crossed between the 
	 * specified startdate and enddate.
	 * In this case returns count ot years
	 * between birthDate and hireDate. If the hireDate is < birthDate then 
	 * datediff will return negative number
	 */
);

create table EmployeeContact
(
	mobilePhone varchar(15) CONSTRAINT empCont_PK PRIMARY KEY ,
	email varchar(50) CONSTRAINT email_valid CHECK (email like '%_@%_.@_'),
	skype varchar(40),
	employeeID char(10) CONSTRAINT empCont_FK REFERENCES Employee(egn) not null,
	CONSTRAINT valid_mobPhone CHECK(mobilePhone not like '%[^0-9]%')
);

create table Place
(
	placeID int identity PRIMARY KEY,
	name varchar(50) 
		CONSTRAINT name_valid CHECK(name like '%[^0-9]%') not null,
	addrID int 
		CONSTRAINT place_addr_FK REFERENCES Address(addrID) not null,
	departmID smallint 
		
);

create table AccessPermission
(
	accessPermID int identity PRIMARY KEY,
	placeID int 
		CONSTRAINT accPerm_place_FK REFERENCES Place(placeID) not null,
	employeeID char(10) 
		CONSTRAINT accPerm_empl_FK REFERENCES Employee(egn) not null,
	code char(15) not null
);

create table AuditAccess
(
	auditID int identity PRIMARY KEY,
	accessPermID int 
		CONSTRAINT auditAcc_accPerm_FK 
		REFERENCES AccessPermission(accessPermID) not null,
	enterTime datetime,
	exitTime datetime,
	CONSTRAINT enter_exit_valid CHECK(enterTime<exitTime)
);


-- Trigger Ideas 
/*
	- check validity of an EGN
	
*/

--Procedure/Function ideas
/*
	- procedure personEnter(person, place), which fills 
	in the entrance date and time for a perosn in AuditAccess
	- procedure personExit(person, place), which fills 
	in the exit date and time for a perosn in AuditAccess
	- we must furst check if the person can access this place
*/
-- =============================================
-- STORED FUNCTIONS
-- =============================================

-- =============================================
-- Author: Victor Hristoskov
-- Description:	Get departmentID by department name
-- =============================================
CREATE FUNCTION getDepartmIDByName
(
	@departmName varchar(50)
)
RETURNS int
AS
BEGIN
	DECLARE @departmID int

	SET @departmID = (select departmID from Department
						where name = @departmName)

	RETURN @departmID
END
GO

-- =============================================
-- Author: Victor Hristoskov
-- Description:	Add new address if it not exists and return its ID
-- if the address exists then only return its ID
-- =============================================

CREATE PROCEDURE addAddressIfNotExist
	@placeCity varchar(30), 
	@placeStreet varchar(40),
	@placePostcode varchar(15) = '',
	@placeBuildingName varchar(15) = '' ,
	@placeBuldingFloor tinyint = 0
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE

	SET NOCOUNT ON;

	DECLARE @addrID int

	BEGIN TRY
		BEGIN TRAN T1

		PRINT 'Searching for address...'

		-- Checking is the addres with definite city, street and so on
		--  exist
		SET @addrID = (SELECT addrID FROM Address
						WHERE city = @placeCity
							and street = @placeStreet
							and buildingName = @placeBuildingName
							and [floor] = @placeBuldingFloor
							and postcode = @placePostcode)

		IF ( @addrID is not null )
		BEGIN 
		-- The address is found
			PRINT 'Adress exist with ID:' + cast(@addrID as varchar)
			COMMIT TRAN T1
			RETURN @addrID
		END

		ELSE
		BEGIN	
			-- if the addres doesn't exist then insert it
			PRINT 'Address not found. Inserting...'

			INSERT INTO Address 
			values(@placeCity, @placeStreet,
			 @placeBuildingName, @placeBuldingFloor, @placePostcode)
			PRINT 'Address is inserted with ID: ' + cast(@@IDENTITY as varchar)

			COMMIT TRAN T1
			RETURN @@IDENTITY
		END
	END TRY

	BEGIN CATCH	

		ROLLBACK
		PRINT 'Something wrong happend'
		PRINT ERROR_MESSAGE()

	END CATCH
END	
GO


-- =============================================
-- STORED PROCEDURES
-- =============================================

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Victor Hristoskov
-- Description:	Add a place to a department
-- =============================================
ALTER PROCEDURE addPlaceToDepartment
	@departmentName varchar(50),
	@placeName varchar(50),
	@placeCity varchar(30),
	@placeStreet varchar(40),
	@placePostcode varchar(15) = '',
	@placeBuildingName varchar(15) = '',
	@placeBuldingFloor tinyint = 0
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE

	DECLARE @departmID int,
			@addrID int
	
	SET NOCOUNT ON;

	BEGIN TRY
		--BEGIN TRAN T1
		
		PRINT 'Obtaining the departmarment ID...'		
		SET @departmID = dbo.getDepartmIDByName(@departmentName)

		PRINT 'Obtaining place address ID...'
		EXEC @addrID = [dbo].addAddressIfNotExist
			@placeCity,
			@placeStreet,
			@placePostcode,
			@placeBuildingName,
			@placeBuldingFloor 

		PRINT 'Place Addres ID obtained: ' + cast(@addrID as varchar)
		
		IF (@departmID > 0) 
		BEGIN 
			-- Department exist
			PRINT 'Department id obtained: ' + cast(@departmID as varchar)

			PRINT 'Inserting place details...'
			INSERT INTO Place 
			values (@placeName, @addrID, @departmID)	
			--COMMIT TRAN T1		
		END

		ELSE
		BEGIN 

			PRINT 'Department with that name does not exist!'
			--COMMIT TRAN T1
			RETURN 0
		END
	END TRY
	
	BEGIN CATCH
		--ROLLBACK
		PRINT 'Something wrong happend!'
		PRINT ERROR_MESSAGE()
	END CATCH
END
GO






-- COMMENTS:
--========================================================
-- Kogato iskame da vzemem dadeno mqsto trqbva osven imeto mu da
-- podadem i departamenta, za6toto v 2 razli4ni departamenta moje da ima 
-- mesta s ednakvi imena


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author: Victor Hristoskov
-- Description:	Add a place to a department
-- =============================================
CREATE PROCEDURE addPlaceToDepartment 
	@deparmentName varchar(50),
	@placeName varchar(50),
	@placeCity varchar(30), 
	@placeStreet varchar(40),
	@placePostcode varchar(15),
	@placeBuildingName varchar(15),
	@placeBuldingFloor tinyint
AS
BEGIN

	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT <@Param1, sysname, @p1>, <@Param2, sysname, @p2>
END
GO


-- =============================================
-- Author: Victor Hristoskov
-- Description:	Add new address if it not exists and return its ID
-- if the address exists then only return its ID
-- =============================================

ALTER PROCEDURE addAddressIfNotExist
	@placeCity varchar(30), 
	@placeStreet varchar(40),
	@placePostcode varchar(15) = NULL,
	@placeBuildingName varchar(15) = NULL ,
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




-- COMMENTS:
--========================================================
-- Kogato iskame da vzemem dadeno mqsto trqbva osven imeto mu da
-- podadem i departamenta, za6toto v 2 razli4ni departamenta moje da ima 
-- mesta s ednakvi imena


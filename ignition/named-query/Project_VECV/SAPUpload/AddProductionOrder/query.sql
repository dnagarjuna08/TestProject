IF EXISTS(SELECT 1 FROM M_BOM WHERE M_BOMNumber = :Material_Number)
BEGIN
    DECLARE @M_BOM_Id INT;
    
    -- Retrieve the M_BOM_Id for the given Material Number
    SELECT @M_BOM_Id = M_BOM_Id FROM M_BOM WHERE M_BOMNumber = :Material_Number;

    -- Check if the Production Order already exists for the given Order Number and BOM ID
    IF EXISTS(SELECT 1 FROM PRODUCTION_ORDER WHERE M_BOM_Id = @M_BOM_Id AND order_number = :Order_Number)
    BEGIN
        -- If the Production Order exists, update the ModifiedDate
        UPDATE PRODUCTION_ORDER SET ModifiedDate = GETDATE() WHERE M_BOM_Id = @M_BOM_Id;
        SELECT 1; -- Indicate success
    END
    ELSE
    BEGIN
        DECLARE @PSN INT;
        
        -- Calculate the next PSN value based on the maximum existing PSN
        SELECT @PSN = MAX(psn) FROM PRODUCTION_ORDER;
        SET @PSN = CASE WHEN @PSN IS NULL THEN 1 ELSE @PSN + 1 END;

        -- Insert a new Production Order record
        INSERT INTO PRODUCTION_ORDER (
            order_number, order_category, OrderStatusid, is_active, is_transferred, plant_id, ready_to_purge,
            M_BOM_Id, booked_time, hold_time, month_code, planned_start_time, planned_end_time, psn, quantity,
            special_instruction, release_time, start_time, complete_time, year_code, is_edited, Createdby, 
            CreatedOn, ModifiedBy, ModifiedDate, MST_Area_Id
        )
        VALUES (
            :Order_Number, :Order_Category, 1, 1, 0, 1, 0, @M_BOM_Id, NULL, NULL, NULL, :Planned_Start_Time,
            :Planned_End_Time, @PSN, NULL, NULL, NULL, NULL, NULL, NULL, 0, 1, GETDATE(), NULL, NULL, :AreaId
        );

        SELECT 1; -- Indicate success
	END
END
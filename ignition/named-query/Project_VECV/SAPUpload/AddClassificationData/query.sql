DECLARE @M_BOM_Id INT;

BEGIN
    SELECT @M_BOM_Id = M_BOM_Id FROM M_BOM WITH(NOLOCK) WHERE M_BOMNumber=:BOMNumber;

    -- Check if a record already exists in ClassificationData for this BOM ID
    IF EXISTS(SELECT 1 FROM ClassificationData WHERE M_BOM_Id=@M_BOM_Id)
    BEGIN
        -- If the record exists, update the ModifiedDate
        UPDATE ClassificationData 
        SET ModifiedDate = GETDATE() 
        WHERE M_BOM_Id = @M_BOM_Id;

        -- Mark the BOM as classified by setting IsClassification to 1
        UPDATE M_BOM 
        SET IsClassification = 1 
        WHERE M_BOM_Id = @M_BOM_Id;
    END
    ELSE
    BEGIN
        -- If the record does not exist, insert a new record into ClassificationData
        INSERT INTO ClassificationData(ModelRange, PlantCode, GearRation, M_BOM_Id, Createdby, CreatedOn, ModifiedBy, ModifiedDate, IsActive, Mst_Area_Id)
        VALUES(:MODEL_RANGE, :MFG_PLANT_CODE, :GEAR_RATIO, @M_BOM_Id, 1, GETDATE(), NULL, NULL, 1, :AreaId);

        -- Mark the BOM as classified by setting IsClassification to 1
        UPDATE M_BOM 
        SET IsClassification = 1 
        WHERE M_BOM_Id = @M_BOM_Id;
    END
END
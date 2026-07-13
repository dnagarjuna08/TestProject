DECLARE @PlantId INT;

SET @PlantId = (SELECT MST_Plant_Id FROM MST_Plant WITH(NOLOCK) WHERE plantcode = :plantCode);

-- Check if a BOM record already exists for the provided BOM number
IF (EXISTS(SELECT 1 FROM M_BOM WHERE M_BOMNumber = :M_BOMNumber))
BEGIN
    -- If the BOM record exists, update it with the provided details
    UPDATE M_BOM 
    SET 
        M_BOMType = :M_BOMType,
        M_BOMVersion = :M_BOMVersion,
        Description = :Description,
        UOM = :UOM,
        Plant_Id = @PlantId,
        ModifiedOn = GETDATE() -- Set the modified timestamp to the current date/time
    WHERE 
        M_BOMNumber = :M_BOMNumber;
END
ELSE
BEGIN
    -- If the BOM record does not exist, insert a new record with the provided details
    INSERT INTO M_BOM (M_BOMNumber, M_BOMType, M_BOMVersion, Description, UOM, Plant_Id, Mst_Area_Id)
    VALUES (:M_BOMNumber, :M_BOMType, :M_BOMVersion, :Description, :UOM, @PlantId, :AreaId);
END
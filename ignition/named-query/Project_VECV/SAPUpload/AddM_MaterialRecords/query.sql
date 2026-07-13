DECLARE @M_BOM_Id INT,
		@Plant_Id INT;
		
SELECT @M_BOM_Id = M_BOM_Id, @Plant_Id = Plant_Id 
FROM M_BOM WITH(NOLOCK) 
WHERE M_BOMNumber = :M_BOMNumber;

IF (EXISTS (SELECT 1 FROM M_Material WHERE M_BOM_Id = @M_BOM_Id AND M_MaterialNumber = :M_MaterialNumber))
    BEGIN
        -- If the material exists, update its ModifiedOn timestamp
        UPDATE M_Material 
        SET ModifiedOn = GETDATE() 
        WHERE M_BOM_Id = @M_BOM_Id AND M_MaterialNumber = :M_MaterialNumber;
    END
ELSE
    BEGIN
        -- If the material does not exist, insert a new record
        INSERT INTO M_Material VALUES (@M_BOM_Id, :M_MaterialNumber, :M_BOMType, :M_BOMVersion, :Description, :UOM, @Plant_Id, 1, 0, 0, 0, NULL, GETDATE(), NULL, NULL, 0, :Mst_Area_Id);
    END;
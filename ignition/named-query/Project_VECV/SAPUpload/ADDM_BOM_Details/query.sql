DECLARE @M_Material_Id INT, @M_BOM_Id INT;

-- Check if the BOM exists in the M_BOM table
IF EXISTS(SELECT 1 FROM M_BOM WITH(NOLOCK) WHERE M_BOMNumber=:BOMNumber)
BEGIN
    -- Retrieve the BOM ID for the given BOM name
    SELECT @M_BOM_Id = M_BOM_Id FROM M_BOM WITH(NOLOCK) WHERE M_BOMNumber=:BOMNumber;

    -- Check if the material already exists in M_BOM_Details
    IF (EXISTS (SELECT 1 FROM M_BOM_Details WITH(NOLOCK) WHERE M_BOM_Id=@M_BOM_Id AND M_Material_Id = (SELECT TOP 1 M.M_Material_Id FROM M_Material M WHERE M.M_BOM_Id=@M_BOM_Id AND M.M_MaterialNumber=:Material_Number)))
		BEGIN
			-- Update the ModifiedOn timestamp if the material exists
			UPDATE M_BOM_Details 
			SET ModifiedOn = GETDATE() 
			WHERE M_BOM_Id = @M_BOM_Id 
			AND M_Material_Id = (SELECT TOP 1 M.M_Material_Id FROM M_Material M WHERE M.M_BOM_Id=@M_BOM_Id AND M.M_MaterialNumber=:Material_Number);
		END
    ELSE
		BEGIN
			-- Insert a new record into M_BOM_Details if the material does not exist
			INSERT INTO M_BOM_Details
			SELECT M.M_BOM_Id, M.M_Material_Id, :Quantity, NULL, NULL, 1, NULL, GETDATE(), NULL, NULL, :Mst_Area_Id 
			FROM M_Material M 
			WHERE M.M_BOM_Id=@M_BOM_Id AND M.M_MaterialNumber=:Material_Number;
		END
END
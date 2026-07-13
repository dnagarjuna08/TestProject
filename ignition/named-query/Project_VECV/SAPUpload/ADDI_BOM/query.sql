DECLARE @PlantCode INT,@PlantID INT;

SELECT @PlantID=Plant_Id FROM M_BOM WITH(NOLOCK) WHERE M_BOMNumber=:BOMNumber;
select @PlantCode=PlantCode from MST_Plant where MST_Plant_Id=@PlantID


INSERT INTO I_BOM (Bom_Name,Category,Material_Number,Quantity,IsActive,CreatedOn,Mst_Area_Id)
VALUES (:BOMNumber,:Category,:Material_Number,:Quantity,0,GETDATE(),:Mst_Area_Id)

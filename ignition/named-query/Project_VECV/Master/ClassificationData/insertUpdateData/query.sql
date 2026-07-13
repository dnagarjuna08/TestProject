declare 
@modelRange nvarchar(50) = :modelRange,
@areaName int = :areaName,
@IsActive int = :IsActive,
@createdBy int = :createdBy,
@bomId int = :bomId,
@plant nvarchar(50) = :plant,
@Id int = :Id,
@gearRatio nvarchar(50) = :gearRatio 



BEGIN

SET NOCOUNT ON;

IF @Id = 0
BEGIN
	IF EXISTS(SELECT 1 FROM ClassificationData WHERE M_BOM_Id = @bomId and IsActive=1)
		BEGIN
			SELECT 0 AS Result
		END
	ELSE
		BEGIN
			INSERT INTO ClassificationData (M_BOM_Id, Mst_Area_Id, ModelRange, CreatedBy,PlantCode,GearRation,IsActive)
			VALUES (@bomId, @areaName, @modelRange, @createdBy, @plant,@gearRatio,@IsActive)
			SELECT 1 AS Result
		END
	END
ELSE
BEGIN
	IF EXISTS(SELECT 1 FROM ClassificationData WHERE M_BOM_Id = @bomId and IsActive=1 and  ClassficationId !=  @Id)
		BEGIN
			SELECT 0 AS Result
		END
	ELSE
		BEGIN
			UPDATE ClassificationData 
			SET 
				M_BOM_Id = @bomId,
				Mst_Area_Id = @areaName,
				ModelRange = @modelRange,
				ModifiedDate = GETDATE(),
				ModifiedBy = @createdBy,
				PlantCode = @plant,
				GearRation = @gearRatio,
				IsActive= @IsActive

			WHERE 
				ClassficationId = @Id
			SELECT 1 AS result
		END
	END
END
-- Declare input variables
DECLARE @BomNumber NVARCHAR(50) = :BOM,
        @ModelName NVARCHAR(100) = :Model,
        @AreaName NVARCHAR(100) = :Area,
        @LineName NVARCHAR(100) = :Line,
        @WorkStationName NVARCHAR(100) = :WorkStation,
        @Item NVARCHAR(100) = :Item,
        @Sequence INT = :Sequence,
        @CreatedBy NVARCHAR(100) = :CreatedBy;

-- Declare output variables with initial value as NULL
DECLARE @BomId INT = NULL,
        @ModelId INT = NULL,
        @AreaId INT = NULL,
        @LineId INT = NULL,
        @WorkStationId INT = NULL;

-- Dynamically assign values to variables
SELECT @BomId = M_BOM_Id
FROM M_BOM
WHERE M_BOMNumber = @BomNumber
  AND IsActive = 1
  AND IsDeleted = 0;

SELECT @ModelId = MST_Model_Id
FROM MST_Model
WHERE IsActive = 1
  AND IsDeleted = 0
  AND ModelName = @ModelName;

SELECT @AreaId = MST_Area_Id
FROM MST_Area
WHERE IsActive = 1
  AND IsDeleted = 0
  AND AreaName = @AreaName;

SELECT @LineId = MST_Line_Id
FROM MST_Line
WHERE IsActive = 1
  AND IsDeleted = 0
  AND LineName = @LineName;

SELECT @WorkStationId = MST_WorkStation_Id
FROM MST_WorkStation
WHERE IsActive = 1
  AND IsDeleted = 0
  AND WorkStationName = @WorkStationName;

-- Insert only if the same data does not already exist
IF NOT EXISTS (
    SELECT 1
    FROM MST_Checklist
    WHERE MST_Model_Id = @ModelId
      AND MST_Area_Id = @AreaId
      AND MST_Line_Id = @LineId
      AND MST_WorkStation_Id = @WorkStationId
      AND SequenceNum = @Sequence
      AND IsActive = 1
      AND IsDeleted = 0
      AND M_BOM_Id = @BomId
      And Item = @Item
)

BEGIN
    INSERT INTO MST_Checklist (MST_Model_Id, MST_Area_Id, MST_Line_Id, MST_WorkStation_Id, Item, SequenceNum, IsActive, IsDeleted, M_BOM_Id, CreatedBy)
    VALUES (@ModelId, @AreaId, @LineId, @WorkStationId, @Item, @Sequence, 1, 0, @BomId, @CreatedBy);

END

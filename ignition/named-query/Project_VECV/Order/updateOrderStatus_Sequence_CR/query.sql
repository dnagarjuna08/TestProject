-- Check if OrderStatusid = 4 exists
-- Declare variables for area ID, line, length, and existence check result
DECLARE 
    @AreaId INT =  :AreaID ,
    @Line NVARCHAR(MAX) =  :LineName ,
    @length INT,
    @Exists INT;

-- Set the length based on the AreaId and Line
IF @AreaId = 1
BEGIN
    IF @Line = 'Drive Head'
    BEGIN
        SET @length = 8;
    END
    ELSE
    BEGIN
        SET @length = 5;
    END
END
ELSE IF @AreaId = 2
BEGIN
    IF @Line = 'Drive Head'
    BEGIN
        SET @length = 8;
    END
    ELSE
    BEGIN
        SET @length = 6;
    END
END
-- Check if OrderStatusid = 4 exists
SET @Exists = (
    SELECT COUNT(*) 
    FROM [PRODUCTION_ORDER] PO
    INNER JOIN M_BOM B ON B.M_BOM_Id = PO.M_BOM_Id
    WHERE PO.[OrderStatusid] IN (4, 2) 
      AND PO.MST_Area_Id = @AreaId 
      AND ((LEN(B.M_BOMNumber) = @length AND @length IS NOT NULL))
);

-- Get the maximum psn value and increment it by 1
DECLARE @psn INT;
SET @psn = (
    SELECT MAX(psn) 
    FROM [dbo].[PRODUCTION_ORDER] OP
    INNER JOIN M_BOM BM ON BM.M_BOM_Id = OP.M_BOM_Id
    WHERE OrderStatusid IN (1, 2, 3, 4, 5, 6, 7, 8, 9) 
      AND OP.MST_Area_Id = @AreaId
      AND ((LEN(BM.M_BOMNumber) = @length AND @length IS NOT NULL))
) + 1;

-- Conditional update based on the existence check
IF @Exists IN (0, 1, 2, 3, 4)
BEGIN
    -- If OrderStatusid = 4 exists, update the OrderStatusid to 4
    UPDATE [PRODUCTION_ORDER]
    SET OrderStatusid = 4,
        psn = @psn
    WHERE id = :Id;
END
ELSE
BEGIN
    -- If OrderStatusid = 4 does not exist, update to the provided OrderStatus
    UPDATE [PRODUCTION_ORDER]
    SET OrderStatusid = :OrderStatus,
        psn = @psn
    WHERE id = :Id;
END
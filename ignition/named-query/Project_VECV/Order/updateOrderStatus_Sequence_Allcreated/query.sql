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
    SET @length = CASE 
    WHEN @Line = 'Drive Head' THEN 8 
    ELSE 5 
 END;
END
ELSE IF @AreaId = 2
BEGIN
    SET @length = CASE 
    WHEN @Line = 'Drive Head' THEN 8 
    ELSE 6 
 END;
END

-- Check if OrderStatusid = 4 exists
SET @Exists = (
    SELECT COUNT(*) 
    FROM [PRODUCTION_ORDER] PO
    INNER JOIN M_BOM B ON B.M_BOM_Id = PO.M_BOM_Id
    WHERE PO.[OrderStatusid] IN (4, 2) 
      AND PO.MST_Area_Id = @AreaId 
      AND ( (LEN(B.M_BOMNumber) = @length AND @length IS NOT NULL))
);

-- Get the top five orders based on psn seq
DECLARE @TopFive TABLE (id INT);
INSERT INTO @TopFive (id)
SELECT TOP 5 PO.id
FROM PRODUCTION_ORDER PO
INNER JOIN M_BOM B ON B.M_BOM_Id = PO.M_BOM_Id
WHERE PO.OrderStatusid IN (2, 4)
  AND PO.MST_Area_Id = @AreaId
  AND ((LEN(B.M_BOMNumber) = @length AND @length IS NOT NULL))
ORDER BY PO.psn;

-- Get the maximum psn value and increment it by 1
DECLARE @psn INT;
SET @psn = (
    SELECT MAX(psn) 
    FROM [dbo].[PRODUCTION_ORDER] OP
    INNER JOIN M_BOM BM ON BM.M_BOM_Id = OP.M_BOM_Id
    WHERE OP.OrderStatusid IN (1, 2, 3, 4, 5, 6, 7, 8, 9) 
      AND OP.MST_Area_Id = @AreaId
) + 1;

-- Conditional update based on the existence check
IF @Exists >=0
BEGIN
    -- Update OrderStatusid from 4 to 2
    UPDATE PO
    SET PO.OrderStatusid = 2
    FROM PRODUCTION_ORDER PO
    INNER JOIN M_BOM B ON B.M_BOM_Id = PO.M_BOM_Id
    WHERE PO.OrderStatusid = 4
      AND PO.MST_Area_Id = @AreaId
      AND ( (LEN(B.M_BOMNumber) = @length AND @length IS NOT NULL))
      AND PO.id NOT IN (SELECT id FROM @TopFive);
 
    -- Update OrderStatusid from 1 to 2
    UPDATE PO
    SET PO.OrderStatusid = 2
    FROM PRODUCTION_ORDER PO
    INNER JOIN M_BOM B ON B.M_BOM_Id = PO.M_BOM_Id
    WHERE PO.OrderStatusid = 1
      AND PO.MST_Area_Id = @AreaId
      AND (LEN(B.M_BOMNumber) = @length AND @length IS NOT NULL);

    -- Set top 5 to released (OrderStatusid = 4)
    UPDATE PO
    SET PO.OrderStatusid = 4
    FROM PRODUCTION_ORDER PO
    INNER JOIN @TopFive T ON T.id = PO.id;
END
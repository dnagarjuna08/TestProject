
DECLARE 
    @speed INT =  :isDHBOM ,
    @length INT,
    @AreaID INT= :AreaId ;
 
-- Set @length based on @area and @speed values

IF @AreaID = 1
BEGIN
    IF @speed = 0
        SET @length = 5;
    ELSE IF @speed = 1
        SET @length = 8;
END;

ELSE IF @AreaID = 2
BEGIN
    IF @speed = 0
        SET @length = 6
    ELSE IF @speed = 1
        SET @length = 8
END;
 
-- Temp table to store top 5 IDs

DECLARE @TopFive TABLE (id INT);
 
-- Step 1: Populate top 5 IDs

INSERT INTO @TopFive (id)
SELECT TOP 5 PO.id
FROM PRODUCTION_ORDER PO
INNER JOIN M_BOM B ON B.M_BOM_Id = PO.M_BOM_Id
WHERE PO.OrderStatusid IN (2, 4)
  AND PO.MST_Area_Id = @AreaID
  AND ((LEN(B.M_BOMNumber) = @length AND @length IS NOT NULL))
ORDER BY PO.psn;
 
-- Step 2: Set all current released orders (except top 5) to sequenced

UPDATE PO
SET PO.OrderStatusid = 2
FROM PRODUCTION_ORDER PO
INNER JOIN M_BOM B ON B.M_BOM_Id = PO.M_BOM_Id
WHERE PO.OrderStatusid = 4
  AND PO.MST_Area_Id = @AreaID
  AND ((LEN(B.M_BOMNumber) = @length AND @length IS NOT NULL))
  AND PO.id NOT IN (SELECT id FROM @TopFive);
 
-- Step 3: Set top 5 to released

UPDATE PO
SET PO.OrderStatusid = 4
FROM PRODUCTION_ORDER PO
INNER JOIN @TopFive T ON T.id = PO.id;
 
-- Step 4: Final output for verification

SELECT 
    ROW_NUMBER() OVER (ORDER BY p.psn) AS SrNo,
    p.[id],
    p.[order_number] AS [Order Number],
    so.[serial_number] AS [TM Serial Number],
    mb.[M_BOMNumber] AS [TM Code],
    mb.[Description] AS [Description],
    os.[OrderStatusDescription] AS [Status],
    p.[order_category] AS [Order Type],
    COALESCE(p.[special_instruction], '') AS [Special Instruction],
    p.psn
FROM PRODUCTION_ORDER p
LEFT JOIN MST_Production_OrderStatus os ON p.OrderStatusid = os.OrderStatusid
LEFT JOIN SERIAL_NUMBER so ON p.id = so.orderid
LEFT JOIN M_BOM mb ON p.M_BOM_Id = mb.M_BOM_Id
WHERE p.OrderStatusid IN (2,4)
  AND p.MST_Area_Id = @AreaID
  AND ((LEN(mb.M_BOMNumber) = @length AND @length IS NOT NULL))
ORDER BY 
    CASE WHEN p.OrderStatusid = 4 THEN 0 ELSE 1 END,
    CASE WHEN p.psn IS NOT NULL THEN 0 ELSE 1 END,
    p.psn;



-- Declare variable to hold count of existing records with OrderStatusid = 4
DECLARE @existingCount INT

SELECT @existingCount = COUNT(*)
FROM [PRODUCTION_ORDER]
WHERE [OrderStatusid] = 4 AND MST_Area_Id = :AreaId

-- Calculate how many more records need to be updated
DECLARE @remainingToUpdate INT = 5 - @existingCount

-- If less than 5 exist, update the necessary additional records
IF @remainingToUpdate > 0
BEGIN
    ;WITH TopRecord AS (
        SELECT TOP (@remainingToUpdate) [id]
        FROM [PRODUCTION_ORDER]
        WHERE [OrderStatusid] IN (2) AND MST_Area_Id = :AreaId
        ORDER BY [psn]
    )
    UPDATE p
    SET p.[OrderStatusid] = 4
    FROM [PRODUCTION_ORDER] p
    INNER JOIN TopRecord t ON p.[id] = t.[id]
END

-- Select and display relevant data
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
FROM 
    [PRODUCTION_ORDER] p
LEFT JOIN 
    [MST_Production_OrderStatus] os ON p.[OrderStatusid] = os.[OrderStatusid]
LEFT JOIN 
    [SERIAL_NUMBER] so ON p.[id] = so.[orderid]
LEFT JOIN 
    [M_BOM] mb ON p.[M_BOM_Id] = mb.[M_BOM_Id]
WHERE 
    p.[OrderStatusid] IN (2, 3, 4) AND p.MST_Area_Id = :AreaId
ORDER BY 
    CASE WHEN p.[OrderStatusid] = 4 THEN 0 ELSE 1 END,
    CASE WHEN p.[psn] IS NOT NULL THEN 0 ELSE 1 END,
    p.[psn];

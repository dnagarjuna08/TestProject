-- Check if a record with [OrderStatusid] = 4 exists
IF NOT EXISTS (
    SELECT 1
    FROM [PRODUCTION_ORDER]
    WHERE [OrderStatusid] = 4
)
BEGIN
    -- Update the top record to have [OrderStatusid] = 4
    WITH TopRecord AS (
        SELECT TOP 1 [id]
        FROM [PRODUCTION_ORDER]
        ORDER BY [CreatedOn]
    )
    UPDATE p
    SET p.[OrderStatusid] = 4
    FROM [PRODUCTION_ORDER] p
    INNER JOIN TopRecord t ON p.[id] = t.[id]
END

-- Select the data
SELECT 
		p.[id],
     p.[order_number] AS [Order Number]
    , so.[serial_number] AS [TM Serial Number]
    , mb.[M_BOMNumber] AS [TM Code]
    , mb.[Description] AS [Description]
    , os.[OrderStatusDescription] AS [Status]
    , p.[order_category] AS [Order Type]
    , COALESCE(p.[special_instruction], '') AS [Special Instruction],
    p. psn 
    
FROM 
    [PRODUCTION_ORDER] p
LEFT JOIN 
    [MST_Production_OrderStatus] os
ON 
    p.[OrderStatusid] = os.[OrderStatusid]
LEFT JOIN 
    [SERIAL_NUMBER] so
ON 
    p.[id] = so.[orderid]
LEFT JOIN 
    [M_BOM] mb
ON 
    p.[M_BOM_Id] = mb.[M_BOM_Id]
WHERE 
    p.[OrderStatusid] in (2, 3, 4)
ORDER BY 
    CASE 
        WHEN p.[OrderStatusid] = 4 THEN 0
        ELSE 1
    END,
    CASE 
        WHEN p.[psn] IS NOT NULL THEN 0
        ELSE 1
    END,
    p.[psn],  -- Ordering by psn here
    p.[CreatedOn];





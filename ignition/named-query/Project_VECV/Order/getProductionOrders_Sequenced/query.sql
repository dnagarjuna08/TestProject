-- Check if a record with [OrderStatusid] = 4 exists
IF NOT EXISTS (
    SELECT 1
    FROM [PRODUCTION_ORDER]
    WHERE [OrderStatusid] = 4 and MST_Area_Id = :AreaId  
)
BEGIN
    -- Update the top record to have [OrderStatusid] = 4
    WITH TopRecord AS (
        SELECT TOP 1 [id]
        FROM [PRODUCTION_ORDER] WHERE 
    [OrderStatusid] in (2) and MST_Area_Id = :AreaId 
        ORDER BY [psn]
    )
    UPDATE p
    SET p.[OrderStatusid] = 4
    FROM [PRODUCTION_ORDER] p
    INNER JOIN TopRecord t ON p.[id] = t.[id] 
 --   INNER JOIN [TRN_StationStatus] a ON a.M_BOM_Id != p.M_BOM_Id
    
END

-- Select the data
SELECT 
	
	ROW_NUMBER() OVER (ORDER BY P.psn) AS SrNo,p.[id],
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
    
--INNER JOIN [TRN_StationStatus] a ON a.M_BOM_Id != p.M_BOM_Id
WHERE 
    p.[OrderStatusid] in (2, 3, 4) and p.MST_Area_Id = :AreaId
ORDER BY 
    CASE 
        WHEN p.[OrderStatusid] = 4 THEN 0
        ELSE 1
    END,
    CASE 
        WHEN p.[psn] IS NOT NULL THEN 0
        ELSE 1
    END,
    p.[psn];  -- Ordering by psn here
    --p.[CreatedOn];





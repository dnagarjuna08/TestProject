DECLARE @isDHBOM INT =  :isDHBOM ;  -- Set 1 for LEN >= 8, or 0 for LEN <= 6
SELECT 
      p.[id]
    , p.[order_number] AS [Order Number]
    , so.[serial_number] AS [TM Serial Number]
    , mb.[M_BOMNumber] AS [TM Code]
    , mb.[Description] AS [Description]
    , os.[OrderStatusDescription] AS [Status]
    , p.[order_category] AS [Order Type]
    , COALESCE(p.[special_instruction], '') AS [Special Instruction]
    , p.[booked_time] AS [Time]
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
    p.[OrderStatusid] = :OrderStatus and p.MST_Area_Id = :AreaId 
    AND (
        (@isDHBOM = 1 AND LEN(mb.[M_BOMNumber]) >= 8)
        OR
        (@isDHBOM = 0 AND LEN(mb.[M_BOMNumber]) <= 6)
    )
ORDER BY p.CreatedOn desc
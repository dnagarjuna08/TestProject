SELECT 
     ROW_NUMBER() OVER (ORDER BY P.psn) AS SrNo
    , p.[id]
    , p.[order_number] AS [Order Number]
    , so.[serial_number] AS [TM Serial Number]
    , mb.[M_BOMNumber] AS [TM Code]
    , mb.[Description] AS [Description]
    , os.[OrderStatusDescription] AS [Status]
    , p.[order_category] AS [Order Type]
    , COALESCE(p.[special_instruction], '') AS [Special Instruction]
    , p.[start_time] AS [StartTime]
    ,p.psn,
    'False' as [Selection]
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
ORDER BY p.psn

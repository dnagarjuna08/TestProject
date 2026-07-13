SELECT 
    M_BOM.M_BOMNumber,
    PRODUCTION_ORDER.serial_number,
    PRODUCTION_ORDER.order_number,
    PRODUCTION_ORDER.start_time
FROM 
    M_BOM
INNER JOIN 
    PRODUCTION_ORDER ON M_BOM.M_BOM_Id = PRODUCTION_ORDER.M_BOM_Id
WHERE 
    start_time BETWEEN :fromDate AND :toDate
    AND M_BOM.M_BOMNumber = :TMCode
    AND OrderStatusid = 6
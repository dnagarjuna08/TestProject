SELECT distinct 
    AreaName, 
--    LineName, 
    M_BOMNumber as RACode,  
    serial_number as SerialNumber,
    SAP_OutboundOrderResponse.MESSAGE as SAP_Message,
    CASE 
        WHEN SAP_OutboundOrderDetail.IsRFC = 1 THEN 'Booked' 
        WHEN SAP_OutboundOrderDetail.IsRFC = 2 THEN 'Pending For Booking' 
        ELSE 'Unknown'
    END as OrderStatus,
    PRODUCTION_ORDER.CreatedOn as StartDate
FROM 
    MST_Area 
INNER JOIN  
    PRODUCTION_ORDER ON PRODUCTION_ORDER.MST_Area_Id = MST_Area.MST_Area_Id
--INNER JOIN  MST_Line ON MST_Area.MST_Area_Id = MST_Line.MST_Area_Id
INNER JOIN M_BOM ON PRODUCTION_ORDER.M_BOM_Id = M_BOM.M_BOM_Id
INNER JOIN  
    SAP_OutboundOrderDetail ON SAP_OutboundOrderDetail.SerialNumber = PRODUCTION_ORDER.serial_number
INNER JOIN  SAP_OutboundOrderResponse ON 
    SAP_OutboundOrderDetail.SAP_OutboundOrderDetail_Id =SAP_OutboundOrderResponse.SAP_OutboundOrderDetail_Id 

WHERE 
    AreaName = :AreaName
    AND PRODUCTION_ORDER.CreatedOn BETWEEN :StartDate AND :EndDate
    AND SAP_OutboundOrderDetail.IsRFC = CASE
        WHEN :OrderState = 'Booked' THEN 1
        WHEN :OrderState = 'Pending For Booking' THEN 2
        ELSE SAP_OutboundOrderDetail.IsRFC  -- Return all if no filter is selected
    END
SELECT distinct 
AreaName, --LineName ,
M_BOMNumber as RACode , serial_number as SerialNumber ,
SAP_OutboundOrderResponse.MESSAGE as SAP_Message,
CASE 
        WHEN SAP_OutboundOrderDetail.IsRFC = 1 THEN 'Booked' 
        WHEN SAP_OutboundOrderDetail.IsRFC = 2 THEN 'Pending for Booking' 
        ELSE 'Unknown'
    END as OrderStatus , PRODUCTION_ORDER.CreatedOn  as StartDate
from 
PRODUCTION_ORDER
inner join MST_Area   on MST_Area.MST_Area_Id =PRODUCTION_ORDER.MST_Area_Id
INNER JOIN M_BOM ON PRODUCTION_ORDER.M_BOM_Id = M_BOM.M_BOM_Id
--inner join MST_Line on MST_Line.MST_Area_Id = MST_Area.MST_Area_Id

inner join
SAP_OutboundOrderDetail ON SAP_OutboundOrderDetail.SerialNumber = PRODUCTION_ORDER.serial_number
INNER JOIN  SAP_OutboundOrderResponse ON 
    SAP_OutboundOrderDetail.SAP_OutboundOrderDetail_Id =SAP_OutboundOrderResponse.SAP_OutboundOrderDetail_Id 
where MST_Area.AreaName=:AreaName and PRODUCTION_ORDER.CreatedOn
Between :StartDate and :EndDate
    

select M_BOM.M_BOMNumber ,PRODUCTION_ORDER.serial_number ,MST_Production_OrderStatus . OrderStatus,
PRODUCTION_ORDER.order_number , PRODUCTION_ORDER.start_time 
from M_BOM
inner join PRODUCTION_ORDER on M_BOM.M_BOM_Id=PRODUCTION_ORDER.M_BOM_Id
inner join  MST_Production_OrderStatus on MST_Production_OrderStatus.OrderStatusid = PRODUCTION_ORDER.OrderStatusid
  
where start_time between :fromDate and :toDate
and  MST_Production_OrderStatus.OrderStatus = 'Started'


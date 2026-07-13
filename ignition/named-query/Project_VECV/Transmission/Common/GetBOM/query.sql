Select B.M_BOMNumber,P.order_number,B.M_BOM_Id
from SERIAL_NUMBER S
inner join PRODUCTION_ORDER P on P.id=S.orderid
inner join M_BOM B ON B.M_BOM_Id=P.M_BOM_Id
where S.serial_number= :SerialNumber
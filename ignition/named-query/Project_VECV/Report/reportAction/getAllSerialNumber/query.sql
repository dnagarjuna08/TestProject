select serial_number AS value, serial_number as label from SERIAL_NUMBER WHERE orderid IN (
select PO.id from PRODUCTION_ORDER AS PO 
INNER JOIN M_BOM AS BM with (NOLOCK) ON BM.M_BOM_Id = PO.M_BOM_Id
WHERE PO.MST_Area_Id IN (SELECT VALUE FROM string_split( :AreaId   ,','))
AND PO.is_active = 1
AND BM.M_BOM_Id IN (SELECT VALUE FROM string_split(:BOM_Id ,','))
GROUP BY PO.id)
select S.serial_number as 'SerialNumber' from MST_Area MA
inner join PRODUCTION_ORDER PO on PO.MST_Area_Id=MA.MST_Area_Id
inner join SERIAL_NUMBER S on S.orderid=PO.id
where MA.MST_Area_Id IN (SELECT VALUE FROM string_split(:Area ,','))
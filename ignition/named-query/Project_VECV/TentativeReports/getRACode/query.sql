--Select distinct  substring(serial_number,12,len(serial_number)) AS ExtractString
--from  SERIAL_NUMBER

select  0 as 'value' , 'Select All' as 'label' 
union all
select  M_BOM_Id as 'value' , M_BOMNumber as 'label' 
from  M_BOM 
where  Mst_Area_Id = :areaId and
	   IsActive = 1 
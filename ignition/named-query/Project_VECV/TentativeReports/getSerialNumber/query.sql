select  0 as 'value' , 'Select All' as 'label' 
union all
select  distinct TRN_DownTime_Id as 'value' , SerialNumber as 'label' 
from  TRN_DownTime
where  Mst_Area_Id = :areaId and
	   MST_Line_Id = :lineId and 
	   MST_WorkStation_Id = :workstationId and 
	   SerialNumber != '' and
	   IsActive = 1 
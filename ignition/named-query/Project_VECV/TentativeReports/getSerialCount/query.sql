select  'Total Count = '+ +cast(count(distinct ss.SerialNumber) as varchar(50))  as 'count'

from  TRN_StationStatus ss
--inner join TRN_StationEvents t on t.SerialNumber = ss.SerialNumber 
--inner join  MST_WorkStation  w on w.MST_WorkStation_Id = t.MST_WorkStation_Id 
--inner join  MST_Status  s on s.MST_Status_Id  = t.MST_Status_Id 

where (ss.M_BOM_Id = :rACode or 0 = :rACode)   and 
	  ss.MST_Status_Id = :status  and
	  ss.MST_WorkStation_Id = :workStation and
	  ss.MST_Area_Id = :area  and
	  ss.MST_Line_Id = :line  and
	  ss.CreatedDate >= :from and ss.CreatedDate <= :to 
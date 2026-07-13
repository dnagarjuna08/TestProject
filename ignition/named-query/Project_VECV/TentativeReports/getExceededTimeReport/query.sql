SELECT distinct  d.[SerialNumber]
				--,d.[MST_Line_Id]
				--,d.[MST_WorkStation_Id]
				,w.WorkStationName
				,w.Description
				
				--,d.[MST_Area_Id]

FROM [dbo].[TRN_DownTime] d
inner join  MST_WorkStation  w on w.MST_WorkStation_Id = d.MST_WorkStation_Id 
where 
	  (d.SerialNumber = :serialNumber or 0= :serialNumber  )and
	  d.MST_Area_Id = :areaId   and
	  d.MST_Line_Id = :lineId  and
      d.MST_WorkStation_Id = :workstationId  and
	  (:from is null or d.CreatedDate >= :from)  and (:to is null or d.CreatedDate <= :to ) 
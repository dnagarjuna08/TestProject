SELECT distinct  t.[SerialNumber]
				--,t.[MST_Line_Id]
				--,t.[MST_WorkStation_Id]
				,w.WorkStationName
				,w.Description
				--,t.[MST_Area_Id]
				--,t.[MST_Status_Id]
				,s.Status
FROM [dbo].[TRN_StationStatus] t
inner join  MST_WorkStation  w on w.MST_WorkStation_Id = t.MST_WorkStation_Id 
inner join  MST_Status  s on s.MST_Status_Id  = t.MST_Status_Id 
where --t.SerialNumber like concat('%',concat('RA567','%')) and
	  (t.M_BOM_Id = :rACode or 0= :rACode  )and
	  t.MST_Area_Id = :area   and
	  t.MST_Line_Id = :line  and
      t.MST_WorkStation_Id = :workStation  and
      t.MST_Status_Id = :status and
	  t.CreatedDate >= :from   and t.CreatedDate <= :to  
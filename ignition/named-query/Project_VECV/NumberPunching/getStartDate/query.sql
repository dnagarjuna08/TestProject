select top 1 ts.CreatedDate from TRN_StationStatus ts 
inner join MST_WorkStation ws on ts.MST_WorkStation_Id=ws.MST_WorkStation_Id
where ws.WorkStationName= :WorkStationName  and SerialNumber= :SerialNumber 
order by ts.CreatedDate desc
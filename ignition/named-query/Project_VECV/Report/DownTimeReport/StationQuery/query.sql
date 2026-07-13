SELECT  WorkStationName from  MST_WorkStation 
inner join  MST_Area 
on MST_Area.MST_Area_Id = MST_WorkStation. MST_Area_Id 
where MST_Area.AreaName=:AreaName and MST_WorkStation.IsActive=1
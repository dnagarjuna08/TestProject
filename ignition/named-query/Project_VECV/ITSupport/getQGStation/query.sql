SELECT [MST_WorkStation_Id] as value,[WorkStationName] as label FROM MST_WorkStation 
WHERE MST_WorkStationType_Id = 3 AND IsActive = 1 and WorkStationName like '%QG%'
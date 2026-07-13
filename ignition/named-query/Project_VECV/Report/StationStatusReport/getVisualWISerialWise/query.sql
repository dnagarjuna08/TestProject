SELECT MST_WorkStation.WorkStationName ,MST_WorkStation.[Description], MST_Event.Event , OperatorID
,TRN_Station_Events.CreatedDate  
FROM MST_WorkStation
inner join TRN_Station_Events
on  MST_WorkStation. MST_WorkStation_Id = TRN_Station_Events.MST_WorkStation_Id 
inner join  MST_Event 
on  MST_Event. MST_Event_Id =  TRN_Station_Events.MST_Event_Id 
where
TRN_Station_Events.MST_Event_Id ='5' AND
TRN_Station_Events. SerialNumber = :SerialNumber  AND  TRN_Station_Events.MST_OPDefinition_Id=1
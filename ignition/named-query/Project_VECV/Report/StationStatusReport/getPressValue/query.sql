select MST_WorkStation.WorkStationName,MST_WorkStation.[Description],MST_Event.Event
,TRN_Operation_Data.PressingValue ,TRN_Operation_Data.PressingDepth,TRN_Station_Events.OperatorID,TRN_Station_Events.CreatedDate from TRN_Operation_Data
inner join TRN_Station_Events
on TRN_Station_Events.TRN_Station_Events_Id=TRN_Operation_Data.TRN_Station_Events_Id
inner join MST_WorkStation
on  MST_WorkStation.MST_WorkStation_Id = TRN_Station_Events.MST_WorkStation_Id 
inner join  MST_Event 
on  MST_Event.MST_Event_Id = TRN_Station_Events.MST_Event_Id
where TRN_Station_Events.SerialNumber= :SerialNumber 
and TRN_Station_Events.MST_OPDefinition_Id='6' 
and TRN_Station_Events.MST_Event_Id = '5'
order by MST_WorkStation.WorkStationName DESC
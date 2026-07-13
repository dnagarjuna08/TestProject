select MST_WorkStation.WorkStationName,MST_Event.Event
,TRN_Operation_Data.Process_LeakRate ,TRN_Operation_Data.Process_Pressure,MST_Status.[Status],TRN_Station_Events.CreatedDate from TRN_Operation_Data
inner join TRN_Station_Events
on TRN_Station_Events.TRN_Station_Events_Id=TRN_Operation_Data.TRN_Station_Events_Id
inner join MST_WorkStation
on  MST_WorkStation.MST_WorkStation_Id = TRN_Station_Events.MST_WorkStation_Id 
inner join  MST_Event 
on  MST_Event.MST_Event_Id = TRN_Station_Events.MST_Event_Id
inner join MST_Status on mst_status.MST_Status_Id=TRN_Station_Events.MST_Status_Id
where TRN_Station_Events.SerialNumber= :SerialNumber 
and TRN_Station_Events.MST_OPDefinition_Id=11 
and TRN_Station_Events.MST_Event_Id = '5'
select MST_WorkStation.WorkStationName,MST_Event.Event
,TRN_TestBed_Data.Process_GEAR_RATIO
,TRN_TestBed_Data.Process_DELTA_SPIN
,TRN_TestBed_Data.Process_DIFF_VIBRATION
,TRN_TestBed_Data.Process_LH_RPM
,TRN_TestBed_Data.Process_LH_VIBRATION
,TRN_TestBed_Data.Process_NOISE
,TRN_TestBed_Data.Process_RH_RPM
,TRN_TestBed_Data.Process_RH_VIBRATION
,TRN_TestBed_Data.Process_TORQUE
,MST_Status.[Status],TRN_Station_Events.CreatedDate from TRN_TestBed_Data
inner join TRN_Station_Events
on TRN_Station_Events.TRN_Station_Events_Id=TRN_TestBed_Data.TRN_Station_Events_Id
inner join MST_WorkStation
on  MST_WorkStation.MST_WorkStation_Id = TRN_Station_Events.MST_WorkStation_Id 
inner join MST_Event 
on  MST_Event.MST_Event_Id = TRN_Station_Events.MST_Event_Id
inner join MST_Status on mst_status.MST_Status_Id=TRN_Station_Events.MST_Status_Id
where 
TRN_Station_Events.SerialNumber=:SerialNumber 
and TRN_Station_Events.MST_OPDefinition_Id='14'
and TRN_Station_Events.MST_Event_Id = '5'
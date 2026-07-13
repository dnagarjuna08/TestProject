SELECT MST_WorkStation.WorkStationName,MST_WorkStation.[Description],MST_Event.Event,OperatorID
, TRN_Station_Events.CreatedDate 
from MST_WorkStation
inner join TRN_Station_Events
on  MST_WorkStation. MST_WorkStation_Id = TRN_Station_Events.MST_WorkStation_Id 
inner join  MST_Event 
on  MST_Event. MST_Event_Id =  TRN_Station_Events.MST_Event_Id
where SerialNumber= :SerialNumber   AND  TRN_Station_Events.MST_OPDefinition_Id='7'
and TRN_Station_Events.MST_Event_Id ='5'
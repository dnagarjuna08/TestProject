select TE.SerialNumber,  WS.WorkStationName, TE.[TRN_StationEvents_Id],[MST_Event_Id],TE.[MST_OPCode_Id],[OPCode],TE.[MST_OPDefinition_Id],[OPDefinition],
[PLCTorqueValue],[PLCTorqueCount],[Torque_Angle1],[PLCTorqueResult],[PressingValue],
[PressingDepth],[ConsumedPartNumber],TE.[OperatorID],[MST_WorkInstruction_Id],TE.[MST_WIType_Id], TE.PartNumber
from [dbo].[TRN_StationEvents] TE 
inner join [dbo].[TRN_OPNonConformance] OPNC on OPNC.TRN_StationEvents_Id=TE.TRN_StationEvents_Id
inner join [dbo].[MST_OPDefinition] OD on OD.[MST_OPDefinition_Id]=TE.[MST_OPDefinition_Id]
inner join [dbo].[MST_OPCode] OC on TE.MST_OPCode_Id=OC.MST_OPCode_Id
INNER JOIN  MST_WorkStation WS ON WS.MST_WorkStation_Id = TE.MST_WorkStation_Id 
WHERE (TE.MST_Line_Id  IN (SELECT VALUE FROM string_split( :Line ,','))) and [MST_Event_Id]=8 and OPNC.MST_NCStatus_Id!=2
AND TE.CreatedDate BETWEEN :StartDate AND :EndDate

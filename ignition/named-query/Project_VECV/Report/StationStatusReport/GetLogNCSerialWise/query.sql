select MST_OPDefinition.OPDefinition , MST_WorkStation.WorkStationName,
	TR.[PLCTorqueValue],TR.[PLCTorqueCount],TR.[Torque_Angle],TR.[PLCTorqueResult],OP.[PressingValue],
	OP.[PressingDepth],OP.[ConsumedPartNumber],TE.[OperatorID], OP.PartNumber,te.CreatedDate,ncs.[Status]
	from [dbo].[TRN_Station_Events] TE 
	inner join [dbo].[TRN_OPNonConformance] OPNC WITH(NOLOCK) on OPNC.TRN_Station_Events_Id=TE.TRN_Station_Events_Id
    inner join MST_Line on MST_line.MST_Line_Id=TE.MST_Line_Id
	LEFT join [dbo].[TRN_Torque_Data] TR WITH(NOLOCK) on TR.TRN_Station_Events_Id=TE.TRN_Station_Events_Id
	LEFT join [dbo].[TRN_Operation_Data] OP WITH(NOLOCK) on OP.TRN_Station_Events_Id=TE.TRN_Station_Events_Id
	inner join [dbo].[MST_OPDefinition] OD WITH(NOLOCK) on OD.[MST_OPDefinition_Id]=TE.[MST_OPDefinition_Id]
	inner join [dbo].[MST_OPCode] OC WITH(NOLOCK) on TE.MST_OPCode_Id=OC.MST_OPCode_Id
    inner join MST_OPDefinition on MST_OPDefinition.MST_OPDefinition_Id=TE.[MST_OPDefinition_Id]
    inner join MST_WorkStation on MST_WorkStation.MST_WorkStation_Id= TE.MST_WorkStation_Id
    inner join MST_NCStatus  ncs on OPNC.MST_NCStatus_Id=ncs.MST_NCStatus_Id
	where TE.[SerialNumber]=   :serialNumber  and [MST_Event_Id]=8  and OPNC.IsActive = 1 
    order by te.CreatedDate desc
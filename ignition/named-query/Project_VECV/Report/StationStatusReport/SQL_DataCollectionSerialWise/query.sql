SELECT 
		ROW_NUMBER() OVER (ORDER BY t.CreatedDate) AS [Sr.No],
		--t.[SerialNumber],
		w.[WorkStationName],
		w.[Description],
		ocd.[OPDefinition],
		TR.[PLCTorqueValue],
		TR.[MESTorqueResult],
		OPD.[MaxVal],
		OPD.[MinVal],
		e.[Event],
		t.OperatorID as 'OperatorID',
		t.CreatedDate as 'EventTime'
	FROM [dbo].[TRN_Station_Events] t
		INNER JOIN [dbo].[TRN_Torque_Data] TR WITH(NOLOCK) ON TR.TRN_Station_Events_Id=t.TRN_Station_Events_Id
		INNER JOIN [dbo].[MST_WorkStation] w WITH(NOLOCK) ON t.[MST_WorkStation_Id]=w.[MST_WorkStation_Id]
		INNER JOIN [dbo].[MST_OPCode] oc WITH(NOLOCK) ON t.[MST_OPCode_Id]=oc.[MST_OPCode_Id]
		INNER JOIN [dbo].[MST_OPDefinition] ocd WITH(NOLOCK) ON t.[MST_OPDefinition_Id]=ocd.[MST_OPDefinition_Id]
		INNER JOIN [dbo].[MST_Event] e WITH(NOLOCK) ON t.[MST_Event_Id] = e.[MST_Event_Id]
		INNER JOIN [dbo].[MST_OPDefinitionTorque] OPD WITH(NOLOCK) ON OPD.[MST_OPCode_Id]=t.[MST_OPCode_Id] 
	WHERE t.[MST_OPDefinition_Id] in ('2','12') AND
		  t.[SerialNumber] =  :SerialNumber 
         AND  t.MST_Event_Id = '5'
		 ORDER BY t.CreatedDate ASC
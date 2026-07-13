Select [WorkStationName] as value,[WorkStationName] as label from MST_WorkStation with(nolock)
where [IsDeleted] = 0 and [MST_Line_Id]=:LineId
order by [WorkStationName] Asc
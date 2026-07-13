select MST_WorkStation_Id ,WorkStationName from MST_WorkStation
where MST_Line_Id=  :MST_Line_Id  and IsActive=1 and IsDeleted=0
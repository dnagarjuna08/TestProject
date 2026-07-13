select MST_WorkStation_Id ,WorkStationName from MST_WorkStation
where MST_Area_Id= :MST_Area_Id and IsActive=1 and IsDeleted=0
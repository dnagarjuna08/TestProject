select MST_WorkStation_Id from TRN_RouteStep where ParallelStation like concat('%',:workStation,'%') 
and IsActive = 1
select ParallelStation,MST_LocationRoute_Id from TRN_RouteStep where IsActive = 1 and MST_LocationRoute_Id IN (
select MST_LocationRoute_Id from MST_LocationRoute where IsActive = 1 and MST_Line_Id = :LineID) and ParallelStation <> ''

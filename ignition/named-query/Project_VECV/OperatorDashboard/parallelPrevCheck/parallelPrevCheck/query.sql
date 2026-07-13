SELECT 
    TRN_RouteStep.MST_WorkStation_Id,
    TRIM(VALUE) AS ParallelStation
FROM 
    TRN_RouteStep
JOIN 
    MST_LocationRoute ON TRN_RouteStep.MST_LocationRoute_Id = MST_LocationRoute.MST_LocationRoute_Id
CROSS APPLY (
    SELECT 
        TRIM(VALUE) AS VALUE
    FROM 
        STRING_SPLIT(TRN_RouteStep.ParallelStation, ',')
) AS SplitValues
WHERE 
    TRN_RouteStep.IsActive = 1
    AND MST_LocationRoute.MST_line_Id =  :MST_line_Id
    AND MST_LocationRoute.IsActive = 1
ORDER BY 
    TRN_RouteStep.MST_WorkStation_Id, ParallelStation;

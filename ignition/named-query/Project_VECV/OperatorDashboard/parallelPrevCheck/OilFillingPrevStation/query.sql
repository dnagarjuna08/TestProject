SELECT 
    CASE 
        WHEN (SELECT TOP 1 MST_Status_id 
              FROM TRN_StationStatus s
              inner join MST_WorkStation w on w.MST_WorkStation_Id = s.MST_WorkStation_Id
              WHERE SerialNumber =   :SerialNumber 
                AND w.WorkStationName in( :currentWS  ,  :currentWSParallel ) --current station
              ORDER BY s.CreatedDate DESC) = 2 THEN 2
              
        WHEN (SELECT TOP 1 MST_Status_id 
              FROM TRN_StationStatus s
              inner join MST_WorkStation w on w.MST_WorkStation_Id = s.MST_WorkStation_Id
              WHERE SerialNumber =  :SerialNumber 
                AND w.WorkStationName IN ( :prevWS ,  :prevWSParallel )  --prevStations LeakTest
              ORDER BY s.CreatedDate DESC) = 2 THEN 1
              
        ELSE 3
    END AS FinalResult;
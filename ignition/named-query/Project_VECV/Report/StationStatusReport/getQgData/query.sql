WITH RankedEvents AS (
    SELECT 
        MST_WorkStation.WorkStationName,
        MST_WorkStation.[Description], 
        MST_Event.Event, 
        TRN_Station_Events.OperatorID,
        TRN_Station_Events.CreatedDate,
        ROW_NUMBER() OVER (PARTITION BY MST_WorkStation.WorkStationName ORDER BY TRN_Station_Events.CreatedDate DESC) AS rn
    FROM MST_WorkStation
    INNER JOIN TRN_Station_Events
        ON MST_WorkStation.MST_WorkStation_Id = TRN_Station_Events.MST_WorkStation_Id 
    INNER JOIN MST_Event 
        ON MST_Event.MST_Event_Id = TRN_Station_Events.MST_Event_Id 
    INNER JOIN MST_WorkStationType
        ON MST_WorkStationType.MST_WorkStationType_Id = MST_WorkStation.MST_WorkStationType_Id
    WHERE
        TRN_Station_Events.MST_Event_Id IN ('5','19')
        AND TRN_Station_Events.SerialNumber =  :SerialNumber 
        AND TRN_Station_Events.OperatorID IS NOT NULL
        AND MST_WorkStationType.MST_WorkStationType_Id = '3'
)
SELECT 
    WorkStationName, [Description], Event, OperatorID, CreatedDate
FROM RankedEvents
WHERE rn = 1
ORDER BY WorkStationName ASC;

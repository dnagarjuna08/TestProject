DECLARE @FromDate DATETIME = :FromDate;  -- User-selected start time
DECLARE @ToDate DATETIME = :ToDate;      -- User-selected end time
DECLARE @WorkStationId NVARCHAR(10) = :WorkStation; -- Selected workstation ID

-- Recursive Common Table Expression (CTE) to generate hourly intervals
;WITH HoursCTE AS (
    SELECT @FromDate AS HourTime
    UNION ALL
    SELECT DATEADD(HOUR, 1, HourTime)
    FROM HoursCTE
    WHERE DATEADD(HOUR, 1, HourTime) <= @ToDate  -- Include the exact @ToDate
)
-- Query to calculate counts for each hour and the total range
SELECT 
    SortOrder, 
    HourTime,
    [Time + 1 Hour],
    SerialNumberCount
FROM (
    -- Total count row
    SELECT 
        0 AS SortOrder,  -- Sorting helper for the total count row
        @FromDate AS HourTime,
        @ToDate AS [Time + 1 Hour],
        (
            SELECT COUNT(DISTINCT t.SerialNumber)
            FROM TRN_StationStatus t
            INNER JOIN MST_WorkStation 
                ON MST_WorkStation.MST_WorkStation_Id = t.MST_WorkStation_Id
            WHERE MST_WorkStation.WorkStationName = @WorkStationId
            AND t.CreatedDate BETWEEN @FromDate AND @ToDate
        ) AS SerialNumberCount
    UNION ALL
    -- Hourly count rows
    SELECT 
        1 AS SortOrder,  -- Sorting helper for hourly rows
        HourTime,
        CASE 
            WHEN DATEADD(HOUR, 1, HourTime) > @ToDate THEN @ToDate -- Last interval adjusts to exact @ToDate
            ELSE DATEADD(HOUR, 1, HourTime) 
        END AS [Time + 1 Hour],
        (
            SELECT COUNT(DISTINCT t.SerialNumber)
            FROM TRN_StationStatus t
            INNER JOIN MST_WorkStation 
                ON MST_WorkStation.MST_WorkStation_Id = t.MST_WorkStation_Id
            WHERE MST_WorkStation.WorkStationName = @WorkStationId
            AND t.CreatedDate >= HourTime 
            AND t.CreatedDate < DATEADD(HOUR, 1, HourTime)
        ) AS SerialNumberCount
    FROM HoursCTE
    WHERE HourTime < @ToDate  -- Ensure we don't generate an interval beyond the @ToDate
    UNION ALL
    -- Last partial hour
    SELECT 
        2 AS SortOrder,  -- Sorting helper for the final partial hour row
        @ToDate AS HourTime,
        @ToDate AS [Time + 1 Hour],
        (
            SELECT COUNT(DISTINCT t.SerialNumber)
            FROM TRN_StationStatus t
            INNER JOIN MST_WorkStation 
                ON MST_WorkStation.MST_WorkStation_Id = t.MST_WorkStation_Id
            WHERE MST_WorkStation.WorkStationName = @WorkStationId
            AND t.CreatedDate >= @ToDate
            AND t.CreatedDate < DATEADD(SECOND, 1, @ToDate)  -- Ensure it's within the exact final second
        ) AS SerialNumberCount
) AS CombinedResults
ORDER BY SortOrder, HourTime
OPTION (MAXRECURSION 0);

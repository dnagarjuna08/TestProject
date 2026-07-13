DECLARE @WorkStationId INT =:WorkStation;
DECLARE @FromDate DATETIME =:FromDate;
DECLARE @ToDate DATETIME =:ToDate;

-- Generate list of dates
WITH Dates AS (
    SELECT @FromDate AS Date
    UNION ALL
    SELECT DATEADD(DAY, 1, Date)
    FROM Dates
    WHERE DATEADD(DAY, 1, Date) <= @ToDate
),

-- Define shift windows
Shifts AS (
    SELECT 
        'A' AS ShiftName,
        DATEADD(HOUR, 7, DATEADD(MINUTE, 30, d.Date)) AS ShiftStart,
        DATEADD(HOUR, 16, d.Date) AS ShiftEnd
    FROM Dates d
    UNION ALL
    SELECT 
        'B',
        DATEADD(HOUR, 16, d.Date),
        DATEADD(SECOND, 59, DATEADD(MINUTE, 59, DATEADD(HOUR, 23, d.Date)))
    FROM Dates d
    UNION ALL
    SELECT 
        'C',
        DATEADD(DAY, 1, d.Date),
        DATEADD(SECOND, 59, DATEADD(MINUTE, 29, DATEADD(HOUR, 7, DATEADD(DAY, 1, d.Date))))
    FROM Dates d
),

-- Assign shifts to each record
ShiftedData AS (
    SELECT 
        s.ShiftName AS Shift,
        t.SerialNumber
    FROM TRN_StationStatus t
    CROSS APPLY Shifts s
    WHERE 
        t.MST_WorkStation_Id = @WorkStationId AND
        t.CreatedDate >= s.ShiftStart AND t.CreatedDate < s.ShiftEnd AND
        t.CreatedDate BETWEEN @FromDate AND @ToDate
),

-- Aggregate count per shift
AggregatedData AS (
    SELECT 
        Shift,
        COUNT(DISTINCT SerialNumber) AS Count
    FROM ShiftedData
    GROUP BY Shift
)

-- Final output
SELECT 
    Shift,
    Count AS Total
FROM AggregatedData

UNION ALL

-- Grand Total
SELECT 
    'Total',
    SUM(Count) AS Total
FROM AggregatedData order by Shift asc;
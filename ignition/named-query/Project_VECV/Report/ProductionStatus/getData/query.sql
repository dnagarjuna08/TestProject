DECLARE @WorkStationId INT = :WorkStation; -- Dynamic Workstation
DECLARE @FromDate DATETIME = :FromDate;    -- Start Date
DECLARE @ToDate DATETIME = :ToDate;        -- End Date

-- Generate shifts for each day in the date range
WITH Dates AS (
    SELECT @FromDate AS Date
    UNION ALL
    SELECT DATEADD(DAY, 1, Date)
    FROM Dates
    WHERE DATEADD(DAY, 1, Date) <= @ToDate
),
Shifts AS (
    SELECT 
        'A' AS ShiftName, 
        DATEADD(HOUR, 7, DATEADD(MINUTE, 30, d.Date)) AS ShiftStart,
        DATEADD(HOUR, 16, d.Date) AS ShiftEnd
    FROM Dates d
    UNION ALL
    SELECT 
        'B',
        DATEADD(HOUR, 16, d.Date) AS ShiftStart,
        --DATEADD(HOUR, 23, DATEADD(MINUTE, 59, d.Date)) AS ShiftEnd
        DATEADD(SECOND, 59, DATEADD(MINUTE, 59, DATEADD(HOUR, 23, d.Date))) AS ShiftEnd
    FROM Dates d
    UNION ALL
    SELECT 
        'C',
        DATEADD(DAY, 1, d.Date) AS ShiftStart, -- Start at 12:00 AM of the next day
   		DATEADD(SECOND, 59, DATEADD(MINUTE, 29, DATEADD(HOUR, 7, DATEADD(DAY, 1, d.Date)))) AS ShiftEnd -- End at 7:29:59 AM of the next day
    FROM Dates d
),
ShiftedData AS (
    SELECT 
        CASE 
            WHEN t.CreatedDate >= s.ShiftStart AND t.CreatedDate < s.ShiftEnd THEN s.ShiftName
            ELSE NULL
        END AS Shift,
        t.SerialNumber,
        CASE 
            WHEN SUBSTRING(t.SerialNumber, CHARINDEX('-', t.SerialNumber) - 2, 2) = 'HD' THEN 'HD'
            WHEN SUBSTRING(t.SerialNumber, CHARINDEX('-', t.SerialNumber) - 2, 2) = 'LD' THEN 'LD'
            ELSE 'Unknown'
        END AS Type
    FROM 
        TRN_StationStatus t
    CROSS APPLY Shifts s
    WHERE 
        t.MST_WorkStation_Id = @WorkStationId
        AND t.CreatedDate BETWEEN @FromDate AND @ToDate
),
AggregatedData AS (
    SELECT 
        Shift,
        Type,
        COUNT(DISTINCT SerialNumber) AS Count
    FROM 
        ShiftedData
    WHERE Shift IS NOT NULL
    GROUP BY Shift, Type
)
-- Generate final output
SELECT 
    Shift,
    SUM(CASE WHEN Type = 'HD' THEN Count ELSE 0 END) AS HD,
    SUM(CASE WHEN Type = 'LD' THEN Count ELSE 0 END) AS LD,
    SUM(Count) AS Total
FROM 
    AggregatedData
GROUP BY 
    Shift

UNION ALL

-- Totals row
SELECT 
    'Total' AS Shift,
    SUM(CASE WHEN Type = 'HD' THEN Count ELSE 0 END) AS HD,
    SUM(CASE WHEN Type = 'LD' THEN Count ELSE 0 END) AS LD,
    SUM(Count) AS Total
FROM 
    AggregatedData;

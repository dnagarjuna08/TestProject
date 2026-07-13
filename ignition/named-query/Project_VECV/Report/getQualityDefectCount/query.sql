-- Created By Nag

DECLARE @cdate DATE =  :date ;

-- Set Shift C date to the next day
DECLARE @shiftCDate DATE = DATEADD(DAY, 1, @cdate);

-- Define Shift start and end times
DECLARE @shiftAStart DATETIME = CAST(@cdate AS DATETIME) + '07:30:00.000';
DECLARE @shiftAEnd DATETIME = CAST(@cdate AS DATETIME) + '15:59:59.999';

DECLARE @shiftBStart DATETIME = CAST(@cdate AS DATETIME) + '16:00:00.000';
DECLARE @shiftBEnd DATETIME = CAST(@cdate AS DATETIME) + '23:59:59.999';

DECLARE @shiftCStart DATETIME = CAST(@shiftCDate AS DATETIME) + '00:00:00.000';
DECLARE @shiftCEnd DATETIME = CAST(@shiftCDate AS DATETIME) + '07:29:59.000';

-- CTE for SerialCount
WITH SerialCount AS (
    SELECT 
        COUNT(DISTINCT SerialNumber) AS SerialCount,
        CASE
            WHEN CreatedDate BETWEEN @shiftAStart AND @shiftAEnd THEN 'A'
            WHEN CreatedDate BETWEEN @shiftBStart AND @shiftBEnd THEN 'B'
            WHEN CreatedDate BETWEEN @shiftCStart AND @shiftCEnd THEN 'C'
        END AS Shift
    FROM TRN_StationStatus
    WHERE MST_WorkStation_Id = (select MST_WorkStation_Id 
			from MST_WorkStation 
			where WorkStationName =  :WorkStationName 
			and IsActive = 1)
      AND CreatedDate BETWEEN @shiftAStart AND @shiftCEnd
    GROUP BY 
        CASE
            WHEN CreatedDate BETWEEN @shiftAStart AND @shiftAEnd THEN 'A'
            WHEN CreatedDate BETWEEN @shiftBStart AND @shiftBEnd THEN 'B'
            WHEN CreatedDate BETWEEN @shiftCStart AND @shiftCEnd THEN 'C'
        END
),

-- CTE for DefectSerialCount
DefectSerialCount AS (
    SELECT 
        COUNT(DISTINCT SerialNumber) AS DefectSerialCount,
        CASE
            WHEN CreatedDate BETWEEN @shiftAStart AND @shiftAEnd THEN 'A'
            WHEN CreatedDate BETWEEN @shiftBStart AND @shiftBEnd THEN 'B'
            WHEN CreatedDate BETWEEN @shiftCStart AND @shiftCEnd THEN 'C'
        END AS Shift
    FROM TRN_StationDefect
    WHERE MST_WorkStation_Id =  (select MST_WorkStation_Id 
			from MST_WorkStation 
			where WorkStationName = :WorkStationName
			and IsActive = 1) 
      AND CreatedDate BETWEEN @shiftAStart AND @shiftCEnd
    GROUP BY 
        CASE
            WHEN CreatedDate BETWEEN @shiftAStart AND @shiftAEnd THEN 'A'
            WHEN CreatedDate BETWEEN @shiftBStart AND @shiftBEnd THEN 'B'
            WHEN CreatedDate BETWEEN @shiftCStart AND @shiftCEnd THEN 'C'
        END
),

-- CTE for DefectCount
DefectCount AS (
    SELECT 
        COUNT(SerialNumber) AS DefectCount,
        CASE
            WHEN CreatedDate BETWEEN @shiftAStart AND @shiftAEnd THEN 'A'
            WHEN CreatedDate BETWEEN @shiftBStart AND @shiftBEnd THEN 'B'
            WHEN CreatedDate BETWEEN @shiftCStart AND @shiftCEnd THEN 'C'
        END AS Shift
    FROM TRN_StationDefect
    WHERE MST_WorkStation_Id = (select MST_WorkStation_Id 
			from MST_WorkStation 
			where WorkStationName =  :WorkStationName 
			and IsActive = 1)
      AND CreatedDate BETWEEN @shiftAStart AND @shiftCEnd
    GROUP BY 
        CASE
            WHEN CreatedDate BETWEEN @shiftAStart AND @shiftAEnd THEN 'A'
            WHEN CreatedDate BETWEEN @shiftBStart AND @shiftBEnd THEN 'B'
            WHEN CreatedDate BETWEEN @shiftCStart AND @shiftCEnd THEN 'C'
        END
),

-- Ensure all shifts are included
Shifts AS (
    SELECT 'A' AS Shift, 1 AS SortOrder
    UNION ALL
    SELECT 'B', 2
    UNION ALL
    SELECT 'C', 3
)

-- Final query to combine results with totals
SELECT 
    ROW_NUMBER() OVER (ORDER BY s.SortOrder) AS SNo,
    s.Shift,
    COALESCE(sc.SerialCount, 0) AS SerialCount,
    COALESCE(dc.DefectCount, 0) AS DefectCount,
    COALESCE(dsc.DefectSerialCount, 0) AS DefectSerialCount,
    s.SortOrder
FROM Shifts s
LEFT JOIN SerialCount sc ON s.Shift = sc.Shift
LEFT JOIN DefectCount dc ON s.Shift = dc.Shift
LEFT JOIN DefectSerialCount dsc ON s.Shift = dsc.Shift

UNION ALL

SELECT 
    NULL AS SNo, -- No serial number for the total row
    'Total' AS Shift,
    SUM(COALESCE(sc.SerialCount, 0)) AS SerialCount,
    SUM(COALESCE(dc.DefectCount, 0)) AS DefectCount,
    SUM(COALESCE(dsc.DefectSerialCount, 0)) AS DefectSerialCount,
    4 AS SortOrder  -- Ensure total is at the bottom
FROM Shifts s
LEFT JOIN SerialCount sc ON s.Shift = sc.Shift
LEFT JOIN DefectCount dc ON s.Shift = dc.Shift
LEFT JOIN DefectSerialCount dsc ON s.Shift = dsc.Shift

ORDER BY SortOrder;

DECLARE @cdate DATE =  :startDate ;

--SET @cdate = '2025-01-10';

-- Set Shift C date to the next day
DECLARE @shiftCDate DATE = DATEADD(DAY, 1, @cdate);

-- Define Shift start and end times
DECLARE @shiftAStart DATETIME = CAST(@cdate AS DATETIME) + '07:30:00.000';
DECLARE @shiftAEnd DATETIME = CAST(@cdate AS DATETIME) + '15:59:59.999';

DECLARE @shiftBStart DATETIME = CAST(@cdate AS DATETIME) + '16:00:00.000';
DECLARE @shiftBEnd DATETIME = CAST(@cdate AS DATETIME) + '23:59:59.999';

DECLARE @shiftCStart DATETIME = CAST(@shiftCDate AS DATETIME) + '00:00:00.000';
DECLARE @shiftCEnd DATETIME = CAST(@shiftCDate AS DATETIME) + '07:29:59.000';

-- CTE for categorizing shifts
WITH ShiftData AS (
    SELECT 
        CASE
            WHEN CreatedDate BETWEEN @shiftAStart AND @shiftAEnd THEN 'A'
            WHEN CreatedDate BETWEEN @shiftBStart AND @shiftBEnd THEN 'B'
            WHEN CreatedDate BETWEEN @shiftCStart AND @shiftCEnd THEN 'C'
        END AS Shift,
        start_time,
        end_time
    FROM trn_issueBtn
    WHERE Issue_type_id = 6
      AND (
          CreatedDate BETWEEN @shiftAStart AND @shiftAEnd
          OR CreatedDate BETWEEN @shiftBStart AND @shiftBEnd
          OR CreatedDate BETWEEN @shiftCStart AND @shiftCEnd
      )
)

-- Main query to sum downtime minutes and sort by shift
SELECT 
    Shift,
    SUM(DATEDIFF(MINUTE, start_time, end_time)) AS TotalDowntimeMinutes
FROM ShiftData
GROUP BY Shift
ORDER BY 
    CASE
        WHEN Shift = 'A' THEN 1
        WHEN Shift = 'B' THEN 2
        WHEN Shift = 'C' THEN 3
    END;

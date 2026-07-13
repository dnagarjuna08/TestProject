-- Created By Nag update by asagar3

DECLARE @cdate DATE = :Date;

-- Set Shift C date to the next day
DECLARE @shiftCDate DATE = DATEADD(DAY, 1, @cdate);

-- Define Shift start and end times
DECLARE @shiftAStart DATETIME = CAST(@cdate AS DATETIME) + '07:30:00.000';
DECLARE @shiftAEnd DATETIME = CAST(@cdate AS DATETIME) + '15:59:59.999';

DECLARE @shiftBStart DATETIME = CAST(@cdate AS DATETIME) + '16:00:00.000';
DECLARE @shiftBEnd DATETIME = CAST(@cdate AS DATETIME) + '23:59:59.999';

DECLARE @shiftCStart DATETIME = CAST(@shiftCDate AS DATETIME) + '00:00:00.000';
DECLARE @shiftCEnd DATETIME = CAST(@shiftCDate AS DATETIME) + '07:29:59.000';

-- Collect and categorize serials by shift and type
WITH ShiftedData AS (
    SELECT 
        CASE
            WHEN CreatedDate BETWEEN @shiftAStart AND @shiftAEnd THEN 'A'
            WHEN CreatedDate BETWEEN @shiftBStart AND @shiftBEnd THEN 'B'
            WHEN CreatedDate BETWEEN @shiftCStart AND @shiftCEnd THEN 'C'
        END AS Shift,
        CASE 
            WHEN SUBSTRING(SerialNumber, CHARINDEX('-', SerialNumber) - 2, 2) = 'HD' THEN 'HD'
            WHEN SUBSTRING(SerialNumber, CHARINDEX('-', SerialNumber) - 2, 2) = 'LD' THEN 'LD'
            ELSE 'Unknown'
        END AS Type,
        SerialNumber
    FROM TRN_StationStatus
    WHERE 
        MST_WorkStation_Id =  :workstation  AND
        (
            CreatedDate BETWEEN @shiftAStart AND @shiftAEnd OR
            CreatedDate BETWEEN @shiftBStart AND @shiftBEnd OR
            CreatedDate BETWEEN @shiftCStart AND @shiftCEnd
        )
),
Aggregated AS (
    SELECT 
        Shift,
        Type,
        COUNT(DISTINCT SerialNumber) AS Count
    FROM ShiftedData
    WHERE Type IN ('HD', 'LD')
    GROUP BY Shift, Type
)
-- Final result: Shift-wise counts
SELECT 
    Shift,
    SUM(CASE WHEN Type = 'HD' THEN Count ELSE 0 END) AS HD,
    SUM(CASE WHEN Type = 'LD' THEN Count ELSE 0 END) AS LD,
    SUM(Count) AS Total
FROM Aggregated
GROUP BY Shift

UNION ALL

-- Add a total row
SELECT 
    'Total' AS Shift,
    SUM(CASE WHEN Type = 'HD' THEN Count ELSE 0 END),
    SUM(CASE WHEN Type = 'LD' THEN Count ELSE 0 END),
    SUM(Count)
FROM Aggregated;


--Author: Aniket Sagar date:12/Jan/2025

DECLARE @cdate DATE = :startDate  ;

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

-- Use a CTE for the pivot table
WITH PivotedData AS (
    SELECT 
        Shift,
        [1] AS [Emergency],
        [2] AS [Inline],
        [3] AS [Machine],
        [4] AS [Material],
        [5] AS [Quality]
    FROM (
        SELECT 
            CASE
                WHEN CreatedDate BETWEEN @shiftAStart AND @shiftAEnd THEN 'A'
                WHEN CreatedDate BETWEEN @shiftBStart AND @shiftBEnd THEN 'B'
                WHEN CreatedDate BETWEEN @shiftCStart AND @shiftCEnd THEN 'C'
            END AS Shift,
            Issue_type_id AS IssueType,
            DATEDIFF(MINUTE, start_time, end_time) AS DowntimeMinutes
        FROM TRN_issueBtn
        WHERE Issue_type_id IN (1, 2, 3, 4, 5)
          AND (
              (CreatedDate BETWEEN @shiftAStart AND @shiftAEnd)
              OR (CreatedDate BETWEEN @shiftBStart AND @shiftBEnd)
              OR (CreatedDate BETWEEN @shiftCStart AND @shiftCEnd)
          )
    ) SourceTable
    PIVOT (
        SUM(DowntimeMinutes)
        FOR IssueType IN ([1], [2], [3], [4], [5])
    ) AS PVT
)

-- Final SELECT with totals
SELECT 
    Shift,
    ISNULL(Emergency, 0) AS [Emergency],
    ISNULL(Inline, 0) AS [Inline],
    ISNULL(Machine, 0) AS [Machine],
    ISNULL(Material, 0) AS [Material],
    ISNULL(Quality, 0) AS [Quality],
    ISNULL(Emergency, 0) + ISNULL(Inline, 0) + ISNULL(Machine, 0) + ISNULL(Material, 0) + ISNULL(Quality, 0) AS Total,
    CASE Shift
        WHEN 'A' THEN 1
        WHEN 'B' THEN 2
        WHEN 'C' THEN 3
        ELSE 4
    END AS SortOrder
FROM PivotedData

-- Union for grand total
UNION ALL
SELECT 
    'Total',
    SUM(ISNULL(Emergency, 0)) AS [Emergency],
    SUM(ISNULL(Inline, 0)) AS [Inline],
    SUM(ISNULL(Machine, 0)) AS [Machine],
    SUM(ISNULL(Material, 0)) AS [Material],
    SUM(ISNULL(Quality, 0)) AS [Quality],
    SUM(ISNULL(Emergency, 0) + ISNULL(Inline, 0) + ISNULL(Machine, 0) + ISNULL(Material, 0) + ISNULL(Quality, 0)) AS Total,
    5 AS SortOrder
FROM PivotedData

-- Order by SortOrder
ORDER BY SortOrder;

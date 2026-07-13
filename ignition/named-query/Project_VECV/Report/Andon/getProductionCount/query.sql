 
-- Created By Nag

declare @cdate date =   :curDate  ;

--set @cdate = '2024-02-26'


-- Set Shift C date to the next day
DECLARE @shiftCDate DATE = DATEADD(DAY, 1, @cdate);

-- Define Shift start and end times
DECLARE @shiftAStart DATETIME = CAST(@cdate AS DATETIME) + '07:30:00.000';
DECLARE @shiftAEnd DATETIME = CAST(@cdate AS DATETIME) + '15:59:59.999';

DECLARE @shiftBStart DATETIME = CAST(@cdate AS DATETIME) + '16:00:00.000';
DECLARE @shiftBEnd DATETIME = CAST(@cdate AS DATETIME) + '23:59:59.999';

DECLARE @shiftCStart DATETIME = CAST(@shiftCDate AS DATETIME) + '00:00:00.000';
DECLARE @shiftCEnd DATETIME = CAST(@shiftCDate AS DATETIME) + '07:29:59.000';

-- Query for counting distinct Serial Numbers by shift
SELECT 
    COUNT(DISTINCT SerialNumber) AS SerialCount,
    CASE
        WHEN CreatedDate BETWEEN @shiftAStart AND @shiftAEnd THEN 'A'
        WHEN CreatedDate BETWEEN @shiftBStart AND @shiftBEnd THEN 'B'
        WHEN CreatedDate BETWEEN @shiftCStart AND @shiftCEnd THEN 'C'
    END AS Shift
FROM TRN_StationStatus
WHERE MST_WorkStation_Id = '331' 
  AND (
      (CreatedDate BETWEEN @shiftAStart AND @shiftAEnd)
      OR (CreatedDate BETWEEN @shiftBStart AND @shiftBEnd)
      OR (CreatedDate BETWEEN @shiftCStart AND @shiftCEnd)
  )
GROUP BY 
    CASE
        WHEN CreatedDate BETWEEN @shiftAStart AND @shiftAEnd THEN 'A'
        WHEN CreatedDate BETWEEN @shiftBStart AND @shiftBEnd THEN 'B'
        WHEN CreatedDate BETWEEN @shiftCStart AND @shiftCEnd THEN 'C'
    END;
  

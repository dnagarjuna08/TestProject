DECLARE @currentDateTime DATETIME = GETDATE();  -- Get the current date and time
DECLARE @cdate DATE = CAST(@currentDateTime AS DATE);

DECLARE @shiftCDate DATE = DATEADD(DAY, 1, @cdate);

-- Define Shift start and end times
DECLARE @shiftAStart DATETIME = CAST(@cdate AS DATETIME) + '07:30:00.000';
DECLARE @shiftAEnd DATETIME = CAST(@cdate AS DATETIME) + '15:59:59.999';

DECLARE @shiftBStart DATETIME = CAST(@cdate AS DATETIME) + '16:00:00.000';
DECLARE @shiftBEnd DATETIME = CAST(@cdate AS DATETIME) + '23:59:59.999';

DECLARE @shiftCStart DATETIME = CAST(@shiftCDate AS DATETIME) + '00:00:00.000';
DECLARE @shiftCEnd DATETIME = CAST(@shiftCDate AS DATETIME) + '07:29:59.999';

DECLARE @currentShift VARCHAR(10);

IF @currentDateTime BETWEEN @shiftAStart AND @shiftAEnd
    SET @currentShift = 'ShiftA';
ELSE IF @currentDateTime BETWEEN @shiftBStart AND @shiftBEnd
    SET @currentShift = 'ShiftB';
ELSE IF @currentDateTime BETWEEN @shiftCStart AND @shiftCEnd
    SET @currentShift = 'ShiftC';


-- Return counts of IssueType for the current shift
SELECT 
    COUNT(*) AS IssueCount,
    Issue_type_id AS IssueType

FROM 
    TRN_issueBtn
WHERE 
    Issue_type_id IN (2, 3, 4, 5)
    AND (
        (@currentShift = 'ShiftA' AND CreatedDate BETWEEN @shiftAStart AND @shiftAEnd) OR
        (@currentShift = 'ShiftB' AND CreatedDate BETWEEN @shiftBStart AND @shiftBEnd) OR
        (@currentShift = 'ShiftC' AND CreatedDate BETWEEN @shiftCStart AND @shiftCEnd)
    )
GROUP BY 
    Issue_type_id
ORDER BY 
    Issue_type_id;



DECLARE @ipDate DATETIME =  :date ; -- Set user input date

WITH ShiftData AS (
    SELECT 
        ts.SerialNumber,
        ts.CreatedDate,
        td.SerialNumber AS DefectSerial,
        CASE 
            WHEN ts.CreatedDate BETWEEN DATEADD(MINUTE, 30, DATEADD(HOUR, 7, @ipDate)) 
                                 AND DATEADD(MINUTE, -1, DATEADD(HOUR, 16, @ipDate)) THEN 'A'
            WHEN ts.CreatedDate BETWEEN DATEADD(HOUR, 16, @ipDate) 
                                 AND DATEADD(MINUTE, -1, DATEADD(HOUR, 24, @ipDate)) THEN 'B'
            WHEN ts.CreatedDate BETWEEN DATEADD(HOUR, 0, DATEADD(DAY, 1, @ipDate)) 
                                 AND DATEADD(MINUTE, 29, DATEADD(HOUR, 7, DATEADD(DAY, 1, @ipDate))) THEN 'C'
        END AS ShiftCategory
    FROM TRN_StationStatus AS ts
    LEFT JOIN TRN_StationDefect td ON td.SerialNumber = ts.SerialNumber
    WHERE ts.MST_WorkStation_Id = 331
    AND ts.CreatedDate BETWEEN DATEADD(HOUR, 7, @ipDate) + '00:30:00'  -- 7:30 AM
                          AND DATEADD(HOUR, 7, DATEADD(DAY, 1, @ipDate)) + '00:29:59'  -- Next day 7:29 AM
)

SELECT 
    COALESCE(ShiftCategory, 'Total') AS Shift,
    COUNT(DISTINCT SerialNumber) AS SerialCount,
    COUNT(DISTINCT CASE WHEN DefectSerial IS NOT NULL THEN SerialNumber END) AS DefectSerialCount
FROM ShiftData
GROUP BY ROLLUP (ShiftCategory)
ORDER BY 
    CASE 
        WHEN ShiftCategory = 'A' THEN 1
        WHEN ShiftCategory = 'B' THEN 2
        WHEN ShiftCategory = 'C' THEN 3
        ELSE 4
    END;



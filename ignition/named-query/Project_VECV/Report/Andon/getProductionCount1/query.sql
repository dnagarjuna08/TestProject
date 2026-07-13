DECLARE @InputDate DATE = :curDate;  -- Replace with your input date

SELECT 
    CASE 
        WHEN CAST(CreatedDate AS TIME) >= '07:30:00' AND CAST(CreatedDate AS TIME) < '15:59:59' THEN 'A'
        WHEN CAST(CreatedDate AS TIME) >= '16:00:00' AND CAST(CreatedDate AS TIME) < '23:59:59' THEN 'B'
        ELSE 'C'
    END AS Shift,
    COUNT(DISTINCT serialNumber) AS SerialCount
FROM 
    TRN_Station_Events 
WHERE 
    [MST_WorkStation_Id] IN ('332') AND
    --MST_Area_Id = 26 AND 
    MST_Event_Id = 5 AND
    (
        (CAST(CreatedDate AS DATE) = @InputDate AND CAST(CreatedDate AS TIME) >= '07:30:00')  -- A Shift
        OR 
        (CAST(CreatedDate AS DATE) = DATEADD(DAY, 1, @InputDate) AND CAST(CreatedDate AS TIME) < '07:30:00')  -- C Shift (from the next day)
    )
GROUP BY 
    CASE 
        WHEN CAST(CreatedDate AS TIME) >= '07:30:00' AND CAST(CreatedDate AS TIME) < '15:59:59' THEN 'A'
        WHEN CAST(CreatedDate AS TIME) >= '16:00:00' AND CAST(CreatedDate AS TIME) < '23:59:59' THEN 'B'
        ELSE 'C'
    END;

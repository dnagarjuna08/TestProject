WITH FilteredData AS (
    SELECT
        distinct SerialNumber,
        SUBSTRING((SerialNumber),12,8) as DHCode,
        TRN_StationStatus.CreatedDate,
        ROW_NUMBER() OVER (PARTITION BY SerialNumber ORDER BY TRN_StationStatus.CreatedDate) AS RowNum
    FROM TRN_StationStatus
    inner join MST_WorkStation on MST_WorkStation.MST_WorkStation_Id=TRN_StationStatus.MST_WorkStation_Id
    WHERE
       MST_WorkStation.WorkStationName=   :Workstation 
        AND TRN_StationStatus.CreatedDate >=   :FromDate 
        AND TRN_StationStatus.CreatedDate <=   :ToDate 
        and TRN_StationStatus.MST_Status_Id='2' and TRN_StationStatus.SerialNumber like '%ID%'
)
SELECT
    ISNULL(DHCode, 'Total') AS DHCode,
    COUNT(*) AS Count
FROM FilteredData
WHERE RowNum = 1
GROUP BY GROUPING SETS (DHCode, ())
ORDER BY CASE WHEN DHCode = 'Total' THEN 1 ELSE 0 END, Count DESC;


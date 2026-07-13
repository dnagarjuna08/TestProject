DECLARE @TakeinStatus NVARCHAR(10) = :TakeinStatus;
DECLARE @Linename NVARCHAR(50) = :Line; 

SELECT 
    ar.AreaName,
    li.LineName,
    tk.SerialNumber,
    wr.WorkStationName AS TakeoutFrom,
    -- us.UserName AS UserName,
    tk.CreatedDate AS TakeoutCreatedDate,
    -- tk.Remarks,
    wr2.WorkStationName AS TakeinStation,
    CASE 
        WHEN tk.TakeIn_Station IS NULL THEN 'NoK' 
        ELSE 'OK'
    END AS TakeinStatus, -- New column
    df.DefectCategory,
    dn.DefectName,
    trd.Comments,
    -- trd.CreatedDate AS DefectCreatedDate,
    tk.TakeIn_Time
FROM 
    TRN_TakeIn_TakeOut AS tk
INNER JOIN 
    MST_Area AS ar ON ar.MST_Area_Id = tk.MST_Area_Id
INNER JOIN 
    MST_Line AS li ON li.MST_Line_Id = tk.MST_Line_Id
INNER JOIN 
    MST_WorkStation AS wr ON wr.MST_WorkStation_Id = tk.TakeOut_Station
LEFT JOIN 
    MST_WorkStation AS wr2 ON wr2.MST_WorkStation_Id = tk.TakeIn_Station
LEFT JOIN 
    TRN_StationDefect AS trd ON 
        trd.SerialNumber = tk.SerialNumber 
        AND ABS(DATEDIFF(SECOND, tk.CreatedDate, trd.CreatedDate)) <= 5 -- Match within 1 minute
-- LEFT JOIN MST_User AS us ON us.MST_User_Id = tk.TakeOut_OperatorID
INNER JOIN 
    MST_Defect AS df ON df.MST_Defect_Id = trd.MST_Defect_Id
INNER JOIN 
    MST_DefectName AS dn ON dn.MST_DefectName_Id = trd.MST_DefectName_Id
INNER JOIN 
    MST_DefectStatus AS ds ON ds.MST_DefectStatus_Id = trd.MST_DefectStatus_Id
-- WHERE tk.SerialNumber = 'TA032639LD-RA310'
WHERE 
    tk.CreatedDate >= :FromDate 
    AND tk.CreatedDate <= :ToDate 
    AND (@TakeinStatus = '' OR 
         CASE 
            WHEN tk.TakeIn_Station IS NULL THEN 'NoK' 
            ELSE 'OK'
         END = @TakeinStatus) -- Filter based on parameter
    AND ar.AreaName = :Area 
    AND (@Linename = '' OR li.LineName = @Linename) -- Properly use @Linename
ORDER BY 
    tk.CreatedDate DESC;

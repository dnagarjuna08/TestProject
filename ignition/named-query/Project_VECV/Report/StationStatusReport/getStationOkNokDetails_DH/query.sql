DECLARE @LineName NVARCHAR(MAX) =  :LineName ;
DECLARE @AreaName NVARCHAR(MAX) =  :AreaName ;
DECLARE @AreaId INT;  
DECLARE @LineId INT; 
DECLARE @FromDate DATETIME =  :FromDate ;
DECLARE @ToDate DATETIME =  :ToDate ;
DECLARE @ColumnNames NVARCHAR(MAX);
DECLARE @Sql NVARCHAR(MAX);

SELECT @AreaId = (SELECT MST_Area_Id FROM MST_Area WHERE AreaName = @AreaName AND IsActive = 1);
SELECT @LineId = (SELECT MST_Line_Id FROM MST_Line WHERE LineName = @LineName AND IsActive = 1);

-- Build dynamic column list
SELECT @ColumnNames = STUFF((
    SELECT ', ' + QUOTENAME(WorkStationName)
    FROM MST_WorkStation 
    WHERE MST_Area_Id = @AreaId AND MST_Line_Id = @LineId AND IsActive = 1 
    FOR XML PATH('')), 1, 2, '');

-- Dynamic SQL with unique serial numbers
SET @Sql = N'
WITH dc AS (
    SELECT DISTINCT
        t.SerialNumber,
        w.WorkStationName,
        e.Status AS result
    FROM TRN_StationStatus t
    INNER JOIN MST_WorkStation w WITH (NOLOCK) ON t.MST_WorkStation_Id = w.MST_WorkStation_Id
    INNER JOIN MST_Status e WITH (NOLOCK) ON t.MST_Status_Id = e.MST_Status_Id
    WHERE 
        t.SerialNumber IS NOT NULL 
        AND t.SerialNumber != '''' 
        AND t.CreatedDate BETWEEN @FromDate AND @ToDate
        AND LEN(t.SerialNumber) = 19
), dt AS (
    SELECT DISTINCT 
        TSS.SerialNumber, 
        TSS.CreatedDate
    FROM TRN_StationStatus TSS
    INNER JOIN mst_workstation MW ON MW.MST_WorkStation_Id = TSS.MST_WorkStation_Id
    WHERE 
        TSS.MST_Area_Id = @AreaId
        
        AND TSS.IsActive = 1
        AND TSS.IsDeleted = 0
        AND MW.MST_WorkStationType_Id = 4
        AND MW.IsActive = 1
        AND MW.IsDeleted = 0
        AND TSS.CreatedDate BETWEEN @FromDate AND @ToDate 
        AND LEN(TSS.SerialNumber) = 19
), finalOutput AS (
    SELECT 
        dc.SerialNumber,
        dc.WorkStationName,
        MAX(CASE 
            WHEN dc.result = ''OK'' THEN ''OK''
            WHEN dc.result = ''NOK'' THEN ''NOK''
            ELSE NULL 
        END) AS result
    FROM dc
    GROUP BY dc.SerialNumber, dc.WorkStationName
), rankedOutput AS (
    SELECT 
        ROW_NUMBER() OVER (PARTITION BY dt.SerialNumber ORDER BY dt.CreatedDate ASC) AS rn,
        dt.SerialNumber,
        dt.CreatedDate,
        CASE WHEN CAST(dt.CreatedDate AS TIME) BETWEEN ''07:30:00'' AND ''15:59:59'' THEN ''A'' 
             WHEN CAST(dt.CreatedDate AS TIME) BETWEEN ''16:00:00'' AND ''23:59:59'' THEN ''B'' 
             ELSE ''C'' END AS SHIFT,
        ' + @ColumnNames + '
    FROM finalOutput 
    PIVOT (
        MAX(result)
        FOR WorkStationName IN (' + @ColumnNames + ')
    ) AS pvt
    INNER JOIN dt ON dt.SerialNumber = pvt.SerialNumber
)
SELECT [Sr.No] = ROW_NUMBER() OVER (ORDER BY CreatedDate),
       SerialNumber, CreatedDate, SHIFT, ' + @ColumnNames + '
FROM rankedOutput
WHERE rn = 1  -- Keep only the first occurrence per SerialNumber
ORDER BY CreatedDate, SerialNumber;
';

EXEC sp_executesql @Sql, N'@AreaId INT, @FromDate DATETIME, @ToDate DATETIME', @AreaId, @FromDate, @ToDate;

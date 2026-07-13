DECLARE @TableName NVARCHAR(128),
        @SQL NVARCHAR(MAX),
        @Tagpath NVARCHAR(MAX) =  :Station,
        @LikePattern NVARCHAR(MAX),
        @StartDateTime DATETIME2(3) =  :StartDateTime,
        @EndDateTime   DATETIME2(3) =  :EndDateTime,
        @StartTS BIGINT,
        @EndTS BIGINT;

-- Convert IST to UTC by subtracting 330 minutes (5 hours 30 minutes)
SET @StartTS = DATEDIFF_BIG(MILLISECOND, '1970-01-01', DATEADD(MINUTE, -330, @StartDateTime));
SET @EndTS = DATEDIFF_BIG(MILLISECOND, '1970-01-01', DATEADD(MINUTE, -330, @EndDateTime));

-- Get the partition that contains the start of the time range
SELECT @TableName = pname
FROM [sqlth_partitions]
WHERE 
    start_time <= CAST(DATEDIFF(SECOND, '19700101', :GETDATE) AS BIGINT) * 1000
    AND end_time >= CAST(DATEDIFF(SECOND, '19700101', :GETDATE) AS BIGINT) * 1000;
-- Exit if no partition is found
IF @TableName IS NULL
BEGIN
    RAISERROR('No valid partition found for the given time range.', 16, 1);
    RETURN;
END

-- Prepare the LIKE pattern
SET @LikePattern = '%' + @Tagpath + '/%';

-- Build dynamic SQL
SET @SQL = N'
SELECT SQ.tagid, 
       SP.tagpath, 
       COALESCE(CAST(SQ.intvalue AS NVARCHAR(255)), CAST(SQ.floatvalue AS NVARCHAR(255)), CAST(SQ.stringvalue AS NVARCHAR(255))) AS dataValues,
       -- Convert Ignition t_stamp to IST with millisecond precision
       DATEADD(MILLISECOND, SQ.[t_stamp] % 1000, 
               DATEADD(MINUTE, 330, DATEADD(SECOND, SQ.[t_stamp] / 1000, ''1970-01-01 00:00:00''))) AS Timestamp,
       -- Extract tag name from full path
       REVERSE(SUBSTRING(REVERSE(SP.tagpath), 1, CHARINDEX(''/'', REVERSE(SP.tagpath)) - 1)) AS TagName
FROM ' + QUOTENAME(@TableName) + ' SQ
INNER JOIN [dbo].[sqlth_te] SP 
    ON SP.id = SQ.tagid
WHERE SP.tagpath LIKE @LikePattern
  AND SQ.[t_stamp] BETWEEN @StartTS AND @EndTS
ORDER BY Timestamp DESC;';

-- Execute the dynamic query
EXEC sp_executesql @SQL, 
    N'@LikePattern NVARCHAR(MAX), @StartTS BIGINT, @EndTS BIGINT',
    @LikePattern, @StartTS, @EndTS;

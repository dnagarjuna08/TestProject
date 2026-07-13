DECLARE @startStationId INT ,
        @startDate DATETIME =  :startDate ,
        @endDate DATETIME = :endDate ,
        @endStationId INT ;
        
        select @startStationId = MST_WorkStation_Id from MST_WorkStation where WorkStationName = :StartStation
		select @endStationId = MST_WorkStation_Id from MST_WorkStation where WorkStationName = :EndStation;
        
    WITH FilteredData AS (
        SELECT DISTINCT 
               SerialNumber, 
               SUBSTRING(SerialNumber, 12, 16) AS [BOM Number]
        FROM TRN_StationStatus
        WHERE MST_WorkStation_Id = @startStationId 
          AND TRN_StationStatus.CreatedDate BETWEEN @startDate AND @endDate
          AND SerialNumber NOT IN (
              SELECT DISTINCT SerialNumber 
              FROM TRN_StationStatus 
              WHERE MST_WorkStation_Id = @endStationId
               AND TRN_StationStatus.CreatedDate BETWEEN @startDate AND @endDate
          )
    )
    SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS [Sr. Number], 
           SerialNumber AS [Serial Number], 
           [BOM Number]
    FROM FilteredData
    ORDER BY [BOM Number]
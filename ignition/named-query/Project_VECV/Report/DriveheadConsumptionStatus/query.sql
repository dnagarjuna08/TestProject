DECLARE @FromDate DATETIME = :FromDate;
DECLARE @ToDate DATETIME =  :ToDate;
DECLARE @LAD10Id INT = (SELECT TOP 1 MST_WorkStation_Id FROM MST_WorkStation WHERE WorkStationName='LAD10');
DECLARE @LAML130Id INT = (SELECT TOP 1 MST_WorkStation_Id FROM MST_WorkStation WHERE WorkStationName='LAML130');
DECLARE @LAH20Id INT = (SELECT TOP 1 MST_WorkStation_Id FROM MST_WorkStation WHERE WorkStationName='LAH20');
DECLARE @LAML120Id INT = (SELECT TOP 1 MST_WorkStation_Id FROM MST_WorkStation WHERE WorkStationName='LAML120');
WITH DroppedSN AS (
    SELECT DISTINCT D.ConsumedSerialNumber
    FROM TRN_Operation_Data D
    INNER JOIN TRN_Station_Events E
        ON D.TRN_Station_Events_Id = E.TRN_Station_Events_Id
    WHERE E.MST_OPDefinition_Id = '3'
        AND E.MST_WorkStation_Id = @LAML130Id
        AND E.MST_Event_Id = '5'
        AND D.ConsumedSerialNumber != ''
),
FirstQuery AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY S.CreatedDate DESC) AS SNo,
        S.SerialNumber AS DHSerialNumber,
        S.CreatedDate AS DHOrderStartDate,
        PO.special_instruction AS DHOrderType,
        CASE
            WHEN D.ConsumedSerialNumber IS NOT NULL THEN 'Dropped'
            ELSE 'Not Dropped'
        END AS DHStatusonLAML130
    FROM TRN_StationStatus S
    INNER JOIN PRODUCTION_ORDER PO
        ON S.SerialNumber = PO.serial_number
    LEFT JOIN DroppedSN D  
        ON S.SerialNumber = D.ConsumedSerialNumber
    WHERE S.MST_WorkStation_Id = @LAD10Id
      AND LEN(S.SerialNumber) = 19
      AND S.CreatedDate BETWEEN @FromDate AND @ToDate
),
SecondQuery AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY T.CreatedDate DESC) AS RowNum,
        T.SerialNumber AS PreLAML130,
        T.CreatedDate AS HubOrderStartDate
    FROM TRN_StationStatus T
    WHERE T.MST_WorkStation_Id = @LAH20Id
      AND T.CreatedDate BETWEEN @FromDate AND @ToDate
      AND NOT EXISTS (
          SELECT 1
          FROM TRN_StationStatus L120
          WHERE L120.SerialNumber = T.SerialNumber
            AND L120.MST_WorkStation_Id = @LAML120Id
      )
)

SELECT
    COALESCE(F.SNo, S.RowNum) AS SNo,
    ISNULL(F.DHSerialNumber, 'NA') AS DHSerialNumber,
    ISNULL(CONVERT(VARCHAR(19), F.DHOrderStartDate, 120), 'NA') AS DHOrderStartDate,
    ISNULL(F.DHOrderType, 'NA') AS DHOrderType,
    ISNULL(F.DHStatusOnLAML130, 'NA') AS DHStatusOnLAML130,
    ISNULL(S.PreLAML130, 'NA') AS PreLAML130,
    ISNULL(CONVERT(VARCHAR(19), S.HubOrderStartDate, 120), 'NA') AS HubOrderStartDate
FROM FirstQuery F
FULL OUTER JOIN SecondQuery S
    ON F.SNo = S.RowNum
ORDER BY SNo;
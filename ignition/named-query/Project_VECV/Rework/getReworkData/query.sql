WITH RankedDefects AS (
    SELECT 
        TT.SerialNumber, 
        TT.OrderNumber, 
        B.M_BOMNumber, 
        B.M_BOM_Id, 
        MA.AreaName, 
        MA.MST_Area_Id, 
        ML.LineName, 
        ML.MST_Line_Id,
        MW.WorkStationName, 
        MW.MST_WorkStation_Id, 
        TT.CreatedDate, 
        D.DefectCategory, 
        TT.Remarks,
        ROW_NUMBER() OVER (PARTITION BY TT.SerialNumber ORDER BY TT.CreatedDate) AS SrNo
    FROM TRN_TakeIn_TakeOut AS TT
    INNER JOIN TRN_ReleasedProductionOrder AS RPO 
        ON RPO.SerialNumber = TT.SerialNumber AND RPO.IsTakeout = 1
    INNER JOIN M_BOM AS B 
        ON B.M_BOM_Id = TT.M_BOM_Id
    INNER JOIN MST_Area AS MA 
        ON MA.MST_Area_Id = TT.MST_Area_Id
    INNER JOIN MST_Line AS ML 
        ON ML.MST_Line_Id = TT.MST_Line_Id
    INNER JOIN MST_WorkStation AS MW 
        ON MW.MST_WorkStation_Id = TT.TakeOut_Station
    LEFT JOIN TRN_StationDefect AS SD 
        ON SD.SerialNumber = TT.SerialNumber
    LEFT JOIN MST_Defect AS D 
        ON D.MST_Defect_Id = SD.MST_Defect_Id
)
SELECT 
    rd.SerialNumber, 
    rd.OrderNumber, 
    rd.M_BOM_Id, 
    rd.M_BOMNumber, 
    rd.MST_Area_Id, 
    rd.AreaName, 
    rd.MST_Line_Id, 
    rd.LineName, 
    rd.MST_WorkStation_Id, 
    rd.WorkStationName, 
    rd.CreatedDate, 
    rd.DefectCategory,
    ISNULL(
        MAX(
            CASE 
                WHEN SE.MST_Event_Id = 3 THEN 1 
                ELSE 0 
            END
        ), 
        0
    ) AS [Action], 
    rd.Remarks
FROM RankedDefects AS rd
LEFT JOIN TRN_Station_Events AS SE
    ON SE.SerialNumber = rd.SerialNumber 
    AND SE.MST_WorkStation_Id =  :WorkStationId
WHERE rd.SrNo = 1
GROUP BY 
    rd.SerialNumber, 
    rd.OrderNumber, 
    rd.M_BOM_Id, 
    rd.M_BOMNumber, 
    rd.MST_Area_Id, 
    rd.AreaName, 
    rd.MST_Line_Id, 
    rd.LineName, 
    rd.MST_WorkStation_Id, 
    rd.WorkStationName, 
    rd.CreatedDate, 
    rd.DefectCategory, 
    rd.Remarks
ORDER BY rd.CreatedDate;

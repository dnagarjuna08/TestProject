WITH CTE AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY EPQ.OrderSequence) AS RowIndex,
        B.M_BOMNumber,
        M.M_MaterialNumber as PartName,
        EPQ.[Description],
        EPQ.ALTERNATEPART as AlternatePart,
        EPQ.MST_ErrorProofQG_Id,
        EPQ.MST_ErrorProofQG_Id as ErrorProofId,
        OrderSequence as seq
    FROM 
        MST_ErrorProofQG EPQ
    INNER JOIN 
        M_BOM B ON EPQ.M_BOM_Id = B.M_BOM_Id
    INNER JOIN 
        M_Material M ON EPQ.M_Material_Id = M.M_Material_Id
    INNER JOIN 
        MST_WorkStation WS ON WS.MST_WorkStation_Id = EPQ.MST_WorkStation_Id
    WHERE 
        B.M_BOMNumber = :BomNumber  
        AND WS.WorkStationName = :WorkStation 
        and EPQ.IsActive=1 and EPQ.IsDeleted=0
        AND EPQ.MST_ErrorProofQG_Id NOT IN (
            SELECT T.MST_ErrorProofQG_Id FROM TRN_ErrorProofQuality T
            INNER JOIN MST_ErrorProofQG E ON E.MST_ErrorProofQG_Id = T.MST_ErrorProofQG_Id
            WHERE [status] <> 0 AND T.ConsumedSerialNumber = :SerialNumber 
        )
)
SELECT 
    RowIndex,
    M_BOMNumber,
    PartName,
    AlternatePart,
    [Description],
    MST_ErrorProofQG_Id,
    ErrorProofId,
    CASE WHEN RowIndex = 1 THEN 1 ELSE 0 END AS ConsumedPart
FROM CTE
order by seq asc;
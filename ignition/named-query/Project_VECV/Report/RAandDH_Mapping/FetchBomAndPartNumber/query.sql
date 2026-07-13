SELECT MM.M_BOMNumber BOM ,MT.M_MaterialNumber [Part Number]
FROM TRN_ErrorProof EP
INNER JOIN MST_WorkStation WS ON WS.MST_WorkStation_Id = EP.MST_WorkStation_Id
INNER JOIN M_BOM MM ON MM.M_BOM_Id = EP.M_BOM_Id
INNER JOIN M_Material MT ON MT.M_Material_Id = EP.M_Material_Id
WHERE EP.MST_Area_Id = :AreaID
AND WS.WorkStationName = :WorkStationName
AND (:BOM  = '' OR MM.M_BOMNumber = :BOM)
AND EP.IsDeleted = 0
AND EP.IsActive = 1
AND EP.Description LIKE 'DIFF%'
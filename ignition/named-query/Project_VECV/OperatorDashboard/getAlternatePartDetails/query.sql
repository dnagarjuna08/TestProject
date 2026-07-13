SELECT ALTERNATEPART
FROM TRN_ErrorProof
WHERE MST_WorkStation_Id =  :WorkStationId 
  AND M_BOM_Id =  :BOMId 
  AND IsActive = 1
  AND IsDeleted = 0
  AND M_Material_Id= :PartId 
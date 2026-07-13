SELECT *
FROM  MST_Checklist 
WHERE  MST_Model_Id = :modelId AND
MST_Area_Id = :areaId AND
MST_Line_Id = :lineId AND
MST_WorkStation_Id = :workstationId AND
SequenceNum = :sequence AND
M_BOM_Id =  :bomId AND
IsActive = 1 AND IsDeleted=0
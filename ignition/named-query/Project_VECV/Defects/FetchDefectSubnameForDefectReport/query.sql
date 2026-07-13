SELECT DefecSubName 
FROM MST_DefectSUBName 
WHERE isactive = 1 
  AND (:defectNameId IS NOT NULL) 
  AND MST_DefectName_Id = (SELECT MST_DefectName_Id FROM MST_DefectName WHERE IsActive = 1 AND DefectName = :defectNameId)

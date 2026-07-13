SELECT MST_DefectSUBName_Id, DefecSubName 
FROM MST_DefectSUBName 
WHERE isactive = 1 
  AND (:defectNameId IS NOT NULL) 
  AND MST_DefectName_Id = :defectNameId

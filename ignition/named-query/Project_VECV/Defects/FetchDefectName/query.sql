SELECT DefectName
FROM MST_DefectName DN
INNER JOIN MST_Defect MD ON MD.MST_Defect_Id = DN.MST_Defect_Id
WHERE MD.DefectCategory = :DefectCategory 
AND  DN.IsActive = 1 
AND DN.IsDeleted = 0
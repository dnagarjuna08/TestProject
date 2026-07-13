SELECT dn.DefectName AS "Defect Name"
FROM MST_DefectName dn
INNER JOIN MST_Defect d ON d.MST_Defect_Id = dn.MST_Defect_Id 
WHERE dn.Isactive = 1
  AND d.DefectCategory = :DefectCategory

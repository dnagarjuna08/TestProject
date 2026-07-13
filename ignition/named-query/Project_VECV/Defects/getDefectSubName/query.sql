/*********************************************/
-- Modified by: Anand Choudhary
-- Modified Date: 12/11/2025
-- Purpose: Fetch Defect Subname
-- Used in: Workstation, Quality Gate, Defect Report

/*********************************************/
SELECT MST_DefectSUBName_Id, DefecSubName 
FROM MST_DefectSUBName 
WHERE isactive = 1 
  AND (:defectNameId IS NOT NULL) 
  AND MST_DefectName_Id = :defectNameId

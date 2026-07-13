WITH Defects AS (
    SELECT 
        MST_Defect_Id AS ValueId,
        DefectCategory AS Label,
        1 AS Level
    FROM MST_Defect
    WHERE isactive = 1

    UNION ALL

    SELECT 
    DN.mst_defectName_id AS ValueId,
    DN.DefectName AS Label,
    2 AS Level
	FROM MST_DefectName DN
	LEFT JOIN 
     MST_Defect MD ON MD.MST_Defect_Id = DN.MST_Defect_Id
	WHERE DN.IsActive = 1 AND MD.MST_Defect_Id = :DefectLevel1
)

SELECT 
    label,
    ValueId AS Value
FROM Defects
WHERE Level = :level;

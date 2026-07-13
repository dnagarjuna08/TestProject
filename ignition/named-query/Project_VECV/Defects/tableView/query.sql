SELECT 
    MST_Defect.DefectCategory AS Defect, 
    MST_DefectName.DefectName AS [Defect Name],
    MST_DefectSUBName.DefecSubName AS [Defect SubName],
	MST_DefectSUBName.Demerit AS Demerit,
    MST_Defect.IsActive AS [Is Active],
	MST_Defect.MST_Defect_Id,
	MST_DefectName.MST_DefectName_Id,
	MST_DefectSUBName.MST_DefectSUBName_Id
FROM 
    MST_Defect
LEFT JOIN 
    MST_DefectName ON MST_Defect.MST_Defect_Id = MST_DefectName.MST_Defect_Id
LEFT JOIN 
    MST_DefectSUBName ON MST_DefectName.MST_DefectName_Id = MST_DefectSUBName.MST_DefectName_Id
ORDER BY 
    MST_Defect.CreatedDate desc;
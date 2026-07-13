select DefectName as "Defect Name" from mst_defectName INNER JOIN  MST_Defect 
 ON MST_Defect. MST_Defect_Id =mst_defectName.MST_Defect_Id 
 where 
 mst_defectName.isactive=1 AND MST_Defect. DefectCategory =:DefectCategory
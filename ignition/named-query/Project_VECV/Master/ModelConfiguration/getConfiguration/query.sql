SELECT LineTypeCode, Mode, IsActive
FROM MST_ModelConfiguration 
WHERE M_BOM_Id = :M_BOM_Id
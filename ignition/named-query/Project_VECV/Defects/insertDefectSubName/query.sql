INSERT INTO MST_DefectSUBName (
    MST_DefectName_Id,
    DefecSubName,
	Demerit,
    CreatedBy
)
VALUES (
         -- This comes from selected Defect Name dropdown
    :MST_DefectName_Id,
    :unitName,      -- This is the input provided by the user
    :Demerit,
    :createdBy        -- Usually the logged-in user ID
	
)

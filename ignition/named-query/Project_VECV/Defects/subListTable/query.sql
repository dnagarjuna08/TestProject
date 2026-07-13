select MST_DefectSUBName_Id , DefecSubName from MST_DefectSUBName 
where isactive=1 and
MST_DefectName_Id = :defectNameId 
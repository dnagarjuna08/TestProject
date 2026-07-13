select M.M_MaterialNumber from TRN_ErrorProof AS E
INNER JOIN M_Material AS M ON M.M_Material_Id = E.M_Material_Id
where E.MST_WorkStation_Id = :MST_WorkStation_Id and E.IsActive = 1 and E.M_BOM_Id = :M_BOM_Id 
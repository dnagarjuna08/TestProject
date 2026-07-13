select C.Item as 'Checklist', B.M_BOMNumber as 'TMCode', C.LowerLimit, C.UpperLimit from MST_Checklist as C
inner join M_BOM as B on B.M_BOM_Id = C.M_BOM_Id
where MST_WorkStation_Id =  :WorkStation_Id and C.IsActive = 1
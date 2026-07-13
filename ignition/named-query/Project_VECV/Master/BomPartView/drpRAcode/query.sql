select distinct bom.M_BOMNumber from classificationData as cd
inner join M_BOM as Bom on cd.M_BOM_Id = bom.M_BOM_Id where cd.IsActive=1 
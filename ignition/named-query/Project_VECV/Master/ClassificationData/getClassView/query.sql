select bom.M_BOMNumber,area.AreaName,cd.ModelRange,cd.PlantCode,cd.GearRation,cd.IsActive,bom.M_BOM_Id as 'M_BOMNumber_Id',area.MST_Area_Id as 'Area_Id',cd.ClassficationId as 'classificationId' from classificationData as cd
inner join M_BOM as Bom on cd.M_BOM_Id = bom.M_BOM_Id
inner join MST_Area as area on cd.Mst_Area_Id = area.MST_Area_Id
WHERE ( :FilterArea = '' or area.AreaName = :FilterArea) AND
( :FilterBomCode = '' or bom.M_BOMNumber = :FilterBomCode) AND
( :FilterModelType = '' or  cd.ModelRange = :FilterModelType ) 
order by cd.IsActive desc
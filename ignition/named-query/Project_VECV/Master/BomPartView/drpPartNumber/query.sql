select M_MaterialNumber from M_Material 
inner join M_BOM on M_Material.M_BOM_Id = M_BOM.M_BOM_Id
where M_Material.IsActive=1 and  M_BOM.M_BOMNumber   = :M_BOMNumber
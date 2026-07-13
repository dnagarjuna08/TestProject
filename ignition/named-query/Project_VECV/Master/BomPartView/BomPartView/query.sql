select b.M_BOM_Id as 'BOM_ID',b.M_BOMNumber as 'BOM_Number',b.Description as 'BOMDescription',mat.M_MaterialNumber as 'Material_Number',mat.Description as 'materialDescription',bd.Quantity,model.ModelName as 'Model_Group'  from M_BOM as b 
inner join M_Material as mat on mat.M_BOM_Id=b.M_BOM_Id
inner join  M_BOM_Details as bd on bd.M_Material_Id=mat.M_Material_Id
inner join REL_GroupBom as rg on b.M_BOM_Id=rg.M_BOM_Id
inner join MST_Model as model on rg.MST_Model_Id = model.MST_Model_Id
WHERE
( :FilterBomCode = '' or b.M_BOMNumber = :FilterBomCode) AND
( :FilterPart = '' or  mat.M_MaterialNumber  = :FilterPart )
order by b.M_BOM_Id
select m_bom.M_BOMNumber from REL_GroupBom 
inner join MST_Model on MST_Model.MST_Model_Id= REL_GroupBom.MST_Model_Id
inner join M_BOM on M_BOM.M_BOM_Id = REL_GroupBom.M_BOM_Id 
where MST_Model.ModelName=:ModelName
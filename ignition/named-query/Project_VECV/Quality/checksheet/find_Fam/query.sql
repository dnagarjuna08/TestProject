
select B.ModelName from REL_GroupBom as A
inner join MST_Model as b on a.MST_Model_Id = b.MST_Model_Id
Inner Join M_BOM as c on a.M_BOM_Id = c.M_BOM_Id
where b.IsActive=1
and c.M_BOMNumber=:M_Bom_ID


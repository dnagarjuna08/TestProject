--SELECT  b.M_BOM_Id as "value", b.M_BOMNumber as "label"
--FROM  M_BOM as b
--Left outer JOIN  MST_ModelConfiguration as m ON  m.M_BOM_Id = b.M_BOM_Id 
--where m.M_BOM_Id IS NULL and m.IsConfigured = 0 
--Group By  b.M_BOM_Id, b.M_BOMNumber

--SELECT BOM.[M_BOM_Id] as "value",BOM.[M_BOMNumber] as "label"
--FROM [MESQADB].[dbo].[M_BOM] AS BOM
--LEFT JOIN [MESQADB].[dbo].[MST_ModelConfiguration] AS ModelConfig
--    ON BOM.[M_BOM_Id] = ModelConfig.[M_BOM_Id]
--WHERE (ModelConfig.[M_BOM_Id] IS NULL OR ModelConfig.[IsConfigured] != 1) AND BOM.IsActive = 1 ;
Select BOM.[M_BOM_Id] as "value", BOM.[M_BOMNumber] as "label" From [dbo].[M_BOM] AS BOM





SELECT M.LineTypeCode, M.Mode, M.IsActive, M.IsConfigured, B.M_BOMNumber, M.MST_ModelConfiguration_Id,M.M_BOM_Id FROM [dbo].[MST_ModelConfiguration] AS M
INNER JOIN [dbo].[M_BOM] AS B ON M.M_BOM_Id = B.M_BOM_Id
WHERE ( :FilterLineTypeCode = '' or M.LineTypeCode = :FilterLineTypeCode) AND
( :FilterMode = '' or M.Mode = :FilterMode) AND
( :FilterCode = -1 or  M.M_BOM_Id = :FilterCode ) AND
M.IsDeleted = 0
order by case when M.ModifiedDate is null then M.CreatedDate  else  M.ModifiedDate  end desc

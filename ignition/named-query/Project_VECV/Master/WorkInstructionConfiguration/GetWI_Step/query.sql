SELECT TOP (1000) [MST_OPCode_Id] ID
      ,a.[MST_Model_Id]
      ,a.[MST_Area_Id]
      ,a.[MST_Line_Id]
      ,a.[MST_WorkStation_Id]
      ,a.[MST_OPDefinition_Id] [OP Definition ID]
      ,[MST_WIType_Id]
      ,[OPCode] [OP Code]
      ,a.[Description]
      ,[AttributeText] [Attribute Text]
      ,[ImageName]
      ,[ImagePath]
      ,a.[IsActive]
      ,[OPDefinition] [OP Definition]
      , WorkStationName [WorkStation]
      , ModelName as Model
      ,0 as [Select] 

  FROM [dbo].[MST_OPCode] a 
  inner join [dbo].[MST_OPDefinition] b on a.MST_OPDefinition_Id=b.MST_OPDefinition_Id
  inner join  MST_WorkStation c on a.[MST_WorkStation_Id]=c.[MST_WorkStation_Id] 
  inner join  MST_Model d on d.MST_Model_Id = a.MST_Model_Id
where a.[IsDeleted]=0 and a.[IsActive]=1 and a.[MST_WorkStation_Id]=:WorkstationID and a.[MST_Model_Id]= :ModelId 
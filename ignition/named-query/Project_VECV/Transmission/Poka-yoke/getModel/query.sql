Select  MST_Model_Id as value, ModelName as label from  MST_Model with(nolock) 
where IsActive = 1 and IsDeleted=0 and MST_Area_Id = :AreaId
order by ModelName Asc

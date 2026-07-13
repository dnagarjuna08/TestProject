SELECT  ModelName from  MST_Model 
inner join  MST_Area   
ON MST_Model.MST_Area_Id=MST_Area. MST_Area_Id 
where MST_Area.AreaName =:AreaName
and   MST_Model.IsActive =1
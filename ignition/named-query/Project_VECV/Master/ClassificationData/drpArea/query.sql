select distinct area.AreaName from classificationData as cd
inner join MST_Area as area on cd.Mst_Area_Id = area.MST_Area_Id
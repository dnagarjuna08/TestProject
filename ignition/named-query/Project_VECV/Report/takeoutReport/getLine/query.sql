select LineName from mst_line 
inner join MST_Area on MST_Line.MST_Area_Id=MST_Area.MST_Area_Id
where mst_line.IsActive=1 and mst_line.IsDeleted=0 
and MST_Area.AreaName=  :Area 
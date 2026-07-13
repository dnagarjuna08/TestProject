
SELECT MST_Line.LineName from MST_Line 
inner join
MST_Area 
on MST_Line.MST_Area_Id = MST_Area.MST_Area_Id 
where MST_Area.AreaName=:selectedArea and MST_Line.IsActive = 1 
 
Select distinct M_BOMNumber from M_BOM 
inner join MST_Area
on  M_BOM.Mst_Area_Id = MST_Area.MST_Area_Id 
where MST_Area.AreaName = :AreaName
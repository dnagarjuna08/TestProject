
SELECT WorkStationName FROM MST_WorkStation 
INNER JOIN MST_Area on MST_Area.MST_Area_Id = MST_WorkStation.MST_Area_Id
inner join MST_Line on mst_line.mst_line_id = MST_WorkStation.mst_line_id
--inner join  MST_WorkStationType on  MST_WorkStationType. MST_WorkStationType_Id = MST_WorkStationType_Id 
WHERE MST_Area.AreaName = :areaName AND mst_line.LineName = :lineName AND 
mst_workstation.IsActive = 1 AND MST_Line.IsActive=1 and MST_Area.IsActive=1 and  MST_WorkStation.MST_WorkStationType_Id <> 1
--order by CAST(SUBSTRING(WorkStationName, 3, LEN(WorkStationName) - 2) AS INT)
--ORDER BY substring(WorkStationName,)
order by LEN(WorkStationName),WorkStationName
                
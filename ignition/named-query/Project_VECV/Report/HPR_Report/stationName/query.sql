SELECT wrk.WorkStationName
FROM mst_workstation wrk
INNER JOIN MST_Area ON wrk.MST_Area_Id = MST_Area.MST_Area_Id
INNER JOIN mst_line ON mst_line.mst_line_id = wrk.mst_line_id
WHERE wrk.IsActive = 1 
  AND wrk.IsDeleted = 0
  AND MST_Line.LineName = :LineNAme 
  and MST_Line.LineName != 'LAConveyor'
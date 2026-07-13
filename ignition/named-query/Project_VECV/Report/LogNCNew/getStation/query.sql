SELECT DISTINCT 
    WorkStationName 
FROM 
    MST_WorkStation 
INNER JOIN  
    MST_Line ON MST_WorkStation.MST_Line_Id = MST_Line.MST_Line_Id 
WHERE   
    MST_Line.LineName = :selectedLine
order by  MST_WorkStation.WorkStationName asc








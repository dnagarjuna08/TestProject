SELECT   c.MST_Checklist_Id  AS Id , m.ModelName  AS Model, a.AreaName  AS Area, l.LineName  AS Line , 
w.WorkStationName  AS QualityGate , c.Item AS 'Item', c.SequenceNum AS Sequence,
c.IsActive AS 'IsActive', 
m.MST_Model_Id AS ModelId,
l.MST_Line_Id AS LineId, w.MST_WorkStation_Id AS WorkStationId, a.MST_Area_Id AS AreaId 

FROM   MST_Checklist  AS c

INNER JOIN  MST_Model AS m on c.MST_Model_Id=m.MST_Model_Id 
INNER JOIN  MST_Area  AS a on c.MST_Area_Id=a.MST_Area_Id  
INNER JOIN  MST_Line  AS l on c.MST_Line_Id=l.MST_Line_Id
INNER JOIN  MST_WorkStation AS w on c.MST_WorkStation_Id=w.MST_WorkStation_Id
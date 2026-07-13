SELECT   i.MST_ImageMaster_Id AS Id , m.ModelName  AS Model, a.AreaName  AS Area, l.LineName  AS Line , 
w.WorkStationName  AS WorkStation , i.ImageName AS 'Image Name', i.Description AS Description,
it.ImageType AS 'Image Type' , i.ImagePath AS 'View' , i.IsActive AS 'Is Active', m.MST_Model_Id AS ModelId,
l.MST_Line_Id AS LineId, w.MST_WorkStation_Id AS WorkStationId, it.MST_ImageType_Id AS ImageTypeId, a.MST_Area_Id AS AreaId 

FROM  MST_ImageMaster AS i

INNER JOIN  MST_Model AS m on i.MST_Model_Id=m.MST_Model_Id 
INNER JOIN  MST_Area  AS a on i.MST_Area_Id=a.MST_Area_Id  
INNER JOIN  MST_Line  AS l on i.MST_Line_Id=l.MST_Line_Id
INNER JOIN  MST_WorkStation AS w on i.MST_WorkStation_Id=w.MST_WorkStation_Id
INNER JOIN  MST_ImageType AS it on i.MST_ImageType_Id=it.MST_ImageType_Id
order by case when i.ModifiedDate is null then i.CreatedDate  else  i.ModifiedDate  end desc
  






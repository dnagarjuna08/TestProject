--select top 100 * from SERIAL_NUMBER where MST_Area_Id=26 order by CreatedDate desc
SELECT   i.MST_ImageMasterQG_Id AS Id , m.ModelName  AS Model, a.AreaName  AS Area, l.LineName  AS Line , 
w.WorkStationName  AS WorkStation , i.ImageName AS 'Image Name', i.Description AS Description,
it.ImageType AS 'Image Type' , i.ImagePath AS 'View' , i.IsActive AS 'Is Active', m.MST_Model_Id AS ModelId,
l.MST_Line_Id AS LineId, w.MST_WorkStation_Id AS WorkStationId, it.MST_ImageType_Id AS ImageTypeId, a.MST_Area_Id AS AreaId
,0 as Status

FROM  MST_ImageMasterQG AS i

INNER JOIN  MST_Model AS m on i.MST_Model_Id=m.MST_Model_Id 
INNER JOIN  MST_Area  AS a on i.MST_Area_Id=a.MST_Area_Id  
INNER JOIN  MST_Line  AS l on i.MST_Line_Id=l.MST_Line_Id
INNER JOIN  MST_WorkStation AS w on i.MST_WorkStation_Id=w.MST_WorkStation_Id
INNER JOIN  MST_ImageType AS it on i.MST_ImageType_Id=it.MST_ImageType_Id
Inner join M_BOM as mb on mb.M_BOM_Id=i.M_BOM_Id
where  mb.M_BOM_Id=i.M_BOM_Id and
mb.M_BOMNumber= :BomNumb 
and w.MST_WorkStation_Id=  :WorkstationId 
and i.IsActive=1 and i.IsDeleted=0
DECLARE @Area NVARCHAR(50) = :Area;
DECLARE @Line NVARCHAR(50) = :Line;
DECLARE @DefectCategory NVARCHAR(50) = :DefectCategory;
DECLARE @DefectName	NVARCHAR(50) = :DefectName;
DECLARE @DefectSubname NVARCHAR(50) = :DefectSubname;
DECLARE @Status NVARCHAR(50) = :Status;
DECLARE @FromDate DATETIME = :FromDate;
DECLARE @ToDate DATETIME = :ToDate;

SELECT 
    ar.AreaName,
    li.LineName,
    ws.WorkStationName,
    td.SerialNumber,
    d.DefectCategory,
    dn.DefectName,
	SB.DefecSubName,
	SB.Demerit,
    ds.[Status],
    td.Comments,
    td.CreatedDate,
    td.ModifiedDate
FROM 
    TRN_StationDefect AS td 
INNER JOIN 
    MST_Area ar ON ar.MST_Area_Id = td.MST_Area_Id
INNER JOIN 
    MST_Line li ON li.MST_Line_Id = td.MST_Line_Id
INNER JOIN 
    MST_WorkStation ws ON ws.MST_WorkStation_Id = td.MST_WorkStation_Id
INNER JOIN 
    MST_Defect d ON d.MST_Defect_Id = td.MST_Defect_Id
INNER JOIN 
    MST_DefectName dn ON dn.MST_DefectName_Id = td.MST_DefectName_Id
INNER JOIN 
	MST_DefectSUBName SB ON SB.MST_DefectSUBName_Id = td.MST_DefectSubName_Id
INNER JOIN 
    MST_DefectStatus ds ON ds.MST_DefectStatus_Id = td.MST_DefectStatus_Id
WHERE 
    ar.AreaName = @Area
    AND (@Line = '' OR li.LineName = @Line) -- Show all if @Line is empty
    AND (@DefectCategory = '' OR d.DefectCategory = @DefectCategory) -- Show all if @DefectCategory is empty
	AND (@DefectName = '' OR DN.DefectName = @DefectName)
	AND (@DefectSubname = '' OR SB.DefecSubName = @DefectSubname)
    AND (@Status = '' OR ds.[Status] = @Status) -- Show all if @Status is empty
    AND td.CreatedDate >= @FromDate 
    AND td.CreatedDate <= @ToDate 
    And td.Isactive=1 and td.isdeleted=0
ORDER BY 
    td.CreatedDate DESC;

SELECT DISTINCT 
    SerialNumber, 
    MST_NonCorformance.nccategory, 
    TRN_OPNonConformance.comments,
    MST_NCStatus.status,
    MST_WorkStation.WorkStationName,
    dbo.MST_User.UserName, 
    dbo.MST_OPDefinition.OPDefinition,
    TRN_OPNonConformance.CreatedDate

FROM 
    MST_NonCorformance 
INNER JOIN 
    TRN_OPNonConformance ON TRN_OPNonConformance.mst_noncorformance_id = MST_NonCorformance.mst_noncorformance_id
INNER JOIN 
    MST_NCStatus ON MST_NCStatus.mst_ncStatus_id = TRN_OPNonConformance.mst_ncStatus_id
INNER JOIN 
    MST_WorkStation ON MST_WorkStation.MST_WorkStation_Id = TRN_OPNonConformance.MST_WorkStation_Id
INNER JOIN 
    dbo.MST_WIOPCode ON dbo.MST_WIOPCode.MST_OPCode_Id = TRN_OPNonConformance.MST_OPCode_Id
INNER JOIN 
    dbo.MST_OPDefinition ON dbo.MST_OPDefinition.MST_OPDefinition_Id = dbo.MST_WIOPCode.MST_OPDefinition_Id
INNER JOIN 
    dbo.MST_User ON dbo.MST_User.MST_User_Id = TRN_OPNonConformance.CreatedBy
INNER JOIN 
    MST_Area ON MST_Area.MST_Area_Id = TRN_OPNonConformance.MST_Area_Id 
INNER JOIN 
    MST_Line ON MST_Line.MST_Line_Id = TRN_OPNonConformance.MST_Line_Id 
WHERE 
    MST_Area.AreaName =:selectedArea
    AND MST_Line.LineName =:selectedLine
    AND MST_WorkStation.WorkStationName =:selectedStation
    And TRN_OPNonConformance.CreatedDate BETWEEN  :Startdate  and  :ToDate 

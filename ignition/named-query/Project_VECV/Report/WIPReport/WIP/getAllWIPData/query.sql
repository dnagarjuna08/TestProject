Declare @StartStationID int ; 
DECLARE @EndStationID int ;
select @StartStationID = MST_WorkStation_ID from MST_WorkStation where WorkStationName = :startStation
select @EndStationID = MST_WorkStation_ID from MST_WorkStation where WorkStationName = :endStation

SELECT Distinct
    M_BOM.M_BOMNumber,
    PRODUCTION_ORDER.serial_number,
    PRODUCTION_ORDER.start_time
FROM 
    TRN_StationStatus
INNER JOIN 
    PRODUCTION_ORDER 
    ON PRODUCTION_ORDER.M_BOM_Id =TRN_StationStatus.M_BOM_Id
INNER JOIN 
    M_BOM
    ON [dbo].[M_BOM].[M_BOM_Id]=[dbo].[TRN_StationStatus].[M_BOM_Id]    
    inner join MST_Area on MST_Area.MST_Area_Id=TRN_StationStatus.MST_Area_Id 
    inner join MST_Line on MST_Line.MST_Line_Id=TRN_StationStatus.MST_Line_Id
WHERE 
    TRN_StationStatus.MST_WorkStation_Id between @StartStationID  and @EndStationID
    AND TRN_StationStatus.MST_Status_Id = 2
    AND MST_Area.AreaName= :areaName
    and MST_Line.LineName= :lineName
 
ORDER BY 
    PRODUCTION_ORDER.start_time DESC;
 
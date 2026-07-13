Declare 
@SerialNumber NVARCHAR(50)= :SerialNumber ;

BEGIN
	SELECT ISNULL((SELECT GearRation FROM ClassificationData WHERE IsActive = 1 AND M_BOM_Id = 
	(select M_BOM_Id from TRN_StationStatus where MST_WorkStation_Id =  :WorkStationId 
	and MST_Status_Id = 2 and IsActive=1 and IsDeleted=0 and SerialNumber=@SerialNumber)),0) AS GearRation

END
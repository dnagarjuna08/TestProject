
BEGIN
	SELECT ISNULL((Select MST_Status_Id from TRN_StationStatus 
    where SerialNumber=  :SerialNumber and MST_WorkStation_Id=  :WorkStationId and IsActive=1 and IsDeleted=0),0) AS GearRation

END


SELECT 
    WS.WorkStationName,
    EP.PartNumber,
	M.Description,
    EP.ConsumedPartNumber,
    EP.CreatedDate as Date,
	EP.MST_ErrorProofQG_Id
FROM TRN_ErrorProofQuality EP
INNER JOIN TRN_Station_Events TE 
    ON EP.trn_station_event_id = TE.TRN_Station_Events_Id
INNER JOIN MST_WorkStation WS 
    ON TE.MST_WorkStation_Id = WS.MST_WorkStation_Id
INNER JOIN MST_ErrorProofQG M
	ON EP.MST_ErrorProofQG_Id= M.MST_ErrorProofQG_Id
WHERE EP.ConsumedSerialNumber = :SerialNumber 
  AND WS.MST_WorkStationType_Id = '3'
  AND WS.IsActive = '1' order by ws.WorkStationName asc
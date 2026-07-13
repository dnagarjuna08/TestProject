SELECT 
	WorkStationName,
	UPPER(SerialNumber) AS SerialNumber,
	DefectCategory,
	DN.DefectName,
	SN.DefecSubName,
	SN.Demerit,
	OperatorID,
	Comments,
	[Status],
	SD.CreatedDate,
	SD.ModifiedDate
FROM 
	TRN_StationDefect SD
LEFT JOIN 
	MST_Defect D ON SD.MST_Defect_Id = D.MST_Defect_Id
LEFT JOIN 
	MST_DefectStatus DS ON SD.MST_DefectStatus_Id = DS.MST_DefectStatus_Id
LEFT JOIN 
	MST_WorkStation WS ON WS.MST_WorkStation_Id = SD.MST_WorkStation_Id
LEFT JOIN 
	MST_DefectName DN ON DN.MST_DefectName_Id = SD.MST_DefectName_Id
LEFT JOIN
	MST_DefectSUBName SN ON SN.MST_DefectSUBName_Id = SD.MST_DefectSubName_Id
WHERE 
	SD.SerialNumber =  :serialNumber
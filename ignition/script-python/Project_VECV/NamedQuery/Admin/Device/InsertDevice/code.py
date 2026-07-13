def InsertDevice( AssetNumber, DeviceSerialNumber,CreatedBy, Description, DeviceName, IPAddress, MST_DeviceType_Id,  MST_WorkStation_Id, Port):
	#NamedQueryPath
	queryPath = 'Project_VECV/Device/InsertDevice'
	currentDateTime=system.date.now()
	#NamedQuery Params
	queryParams = {"AssetNumber":AssetNumber,"DeviceSerialNumber":DeviceSerialNumber,"CreatedBy":CreatedBy,
					"CreatedDate":currentDateTime, "Description":Description,
					"DeviceName" :DeviceName,"IPAddress":IPAddress, "MST_DeviceType_Id":MST_DeviceType_Id,
					"MST_WorkStation_Id":MST_WorkStation_Id, "Port":Port}
	result = system.db.runNamedQuery(queryPath,queryParams)
	return result
	
	
	
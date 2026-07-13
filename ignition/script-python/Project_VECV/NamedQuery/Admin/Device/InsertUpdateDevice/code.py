"""
Written By: Gaurav Amrutkar
Written Date: 12/05/2024
Purpose:			 
		Function to insert/update device details into table. 
"""
def InsertUpdateDevice( AssetNumber, DeviceSerialNumber,ModifiedBy, Description, DeviceName, IPAddress, MST_DeviceType_Id,  MST_WorkStation_Id, Port, Id,IsActive,DeviceMapId,WS):
	try:
#		if WS != 1:
		queryPath = 'Project_VECV/Device/InsertUpdateDevice'
		queryParams = {"AssetNumber":AssetNumber,"DeviceSerialNumber":DeviceSerialNumber,"ModifiedBy":ModifiedBy, 
						"Description":Description, "DeviceName" :DeviceName,"IPAddress":IPAddress, "MST_DeviceType_Id":MST_DeviceType_Id,
						"Port":Port, "Id":Id,"IsActive":IsActive}
		result = system.db.runNamedQuery(queryPath,queryParams)
		for row in result:
			DeviceId = row[0]
		system.perspective.print("result from library:%s"%DeviceId)
		for i in MST_WorkStation_Id:
			system.perspective.print("MST_WorkStation_Id from library:%s,%s,%s"%(i,str(DeviceMapId),str(DeviceId)))
			queryPath = 'Project_VECV/Device/InsertUpdateDeviceMap'
			queryParams = {'DeviceId':DeviceId,'WorkStationId':i,'Id':Id,'DeviceMapId':DeviceMapId}
			RESULTVAL = system.db.runNamedQuery(queryPath,queryParams)
			val = 1
#		else:
#			val = 2
		return val
	except:
		screenName ='Device Panel'   
		filePath=str('Project_VECV/Pannel/Device Pannel/Project Library/InsertUpdateDevice')  
		errorFunction = str('Event:onActionPerformed -> cntSave/btn_Save')  
		errorType=str('Library Function')  
		errorCode = str(Project_VECV.Common.GenerateUUID.getUniqueUUID())   
		description=str(sys.exc_info()[1]) #error description 
		lineNumber=str(sys.exc_info()[2].tb_lineno) #lineno on which error 
#		print lineNumber,description
		Project_VECV.Configuration.Common.AddLogDetails.AddErrorLogs(screenName,filePath,errorFunction,errorType,errorCode,description,lineNumber) 
	#End of except block		
		return 0
		
		
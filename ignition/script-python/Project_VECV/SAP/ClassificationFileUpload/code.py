def ClassificationFileUpload(event, Area_Id, UserName):
	try:
		uploaded_file = event.file
		file_content = uploaded_file.getBytes()
		import xml.etree.ElementTree as ET
		document= event.file.getString()
		root = ET.fromstring(document)
		if str(root.tag) == 'CLFMAS02':
			for child in root:
				if str(child.tag) == 'IDOC':
					for subchild in child:
						if str(subchild.tag) == 'E1OCLFM':
							for nestedsubchild in subchild:
								if str(nestedsubchild.tag) == 'OBJEK': 
									BOMNumber = nestedsubchild.text
								if str(nestedsubchild.tag) == 'E1AUSPM':
									for node in nestedsubchild:
										if str(node.text) == 'GEAR_RATIO':
											GEAR_RATIO = [elem.text for elem in nestedsubchild.findall(".//ATWRT")][0]
										if str(node.text) == 'MODEL_RANGE':
											MODEL_RANGE = [elem.text for elem in nestedsubchild.findall(".//ATWRT")][0]
										if str(node.text) == 'MFG_PLANT_CODE':
											MFG_PLANT_CODE = [elem.text for elem in nestedsubchild.findall(".//ATWRT")][0]
											
			params  = {'MODEL_RANGE':MODEL_RANGE,
			'MFG_PLANT_CODE':MFG_PLANT_CODE,
			'GEAR_RATIO':GEAR_RATIO,
			'AreaId':Area_Id,
			'BOMNumber':BOMNumber}
			count = system.db.runNamedQuery("Project_VECV/SAPUpload/CheckValidBOMNumber",{"Material_Number":BOMNumber, "Area_Id":Area_Id})
			if count > 0:
				system.db.runNamedQuery("Project_VECV/SAPUpload/AddClassificationData",params)
				try:
					stationName="SAP Classification Upload" 
					state='info'
					userName=UserName
					ipAddress='Manual'
					data="Data saved successfully %s"%event.file.name
					Project_VECV.Audit.Logs.logUpload(stationName,state,userName,ipAddress,data)
				except:
					pass
				return True
			else:
				try:
					stationName="SAP Classification Upload" 
					state='error'
					userName=UserName
					ipAddress='Manual'
					data="Data saving failed %s"%event.file.name
					Project_VECV.Audit.Logs.logUpload(stationName,state,userName,ipAddress,data)
				except:
					pass
				return False
		else:
			try:
				stationName="SAP Classification Upload" 
				state='error'
				userName=UserName
				ipAddress='Manual'
				data="Wrong BOM Uploaded %s"%event.file.name
				Project_VECV.Audit.Logs.logUpload(stationName,state,userName,ipAddress,data)
			except:
				pass
			return False
	except Exception as e:
		screenName ='ClassificationFileUpload'   
		filePath=str('ClassificationFileUpload')  
		errorFunction = str('Project_VECV/SAP/ClassificationFileUpload')  
		errorType=str('Application')  
		errorCode = str(Project_VECV.Common.GenerateUUID.getUniqueUUID())   
		description=str(sys.exc_info()[1]) #error description 
		lineNumber=str(sys.exc_info()[2].tb_lineno) #lineno on which error 
		Project_VECV.Configuration.Common.AddLogDetails.AddErrorLogs(screenName,filePath,errorFunction,errorType,errorCode,description,lineNumber) 
		try:
			stationName="SAP Classification Upload" 
			state='error'
			userName=UserName
			ipAddress='Manual'
			data="Data Uploading Failed For file %s"%event.file.name
			Project_VECV.Audit.Logs.logUpload(stationName,state,userName,ipAddress,data)
		except:
			pass
		return False
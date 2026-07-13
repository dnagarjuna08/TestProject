def UploadMaterial(event, Area_Id, UserName):
	try:
		uploaded_file = event.file
		file_content = uploaded_file.getBytes()
		import xml.etree.ElementTree as ET
		document= event.file.getString()
		root = ET.fromstring(document)
		if str(root.tag) == 'ZIMATMAS':
			BOMParams = {}
			count = 1
			for child in root:
				if str(child.tag) == 'IDOC':
					for subchild in child:
						if str(subchild.tag) == 'ZSEG_MATMAS':
							if count == 1:
								system.perspective.print(count)
								for rt in subchild:
									if str(rt.tag) == 'MATNR':
										M_BOMNumber = rt.text
									if str(rt.tag) == 'MTART':
										M_BOMType = rt.text
									if str(rt.tag) == 'EISBE':
										M_BOMVersion = rt.text
									if str(rt.tag) == 'MAKTX':
										Description = rt.text
									if str(rt.tag) == 'MEINS':
										UOM = rt.text
									if str(rt.tag) == 'WERKS':
										plantCode = rt.text
										
								count +=1
								BOMParams = {"M_BOMNumber":M_BOMNumber,
								"M_BOMType":M_BOMType,
								"M_BOMVersion":int(float(M_BOMVersion)),
								"Description":Description,
								"UOM":UOM,
								"plantCode":plantCode,
								"AreaId":Area_Id}
								system.db.runNamedQuery("Project_VECV/SAPUpload/AddMBomRecord",BOMParams)
								params = {
								'MaterialNumber':M_BOMNumber,
								'MaterialType':M_BOMType,
								'MaterialVersion':int(float(M_BOMVersion)),
								'Plant_Code':plantCode,
								'UOM':UOM,
								'IsMBomRecord':1,
								'Mst_Area_Id':Area_Id}
								system.db.runNamedQuery("Project_VECV/SAPUpload/AddI_MaterialRecords",params)
								try:
									stationName="SAP Material Upload" 
									state='info'
									userName=UserName
									ipAddress='Manual'
									data="BOM %s Records Updated"%M_BOMNumber
									Project_VECV.Audit.Logs.logUpload(stationName,state,userName,ipAddress,data)
								except:
									pass
							else:
								count +=1
								for rt in subchild:
									if str(rt.tag) == 'MATNR':
										M_MaterialNumber = rt.text
									if str(rt.tag) == 'MTART':
										M_BOMType = rt.text
									if str(rt.tag) == 'EISBE':
										M_BOMVersion = rt.text
									if str(rt.tag) == 'MAKTX':
										Description = rt.text
									if str(rt.tag) == 'MEINS':
										UOM = rt.text
									if str(rt.tag) == 'WERKS':
										plantCode = rt.text
									
								params = {
								'M_BOMNumber':M_BOMNumber,
								'M_MaterialNumber':M_MaterialNumber,
								'M_BOMType':M_BOMType,
								'M_BOMVersion':int(float(M_BOMVersion)),
								'Description':Description,
								'UOM':UOM,
								'Mst_Area_Id':Area_Id}
								system.db.runNamedQuery("Project_VECV/SAPUpload/AddM_MaterialRecords",params)
								params = {
								'MaterialNumber':M_MaterialNumber,
								'MaterialType':M_BOMType,
								'MaterialVersion':int(float(M_BOMVersion)),
								'Plant_Code':plantCode,
								'UOM':UOM,
								'IsMBomRecord':0,
								'Mst_Area_Id':Area_Id}
								system.db.runNamedQuery("Project_VECV/SAPUpload/AddI_MaterialRecords",params)
						else:
							continue
			try:
				stationName="SAP Material Upload" 
				state='error'
				userName=UserName
				ipAddress='Manual'
				data="Data uploaded successfully %s"%event.file.name
				Project_VECV.Audit.Logs.logUpload(stationName,state,userName,ipAddress,data)
			except:
				pass
			return True	
		else:
			try:
				stationName="SAP Material Upload" 
				state='error'
				userName=UserName
				ipAddress='Manual'
				data="Wrong BOM Uploaded %s"%event.file.name
				Project_VECV.Audit.Logs.logUpload(stationName,state,userName,ipAddress,data)
			except:
				pass
			return False
	except Exception as e:
		screenName ='MaterialFileUpload'   
		filePath=str('MaterialFileUpload')  
		errorFunction = str('Project_VECV/SAP/MaterialFileUpload')  
		errorType=str('Application')  
		errorCode = str(Project_VECV.Common.GenerateUUID.getUniqueUUID())   
		description=str(sys.exc_info()[1]) #error description 
		lineNumber=str(sys.exc_info()[2].tb_lineno) #lineno on which error 
		Project_VECV.Configuration.Common.AddLogDetails.AddErrorLogs(screenName,filePath,errorFunction,errorType,errorCode,description,lineNumber) 
		try:
			stationName="SAP Material Upload" 
			state='error'
			userName=UserName
			ipAddress='Manual'
			data="Data Uploading Failed For file %s"%event.file.name
			Project_VECV.Audit.Logs.logUpload(stationName,state,userName,ipAddress,data)
		except:
			pass
		return False
def BOMFileUpload(event, Area_Id, UserName):
	try:
		uploaded_file = event.file
		file_content = uploaded_file.getBytes()
		import xml.etree.ElementTree as ET
		document= event.file.getString()
		root = ET.fromstring(document)
		flag = False
		IBOMFlag = True
		if str(root.tag) == 'BOMMAT03':
			for child in root:
				if str(child.tag) == 'IDOC':
					for subchild in child:
						if str(subchild.tag) == 'E1STZUM':
							for nestedsubchild in subchild:
								if str(nestedsubchild.tag) == 'STLTY':
									Category = nestedsubchild.text
								if str(nestedsubchild.tag) == 'E1MASTM':
									for node in nestedsubchild:
										if str(node.tag) == 'MATNR':
											BOMNumber = node.text
											Area_Id = Area_Id
											count = system.db.runNamedQuery("Project_VECV/SAPUpload/CheckValidBOMNumber",{"Material_Number":BOMNumber, "Area_Id":Area_Id})
											if count > 0:
												response = system.db.runNamedQuery("Project_VECV/SAPUpload/checkI_BOM",{"BOMNumber":BOMNumber})
												if response > 0:
													IBOMFlag = False
												flag = True
											else:
												break
								elif str(nestedsubchild.tag) == 'E1STPOM':
									if flag:
										for node in nestedsubchild:
											if str(node.tag) == 'IDNRK':
												Material_Number = node.text
											if str(node.tag) == 'MENGE_C':
												Quantity = node.text
										IBOMparams = {"Material_Number":Material_Number,
										"Quantity":int(float(Quantity)),
										"BOMNumber":BOMNumber,
										"Category":Category,
										"Mst_Area_Id":Area_Id}
										if IBOMFlag:
											system.db.runNamedQuery("Project_VECV/SAPUpload/ADDI_BOM",IBOMparams)
										BOMDetailsparams = {"Material_Number":Material_Number,
										"Quantity":int(float(Quantity)),
										"BOMNumber":BOMNumber,
										"Mst_Area_Id":Area_Id}
										system.db.runNamedQuery("Project_VECV/SAPUpload/ADDM_BOM_Details",BOMDetailsparams)
									else:
										break
								else:
									pass
						else:
							continue
			try:
				stationName="SAP BOM Upload" 
				state='info'
				userName=UserName
				ipAddress='Manual'
				data="Data saved Successfully %s"%event.file.name
				Project_VECV.Audit.Logs.logUpload(stationName,state,userName,ipAddress,data)
			except:
				pass
			return True
		else:
			try:
				stationName="SAP BOM Upload" 
				state='error'
				userName=UserName
				ipAddress='Manual'
				data="Wrong BOM Uploaded %s"%event.file.name
				Project_VECV.Audit.Logs.logUpload(stationName,state,userName,ipAddress,data)
			except:
				pass
			return False
	except Exception as e:
		screenName ='BOMFileUpload'   
		filePath=str('BOMFileUpload')  
		errorFunction = str('Project_VECV/SAP/BOMFileUpload')  
		errorType=str('Application')  
		errorCode = str(Project_VECV.Common.GenerateUUID.getUniqueUUID())   
		description=str(sys.exc_info()[1]) #error description 
		lineNumber=str(sys.exc_info()[2].tb_lineno) #lineno on which error 
		Project_VECV.Configuration.Common.AddLogDetails.AddErrorLogs(screenName,filePath,errorFunction,errorType,errorCode,description,lineNumber) 
		try:
			stationName="SAP BOM Upload" 
			state='error'
			userName=UserName
			ipAddress='Manual'
			data="Data Uploading Failed For file %s"%event.file.name
			Project_VECV.Audit.Logs.logUpload(stationName,state,userName,ipAddress,data)
		except:
			pass
		return False
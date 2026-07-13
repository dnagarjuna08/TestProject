def UploadOrder(event, Area_Id, UserName):
	try:
		uploaded_file = event.file
		file_content = uploaded_file.getBytes()
		import xml.etree.ElementTree as ET
		document= event.file.getString()
		root = ET.fromstring(document)
		if str(root.tag) == 'LOIPLO01':
			for child in root:
				if str(child.tag) == 'IDOC':
					for subchild in child:
						if str(subchild.tag) == 'E1PLAFL':
							for rt in subchild:
								if str(rt.tag) == 'MATNR':
									Material_Number = rt.text
								if str(rt.tag) == 'PAART':
									Order_Category = rt.text
								if str(rt.tag) == 'PLNUM':
									Order_Number = rt.text
								if str(rt.tag) == 'PEDTR':
									Planned_End_Time = rt.text
								if str(rt.tag) == 'PERTR':
									Planned_Start_Time = rt.text
						else:
							continue
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
		BOMNumber = system.db.runNamedQuery("Project_VECV/SAPUpload/CheckValidBOMNumber",{"Material_Number":Material_Number, "Area_Id":Area_Id})
		if BOMNumber > 0:
			try:
				stationName="SAP Order Upload" 
				state='Info'
				userName=UserName
				ipAddress='Manual'
				data="Valid BOM %s For Order %s"%(Material_Number,Order_Number)
				Project_VECV.Audit.Logs.logUpload(stationName,state,userName,ipAddress,data)
			except:
				pass
			from datetime import datetime
			Planned_End_Time = datetime.strptime(Planned_End_Time, "%Y%m%d")			
			Planned_Start_Time = datetime.strptime(Planned_Start_Time, "%Y%m%d")			
			params = {"AreaId":Area_Id,
			'Material_Number':Material_Number,
			'Order_Category':Order_Category,
			'Order_Number':Order_Number,
			'Planned_End_Time':str(Planned_End_Time),
			'Planned_Start_Time':str(Planned_Start_Time)} 
			system.db.runNamedQuery("Project_VECV/SAPUpload/AddProductionOrder",params)
			try:
				stationName="SAP Order Upload" 
				state='Info'
				userName=UserName
				ipAddress='Manual'
				data="Data Uploaded in Production_Order For Order %s"%Order_Number
				Project_VECV.Audit.Logs.logUpload(stationName,state,userName,ipAddress,data)
			except:
				pass
			system.db.runNamedQuery("Project_VECV/SAPUpload/AddIProductionOrder",params)
			try:
				stationName="SAP Order Upload" 
				state='Info'
				userName=UserName
				ipAddress='Manual'
				data="Data Uploaded in I_Production_Order For Order %s"%Order_Number
				Project_VECV.Audit.Logs.logUpload(stationName,state,userName,ipAddress,data)
			except:
				pass
			try:
				stationName="SAP Order Upload" 
				state='Info'
				userName=UserName
				ipAddress='Manual'
				data="Data Uploaded Successfully For Order %s"%Order_Number
				Project_VECV.Audit.Logs.logUpload(stationName,state,userName,ipAddress,data)
			except:
				pass
			return True
		else:
			return False
	except Exception as e:
		screenName ='OrderFileUpload'   
		filePath=str('OrderFileUpload')  
		errorFunction = str('Project_VECV.SAP.OrderFileUpload.UploadOrder')  
		errorType=str('Application')  
		errorCode = str(Project_VECV.Common.GenerateUUID.getUniqueUUID())   
		description=str(sys.exc_info()[1]) #error description 
		lineNumber=str(sys.exc_info()[2].tb_lineno) #lineno on which error 
		Project_VECV.Configuration.Common.AddLogDetails.AddErrorLogs(screenName,filePath,errorFunction,errorType,errorCode,description,lineNumber) 
		try:
			stationName="SAP Order Upload" 
			state='error'
			userName=UserName
			ipAddress='Manual'
			data="Data Uploading Failed For file %s"%event.file.name
			Project_VECV.Audit.Logs.logUpload(stationName,state,userName,ipAddress,data)
		except:
			pass
		return False
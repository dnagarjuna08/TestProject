"""
Written By: Niladri Banerjee
Written Date: 20/05/2024
Purpose:			 
		Function to save workInstruction. 
"""
def SaveWorkInstruction(headerLabel,wiID,wiName,description,areaId,lineId,workstationId,isActive,createdBy,stepCount,modelID,OPList,BomId,payload,loggedInUserId):
	try:
		#validationResult=Project_VECV.Configuration.FixturePanel.Validation.IsValidate(wiID,wiName,description,stepCount)
		validationResult=Project_VECV.Configuration.WIGeneral.Validation.IsValidate(wiID,wiName,description,stepCount,modelID,workstationId,BomId)
		isValidate=int(validationResult['isValidate'])
		message=str(validationResult['message'])	
		#isValidate=1
		# check validation
		#createdBy=1
		if(isValidate==1):	
			toJsonString=system.util.jsonEncode(OPList)
			# Add all the details in database
			if(str(headerLabel) == 'Add'):	
				# adding WI details and return WI id 
#				args=str('')
#				for row in range(len(OPList)):
#					OPCodeID=OPList[row]['ID']
#					OPCode= OPList[row]['OPCode']
#					OPDefinitionID= OPList[row]['OP Definition ID']
#					description= OPList[row]['Description'] 
#					Model=OPList[row]['Model'] 
#					OPDefinition = OPList[row]['OPDefinition']
#					Sequence=OPList[row]['Sequence']
#					if args=='':
#						args='('+'@wiId'+','+str(OPCodeID)+','+str(OPDefinitionID)+','+str(Sequence)+','+str(workstationId)+','+str(createdBy)+','+'getdate()'+')'
#					else:
#						args=str(args)+','+'('+'@wiId'+','+str(OPCodeID)+','+str(OPDefinitionID)+','+str(Sequence)+','+str(workstationId)+','+str(createdBy)+','+'getdate()'+')'
				system.perspective.print(OPList)
				
				params = {"Name":str(wiName),"Description":str(description),"AreaId":int(areaId),"LineId":int(lineId),"WorkStationId":int(workstationId),"CreatedBy":int(createdBy),"ModelId":int(modelID),"OPList":toJsonString,"BomId":int(BomId)}
				result = system.db.runNamedQuery("Project_VECV/Master/WorkInstructionConfiguration/AddWI",params)
				
				system.perspective.print(result)
				
				if(int(result) > 0):		
					message = "Record added successfully."
					auditMsg=str(wiName) +" Configuration details added successfully."
					headerLabel = "Add"
					messageType = 'WiGeneralPannel'   				
					payload = {'headerLabel':headerLabel,'WIid':int(0),'name':'','desc':'','areaId':-1,'lineId':-1,'WorkStationId':-1,'isActive':-1,'UsedStepCount':0}		 			
					system.perspective.sendMessage(messageType, payload, scope = 'page' )
					system.perspective.openDock("rightView")
					system.perspective.closeDock('rightp')
					#system.perspective.print ("loop1")
					messageType = 'tableRefresh'    	 			
					system.perspective.sendMessage(messageType,scope = 'page' )
					#system.perspective.print ("loop2")
					messageType = 'popup_View' 
					state='success'   			
					system.perspective.sendMessage(messageType,payload = {"display":1,'state':str(state),'text':str(message)},scope = 'page' )
					system.perspective.sendMessage("tableRow",payload = {"Index":-1}, scope = "page")	
					system.perspective.sendMessage("deleteIsVisible",payload = {"IsVisible":0}, scope = "page")	
					system.perspective.sendMessage("isEditDisplay",payload = {"IsVisible":0}, scope = "page")
					#system.perspective.print ("loop3")
			#End of Add all the details in database
			
			#update all the details in database				
			elif(str(headerLabel) == 'Edit'):	
				#system.perspective.print("printing WIID")
				#system.perspective.print(int(wiID))
				#system.perspective.print(toJsonString)		
				#update WI details
				params = {"wiID":int(wiID),"Name":str(wiName),"Description":str(description),"AreaId":int(areaId),"LineId":int(lineId),"WorkStationId":int(workstationId),"CreatedBy":int(createdBy),"ModelId":int(modelID),"IsActive":isActive,"OPList":toJsonString}   
				#system.perspective.print(params)
				result = system.db.runNamedQuery("Project_VECV/Master/WorkInstructionConfiguration/UpdateWI",params) 	 			
				#system.perspective.sendMessage(messageType,payload,scope = 'page' )
				if(int(result) > 0):		
				 	message = "Record Updated successfully."
				 	auditMsg=str(wiName) +" Configuration details updated successfully."
				 	headerLabel = "Add"
				 	messageType = 'WiGeneralPannel'   				
				 	payload = {'headerLabel':headerLabel,'WIid':wiID,'name':'','desc':'','areaId':-1,'lineId':-1,'WorkStationId':-1,'isActive':-1,'UsedStepCount':0}		 			
				 	system.perspective.sendMessage(messageType, payload, scope = 'page' )
				 	system.perspective.openDock("rightView")
				 	system.perspective.closeDock('rightp')
				 	#system.perspective.print ("loop1")
				 	messageType = 'tableRefresh'    	 			
				 	system.perspective.sendMessage(messageType,scope = 'page' )
				 	#system.perspective.print ("loop2")
				 	messageType = 'popup_View' 
				 	state='success'   			
				 	system.perspective.sendMessage(messageType,payload = {"display":1,'state':str(state),'text':str(message)},scope = 'page' )
				 	system.perspective.sendMessage("tableRow",payload = {"Index":-1}, scope = "page")	
				 	system.perspective.sendMessage("deleteIsVisible",payload = {"IsVisible":0}, scope = "page")	
				 	system.perspective.sendMessage("isEditDisplay",payload = {"IsVisible":0}, scope = "page")
				 					 
				
		else:
			messageType = 'popup_View'  
			state='error'      			
			system.perspective.sendMessage(messageType,payload = {"display":1,'state':str(state),'text':str(message)},scope = 'page' )
			
		#addToAuditLog
		system.perspective.print(auditMsg)
		category='Master Configuration'
		subCategory='WI Configuration'
		if(wiID!=0):
#			prevDesc=self.view.getChild("root").custom.payload
			prevDesc=payload
			#curDesc={"linetypecode":LineTypeCode, "mode":mode, "isActive":isActive, "Code":bomId }
			curDesc = {
							"wiName":wiName,
							"description":description,
							"wiID":wiID,
							"areaId":areaId,
							"lineId":lineId,
							"workstationId":workstationId,
							"isActive":isActive,
							"stepCount":stepCount,
							"modelID":modelID,
							"OPList":OPList,
							"BomId":BomId  
						}
			system.perspective.print(prevDesc)
			system.perspective.print(curDesc)
			description=str(auditMsg)+"Where ID="+str(wiID)+" With Previous Data->"+str(prevDesc)+" and Updated Data->"+str(curDesc)
		else:
			description=str(auditMsg)
		createdBy=int(loggedInUserId)
		Project_VECV.Configuration.Common.AddLogDetails.AddAuditLogs(category, subCategory, description, createdBy)
		#AuditLog end
			
	except:	
		#start of except block		
		screenName ='Work instruction' 
		filePath=str('Project_VECV/Configuration/WIGeneral/ButtonSave')
		errorFunction = str('Scripting:FunctionName->SaveWorkInstruction')
		errorType=str('Application')
		errorCode = str(Project_VECV.Common.GenerateUUID.getUniqueUUID()) 
		description=str(sys.exc_info()[1]) #error description
		lineNumber=str(sys.exc_info()[2].tb_lineno) #lineno on which error occur			
		Project_VECV.Configuration.Common.AddLogDetails.AddErrorLogs(screenName,filePath,errorFunction,errorType,errorCode,description,lineNumber)	

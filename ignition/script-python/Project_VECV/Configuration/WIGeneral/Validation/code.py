"""
Written By: Niladri Banerjee
Written Date: 20/05/2024
Purpose:			 
		Function to validate correct workinstruction. 
"""
def IsValidate(wiID,wiName,description,stepCount,modelID,workstationId,BomId):
	validationdict={'isValidate':1,'message':''}
	try:
#		params = {"WIName":str(wiName),"WIId":int(wiID)}
#		result = system.db.runNamedQuery("Project_VECV/Master/WorkInstructionConfiguration/CheckWINameAlreadyExist",params)
		params = {"bomid":int(BomId),"WIId":int(wiID),'workstationid':workstationId}
		result = system.db.runNamedQuery("Project_VECV/Master/WorkInstructionConfiguration/CheckWIAlreadyExist",params)
		stepCount=int(stepCount[15:len(stepCount)])
		
		if(wiName!=''):
			if(len(wiName)>50):
				validationdict={'isValidate':0,'message':'Work instrunction name length should be between 4 to 20 characters.'}
			elif(result >0):
				validationdict={'isValidate':0,'message':'Work instruction already exist.'}
			elif(len(description)>200):
				validationdict={'isValidate':0,'message':'Description must not exceed 200 characters.'}	
			elif(stepCount<= 0):
				validationdict={'isValidate':0,'message':'Please select steps for work instruction - '+wiName}
		else:
			validationdict={'isValidate':0,'message':'Fields mark with (*) are required.'}
	except:	
		#start of except block		
		screenName ='Work instruction' 
		filePath=str('Project_VECV/Configuration/WIGeneral/Validation')
		errorFunction = str('Scripting:FunctionName->IsValidate')
		errorType=str('Application')
		errorCode = str(Project_VECV.Common.GenerateUUID.getUniqueUUID()) 
		description=str(sys.exc_info()[1]) #error description
		lineNumber=str(sys.exc_info()[2].tb_lineno) #lineno on which error occur			
		Project_VECV.Configuration.Common.AddLogDetails.AddErrorLogs(screenName,filePath,errorFunction,errorType,errorCode,description,lineNumber)	
		validationdict={'isValidate':0,'message':'Exception occured'}			
	return validationdict

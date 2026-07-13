"""
Written By: Piyush Setia
Written Date: 30/05/2024
Purpose:			 
		Functions to insert Checklist data. 
"""	
def insertChecklist(Id,modelId, areaId, lineId, workstationId, item , sequence, isActive, createdBy, bomId):
	try:
		# query path
		queryPath='Project_VECV/Quality/insertChecklist'
		# query params
		queryParams={"Id":Id,"modelId":modelId , "areaId":areaId ,"lineId":lineId 
		,"workStationId":workstationId  ,"item":item ,"sequence":sequence ,
		"isActive":isActive  ,"createdBy":createdBy, "bomId":bomId}
		
		dataset = system.db.runNamedQuery(queryPath,queryParams)
		return dataset
	
	except:
		screenName ='Checklist Configuration'   
		filePath=str('Project_VECV/NamedQuery/Quality/insertChecklist')  
		errorFunction = str('Event:onActionPerformed -> insertChecklist')  
		errorType=str('Application')  
		errorCode = str(Project_VECV.Common.GenerateUUID.getUniqueUUID())   
		description=str(sys.exc_info()[1]) #error description 
		lineNumber=str(sys.exc_info()[2].tb_lineno) #lineno on which error 
		Project_VECV.Configuration.Common.AddLogDetails.AddErrorLogs(screenName,filePath,errorFunction,errorType,errorCode,description,lineNumber) 
		#End of except block		
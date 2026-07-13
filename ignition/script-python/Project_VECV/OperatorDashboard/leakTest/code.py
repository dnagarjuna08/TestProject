"""
	Written By: Amitkumar Ravat
	Written Date: 05/08/2024
	Purpose: Add leak test station event. 
"""
def AddStationEvents(MST_Event_Id, SerialNumber,MST_Status_Id, OperatorID, OPStartTime, OPEndTime, Process_LeakRate, Process_Pressure, WorkStationName, BOMName):
	try:
		params = {"dropdowntype":1,"workStationName":WorkStationName}
		queryPath = 'Project_VECV/LeakTest/getAllIDs'
		dataset = system.db.runNamedQuery(queryPath,params)
		system.util.getLogger("line 11").info(str(dataset))
		for data in dataset:
			MST_Area_Id=data['MST_Area_Id']
			MST_Line_Id=data['MST_Line_Id']
			MST_WorkStation_Id=data['MST_WorkStation_Id']
		
		system.util.getLogger("line 11").info(str(MST_Area_Id))
		
		params = {"dropdowntype":2,"M_BOMNumber":BOMName}
		queryPath = 'Project_VECV/LeakTest/getAllIDs'
		dataset = system.db.runNamedQuery(queryPath,params)
		for data in dataset:
			M_BOM_Id = data['M_BOM_Id']
			
		queryPath = 'Project_VECV/LeakTest/AddStationEvents'

		params = {'MST_Area_Id' : MST_Area_Id,
		'MST_Line_Id' : MST_Line_Id,
		'MST_WorkStation_Id' : MST_WorkStation_Id,
		'MST_Event_Id' : MST_Event_Id,
		'M_BOM_Id' : M_BOM_Id,
		'SerialNumber' : SerialNumber,
		'MST_Status_Id' : MST_Status_Id,
		'OperatorID' : OperatorID,
		'OPStartTime' : OPStartTime,
		'OPEndTime' : OPEndTime,
		'CreatedBy' : 0,
		'Process_LeakRate': Process_LeakRate,
		'Process_Pressure':Process_Pressure}
		system.db.runNamedQuery(queryPath,params)
	except:
		screenName ='AddStationEvents'   
		filePath=str('Project_VECV/OperatorDashboard/leakTest')  
		errorFunction = str('Project Library')  
		errorType=str('Application')  
		errorCode = str(Project_VECV.Common.GenerateUUID.getUniqueUUID())   
		description=str(sys.exc_info()[1]) #error description 
		lineNumber=str(sys.exc_info()[2].tb_lineno) #lineno on which error 
#		system.perspective.print("errorFunction: "+str(errorFunction)+" description: "+str(description)+" lineno: "+str(lineNumber))
		Project_VECV.Configuration.Common.AddLogDetails.AddErrorLogs(screenName,filePath,errorFunction,errorType,errorCode,description,lineNumber) 	
		
		
def testMAC():
	data = system.tag.readBlocking("[System]Client/Network/MACAddress")[0].value
	return data
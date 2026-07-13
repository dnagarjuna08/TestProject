"""
	Written By: Amitkumar Ravat
	Written Date: 05/06/2024
	Purpose: Get station details. 
"""
def getStationDetails(WorkStationID,SerialNumber,AreaID,LineID):
	try:
		queryPath = 'Project_VECV/OperatorDashboard/getStationStatus'
		params = {'WorkStationID':WorkStationID,'SerialNumber':SerialNumber}
		dataset = system.db.runNamedQuery(queryPath,params)
		if len(dataset) > 0:
			for data in dataset:
				status = data["Status"]
			count = Project_VECV.OperatorDashboard.OperatorDashboard.getNCCount(SerialNumber, WorkStationID, AreaID, LineID)
			if (status == 'OK') or (status == 'NOK' and count > 0) :
				return 1
			else:
				return 0
			return 0
		else:
			return 0
	except:
		screenName ='getStationDetails'   
		filePath=str('Project_VECV/OperatorDashboard/OperatorDashboard')  
		errorFunction = str('Project Library')  
		errorType=str('Application')  
		errorCode = str(Project_VECV.Common.GenerateUUID.getUniqueUUID())   
		description=str(sys.exc_info()[1]) #error description 
		lineNumber=str(sys.exc_info()[2].tb_lineno) #lineno on which error 
#		system.perspective.print("errorFunction: "+str(errorFunction)+" description: "+str(description)+" lineno: "+str(lineNumber))
		print("errorFunction: "+str(errorFunction)+" description: "+str(description)+" lineno: "+str(lineNumber))
		Project_VECV.Configuration.Common.AddLogDetails.AddErrorLogs(screenName,filePath,errorFunction,errorType,errorCode,description,lineNumber) 	
		return 0

					
"""
	Written By: Amitkumar Ravat
	Written Date: 05/06/2024
	Purpose: Get previous station status. 
"""					
def getPrevStationStatus(SerialNumber,WorkStationID,AreaID, LineID):
	try:
		queryPath = 'Project_VECV/OperatorDashboard/getPrevStationDetails'
		params = {'AreaID':AreaID,'LineID':LineID,'WorkStationID':WorkStationID}
		dataset = system.db.runNamedQuery(queryPath,params)
		flag = 1
		for data in dataset:
			workstationId =  data['prevMST_WorkStation_Id']
			parallelId = data['ParallelStation']
			if workstationId == "":
				return 1
			else:
				if ',' in workstationId:
					wsIds1 = workstationId.split(',')
				else:
					wsIds1 = [workstationId]
				if ',' in parallelId:
					wsIds2 = parallelId.split(',')
				else:
					wsIds2 = [parallelId]
				wsIds = wsIds1 + wsIds2
				for ws in wsIds:
					if str(ws) != '':
						status = getStationDetails(int(ws.strip()),SerialNumber,AreaID,LineID)
						if status == 0:
							flag = 3
							break
		return flag
	except:
		screenName ='getPrevStationStatus'   
		filePath=str('Project_VECV/OperatorDashboard/OperatorDashboard')  
		errorFunction = str('Project Library')  
		errorType=str('Application')  
		errorCode = str(Project_VECV.Common.GenerateUUID.getUniqueUUID())   
		description=str(sys.exc_info()[1]) #error description 
		lineNumber=str(sys.exc_info()[2].tb_lineno) #lineno on which error 
#		system.perspective.print("errorFunction: "+str(errorFunction)+" description: "+str(description)+" lineno: "+str(lineNumber))
		print("errorFunction: "+str(errorFunction)+" description: "+str(description)+" lineno: "+str(lineNumber))
		Project_VECV.Configuration.Common.AddLogDetails.AddErrorLogs(screenName,filePath,errorFunction,errorType,errorCode,description,lineNumber) 	
		return 1
	
	
"""
	Written By: Amitkumar Ravat
	Written Date: 05/06/2024
	Purpose: Get station status. 
"""	
def checkDetailsForOPStart(SerialNumber, WorkStationID, AreaID, LineID):
	try:
		queryPath = 'Project_VECV/OperatorDashboard/getStationStatus'
		params = {'WorkStationID':WorkStationID,'SerialNumber':SerialNumber}
		dataset = system.db.runNamedQuery(queryPath,params)
		if len(dataset) > 0:
			for data in dataset:
				status = data["Status"]
			count = Project_VECV.OperatorDashboard.OperatorDashboard.getNCCount(SerialNumber, WorkStationID, AreaID, LineID)
			if (status == 'OK') or (status == 'NOK' and count > 0) :
				return 2
			return 1
		else:
			return getPrevStationStatus(SerialNumber,WorkStationID,AreaID, LineID)
	except:
		screenName ='checkDetailsForOPStart'   
		filePath=str('Project_VECV/OperatorDashboard/OperatorDashboard')  
		errorFunction = str('Project Library')  
		errorType=str('Application')  
		errorCode = str(Project_VECV.Common.GenerateUUID.getUniqueUUID())   
		description=str(sys.exc_info()[1]) #error description 
		lineNumber=str(sys.exc_info()[2].tb_lineno) #lineno on which error 
#		system.perspective.print("errorFunction: "+str(errorFunction)+" description: "+str(description)+" lineno: "+str(lineNumber))
		print("errorFunction: "+str(errorFunction)+" description: "+str(description)+" lineno: "+str(lineNumber))
		Project_VECV.Configuration.Common.AddLogDetails.AddErrorLogs(screenName,filePath,errorFunction,errorType,errorCode,description,lineNumber) 	
		return 1
		
"""
	Written By: Amitkumar Ravat
	Written Date: 05/06/2024
	Purpose: Add station events. 
"""			
def AddStationEvents(MST_Area_Id,MST_Line_Id,MST_Shift_Id,MST_WorkStation_Id, MST_Event_Id, M_BOM_Id, SerialNumber, PartNumber, MST_OPCode_Id, MST_OPDefinition_Id, MST_Status_Id, ConsumedSerialNumber,
ConsumedPartNumber, PLCTorqueValue, PLCTorqueCount, PLCTorqueResult, Torque_Angle, MESTorqueResult, MESTorqueMaxValue, MESTorqueMinValue, PressingValue, PressingDepth,
PressingPTLStatus, ProcessPTLStatus, OperatorID, IsExceedTime, CreatedBy, OrderNumber, LeakRate, pressure, abs, GreaseQty):
	try:
		queryPath = 'Project_VECV/OperatorDashboard/AddStationEvents'
		system.perspective.print("inside AddStationEvents")
		params = {'MST_Area_Id' : MST_Area_Id,
		'MST_Line_Id' : MST_Line_Id,
		'MST_Shift_Id' : MST_Shift_Id,
		'MST_WorkStation_Id' : MST_WorkStation_Id,
		'MST_Event_Id' : MST_Event_Id,
		'M_BOM_Id' : M_BOM_Id,
		'SerialNumber' : SerialNumber,
		'PartNumber' : PartNumber,
		'MST_OPCode_Id' : MST_OPCode_Id,
		'MST_OPDefinition_Id' : MST_OPDefinition_Id,
		'MST_Status_Id' : MST_Status_Id,
		'ConsumedSerialNumber' : ConsumedSerialNumber,
		'ConsumedPartNumber' : ConsumedPartNumber,
		'PLCTorqueValue' : PLCTorqueValue,
		'PLCTorqueCount' : PLCTorqueCount,
		'PLCTorqueResult' : PLCTorqueResult,
		'Torque_Angle' : Torque_Angle,
		'MESTorqueResult' : MESTorqueResult,
		'MESTorqueMaxValue' : MESTorqueMaxValue,
		'MESTorqueMinValue' : MESTorqueMinValue,
		'PressingValue' : PressingValue,
		'PressingDepth' : PressingDepth,
		'PressingPTLStatus' : PressingPTLStatus,
		'ProcessPTLStatus' : ProcessPTLStatus,
		'OperatorID' : OperatorID,
		'IsExceedTime' : IsExceedTime,
		'CreatedBy' : CreatedBy,
		'OrderNumber': OrderNumber,
		'LeakRate': LeakRate,
		'pressure': pressure,
		'abs': abs,
		'GreaseQty': GreaseQty}
		system.perspective.print(params)
		system.db.runNamedQuery(queryPath,params)
	except:
		screenName ='AddStationEvents'   
		filePath=str('Project_VECV/OperatorDashboard/OperatorDashboard')  
		errorFunction = str('Project Library')  
		errorType=str('Application')  
		errorCode = str(Project_VECV.Common.GenerateUUID.getUniqueUUID())   
		description=str(sys.exc_info()[1]) #error description 
		lineNumber=str(sys.exc_info()[2].tb_lineno) #lineno on which error 
		system.perspective.print("errorFunction: "+str(errorFunction)+" description: "+str(description)+" lineno: "+str(lineNumber))
		Project_VECV.Configuration.Common.AddLogDetails.AddErrorLogs(screenName,filePath,errorFunction,errorType,errorCode,description,lineNumber) 	
		
"""
	Written By: Amitkumar Ravat
	Written Date: 05/06/2024
	Purpose: Update station events. 
"""			
def UpdateStationEvents(SerialNumber, WorkStationId, BOMId, ModifiedBy, EventId):
	try:
		queryPath = 'Project_VECV/OperatorDashboard/UpdateStationEvents'
		params = {'SerialNumber':SerialNumber,
		'WorkStationId':WorkStationId,
		'BOMId':BOMId,
		'ModifiedBy':ModifiedBy,
		'EventId':EventId}
		system.db.runNamedQuery(queryPath,params)
	except:
		screenName ='UpdateStationEvents'   
		filePath=str('Project_VECV/OperatorDashboard/OperatorDashboard')  
		errorFunction = str('Project Library')  
		errorType=str('Application')  
		errorCode = str(Project_VECV.Common.GenerateUUID.getUniqueUUID())   
		description=str(sys.exc_info()[1]) #error description 
		lineNumber=str(sys.exc_info()[2].tb_lineno) #lineno on which error 
		system.perspective.print("errorFunction: "+str(errorFunction)+" description: "+str(description)+" lineno: "+str(lineNumber))
		Project_VECV.Configuration.Common.AddLogDetails.AddErrorLogs(screenName,filePath,errorFunction,errorType,errorCode,description,lineNumber) 	


"""
	Written By: Amitkumar Ravat
	Written Date: 05/06/2024
	Purpose: Update station status. 
"""	
def UpdateOrderStatus(ModifiedBy, SerialNumber, BOMId, OrderNumber):
	try:
		queryPath = 'Project_VECV/OperatorDashboard/UpdateOrderStatus'
		params = {'ModifiedBy':ModifiedBy,
		'SerialNumber':SerialNumber,
		'BOMId':BOMId,
		'OrderNumber':OrderNumber}
		system.db.runNamedQuery(queryPath,params)
	except:
		screenName ='UpdateOrderStatus'   
		filePath=str('Project_VECV/OperatorDashboard/OperatorDashboard')  
		errorFunction = str('Project Library')  
		errorType=str('Application')  
		errorCode = str(Project_VECV.Common.GenerateUUID.getUniqueUUID())   
		description=str(sys.exc_info()[1]) #error description 
		lineNumber=str(sys.exc_info()[2].tb_lineno) #lineno on which error 
		system.perspective.print("errorFunction: "+str(errorFunction)+" description: "+str(description)+" lineno: "+str(lineNumber))
		Project_VECV.Configuration.Common.AddLogDetails.AddErrorLogs(screenName,filePath,errorFunction,errorType,errorCode,description,lineNumber) 	
		
"""
	Written By: Amitkumar Ravat
	Written Date: 05/06/2024
	Purpose: Get running order status. 
"""		
def getOrderStatus(SerialNumber, BOMId):
	queryPath = 'Project_VECV/OperatorDashboard/GetStartedOrderStatus'
	params = {'SerialNumber':SerialNumber,'BOMId':BOMId}
	dataset = system.db.runNamedQuery(queryPath,params)
	for data in dataset:
		return data['IsStarted']
	return False
	
def getTakeOutStatus(SerialNumber, BOMId, OrderNumber, LineId):
	queryPath = 'Project_VECV/OperatorDashboard/GetTakeoutOrderStatus'
	params = {'SerialNumber':SerialNumber,'BOMId':BOMId,'OrderNumber':OrderNumber,'LineId':LineId}
	dataset = system.db.runNamedQuery(queryPath,params)
	for data in dataset:
		return data['IsTakeout']
	return False
	
"""
	Written By: Amitkumar Ravat
	Written Date: 05/06/2024
	Purpose: Add Lognc event along with station event. 
"""	
def AddLogNCPerStationEvents(MST_Area_Id,MST_Line_Id,MST_Shift_Id,MST_WorkStation_Id, MST_Event_Id, M_BOM_Id, SerialNumber, PartNumber, MST_OPCode_Id, MST_OPDefinition_Id, MST_Status_Id, ConsumedSerialNumber,
ConsumedPartNumber, PLCTorqueValue, PLCTorqueCount, PLCTorqueResult, Torque_Angle, MESTorqueResult, MESTorqueMaxValue, MESTorqueMinValue, PressingValue, PressingDepth,
PressingPTLStatus, ProcessPTLStatus, OperatorID, IsExceedTime, CreatedBy, OrderNumber, LOGNCId, Comments, ID, LeakRate, pressure, abs,GreaseQty):
	try:
		system.perspective.print("LOGNCId**%s"%LOGNCId)
		queryPath = 'Project_VECV/OperatorDashboard/AddLogNCPerStationEvents'
		params = {'MST_Area_Id' : MST_Area_Id,
		'MST_Line_Id' : MST_Line_Id,
		'MST_Shift_Id': MST_Shift_Id,
		'MST_WorkStation_Id' : MST_WorkStation_Id,
		'MST_Event_Id' : MST_Event_Id,
		'M_BOM_Id' : M_BOM_Id,
		'SerialNumber' : SerialNumber,
		'PartNumber' : PartNumber,
		'MST_OPCode_Id' : MST_OPCode_Id,
		'MST_OPDefinition_Id' : MST_OPDefinition_Id,
		'MST_Status_Id' : MST_Status_Id,
		'ConsumedSerialNumber' : ConsumedSerialNumber,
		'ConsumedPartNumber' : ConsumedPartNumber,
		'PLCTorqueValue' : PLCTorqueValue,
		'PLCTorqueCount' : PLCTorqueCount,
		'PLCTorqueResult' : PLCTorqueResult,
		'Torque_Angle' : Torque_Angle,
		'MESTorqueResult' : MESTorqueResult,
		'MESTorqueMaxValue' : MESTorqueMaxValue,
		'MESTorqueMinValue' : MESTorqueMinValue,
		'PressingValue' : PressingValue,
		'PressingDepth' : PressingDepth,
		'PressingPTLStatus' : PressingPTLStatus,
		'ProcessPTLStatus' : ProcessPTLStatus,
		'OperatorID' : OperatorID,
		'IsExceedTime' : IsExceedTime,
		'CreatedBy' : CreatedBy,
		'OrderNumber':OrderNumber,
		'LOGNCId':LOGNCId,
		'Comments':Comments,
		'ID':ID,
		'LeakRate':LeakRate,
		'pressure': pressure,
		'abs': abs,
		'GreaseQty': GreaseQty}
		system.perspective.print("params %s "%params)
		system.db.runNamedQuery(queryPath,params)
	except:
		screenName ='AddLogNCPerStationEvents'   
		filePath=str('Project_VECV/OperatorDashboard/OperatorDashboard')  
		errorFunction = str('Project Library')  
		errorType=str('Application')  
		errorCode = str(Project_VECV.Common.GenerateUUID.getUniqueUUID())   
		description=str(sys.exc_info()[1]) #error description 
		lineNumber=str(sys.exc_info()[2].tb_lineno) #lineno on which error 
		system.perspective.print("errorFunction: "+str(errorFunction)+" description: "+str(description)+" lineno: "+str(lineNumber))
		Project_VECV.Configuration.Common.AddLogDetails.AddErrorLogs(screenName,filePath,errorFunction,errorType,errorCode,description,lineNumber) 	

"""
	Written By: Amitkumar Ravat
	Written Date: 05/06/2024
	Purpose: Get NonConformance count. 
"""
def getNCCount(SerialNumber, WorkStationID, AreaID, LineID):
	queryPath = 'Project_VECV/OperatorDashboard/getNCCount'
	params = {"MST_Area_Id":AreaID,"MST_Line_Id":LineID,"MST_WorkStation_Id":WorkStationID,"SerialNumber":SerialNumber}
	dataset = system.db.runNamedQuery(queryPath,params)
	result = 0
	for i in dataset:
		result = i['count']
	return result
	
"""
	Written By: Amitkumar Ravat
	Written Date: 05/06/2024
	Purpose: Get details for Parallel station status. 
"""	
def checkDetailsForOPStartParrallel(SerialNumber, PWorkStationID, AreaID, LineID, WorkStationID):
	try:
		queryPath = 'Project_VECV/OperatorDashboard/getStationStatus'
		params = {'WorkStationID':PWorkStationID,'SerialNumber':SerialNumber}
		dataset = system.db.runNamedQuery(queryPath,params)
		if len(dataset) > 0:
			for data in dataset:
				status = data["Status"]
			count = Project_VECV.OperatorDashboard.OperatorDashboard.getNCCount(SerialNumber, PWorkStationID, AreaID, LineID)
			if (status == 'OK') or (status == 'NOK' and count > 0) :
				return 2
			return 1
		else:
			return getPrevStationStatus(SerialNumber,WorkStationID,AreaID, LineID)
	except:
		screenName ='checkDetailsForOPStart'   
		filePath=str('Project_VECV/OperatorDashboard/OperatorDashboard')  
		errorFunction = str('Project Library')  
		errorType=str('Application')  
		errorCode = str(Project_VECV.Common.GenerateUUID.getUniqueUUID())   
		description=str(sys.exc_info()[1]) #error description 
		lineNumber=str(sys.exc_info()[2].tb_lineno) #lineno on which error 
#		system.perspective.print("errorFunction: "+str(errorFunction)+" description: "+str(description)+" lineno: "+str(lineNumber))
		print("errorFunction: "+str(errorFunction)+" description: "+str(description)+" lineno: "+str(lineNumber))
		Project_VECV.Configuration.Common.AddLogDetails.AddErrorLogs(screenName,filePath,errorFunction,errorType,errorCode,description,lineNumber) 	
		return 1
		
def OperatorScreen():
	Project_VECV.Transmission.delaytimer.delayTime(0.5)
	return
	
		
def DWI():
	Project_VECV.Transmission.delaytimer.delayTime(0.1)
	return
	
		
def getTakeOutStatus(SerialNumber, BOMId, OrderNumber, LineId):
	queryPath = 'Project_VECV/OperatorDashboard/GetTakeoutOrderStatus'
	params = {'SerialNumber':SerialNumber,'BOMId':BOMId,'OrderNumber':OrderNumber,'LineId':LineId}
	dataset = system.db.runNamedQuery(queryPath,params)
	for data in dataset:
		return data['IsTakeout']
	return False
	
	
def getTakeOutStatusPDI(SerialNumber):
	queryPath = 'Project_VECV/Quality/checkTakeOutPDI'
	params = {'SerialNumber':SerialNumber}
	dataset = system.db.runNamedQuery(queryPath,params)
	for data in dataset:
		return data['IsTakeout']
	return False
	
def GetTakeoutOrderStatusBackend(SerialNumber, LineName):
	queryPath = 'Project_VECV/OperatorDashboard/GetTakeoutOrderStatusBackend'
	params = {'SerialNumber':SerialNumber,'LineName':LineName}
	dataset = system.db.runNamedQuery(queryPath,params)
	for data in dataset:
		return data['IsTakeout']
	return False
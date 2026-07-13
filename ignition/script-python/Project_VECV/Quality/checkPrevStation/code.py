def getStationDetails(WorkStationID,SerialNumber):
	queryPath = 'Project_VECV/OperatorDashboard/getStationStatus'
	params = {'WorkStationID':WorkStationID,'SerialNumber':SerialNumber}
	dataset = system.db.runNamedQuery(queryPath,params)
	if len(dataset) > 0:
		for data in dataset:
			status = data["Status"]
		queryPath = 'Project_VECV/Quality/NCCount'
		params = {"MST_WorkStation_Id":WorkStationID,"SerialNumber":SerialNumber}
		dataset = system.db.runNamedQuery(queryPath,params)
		count = 0
		for i in dataset:
			count = i['count']
		if (status == 'OK') or (status == 'NOK' and count > 0) :
			return 1
		else:
			return 0
		return 0
	else:
		return 0

def getPrevStationStatus(SerialNumber,WorkStationID,AreaID, LineID):
	try:
		queryPath = 'Project_VECV/OperatorDashboard/getPrevStationDetails'
		params = {'AreaID':AreaID,'LineID':LineID,'WorkStationID':WorkStationID}
		dataset = system.db.runNamedQuery(queryPath,params)
		flag = 1
		for data in dataset:
			workstationId =  data['prevMST_WorkStation_Id']
			parallelId = data['ParallelStation']
			IDs =  parallelId + ',' + workstationId
			if IDs == ",":
				return 1
			else:
				IDs = IDs.split(',')
				for ws in IDs:
					if str(ws) != '':
						status = getStationDetails(int(ws.strip()),SerialNumber)
						if status == 1:
							flag = 1
							break
						else:
							flag = 3
		return flag
	except:
		return 1

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
#			print "no work done on this Station" #check whether all it's previous station are completed
			return getPrevStationStatus(SerialNumber,WorkStationID,AreaID, LineID)
	except:
		return 1
		
		
#prev_station_status = checkDetailsForOPStart(SerialNumber, WorkStationID, AreaID, LineID)
#if prev_station_status == 1:
#	print " carry on"
#elif prev_station_status == 2:
#	print "current Station complete"
#else:
#	print "previous is not ok"
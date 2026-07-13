def getStationDetails(SerialNumber, BOM):
	queryPath = 'Project_VECV/OperatorDashboard/getPrevQG3Data'
	params = {'BOM':BOM,'Serial':SerialNumber}
	dataset = system.db.runNamedQuery(queryPath,params)
	if len(dataset) > 0:
		for data in dataset:
			status = data["Status"]
		if (status == 'OK') or (status == 'NOK') :
			return 1
		else:
			return 3
		return 3
	else:
		return 3


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
			return getStationDetails(SerialNumber,SerialNumber.split('-')[1])
	except:
		return 1

"""
	Written By: Amitkumar Ravat
	Written Date: 08/06/2024
	Purpose: Function to get event ID values. 
"""
EMPTY = 1
WAITING_TO_START = 2
STARTED = 3
PAUSE = 4
COMPLETED = 5
EXCEEDTIME = 6 
PARTIALNEWSTART = 7
LOGNC = 8
TAKEOUT = 9
REWORKSTARTED = 10
REWORKCOMPLETED = 11
TESTINGSTARTED = 12
TESTINGCOMPLETED = 13
REPAIRSTARTED = 14
REPAIRCOMPLETED = 15
PAINTINGSTARTED = 16
PAINTINGCOMPLETED = 17
PDISTARTED = 18
PDICOMPLETED = 19
NEWSTART = 20
NoOperationRequired = 21

VariantLineID = [40, 41]
Mode = { '40':"Titan EV Carrier",'41': "Titan Diesel Carrier"}

def getEmptyID():
	return EMPTY

def getMode():
	return Mode

def getWaitingToStartID():
	return WAITING_TO_START
	
def getStartedID():
	return STARTED
	
def getPauseID():
	return PAUSE
	
def getCompletedID():
	return COMPLETED
	
def getExceedTimeID():
	return EXCEEDTIME
	
def getPartialNewStartID():
	return PARTIALNEWSTART
	
def getlogNCID():
	return LOGNC
	
def getTakeOutID():
	return TAKEOUT
	
def getReworkStartedID():
	return REWORKSTARTED
	
def getReworkCompletedID():
	return REWORKCOMPLETED
	
def getTestingStartedID():
	return TESTINGSTARTED
	
def getTestingCompletedID():
	return TESTINGCOMPLETED
	
def getRepairStartedID():
	return REPAIRSTARTED
	
def getRepairCompletedID():
	return REPAIRCOMPLETED
	
def getPaintingStartedID():
	return PAINTINGSTARTED
	
def getPaintingCompletedID():
	return PAINTINGCOMPLETED
	
def getPDIStartedID():
	return PDISTARTED
	
def getPDICompletedID():
	return PDICOMPLETED
	
def getNewStartID():
	return NEWSTART
	
def getNoOperationRequiredID():
	return NoOperationRequired

def getVariantLineID():
	return VariantLineID


def getMainWashingMachineID(AreaName):
	if AreaName=='Titan Axle':
		workstationName = 'LAML10'
		workstationID = system.db.runNamedQuery('Project_VECV/Order/WashingMachine/getActiveWashingMachine',{'workstationName':workstationName})
		return workstationID
	elif AreaName=='Legacy Axle':
		workstationName = 'LAH20'
		workstationID = system.db.runNamedQuery('Project_VECV/Order/WashingMachine/getActiveWashingMachine',{'workstationName':workstationName})
		return workstationID
	elif AreaName=='6S Legacy Transmission':
		workstationName = ''
		workstationID = system.db.runNamedQuery('Project_VECV/Order/WashingMachine/getActiveWashingMachine',{'workstationName':workstationName})
		return workstationID
	return None
		
		
		
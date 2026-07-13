"""
	Written By: Amitkumar Ravat
	Written Date: 11/07/2024
	Purpose: Function to get log NC data based on different filter conditions. 
"""
def getLOGNCbySerialNumber(StartDate, Endate, SerialNumbers, workstation):
	params = {"SerialNumber":SerialNumbers,"EndDate":Endate,"StartDate":StartDate, "workstation":workstation}
	return system.db.runNamedQuery('Project_VECV/Report/LOGNC/getLOGNCBySerialNumber',params)
	
	
def getLOGNCbyBOM(StartDate, Endate, BOM):
	params = {"BOM":BOM,"EndDate":Endate,"StartDate":StartDate}
	return system.db.runNamedQuery('Project_VECV/Report/LOGNC/getLOGNCByBOM',params)	
	

def getLOGNCbyWS(StartDate, Endate, WS):
	params = {"workstation":WS,"EndDate":Endate,"StartDate":StartDate}
	return system.db.runNamedQuery('Project_VECV/Report/LOGNC/getLOGNCByWorkStation',params)	


def getLOGNCbyLine(StartDate, Endate, Line):
	params = {"Line":Line,"EndDate":Endate,"StartDate":StartDate}
	return system.db.runNamedQuery('Project_VECV/Report/LOGNC/getLOGNCByLine',params)	
	
	
def getLOGNCbyArea(StartDate, Endate, Area):
	params = {"Area":Area,"EndDate":Endate,"StartDate":StartDate}
	return system.db.runNamedQuery('Project_VECV/Report/LOGNC/getLOGNCByArea',params)	
	
def getLOGNC(StartDate, Endate, SerialNumbers, workstation, Area, Line, BOM):
	params = {"SerialNumber":SerialNumbers,"EndDate":Endate,"StartDate":StartDate, "workstation":workstation}
	return system.db.runNamedQuery('Project_VECV/Report/LOGNC/getLOGNC',params)
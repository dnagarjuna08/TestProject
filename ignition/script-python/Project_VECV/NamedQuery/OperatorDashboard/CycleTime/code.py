"""
Written By: Amitkumar Ravat
Written Date: 05/06/2024
Purpose:			 
		Functions to Get cycle time on DWI. 
"""	
def getCycleTime(LineID, WorkstationID, ModelID):
	params = {'LineID':LineID,'WorkstationID':WorkstationID,'ModelID':ModelID}
	return system.db.runNamedQuery('Project_VECV/OperatorDashboard/getCycleTime',params)[0]['CycleTime']
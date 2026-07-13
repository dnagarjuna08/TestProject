"""
	Written By: Amitkumar Ravat
	Written Date: 05/06/2024
	Purpose: Get details for Parallel station. 
"""
def getParallelStation(workStation):
	dataset = system.db.runNamedQuery('Project_VECV/OperatorDashboard/getparallelStation',{'workStation':workStation})
	workStation = ''
	for data in dataset:
		workStation = str(data['MST_WorkStation_Id'])
	return workStation
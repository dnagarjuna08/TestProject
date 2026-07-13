"""
	Written By: Amitkumar Ravat
	Written Date: 05/06/2024
	Purpose: Check Gear Ratio. 
"""
def checkGearRatio(SerialNumber,BOM):
	system.db.runNamedQuery("Project_VECV/OperatorDashboard/checkGearRatio",{"SerialNumber":SerialNumber,"BOM":BOM})

"""
	Written By: Sagar Iparkar
	Written Date: 11/05/2024
	Purpose: Function to get shift name from line id. 
"""
def getShiftName(MST_Line_Id):
	dataset = system.db.runNamedQuery("Project_VECV/NumberPunching/getShiftName",{'MST_Line_Id':MST_Line_Id})
	Shift = ''
	MST_Shift_Id = 0
	shiftdetails=''
	for data in dataset:
		Shift = data['Shift']
		MST_Shift_Id = data['MST_Shift_Id']	
		shiftdetails = str(Shift) + '-' + str(MST_Shift_Id)
	return shiftdetails
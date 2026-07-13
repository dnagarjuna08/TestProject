"""
Written By: Amitkumar Ravat
Written Date: 10/05/2024
Purpose:			 
		Functions to insert/update shift details into table. 
"""
def InsertUpdateShift(ModifiedBy, IsActive ,MST_Line_Id, MST_Shift_Id, ShiftEndTime,  ShiftStartTime,  ShiftNumber,TRN_Shift_Id):
	#NamedQueryPath
	queryPath = 'Project_VECV/Shift/InsertUpdateTRNShift'
	
	#NamedQuery Params
	queryParams = {'ModifiedBy':ModifiedBy, 'IsActive':IsActive ,'MST_Line_Id':MST_Line_Id, 'MST_Shift_Id':MST_Shift_Id, 'ShiftEndTime':ShiftEndTime, 'ShiftStartTime':ShiftStartTime,  'ShiftNumber':ShiftNumber,
				'TRN_Shift_Id':TRN_Shift_Id}
	dataset = system.db.runNamedQuery(queryPath,queryParams)
	for data in dataset:
			result = data['Result']
	return result
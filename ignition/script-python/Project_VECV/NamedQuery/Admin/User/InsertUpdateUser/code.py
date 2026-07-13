"""
Written By: Amitkumar Ravat
Written Date: 02/05/2024
Purpose:			 
		Functions to insert/update user details into table. 

Update Date: 10/01/2025
Author: Aniket Sagar
Purpose: Add Service request number 
"""
def UpdateUserManagement(firstName, lastName, userName, roleID, email, phoneNumber, isActive, password, passwordExpiry, modifiedBy, Id,serviceRequest):
	#NamedQueryPath
	queryPath = 'Project_VECV/User/InsertUpdateUserManagement'
	
	#NamedQuery Params
	queryParams = {"firstName":firstName,"lastName":lastName, "userName":userName,
					"roleID" :roleID,"email":email, "phoneNumber":phoneNumber,
					"isActive":isActive, "password":password,"passwordExpiry":passwordExpiry,
					"modifiedBy":modifiedBy, "Id": Id, "serviceRequest":serviceRequest}
	dataset = system.db.runNamedQuery(queryPath,queryParams)
	for data in dataset:
		result = data['Result']
	return result
	
	
	
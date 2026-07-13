"""
Written By: Amitkumar Ravat
Written Date: 01/05/2024
Purpose:			 
		Functions to get role details module/form wise. 
"""
def getRolesModules(roleID):
	queryPath = 'Project_VECV/Role/Role_Module/Get_RolesModules'
	queryParams = {"roleID":roleID}
	dataset = system.db.runNamedQuery(queryPath,queryParams)
	return dataset
	
	
def getRoles():
	queryPath = 'Project_VECV/Role/Role_Module/Get_AllRole'
	dataset = system.db.runNamedQuery(queryPath)
	return dataset
	

def getUserBasedOnRoles(roleID):
	queryPath = 'Project_VECV/Role/getUserBasedOnRoles'
	queryParams = {"roleID":roleID}
	dataset = system.db.runNamedQuery(queryPath,queryParams)
	return dataset
	
	
def getUserModules(userID):
	queryPath = 'Project_VECV/Role/Role_Module/Get_UserModules'
	queryParams = {"userID":userID}
	dataset = system.db.runNamedQuery(queryPath,queryParams)
	return dataset


def getUserScreen(userID):
	queryPath = 'Project_VECV/Role/Role_Screens/Get_UserScreenData'
	queryParams = {"userID":userID}
	dataset = system.db.runNamedQuery(queryPath,queryParams)
	return dataset
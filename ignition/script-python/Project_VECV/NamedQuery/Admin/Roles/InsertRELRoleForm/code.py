"""
Written By: Amitkumar Ravat
Written Date: 01/05/2024
Purpose:			 
		Functions to insert/update role details into table. 
"""
def UpdateRELRoleForm(MST_Role_Id, MST_Module_Id, MST_Form_Id, CreatedBy, isEdit):
	#NamedQueryPath
	queryPath = 'Project_VECV/Role/UpdateRELRoleForm'
	#NamedQuery Params
	queryParams = {"MST_Role_Id":MST_Role_Id,"MST_Module_Id":MST_Module_Id,"MST_Form_Id":MST_Form_Id,"CreatedBy":CreatedBy,
					"isEdit":isEdit}
	return system.db.runNamedQuery(queryPath,queryParams)
	
	
def UpdateRELUserForm(MST_User_Id, MST_Module_Id, MST_Form_Id, CreatedBy, isEdit):
	#NamedQueryPath
	queryPath = 'Project_VECV/Role/UpdateRELUserForm'
	#NamedQuery Params
	queryParams = {"MST_User_Id":MST_User_Id,"MST_Module_Id":MST_Module_Id,"MST_Form_Id":MST_Form_Id,"CreatedBy":CreatedBy,
					"isEdit":isEdit}
	return system.db.runNamedQuery(queryPath,queryParams)
	
	
def InsertUpdateRolesConfiguration(roleName, description, createdBy, Id, isActive):
	#NamedQueryPath
	queryPath = 'Project_VECV/Role/InsertUpdateRoles'
	#NamedQuery Params
	queryParams = {"roleName":roleName,"description":description,"createdBy":createdBy,"Id":Id, "isActive":isActive}
	dataset = system.db.runNamedQuery(queryPath,queryParams)
	for data in dataset:
		result = data['Result']
	return result
	
	
	
	
	
def isAuthenticate(userName, password):
	queryPath = 'Project_VECV/Login/Authenticate'
	queryParams = {"userName":userName,"password":password}
	return system.db.runNamedQuery(queryPath,queryParams)
	
def GetAssignFormToRole(roleID):		
	main_nav=()
	queryParams = {"roleID":roleID}
	menu_data = system.db.runNamedQuery("Project_VECV/MenuBarNavigation/GetData",queryParams)
	# Define a dictionary to store the menu structure
	menu_structure = {}
	
	# Iterate over the fetched menu data
	for row in menu_data:
	    menu_description = row["MenuDescription"]
	    icon_path = row["ParentIconPath"]
	    c_icon_path = row["ChildIconPath"]
	    action_path = row["ActionPath"]
	    sub_menu_name = row["subMenuName"]
	    target = row["TargetURL"]
	
	    # If the MenuDescription doesn't exist in the menu_structure dictionary, add it
	    if menu_description not in menu_structure:
	        menu_structure[menu_description] = {
	            "instanceStyle": {"classes": ""},
	            "instancePosition": {},
	            "ActionPath": action_path,
	            "IconPath": icon_path,
	            "Instance": [],
	            "MenuDescription": menu_description
	        }
	
	    # Add submenu details to the menu structure
	    menu_structure[menu_description]["Instance"].append({
	        "icon": c_icon_path,
	        "instancePosition": {},
	        "instanceStyle": {"classes": ""},
	        "subMenuName": sub_menu_name,
	        "target": target
	    })
	
	# Convert menu structure dictionary to JSON
	menu_json =list(menu_structure.values())
	val = system.util.jsonEncode(menu_structure,5)
	obj=main_nav+tuple(menu_json)
	desired_order = ["Administration", "Master Configuration", "Operator Dashboard", "Report", "Order", "Quality"]
	sorted_menu_data = sorted(obj, key=lambda x: desired_order.index(x["MenuDescription"]))
	return sorted_menu_data	
		
def GetAssignFormToUser(userID):
	main_nav=()
	queryParams = {"userID":userID}
	menu_data = system.db.runNamedQuery("Project_VECV/Role/getNavigationMenu",queryParams)
	# Define a dictionary to store the menu structure
	menu_structure = {}
	
	# Iterate over the fetched menu data
	for row in menu_data:
	    menu_description = row["MenuDescription"]
	    icon_path = row["ParentIconPath"]
	    c_icon_path = row["ChildIconPath"]
	    action_path = row["ActionPath"]
	    sub_menu_name = row["subMenuName"]
	    target = row["TargetURL"]
	
	    # If the MenuDescription doesn't exist in the menu_structure dictionary, add it
	    if menu_description not in menu_structure:
	        menu_structure[menu_description] = {
	            "instanceStyle": {"classes": ""},
	            "instancePosition": {},
	            "ActionPath": action_path,
	            "IconPath": icon_path,
	            "Instance": [],
	            "MenuDescription": menu_description
	        }
	
	    # Add submenu details to the menu structure
	    menu_structure[menu_description]["Instance"].append({
	        "icon": c_icon_path,
	        "instancePosition": {},
	        "instanceStyle": {"classes": ""},
	        "subMenuName": sub_menu_name,
	        "target": target
	    })
	
	# Convert menu structure dictionary to JSON
	menu_json =list(menu_structure.values())
	val = system.util.jsonEncode(menu_structure,5)
	obj=main_nav+tuple(menu_json)
	desired_order = ["Administration", "Master Configuration", "Operator Dashboard", "Report", "Order", "Quality"]
	sorted_menu_data = sorted(obj, key=lambda x: desired_order.index(x["MenuDescription"]))
	return sorted_menu_data

"""
Written By: AmitKumar ravat
Written Date: 25/08/2024
Purpose:			 
		Functions to return user details from AD. 
"""
def getUserDetails(username):

    # Specify the user source (replace 'AD_UserSource' with your actual AD user source name)
    user_source = "VECV"
    
    try:
        # Get the user object from the user source
        user = system.user.getUser(user_source, username)

        if user is not None:
            # Get user details
            user_details = {
                "Username":  user.get('username'),
                "Full Name":  str(user.get('firstname'))+' '+str(user.get('lastname')),
                "Roles":user.get('roles')
            }
            return user_details
        else:
            return None
    except Exception as e:
        print "Error: " + str(e)
        return None
        
def getValidUser(UserName,Password):
	return system.security.validateUser(UserName,Password)
def deleteImage(imagePath):
	"""
	Written By: Piyush Setia
	Written Date: 10/05/2024
	Purpose:			 
			Function to delete image from repository. 
	"""
#	try:
#		#fixedDirectory = "//srdwsmesqa01/Ignition/MasterImage"
#		import os
#		os.remove( (imagePath.split("http:"))[1] )
#		system.perspective.print("Finally Image Deleted")
#			
#	except:
#		system.perspective.print("Error in Image Deletion")

	"""
	Written By: Sadhana
	Written Date: 20/05/2025
	Purpose:			 
			Function to delete image from repository. 
	"""
	try:
		#fixedDirectory = "//srdwsmesqa01/Ignition/MasterImage"
		import os
		if imagePath.startswith("http://"):
		            network_path = "\\" + imagePath.split("http://")[1].replace("/", "\\")
		else:
		            network_path = imagePath  # Fallback if it's already a path
		
		system.perspective.print("Deleting file at: " + network_path)
		
		if os.path.exists(network_path):
		            os.remove(network_path)
		            system.perspective.print(" Image Deleted Successfully")
		else:
		            system.perspective.print("️ File does not exist at path: " + network_path)
		
	except Exception as e:
		        system.perspective.print(" Error in Image Deletion: " + str(e))
		        #old code starts here
		#os.remove( (imagePath.split("http:"))[1] )
		#system.perspective.print("Finally Image Deleted")
			
	#except:
	#	system.perspective.print("Error in Image Deletion")
	#old code ends here
	
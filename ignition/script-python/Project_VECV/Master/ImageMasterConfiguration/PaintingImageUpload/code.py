"""
Written By: Piyush Setia
Written Date: 10/05/2024
Purpose:			 
		Function to upload image into repository. 
"""
def upload():
	try:
		li=Project_VECV.Master.ImageMasterConfiguration.FileUpload.sendf()
		eventf=li[0]
		imagePath=li[1]
		
		system.perspective.print("name = %s"%(li[0].file.name))
		#file upload event and working
		eventf.file.copyTo(imagePath)

		system.perspective.print("URL = %s"%imagePath)
		
		return True
	except:
		return False
	
	
	
#def sendURL():
#	return url
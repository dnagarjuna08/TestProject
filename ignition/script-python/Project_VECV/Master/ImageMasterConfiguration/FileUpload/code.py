"""
Written By: Piyush Setia
Written Date: 10/05/2024
Purpose:			 
		Function to upload image at location. 
"""
def fileUpload(event,imagePath):
	global li
	li=[event,imagePath]
	return li

def sendf():
	return li	
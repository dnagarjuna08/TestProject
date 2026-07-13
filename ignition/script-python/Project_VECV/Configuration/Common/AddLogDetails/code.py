#Author: Gaurav Amrutkar
#Date: 02/04/2024
#Function Name: AddErrorLogs
#Description: Add error log details to errorlog DB
def AddErrorLogs(screenName,filePath,errorFunction,errorType,errorCode,description,lineNumber):
		#Function Name: GetSerialNumberDetails
		#Description: Add error log details to errorlog DB
#		zoneName = system.tag.read("[default]Project_VECV/ClientTags/ZoneName").value
#		currentDateTime = Project_VECV.ShiftTimeZone.getTimeZonefromUTC(zoneName)
		currentDateTime=system.date.now()
		params = {"ScreenName":str(screenName),"FilePath":filePath,"ErrorFunction":str(errorFunction),"ErrorType":str(errorType),"ErrorCode":str(errorCode),"Description":str(description),"lineNumber":lineNumber,"CreatedDate":currentDateTime}
		result = system.db.runNamedQuery("Project_VECV/ErrorLog/InsertIntoErrorLog",params)
		if(result>0):
			message='Something went wrong Error code :'+str(errorCode)
		system.perspective.print("ERROR  "+str(params))
#		print("ERROR  "+str(params))


def AddAuditLogs(category,subCategory,description,createdBy):
		#Description: Add Udit log details to Auditlog DB
#		zoneName = system.tag.read("[default]Project_VECV/ClientTags/ZoneName").value
#		currentDateTime = Project_VECV.ShiftTimeZone.getTimeZonefromUTC(zoneName)
		currentDateTime=system.date.now()
		system.perspective.print("Into Audit Log---->")
		params = {"Category":str(category),"SubCategory":str(subCategory),"Description":str(description),"CreatedBy":createdBy,"CreatedDate":currentDateTime}
		system.perspective.print("params passed---->"+str(params))
		result = system.db.runNamedQuery("Project_VECV/AuditLog/InsertIntoAuditLog",params)
		system.perspective.print("addedToAuditLog---->"+str(params))


		
def showloader():
#Description: function to show loader
	system.perspective.openPopup("#loaderPopup",'Project_VECV/Templates/Loader', showCloseIcon = False, draggable = False, modal = True,overlayDismiss = False)		
	
def closeloader():
#Description: function to close loader
	system.perspective.closePopup('#loaderPopup')		

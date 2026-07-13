#Author: Gaurav Anrutkar
#Date: 02/04/2024
#Function Name: getUniqueUUID
#Description: Function for making a UUID based on the host ID and current time
import uuid

def getUniqueUUID():
	#Function Name: getUniqueUUID
	#Description: Function for making a UUID based on the host ID and current time
	try:
	#Start of try block	
		# make a UUID based on the host ID and current time
		data = uuid.uuid1()
		return data
	#End of try block
	except:   
	#Start of except block   
		screenName ='GenerateUUID'
		filePath=str('Project_VECV/Common/GenerateUUID')
		errorFunction = str('Scripting:FunctionName->getUniqueUUID')
		errorType=str('Application')
		errorCode = str(Project_VECV.Common.GenerateUUID.getUniqueUUID())
		description=str(sys.exc_info()[1]) #error description
		lineNumber=str(sys.exc_info()[2].tb_lineno) #lineno on which error occur
		Project_VECV.Configuration.Common.AddLogDetails.AddErrorLogs(screenName,filePath,errorFunction,errorType,errorCode,description,lineNumber)
	#End of except block
	
#	select MST_Area_Id,MST_Line_Id,(isnull(TBL.prevMST_WorkStation_Id,'0')+''+isnull(tbl.prevAddMST_WorkStation_Id,'')) as prevMST_WorkStation_Id  from (select 
#	(select top (1) convert (varchar (20 ),MST_WorkStation_Id) from TRN_RouteStep where LR.MST_LocationRoute_Id=MST_LocationRoute_Id and StepNumber < rt.StepNumber order by StepNumber desc)
#	as prevMST_WorkStation_Id
#	,(select ','+convert(varchar(500),MST_WorkStation_Id)  from TRN_RouteAdditionalStep where MST_RouteStep_Id =RT.MST_RouteStep_Id for XML PATH('')) as prevAddMST_WorkStation_Id 
#	,MST_Area_Id,MST_Line_Id
#	from MST_LocationRoute LR
#	inner join TRN_RouteStep RT on rt.MST_LocationRoute_Id=lr.MST_LocationRoute_Id
#	where MST_Area_Id=22 and MST_Line_Id=31 and RT.MST_WorkStation_Id=269) as TBL 
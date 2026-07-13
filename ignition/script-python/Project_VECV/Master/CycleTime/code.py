"""
Written By: Sagar Iparkar
Written Date: 12/05/2024
Purpose:			 
		Function to return cycle time configuration data to table. 
"""

import re
import json
import urllib2, urllib 
import datetime

def GetCycleTime(MST_Line_Id,ProductGroupID,ShiftId):
	try:
		scriptName='GetProductCodeByLineId'
		parameters = {"MST_Line_Id":MST_Line_Id,"ProductGroupID":ProductGroupID,"ShiftID":ShiftId}
		ds=system.db.runNamedQuery('Project_VECV/CycleTimeConfiguration/GetCycleTime', parameters)
#		ds=system.dataset.toPyDataSet(ds)
		dataList = []
		count=1
		for i in ds:
			if count==1:
				myList = ["","","",-1,"","","","-1"]
				dataList.append(myList)
			MST_WorkStation_Id= str(i['MST_WorkStation_Id'])
			MST_Line_Id= str(i['MST_Line_Id'])
			WorkStationName= str(i['WorkStationName'])
			CycleTime=  int(i['CycleTime'])
			MSTCycleTimeId= str(i['MSTCycleTimeId'])
			GroupId= str(i['GroupId'])
			ShiftID= str(i['ShiftID'])
			ActionN= str(i['ActionN'])
			
			myList = [MST_WorkStation_Id,MST_Line_Id, WorkStationName,CycleTime,MSTCycleTimeId,GroupId,ShiftID,ActionN]
			dataList.append(myList)
			count=count+1
		
		headers = ["MST_WorkStation_Id","MST_Line_Id","WorkStationName","CycleTime","MSTCycleTimeId","GroupId","ShiftID","ActionN"]
		resultDetails = system.dataset.toDataSet(headers,dataList)
		resultDetails = system.dataset.toPyDataSet(resultDetails)	
		if len(resultDetails)>0:
			return resultDetails
		else:
			return None
	except:	
		import sys, os
		errorMessage=scriptName  +' Exception : '+  str(sys.exc_info()[1])
		Authentication.exceptionLogger(errorMessage)	
		result =None
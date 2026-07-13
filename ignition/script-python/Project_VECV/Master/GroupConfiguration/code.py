"""
Written By: Sagar Iparkar
Written Date: 27/05/2024
Purpose:			 
		Function to return dataset of product code by LineId. 
"""

import re
import json
import urllib2, urllib 
import datetime

def GetProductCodeByLineId(MST_Line_Id):
	try:
		scriptName='GetProductCodeByLineId'
		parameters = {"MST_Line_Id":MST_Line_Id}
		ds=system.db.runNamedQuery('Project_VECV/GroupConfiguration/GetProductCodeByLineId', parameters)
		ds=system.dataset.toPyDataSet(ds)
		return ds
	except:	
		import sys, os
		errorMessage=scriptName  +' Exception : '+  str(sys.exc_info()[1])
		Authentication.exceptionLogger(errorMessage)	
		result =None
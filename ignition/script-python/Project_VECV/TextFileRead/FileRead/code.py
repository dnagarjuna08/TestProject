"""
	Written By: Piyush Setia
	Written Date: 11/06/2024
	Purpose: Function to write into file for laser marking. 
"""
def fileWrite(serialN,gearR,MCode,shift): 
	try:
		serialN=serialN[:serialN.index("-")]
		directory="//10.109.12.32/ta_laser_marking/"
		fileName="DATA"
		fileName=directory+str(fileName)+".txt" 
		today= system.date.now()
		date= system.date.format(today, "dd/MM/yy")
		f = open(fileName, "w")
		#print("File created successfully")
		f.write("          " +serialN)
		f.write("\n\n"+MCode+"                  "+ str(date))
		f.write("\n\n"+gearR+"                     "+shift)
		print("File write successfully")
		f.close()
	    
	except:   
    	#Start of except block   
    		screenName ='TextFileNumberPunching'
    		filePath=str('Project_VECV/Common/GenerateUUID')
    		errorFunction = str('Scripting:FunctionName->getUniqueUUID')
    		errorType=str('Application')
    		errorCode = str(Project_VECV.Common.GenerateUUID.getUniqueUUID())
    		description=str(sys.exc_info()[1]) #error description
    		lineNumber=str(sys.exc_info()[2].tb_lineno) #lineno on which error occur
    		Project_VECV.Configuration.Common.AddLogDetails.AddErrorLogs(screenName,filePath,errorFunction,errorType,errorCode,description,lineNumber)    
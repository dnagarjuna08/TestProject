def logUpload(stationName,state,userName,ipAddress,data):
	try:
		import os
		if len(stationName) > 1:
			response = stationName[:2]
			if str(response) == 'LA':
				fixedDirectory ="//10.109.1.15/Ignition/MES_LOGS/LegacyAxle/"
			elif str(response) == 'TA':
				fixedDirectory ="//10.109.1.15/Ignition/MES_LOGS/TitanAxle/"
		
			#path='S30'
			directory=fixedDirectory+stationName
						
			#creating directory if not exist
			if not os.path.exists(directory):
			    # Create the directory
			    print(os.makedirs(directory))
			    #print(os.path.exists(directory))
			    print("Directory created successfully!")
			else:
			    print("Directory already exists!")
			    
			fileWrite(directory,stationName,state,userName,ipAddress,data)
	except:	
		#start of except block		
		screenName ='Log function' 
		filePath=str('Project_VECV/Audit/Logs')
		errorFunction = str('Scripting:FunctionName->logUpload')
		errorType=str('Application')
		errorCode = str(Project_VECV.Common.GenerateUUID.getUniqueUUID()) 
		description=str(sys.exc_info()[1]) #error description
		lineNumber=str(sys.exc_info()[2].tb_lineno) #lineno on which error occur			
		Project_VECV.Configuration.Common.AddLogDetails.AddErrorLogs(screenName,filePath,errorFunction,errorType,errorCode,description,lineNumber)	
	 
	 
#def logUpload(stationName,state,userName,ipAddress,data):
#	"""
#	Written By: Piyush Setia
#	Written Date: 10/06/2024
#	Purpose:			 
#			Logger file respository creation. 
#	"""
#	try:
#		import os
#		fixedDirectory ="//srdwsmesqa01/Ignition/MES_LOGS/TitanAxle/"
#		
#		#path='S30'
#		directory=fixedDirectory+stationName
#					
#		#creating directory if not exist
#		if not os.path.exists(directory):
#		    # Create the directory
#		    print(os.makedirs(directory))
#		    #print(os.path.exists(directory))
#		    print("Directory created successfully!")
#		else:
#		    print("Directory already exists!")
#		    
#		fileWrite(directory,stationName,state,userName,ipAddress,data)
#	except:	
#		#start of except block		
#		screenName ='Log function' 
#		filePath=str('Project_VECV/Audit/Logs')
#		errorFunction = str('Scripting:FunctionName->logUpload')
#		errorType=str('Application')
#		errorCode = str(Project_VECV.Common.GenerateUUID.getUniqueUUID()) 
#		description=str(sys.exc_info()[1]) #error description
#		lineNumber=str(sys.exc_info()[2].tb_lineno) #lineno on which error occur			
#		Project_VECV.Configuration.Common.AddLogDetails.AddErrorLogs(screenName,filePath,errorFunction,errorType,errorCode,description,lineNumber)	
#	 
	    
def fileWrite(directory,stationName,state,userName,ipAddress,data): 
	"""
	Written By: Piyush Setia
	Written Date: 10/06/2024
	Purpose:			 
			write into logger. 
	"""
	try:
		directory=directory+"/" 
		
		# Import date class from datetime module
		from datetime import date
		
		 
		# Returns the current local date
		fileName = date.today()
		print("Today date is: ", fileName)
		fileName=directory+str(fileName)+".txt" 
		
		import os
		if os.path.isfile(fileName):
			print("True")
		else:
			print("False")
			f = open(fileName, "a")
		  	f.write('TIME'+"\t\t\t\t    "+'IP ADDRESS'+"\t\t "+'STATION NAME'+"\t "+'STATE'+"\t\t"+'USER NAME'+"\t\t\t\t\t\t"+'DATA'+"\n")
		  	f.write('______________________________________________________________________________________________________________________________________________________________________________________\n')
		  	f.close()
		  	
		f = open(fileName, "a")
		print("File created successfully")
		# using datetime module
		import datetime;
		 
		# ct stores current time
		ct = str(datetime.datetime.now())
		print("current time:-", ct)
		
		f.write(ct+"----------"+ipAddress+"----------"+stationName+"----------"+state+"----------"+userName+"----------"+data+"\n")
		print("File write successfully")
		f.close()
	except:	
		#start of except block		
		screenName ='Log function' 
		filePath=str('Project_VECV/Audit/Logs')
		errorFunction = str('Scripting:FunctionName->fileWrite')
		errorType=str('Application')
		errorCode = str(Project_VECV.Common.GenerateUUID.getUniqueUUID()) 
		description=str(sys.exc_info()[1]) #error description
		lineNumber=str(sys.exc_info()[2].tb_lineno) #lineno on which error occur			
		Project_VECV.Configuration.Common.AddLogDetails.AddErrorLogs(screenName,filePath,errorFunction,errorType,errorCode,description,lineNumber)	
			
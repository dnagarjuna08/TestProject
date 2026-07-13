"""
	Written By: Sagar Iparkar
	Written Date: 11/06/2024
	Purpose: Function to send print command. 
"""
from java.net import Socket
from java.io import DataOutputStream
import socket
import sys 
import datetime

'''def getPrint(serialNumber,GearRatio,shift,IP,port):
	
	scriptName="Printer"
	printerIP = IP        
	barcodeData=serialNumber
#	date=datetime.now().strftime("%dd-%mm-%yy")
	
	today = system.date.now()
	date= system.date.format(today, "dd/MM/yy")
	
#	GearRatio="10*47(4.7)"
	time = system.date.now()#.strftime("%H:%M:%S")
#	if time >"16.00" and time <= "23:59":
#	     = 'B'
#	elif time >="07.31" and time < "16:00": 
#	    shift = 'A'
#	else:
#	    shift='C'
	PrintFile="""CT~~CD,~CC^~CT~
	^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR5,5~SD20^JUS^LRN^CI0^XZ
	 
	^XA
	^MMT
	^PW609
	^LL0406
	^LS0
	^FT276,130^BQN,4,4
	^FDMA,"""+barcodeData+"""^FS
	^FT69,160^A0N,25,25^FH\^FD"""+barcodeData+"""^FS
	^FT69,185^A0N,25,25^FH\^FD"""+date+""" ("""+str(shift)+""")"""+"""^FS
	
	^FT400,185^A0N,25,25^FH\^FD"""+GearRatio+"""^FS
	^PQ1,0,1,Y
	^XZ"""
	NoOfPrint=2
	port = int(port)
	scriptName = 'shared.production.printLogLabels No of Print '
	try:
	    clientSocket=Socket(printerIP,port)    
	    outToPrinter=DataOutputStream(clientSocket.getOutputStream())
	    for i in range(NoOfPrint):
	        outToPrinter.write(PrintFile)#Code for dynamic print
	    outToPrinter.close();
	    clientSocket.close();
	    return True
	
	except:
		screenName ='Number Punching' 
		filePath=str('Peoject Library/Project_VECV/Printer/GetPrint')
		errorFunction = str('Scripting:FunctionName->GetPrint')
		errorType=str('Application')
		errorCode = str(Project_VECV.Common.GenerateUUID.getUniqueUUID()) 
		description=str(sys.exc_info()[1]) #error description
		lineNumber=str(sys.exc_info()[2].tb_lineno) #lineno on which error occur			
		Project_VECV.Configuration.Common.AddLogDetails.AddErrorLogs(screenName,filePath,errorFunction,errorType,errorCode,description,lineNumber)	

		
"""
	Written By: Gaurav Amrutkar
	Written Date: 24/08/2024
	Purpose: Function to send print command PDI printer. 
"""		
'''

def getPrint(serialNumber,GearRatio,shift,IP,port,NoofPrint):
	
	scriptName="Printer"
	printerIP = IP        
	barcodeData=serialNumber
#	date=datetime.now().strftime("%dd-%mm-%yy")
	
	today = system.date.now()
	date= system.date.format(today, "dd/MM/yy")
	
#	GearRatio="10*47(4.7)"
	time = system.date.now()#.strftime("%H:%M:%S")
#	if time >"16.00" and time <= "23:59":
#	     = 'B'
#	elif time >="07.31" and time < "16:00": 
#	    shift = 'A'
#	else:
#	    shift='C'
	SerailNumberBigSize=serialNumber[2:].split('-')[0]
	PrintFile="""CT~~CD,~CC^~CT~
	^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR5,5~SD20^JUS^LRN^CI0^XZ
	 
	^XA
	^MMT
	^PW609
	^LL0406
	^LS0
	^FT52,100^A0N,100,100^FD""" + SerailNumberBigSize + """^FS
	^FT500,130^BQN,4,4
	^FDMA,"""+barcodeData+"""^FS
	^FT69,160^A0N,25,25^FH\^FD"""+barcodeData+"""^FS
	^FT69,185^A0N,25,25^FH\^FD"""+date+""" ("""+str(shift)+""")"""+"""^FS
	
	^FT400,185^A0N,25,25^FH\^FD"""+GearRatio+"""^FS
	^PQ1,0,1,Y
	^XZ"""
	NoOfPrint=int(NoofPrint)
	port = int(port)
	scriptName = 'shared.production.printLogLabels No of Print '
	try:
	    clientSocket=Socket(printerIP,port)    
	    outToPrinter=DataOutputStream(clientSocket.getOutputStream())
	    for i in range(NoOfPrint):
	        outToPrinter.write(PrintFile)#Code for dynamic print
	    outToPrinter.close();
	    clientSocket.close();
	    return True
	
	except:
		screenName ='Number Punching' 
		filePath=str('Peoject Library/Project_VECV/Printer/GetPrint')
		errorFunction = str('Scripting:FunctionName->GetPrint')
		errorType=str('Application')
		errorCode = str(Project_VECV.Common.GenerateUUID.getUniqueUUID()) 
		description=str(sys.exc_info()[1]) #error description
		lineNumber=str(sys.exc_info()[2].tb_lineno) #lineno on which error occur			
		Project_VECV.Configuration.Common.AddLogDetails.AddErrorLogs(screenName,filePath,errorFunction,errorType,errorCode,description,lineNumber)	

		
"""
	Written By: Aniket
	Written Date: 25/11/2024
	Purpose: Function to send print command Washing Machine Printers . 
"""

def getPDIPrint(serialNumber,IP,port,line):		
	scriptName="Printer"
	printerIP = IP
	
	serialNum = serialNumber.split('-')[0]
	racode = serialNumber.split('-')[1]
	
	
	gearRatio = system.db.runNamedQuery("Project_VECV/ITSupport/getGearRatio",{"SerialNumber":serialNumber})
	
	today = system.date.now()
	date= system.date.format(today, "ddMMyy")
	

	time = system.date.now()
	shiftdetails = str(Project_VECV.WashingMachine.Shift.getShiftName(line))
	ShiftCode = shiftdetails.split('-')[0]
	barcodeData = "P"+racode+"DA#T"+date+str(ShiftCode)+serialNum+gearRatio+"#V126885#"
	system.util.getLogger("barcodeData").info(barcodeData)
	PrintFile="""CT~~CD,~CC^~CT~
	^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR4,5~SD20^JUS^LRN^CI0^XZ
	
		
	^XA
	^MMT
	^PW806
	^LL0406
	^LS0
	^FT20,400^BQN,4,4
	^FDMA,"""+barcodeData+"""^FS
	^FT0,250^A0N,300,250^FH\^FD"""+racode+"""^FS
	^FT150,350^A0N,50,28^FH\^FD"""+barcodeData+"""^FS
	^PQ1,0,1,Y
	^XZ"""

    

	
	
	
	NoOfPrint=1
	port = int(port)
	scriptName = 'shared.production.printLogLabels No of Print '
	try:
	    clientSocket=Socket(printerIP,port)    
	    outToPrinter=DataOutputStream(clientSocket.getOutputStream())
	    for i in range(NoOfPrint):
	        outToPrinter.write(PrintFile)#Code for dynamic print
	    outToPrinter.close();
	    clientSocket.close();
	    return True
	
	except:
		screenName ='Quality PDI' 
		filePath=str('Peoject Library/Project_VECV/Printer/GetPDIPrint')
		errorFunction = str('Scripting:FunctionName->GetPrint')
		errorType=str('Application')
		errorCode = str(Project_VECV.Common.GenerateUUID.getUniqueUUID()) 
		description=str(sys.exc_info()[1]) #error description
		lineNumber=str(sys.exc_info()[2].tb_lineno) #lineno on which error occur			
		Project_VECV.Configuration.Common.AddLogDetails.AddErrorLogs(screenName,filePath,errorFunction,errorType,errorCode,description,lineNumber)	
		
		
	
'''def getPrintSupport(serialNumber,GearRatio,shift,IP,port, date):
	
	scriptName="Printer"
	printerIP = IP        
	barcodeData=serialNumber
#	date=datetime.now().strftime("%dd-%mm-%yy")
	
#	GearRatio="10*47(4.7)"
	time = system.date.now()#.strftime("%H:%M:%S")
#	if time >"16.00" and time <= "23:59":
#	     = 'B'
#	elif time >="07.31" and time < "16:00": 
#	    shift = 'A'
#	else:
#	    shift='C'
	PrintFile="""CT~~CD,~CC^~CT~
	^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR5,5~SD20^JUS^LRN^CI0^XZ
	 
	^XA
	^MMT
	^PW609
	^LL0406
	^LS0
	^FT276,130^BQN,4,4
	^FDMA,"""+barcodeData+"""^FS
	^FT69,160^A0N,25,25^FH\^FD"""+barcodeData+"""^FS
	^FT69,185^A0N,25,25^FH\^FD"""+date+""" ("""+str(shift)+""")"""+"""^FS
	
	^FT400,185^A0N,25,25^FH\^FD"""+GearRatio+"""^FS
	^PQ1,0,1,Y
	^XZ"""
	NoOfPrint=2
	port = int(port)
	scriptName = 'shared.production.printLogLabels No of Print '
	try:
	    clientSocket=Socket(printerIP,port)    
	    outToPrinter=DataOutputStream(clientSocket.getOutputStream())
	    for i in range(NoOfPrint):
	        outToPrinter.write(PrintFile)#Code for dynamic print
	    outToPrinter.close();
	    clientSocket.close();
	    return True
	
	except:
		screenName ='Number Punching' 
		filePath=str('Peoject Library/Project_VECV/Printer/GetPrint')
		errorFunction = str('Scripting:FunctionName->getPrintSupport')
		errorType=str('Application')
		errorCode = str(Project_VECV.Common.GenerateUUID.getUniqueUUID()) 
		description=str(sys.exc_info()[1]) #error description
		lineNumber=str(sys.exc_info()[2].tb_lineno) #lineno on which error occur			
		Project_VECV.Configuration.Common.AddLogDetails.AddErrorLogs(screenName,filePath,errorFunction,errorType,errorCode,description,lineNumber)		
'''

def getPrintSupport(serialNumber,GearRatio,shift,IP,port, date):
					
	scriptName="Printer"
	printerIP = IP        
	barcodeData=serialNumber
#	date=datetime.now().strftime("%dd-%mm-%yy")
	
#	GearRatio="10*47(4.7)"
	time = system.date.now()#.strftime("%H:%M:%S")
#	if time >"16.00" and time <= "23:59":
#	     = 'B'
#	elif time >="07.31" and time < "16:00": 
#	    shift = 'A'
#	else:
#	    shift='C'
	SerailNumberBigSize=serialNumber[2:].split('-')[0]
	PrintFile="""CT~~CD,~CC^~CT~
		^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR5,5~SD20^JUS^LRN^CI0^XZ
		 
		^XA
		^MMT
		^PW609
		^LL0406
		^LS0
		^FT52,100^A0N,100,100^FD""" + SerailNumberBigSize + """^FS
		^FT500,130^BQN,4,4
		^FDMA,"""+barcodeData+"""^FS
		^FT69,160^A0N,25,25^FH\^FD"""+barcodeData+"""^FS
		^FT69,185^A0N,25,25^FH\^FD"""+date+""" ("""+str(shift)+""")"""+"""^FS
		
		^FT400,185^A0N,25,25^FH\^FD"""+GearRatio+"""^FS
		^PQ1,0,1,Y
		^XZ"""
	NoOfPrint=2
	port = int(port)
	scriptName = 'shared.production.printLogLabels No of Print '
	try:
	    clientSocket=Socket(printerIP,port)    
	    outToPrinter=DataOutputStream(clientSocket.getOutputStream())
	    for i in range(NoOfPrint):
	        outToPrinter.write(PrintFile)#Code for dynamic print
	    outToPrinter.close();
	    clientSocket.close();
	    return True
	
	except:
		screenName ='Number Punching' 
		filePath=str('Peoject Library/Project_VECV/Printer/GetPrint')
		errorFunction = str('Scripting:FunctionName->getPrintSupport')
		errorType=str('Application')
		errorCode = str(Project_VECV.Common.GenerateUUID.getUniqueUUID()) 
		description=str(sys.exc_info()[1]) #error description
		lineNumber=str(sys.exc_info()[2].tb_lineno) #lineno on which error occur			
		Project_VECV.Configuration.Common.AddLogDetails.AddErrorLogs(screenName,filePath,errorFunction,errorType,errorCode,description,lineNumber)		
				
		
def getDHPrint(serialNumber,IP,port,partNumber,GearRatio):
	
	scriptName="Printer"
#	printerIP = '10.109.12.209'
	printerIP=IP
	
	
	barcodeData = "P"+partNumber+"#T"+str(serialNumber)+"#V126885#"
	PrintFile="""CT~~CD,~CC^~CT~
	^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR5,5~SD30^JUS^LRN^CI0^XZ
	
	^XA
	^MMT
	^PW609
	^LL0406
	^LS0
	^FT180,120^BQN,3.4,3.4
	^FDMA,"""+barcodeData+"""^FS
	^FT170,180^A0N,30,14^FH\^FD"""+barcodeData+"""^FS
	^FT280,90^A0N,35,35^FH\^FD"""+str(GearRatio)+"""^FS
	^PQ1,0,1,Y
	^XZ"""
	NoOfPrint=1
#	port = int(9100)
	port=int(port)
	scriptName = 'shared.production.printLogLabels No of Print '
	try:
	    clientSocket=Socket(printerIP,port)    
	    outToPrinter=DataOutputStream(clientSocket.getOutputStream())
	    for i in range(NoOfPrint):
	        outToPrinter.write(PrintFile)#Code for dynamic print
	    outToPrinter.close();
	    clientSocket.close();
	    return True
	
	except:
		screenName ='Quality PDI' 
		filePath=str('Peoject Library/Project_VECV/Printer/getDHPrint')
		errorFunction = str('Scripting:FunctionName->getDHPrint')
		errorType=str('Application')
		errorCode = str(Project_VECV.Common.GenerateUUID.getUniqueUUID()) 
		description=str(sys.exc_info()[1]) #error description
		lineNumber=str(sys.exc_info()[2].tb_lineno) #lineno on which error occur			
		Project_VECV.Configuration.Common.AddLogDetails.AddErrorLogs(screenName,filePath,errorFunction,errorType,errorCode,description,lineNumber)
	
	
def getDHPrintExtra(serialNumber,IP,port,partNumber,GearRatio):
	scriptName="Printer"
#	printerIP = '10.109.12.209'
	printerIP=IP
	
	if serialNumber.endswith(("RA111111")):
		barcodeData = "P"+partNumber+"#T"+str(serialNumber)+"#V126885#"
		PrintFile="""CT~~CD,~CC^~CT~
		^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR5,5~SD30^JUS^LRN^CI0^XZ
		
		^XA
		^MMT
		^PW609
		^LL0406
		^LS0
		^FT200,120^BQN,3.4,3.4
		^FDMA,"""+barcodeData+"""^FS
		^FT170,180^A0N,28,15^FH\^FD"""+barcodeData+"""^FS
		^FT330,90^A0N,28,15^FH\^FD"""+str(GearRatio)+"""^FS
		^PQ1,0,1,Y
		^XZ"""
		NoOfPrint=1
	#	port = int(9100)
		port=int(port)
		scriptName = 'shared.production.printLogLabels No of Print '
		try:
		    clientSocket=Socket(printerIP,port)    
		    outToPrinter=DataOutputStream(clientSocket.getOutputStream())
		    for i in range(NoOfPrint):
		        outToPrinter.write(PrintFile)#Code for dynamic print
		    outToPrinter.close();
		    clientSocket.close();
		    return True
		except:
			screenName ='Quality PDI' 
			filePath=str('Peoject Library/Project_VECV/Printer/getDHPrint')
			errorFunction = str('Scripting:FunctionName->getDHPrint')
			errorType=str('Application')
			errorCode = str(Project_VECV.Common.GenerateUUID.getUniqueUUID()) 
			description=str(sys.exc_info()[1]) #error description
			lineNumber=str(sys.exc_info()[2].tb_lineno) #lineno on which error occur			
			Project_VECV.Configuration.Common.AddLogDetails.AddErrorLogs(screenName,filePath,errorFunction,errorType,errorCode,description,lineNumber)
	else:
		return False	
		
		
def getPDIPrintSupport(serialNumber,IP,port,today,line):
	
	scriptName="Printer"
	printerIP = IP
	
	serialNum = serialNumber.split('-')[0]
	racode = serialNumber.split('-')[1]
	
	
	gearRatio = system.db.runNamedQuery("Project_VECV/ITSupport/getGearRatio",{"SerialNumber":serialNumber})
	
	date= system.date.format(today, "ddMMyy")
	

	time = system.date.now()
	shiftdetails = str(Project_VECV.WashingMachine.Shift.getShiftName(line))
	ShiftCode = shiftdetails.split('-')[0]
	barcodeData = "P"+racode+"DA#T"+date+str(ShiftCode)+serialNum+gearRatio+"#V126885#"
	PrintFile="""CT~~CD,~CC^~CT~
		^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR4,5~SD20^JUS^LRN^CI0^XZ
		
			
		^XA
		^MMT
		^PW806
		^LL0406
		^LS0
		^FT20,400^BQN,4,4
		^FDMA,"""+barcodeData+"""^FS
		^FT0,250^A0N,300,250^FH\^FD"""+racode+"""^FS
		^FT150,350^A0N,50,28^FH\^FD"""+barcodeData+"""^FS
		^PQ1,0,1,Y
		^XZ"""
	NoOfPrint=1
	port = int(port)
	scriptName = 'shared.production.printLogLabels No of Print '
	try:
	    clientSocket=Socket(printerIP,port)    
	    outToPrinter=DataOutputStream(clientSocket.getOutputStream())
	    for i in range(NoOfPrint):
	        outToPrinter.write(PrintFile)#Code for dynamic print
	    outToPrinter.close();
	    clientSocket.close();
	    return True
	
	except:
		screenName ='Quality PDI' 
		filePath=str('Peoject Library/Project_VECV/Printer/GetPDIPrint')
		errorFunction = str('Scripting:FunctionName->GetPrint')
		errorType=str('Application')
		errorCode = str(Project_VECV.Common.GenerateUUID.getUniqueUUID()) 
		description=str(sys.exc_info()[1]) #error description
		lineNumber=str(sys.exc_info()[2].tb_lineno) #lineno on which error occur			
		Project_VECV.Configuration.Common.AddLogDetails.AddErrorLogs(screenName,filePath,errorFunction,errorType,errorCode,description,lineNumber)	
		
def getPrintHub(IP,Port,SerialNumber,RACode):
	scriptName="Printer"
	printerIP = IP
	
	
	barcodeData = "P"+str(RACode)+"#T"+str(SerialNumber)+"#V126885#"
	PrintFile="""CT~~CD,~CC^~CT~
	^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR5,5~SD30^JUS^LRN^CI0^XZ
	
	^XA
	^MMT
	^PW609
	^LL0406
	^LS0
	^FT260,140^BQN,3.4,3.4
	^FDMA,"""+barcodeData+"""^FS
	^FT170,180^A0N,28,15^FH\^FD"""+barcodeData+"""^FS
	^PQ1,0,1,Y
	^XZ"""
	NoOfPrint=2
	port = int(Port)
	scriptName = 'shared.production.printLogLabels No of Print '
	try:
		clientSocket=Socket(printerIP,port)    
		outToPrinter=DataOutputStream(clientSocket.getOutputStream())
		for i in range(NoOfPrint):
		    outToPrinter.write(PrintFile)#Code for dynamic print
		outToPrinter.close();
		clientSocket.close();
		return True
	except:
		screenName ='Hub Barcode Generation' 
		filePath=str('Project Library/Project_VECV/Printer/GetCHPrint')
		errorFunction = str('Scripting:FunctionName->GetPrint')
		errorType=str('Application')
		errorCode = str(Project_VECV.Common.GenerateUUID.getUniqueUUID()) 
		description=str(sys.exc_info()[1]) #error description
		lineNumber=str(sys.exc_info()[2].tb_lineno) #lineno on which error occur			
		Project_VECV.Configuration.Common.AddLogDetails.AddErrorLogs(screenName,filePath,errorFunction,errorType,errorCode,description,lineNumber)	

def getPrintHelp(serialNumber,GearRatio,shift,IP,port,NoofPrint,date):					
	scriptName="Printer"
	printerIP = IP        
	barcodeData=serialNumber
	#	date=datetime.now().strftime("%dd-%mm-%yy")
	
	#today = system.date.now()
	#date= system.date.format(today, "dd/MM/yy")
	
	#	GearRatio="10*47(4.7)"
	time = system.date.now()#.strftime("%H:%M:%S")
	#	if time >"16.00" and time <= "23:59":
	#	     = 'B'
	#	elif time >="07.31" and time < "16:00": 
	#	    shift = 'A'
	#	else:
	#	    shift='C'
	SerailNumberBigSize=serialNumber[2:].split('-')[0]
	PrintFile="""CT~~CD,~CC^~CT~
	^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR5,5~SD20^JUS^LRN^CI0^XZ
	 
	^XA
	^MMT
	^PW609
	^LL0406
	^LS0
	^FT52,100^A0N,100,100^FD""" + SerailNumberBigSize + """^FS
	^FT500,130^BQN,4,4
	^FDMA,"""+barcodeData+"""^FS
	^FT69,160^A0N,25,25^FH\^FD"""+barcodeData+"""^FS
	^FT69,185^A0N,25,25^FH\^FD"""+date+""" ("""+str(shift)+""")"""+"""^FS
	
	^FT400,185^A0N,25,25^FH\^FD"""+GearRatio+"""^FS
	^PQ1,0,1,Y
	^XZ"""
	NoOfPrint=int(NoofPrint)
	port = int(port)
	scriptName = 'shared.production.printLogLabels No of Print '
	try:
	    clientSocket=Socket(printerIP,port)    
	    outToPrinter=DataOutputStream(clientSocket.getOutputStream())
	    for i in range(NoOfPrint):
	        outToPrinter.write(PrintFile)#Code for dynamic print
	    outToPrinter.close();
	    clientSocket.close();
	    return True
	except:
		screenName ='Number Punching' 
		filePath=str('Peoject Library/Project_VECV/Printer/GetPrint')
		errorFunction = str('Scripting:FunctionName->GetPrint')
		errorType=str('Application')
		errorCode = str(Project_VECV.Common.GenerateUUID.getUniqueUUID()) 
		description=str(sys.exc_info()[1]) #error description
		lineNumber=str(sys.exc_info()[2].tb_lineno) #lineno on which error occur			
		Project_VECV.Configuration.Common.AddLogDetails.AddErrorLogs(screenName,filePath,errorFunction,errorType,errorCode,description,lineNumber)

						
def getTAQG01Print(serialNumber,IP,port,partNumber,GearRatio):
							
	scriptName="Printer"
#	printerIP = '10.109.12.209'
	printerIP=IP
	
	
	barcodeData = "P"+partNumber+"#T"+str(serialNumber)+"#V126885#"
	PrintFile="""CT~~CD,~CC^~CT~
	^XA~TA000~JSN^LT0^MNW^MTT^PON^PMN^LH0,0^JMA^PR5,5~SD30^JUS^LRN^CI0^XZ
	
	^XA
	^MMT
	^PW609
	^LL0406
	^LS0
	^FT200,120^BQN,3.4,3.4
	^FDMA,"""+barcodeData+"""^FS
	^FT170,180^A0N,28,15^FH\^FD"""+barcodeData+"""^FS
	^FT330,90^A0N,28,15^FH\^FD"""+str(GearRatio)+"""^FS
	^PQ1,0,1,Y
	^XZ"""
	NoOfPrint=1
#	port = int(9100)
	port=int(port)
	scriptName = 'shared.production.printLogLabels No of Print '
	try:
	    clientSocket=Socket(printerIP,port)    
	    outToPrinter=DataOutputStream(clientSocket.getOutputStream())
	    for i in range(NoOfPrint):
	        outToPrinter.write(PrintFile)#Code for dynamic print
	    outToPrinter.close();
	    clientSocket.close();
	    return True
	
	except:
		screenName ='Quality PDI' 
		filePath=str('Peoject Library/Project_VECV/Printer/getDHPrint')
		errorFunction = str('Scripting:FunctionName->getDHPrint')
		errorType=str('Application')
		errorCode = str(Project_VECV.Common.GenerateUUID.getUniqueUUID()) 
		description=str(sys.exc_info()[1]) #error description
		lineNumber=str(sys.exc_info()[2].tb_lineno) #lineno on which error occur			
		Project_VECV.Configuration.Common.AddLogDetails.AddErrorLogs(screenName,filePath,errorFunction,errorType,errorCode,description,lineNumber)
							
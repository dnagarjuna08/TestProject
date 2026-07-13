from java.net import Socket
from java.io import DataOutputStream
import socket
import sys 
import datetime

def getPrint(serialNumber,GearRatio,shift):
	
	scriptName="Printer"
	printerIP = '10.109.12.204'        
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
	NoOfPrint=4
	port = int(9100)
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
	    import sys, os
	    errorMessage=scriptName  +' Exception : '+  str(sys.exc_info()[1])
	#        system.perspective.print("errorMessage ="+str(errorMessage))
	    print errorMessage
	#    Authentication.exceptionLogger(errorMessage)
	#        system.perspective.print("errorMessage " +str(errorMessage))
	    return False
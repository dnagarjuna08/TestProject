def ExcelToDataset(uploaded_file,createdBy):
	from org.apache.poi.xssf.usermodel import XSSFWorkbook
	from org.apache.poi.ss.usermodel import DataFormatter
	from java.io import ByteArrayInputStream
	import system
	
	try:
	    # Read the file content as a byte array
	    file_content = uploaded_file.getBytes()
	    system.perspective.print(len(file_content))  # Print size of the content
	    # Create an input stream from the byte array
	    input_stream = ByteArrayInputStream(file_content)
	    # Load the workbook
	    workbook = XSSFWorkbook(input_stream)
	    # Extract data from the first sheet
	    sheet = workbook.getSheetAt(0)
	    data_formatter = DataFormatter()
	    rows = []
	    for row in sheet:
	        row_data = []
	        for cell in row:
	            row_data.append(data_formatter.formatCellValue(cell))
	        rows.append(row_data)
	    # Assuming the first row is the header
	    headers = rows[0]
	    system.perspective.print(headers)
	    # Create a dataset from the rows (excluding headers)
	    dataset = system.dataset.toDataSet(headers, rows[1:])
	    system.perspective.print(dataset)
	    Project_VECV.Transmission.Upload.upload(dataset,createdBy)
	except Exception as e:
	    system.perspective.print(str(e))
		
def upload(dataset,createdBy):	
	print("ds1 %s"%dataset)
	ds1=dataset
	r=ds1.getRowCount()
	c=ds1.getColumnCount()
	#i=0
	#checkPoints=[]
	path='Project_VECV/Transmission/TransmissionType/UploadExcelData'
	totalCount=r
	successCount = 0
	for i in range(r):
		checkPoints=[]
		for j in range(0,c):
			checkPoints.append(str(ds1.getValueAt(i,j)).strip())
			#print(ds1.getValueAt(i,j).upper())#, ---> to avoid line changing
	#   collecting params for query
		BOM=checkPoints[0]
		Model=checkPoints[1]
		PunchingCode=checkPoints[2]
		PunchingGroup=checkPoints[3]
		WormSpeedoRatio=checkPoints[4]
		Design=checkPoints[5]
		# taking createdBy from functions parameter list --- upload(createdBy)
	#   parameters for checking sequence no. exist or not
		params={"BOM":BOM.upper(),"Design":Design.upper(),"Model":Model.upper(),"PunchingCode":PunchingCode.upper(),"PunchingGroup":PunchingGroup.upper(),"WormSpeedoRatio":WormSpeedoRatio.upper(),"CreatedBy":createdBy}
#		query for checking sequence exists or not
		result=0
		try:
			result = system.db.runNamedQuery(path,params)
			for k in result:
				successCount+=1
				print(k['result'])
		except:
			print(result)
		
		print(checkPoints)
	system.perspective.print("Total Record %s"%totalCount)
	system.perspective.print("SuccessCount %s"%successCount)
	message = 'Total Record %s'%totalCount + '   SuccessCount %s'%successCount
	#warning
	#info
	#success
	#error
	state = "info"
	Project_VECV.PopUp.Alerts.showAlert(str(state), str(state.capitalize()), str(message), "true", "Okay", "", "", "", "", "closePopup", "closePopup", "closePopup","","","","")
	system.perspective.sendMessage("refreshTable",scope='page')
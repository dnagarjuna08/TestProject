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
	    system.perspective.print("at line 15---->")
	    # Extract data from the first sheet
	    sheet = workbook.getSheetAt(0)
	    system.perspective.print("at line 18 sheet----> %s"%sheet)
	    data_formatter = DataFormatter()
	    rows = []
	    for row in sheet:
	        row_data = []
	        for cell in row:
	            row_data.append(data_formatter.formatCellValue(cell))
	            #system.perspective.print("at line 25 row_data %s---->"%row_data)
	        rows.append(row_data)
	        #system.perspective.print("at line 27 row_data %s---->"%row_data)
	    # Assuming the first row is the header
	    headers = rows[0]
	    system.perspective.print("at line 30 row_data rows[1] %s---->"%rows[1])
	    system.perspective.print("Headers---->%s"%headers)
	    # Create a dataset from the rows (excluding headers)
	    try:
	        # Create a dataset from the rows (excluding headers)
	        if len(rows) > 1:  # Ensure there is data beyond the header row
	            valid_rows = [row for row in rows[1:] if len(row) == len(headers)]  # Filter invalid rows
	            dataset = system.dataset.toDataSet(headers, valid_rows)
	            system.perspective.print("Dataset created successfully with " + str(dataset.getRowCount()) + " rows.")
	        else:
	            system.perspective.print("No data rows found in the Excel file.")
	            return
	    except Exception as e:
	        system.perspective.print("Error while creating dataset: " + str(e))
	        return
	    #system.perspective.print("at line 34 dataset %s---->"%dataset)
	    #system.perspective.print("dataset---->%s"%dataset)
	    Project_VECV.Quality.Checklist.ExcelUpload1.upload(dataset,createdBy)
	except Exception as e:
	    system.perspective.print(str(e))
		
def upload(dataset,createdBy):	
	system.perspective.print("ds1-------> %s"%dataset)
	ds1=dataset
	r=ds1.getRowCount()
	c=ds1.getColumnCount()
	#i=0
	#checkPoints=[]
	path='Project_VECV/Quality/checksheet/addNewCheckSheet'
	system.perspective.print("ds--->%s"%ds1)
	system.perspective.print("r--->%s"%r)
	system.perspective.print("C--->%s"%c)
	totalCount=r
	successCount = 0
	system.perspective.print("totalCount--->%s"%totalCount)
	for i in range(r):
		checkPoints=[]
		for j in range(0,c):
			checkPoints.append(str(ds1.getValueAt(i,j)).strip())
			#system.perspective.print("checkPoints--->%s"%checkPoints)
			#print(ds1.getValueAt(i,j).upper())#, ---> to avoid line changing
	#   collecting params for query
		BOM=checkPoints[6]
		Model=checkPoints[1]
		Sequence=checkPoints[0]
		Area=checkPoints[2]
		Line=checkPoints[3]
		WorkStation=checkPoints[4]
		Item=checkPoints[5]
		# taking createdBy from functions parameter list --- upload(createdBy)
	#   parameters for checking sequence no. exist or not
		params={"BOM":BOM,"Model":Model,"Sequence":Sequence,"Area":Area,"Line":Line,"WorkStation":WorkStation,"CreatedBy":createdBy,"Item":Item}
#		query for checking sequence exists or not
		system.perspective.print("params ---->>>> %s"%params)
		result=0
		try:
			result = system.db.runNamedQuery(path,params)
			system.perspective.print("results %s"%result)
			if result==1:
				successCount+=1
				system.perspective.print("successCount %s"%successCount)
				system.perspective.print("result ---->>>>%s"%k['result'])
		except Exception as e:
			system.perspective.print("error occured at line 69 %s" %e)
		
		system.perspective.print("CheckPoint ---->>>>%s"%checkPoints)
	system.perspective.print("Total Record %s"%totalCount)
	system.perspective.print("SuccessCount %s"%successCount)
	message = 'Total Record %s'%totalCount + '   SuccessCount %s'%successCount
	#warning
	#info
	#success
	#error
	
	state = "info"
	Project_VECV.PopUp.Alerts.showAlert(
	    str(state), 
	    str(state.capitalize()), 
	    str(message), 
	    "true", 
	    "Okay", 
	    "", 
	    "", 
	    "", 
	    "", 
	    "closePopup", 
	    "closePopup", 
	    "closePopup", 
	    "", 
	    "", 
	    "", 
	    ""
	)
	system.perspective.sendMessage("tableRefresh",scope='page')
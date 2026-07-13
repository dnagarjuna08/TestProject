def ExcelToDataset(uploaded_file,createdBy,Area, Line, WS):
	from org.apache.poi.xssf.usermodel import XSSFWorkbook
	from org.apache.poi.ss.usermodel import DataFormatter
	from java.io import ByteArrayInputStream
	import system
	import org.apache.poi.ss.usermodel.DateUtil as DateUtil
	
	try:
	    # Read the file content as a byte array
	    file_content = uploaded_file.getBytes()\ # Print size of the content
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
			system.perspective.print("sheet %s"%sheet)
			for cell in row:
				cellType = cell.getCellType().toString()
				if cellType == 'STRING':
					row_data.append(cell)
				elif cellType == 'NUMERIC':
					if DateUtil.isCellDateFormatted(cell):
						row_data.append(cell.dateCellValue)
					else:
						row_data.append(cell.getNumericCellValue())
				elif cellType == 'BLANK':
					row_data.append(None)
			rows.append(row_data)
	    # Assuming the first row is the header
	    headers = rows[0]
	    # Create a dataset from the rows (excluding headers)
	    dataset = system.dataset.toDataSet(headers, rows[1:])
	    Project_VECV.Transmission.ChecklistUpload.upload.upload(dataset,createdBy,Area, Line, WS)
	except Exception as e:
	    system.perspective.print(str(e))
		
def upload(dataset,createdBy,Area, Line, WS):
	dataset = system.dataset.toPyDataSet(dataset)
	totalCount = len(dataset)
	for dt in dataset:
		TMCode=dt['TMCode']
		LowerLimit=dt['Lower Limit']
		UpperLimit=dt['Upper Limit']
		Parameter=dt['Parameter']
		if LowerLimit is not None:
			LowerLimit = round(float(LowerLimit),2)
		if UpperLimit is not None:
			UpperLimit = round(float(UpperLimit),2)
		params={"TMcode":str(TMCode).upper(),"Parameter":Parameter,"LowerLimit":LowerLimit,
		"UpperLimit":UpperLimit,"WS":WS,"Area":Area,"Line":Line,"CreatedBy":createdBy}
		successCount = 1
		system.perspective.print(params)
		try:
			system.db.runNamedQuery("Project_VECV/Transmission/Checklist/InsertCheckList",params)
			system.perspective.print("query called")
			successCount+=1
		except Exception as e:
		    system.perspective.print(str(e))
		
	message = 'Total Record %s'%totalCount + '   SuccessCount %s'%successCount

	state = "info"
	Project_VECV.PopUp.Alerts.showAlert(str(state), str(state.capitalize()), str(message), "true", "Okay", "", "", "", "", "closePopup", "closePopup", "closePopup","","","","")
	system.perspective.sendMessage("refreshTable",scope='page')
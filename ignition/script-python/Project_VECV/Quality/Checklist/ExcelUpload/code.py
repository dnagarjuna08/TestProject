def excelToDataSet(fileName, hasHeaders=False, sheetNum=0, firstRow=None, lastRow=None, firstCol=None, lastCol=None):
    import org.apache.poi.ss.usermodel.WorkbookFactory as WorkbookFactory
    import org.apache.poi.ss.usermodel.DateUtil as DateUtil
    from java.io import FileInputStream

    """
    Function to create a dataset from an Excel spreadsheet with robust handling for empty rows/cells.
    params:
        fileName   - The path to the Excel spreadsheet. (required)
        hasHeaders - If true, uses the first row of the spreadsheet as column names.
        sheetNum   - Select the sheet to process. Defaults to the first sheet.
        firstRow   - Select the first row to process.
        lastRow    - Select the last row to process.
        firstCol   - Select the first column to process.
        lastCol    - Select the last column to process.
    """

    # Open the Excel file
    fileStream = FileInputStream(fileName)
    wb = WorkbookFactory.create(fileStream)
    sheet = wb.getSheetAt(sheetNum)

    # Determine row and column boundaries
    if firstRow is None:
        firstRow = sheet.getFirstRowNum()
    if lastRow is None:
        lastRow = sheet.getLastRowNum()

    headers = []
    data = []

    # Iterate through rows
    for i in range(firstRow, lastRow + 1):
        row = sheet.getRow(i)
        if row is None:
            continue  # Skip entirely empty rows

        # Determine column boundaries on the first valid row
        if i == firstRow:
            if firstCol is None:
                firstCol = row.getFirstCellNum()
            if lastCol is None:
                lastCol = row.getLastCellNum()
            else:
                lastCol += 1  # Adjust for Python indexing

            if hasHeaders:
                headers = []
                for j in range(firstCol, lastCol):
                    cell = row.getCell(j)
                    if cell and cell.getCellType().toString() == 'STRING':
                        headers.append(cell.getStringCellValue().strip())
                    else:
                        headers.append("Col" + str(j))
                continue
            else:
                headers = ["Col" + str(j) for j in range(firstCol, lastCol)]

        rowOut = []

        # Iterate through columns in the row
        for j in range(firstCol, lastCol):
            cell = row.getCell(j)
            value = None

            if cell is not None:
                cellType = cell.getCellType().toString()
                if cellType == 'NUMERIC':
                    if DateUtil.isCellDateFormatted(cell):
                        value = cell.dateCellValue
                    else:
                        value = cell.getNumericCellValue()
                        if value == int(value):
                            value = int(value)
                elif cellType == 'STRING':
                    value = cell.getStringCellValue().strip()
                elif cellType == 'BOOLEAN':
                    value = cell.getBooleanCellValue()
                elif cellType == 'FORMULA':
                    formulaType = cell.getCachedFormulaResultType().toString()
                    if formulaType == 'NUMERIC':
                        if DateUtil.isCellDateFormatted(cell):
                            value = cell.dateCellValue
                        else:
                            value = cell.getNumericCellValue()
                            if value == int(value):
                                value = int(value)
                    elif formulaType == 'STRING':
                        value = cell.getStringCellValue().strip()
                    elif formulaType == 'BOOLEAN':
                        value = cell.getBooleanCellValue()

            rowOut.append(value)

        if rowOut:  # Only add non-empty rows
            data.append(rowOut)

    fileStream.close()

    # Return dataset
    return system.dataset.toDataSet(headers, data)
		

def upload(createdBy):
	# Read .xlsx file
#	fName = "C:\Users\zzpsethiya\Downloads\Updated Axle Quality Master.xlsx"
#	fName='http://srdwsmesqa01/Ignition/ExcelUpload/ChecklistData.xlsx'
	fName='//10.109.1.71/Ignition/ExcelUpload/ChecklistData.xlsx'
	ds1 = excelToDataSet(fName, True)		
	#util.printDataSet(ds1)
	print("ds1 %s"%ds1)
	#ds2=system.dataset.toPyDataSet(ds1)
	r=ds1.getRowCount()
	c=ds1.getColumnCount()
	#i=0
	#checkPoints=[]
	path='Project_VECV/Quality/validateExcelSequence'
	totalCount=r
	successCount = 0
	for i in range(r):
		checkPoints=[]
		for j in range(0,c):
			checkPoints.append(str(ds1.getValueAt(i,j)).strip())
			#print(ds1.getValueAt(i,j).upper())#, ---> to avoid line changing
	#   collecting params for query
		modelName=checkPoints[1]
		areaName=checkPoints[2]
		lineName=checkPoints[3]
		workstationName=checkPoints[4]
		sequenceNum=int(checkPoints[0])
		item=checkPoints[5]
		BOM=checkPoints[6]
		# taking createdBy from functions parameter list --- upload(createdBy)
	#   parameters for checking sequence no. exist or not
		params={"modelName":modelName,"areaName":areaName,"lineName":lineName,"workstationName":workstationName,"sequenceNum":sequenceNum,"createdBy":createdBy,"item":item,"BOM":BOM}
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

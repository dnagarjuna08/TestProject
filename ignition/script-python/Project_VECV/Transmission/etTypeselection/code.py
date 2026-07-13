def val(basePath,variableName):
	
	# List of boolean tags within the UDT
	tagNames = [
	    "MW_ET30S5", "MW_ET35S5", "MW_ET35S6", "MW_ET40S5",
	    "MW_ET40S6", "MW_ET50S7", "MW_ET60S5", "MW_ET60S6",
	    "MW_ET60S7", "MW_ET70S6", "MW_ET80S6", "MW_ET90S6"
	]
	# Create a function to map the variable name to the tag name
	def mapVariableToTag(variable):
	    for tag in tagNames:
	        if variable in tag:
	            return tag
	    return None
	
	# Set all boolean tags to False first
	for tagName in tagNames:
	    fullTagPath = basePath + tagName
	    system.tag.writeBlocking([fullTagPath], [False])
	
	# Set the selected tag to True based on the variableName
	selectedTag = mapVariableToTag(variableName)
	
	if selectedTag:
	    selectedTagPath = basePath + selectedTag
	    system.tag.writeBlocking([selectedTagPath], [True])
	else:
	    print("Invalid variable name: {variableName}. No matching tag found.")
	    
def pokayokeselection(basePath,pydataset):
	
	# Prefix to be added to the tag names from the database
	prefix = "MW_"
	
	# Iterate over the columns (tag names from database) and row values from the PyDataSet
	for tagName in pydataset.columnNames:
	    # Retrieve the value from the dataset
	    value = pydataset.getValueAt(0, tagName)
	
	    # Construct the full tag path by adding the "MW_" prefix
	    fullTagPath = basePath + prefix + tagName
	
	    # Write the value (True/False) to the corresponding tag
	    system.tag.writeBlocking([fullTagPath], [value])

def LeakTestSelection(basePath,pydataset):
	
	# Iterate over the columns (tag names from database) and row values from the PyDataSet
	for tagName in pydataset.columnNames:
	    # Retrieve the value from the dataset
	    value = pydataset.getValueAt(0, tagName)
	
	    # Construct the full tag path by adding the "MW_" prefix
	    fullTagPath = basePath + tagName
	
	    # Write the value (True/False) to the corresponding tag
	    system.tag.writeBlocking([fullTagPath], [value])
	    
def HBETSelection(basePath,pydataset):
	
	# Iterate over the columns (tag names from database) and row values from the PyDataSet
	for tagName in pydataset.columnNames:
	    # Retrieve the value from the dataset
	    value = pydataset.getValueAt(0, tagName)
	
	    # Construct the full tag path by adding the "MW_" prefix
	    fullTagPath = basePath + tagName
	
	    # Write the value (True/False) to the corresponding tag
	    system.tag.writeBlocking([fullTagPath], [value])
import os

def read_file(file_path):
	"""Reads the contents of a file and returns it as a string."""
	try:
		with open(file_path, 'r') as file:
			content = file.read()
		return content
	except Exception as e:
		return "Error reading file: %"%e


def write_file(file_path, content):
	try:
		with open(file_path, 'w') as file:
			file.write(content)
		return "File written successfully."
	except Exception as e:
		return "Error writing to file: %s"%e
	
def update():
	file_path = '//srdwsmespro01/Ignition/DevOps/log.txt'
	print file_path
	file_content = read_file(file_path)
	print "------------------->"
	print file_content
	print "------------------->"
	print len(file_content)
	if str(file_content).upper().strip() == 'Updated'.upper():
		system.project.requestScan(30)
		import os
		new_content = ""
		write_result = write_file(file_path, new_content)
		data = "update Pushed successfully"
		system.util.getLogger("DevOps").info(str(write_result))
		print write_result
		system.util.getLogger("DevOps").info(str(data))
		print data
	else:
		data = "no new changes found"
		system.util.getLogger("DevOps").info(str(data))
		print data
	return True
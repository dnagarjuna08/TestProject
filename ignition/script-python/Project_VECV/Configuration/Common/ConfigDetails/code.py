# ServerName --> QA, PROD
serverName = 'QA'

if serverName == 'QA':
	projDBName = 'MESQADB'
else:
	projDBName = ''
	
def CONST_DB_NAME():
	return projDBName

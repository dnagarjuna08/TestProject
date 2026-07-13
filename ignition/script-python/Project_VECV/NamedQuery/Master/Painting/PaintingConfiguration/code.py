"""
Written By: Sagar Iparkar
Written Date: 27/07/2024
Purpose:			 
		Functions to add/update painting details . 
"""	
def insert(areaId,categoryId,imageName,imagePath,stepNo,isActive,createdBy,id):
	try :
		# query path
		queryPath='Project_VECV/Painting/addUpdatePainting'
		# query params
#		imagePath = str('http:'+imagePath)
		queryParams={"id":id, "areaId":areaId ,"imageName":imageName ,"imagePath":imagePath ,
		"stepNo": stepNo ,  "isActive":isActive  ,"createdBy":createdBy , "categoryId":categoryId}
		
		dataset = system.db.runNamedQuery(queryPath,queryParams)
		return dataset
	except :
		system.perspective.print("Data not inserted")
		
		
		
#		"areaId":areaId ,
#		"categoryId":categoryId,
#		"imageName" :imageName ,
#		"imagePath" :imagePath,
#		"stepNo":stepNo ,
#		"isActive" :isActive ,
#		"createdBy":createdBy ,
#		"id":id
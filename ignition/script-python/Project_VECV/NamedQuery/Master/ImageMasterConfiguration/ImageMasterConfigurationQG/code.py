"""
Written By: Sadhana
Written Date: 10/05/2025
Purpose:			 
		Functions to Insert image data into table. 
"""	
def insertImage(Id,model_id,area_id,line_id,workstation_id,imagename,description,imagetype_id,active,createdBy,name,bom_id):
	# query path
	queryPath='Project_VECV/Master/ImageMasterConfiguration/insertImageQG'
	# query params
	queryParams={"Id":Id,"MST_Model_Id":model_id , "MST_Area_Id":area_id ,"MST_Line_Id":line_id 
	,"MST_WorkStation_Id":workstation_id  ,"ImageName":imagename ,"Description":description ,
	"MST_ImageType_Id": imagetype_id
	, "ImagePath":name , "IsActive":active  ,"CreatedBy":createdBy,"M_BOM_Id":bom_id}
	system.perspective.print(queryParams)
	dataset = system.db.runNamedQuery(queryPath,queryParams)
	return dataset



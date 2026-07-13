/**********
Edited By: Anand Choudhary
Edited Date: 11/11/2025
Purpose: Insert defect subname throught quality gate.
*********/

Declare 
@workStationId int, @bomId int , @defectId int , @defectNameId int, @defectSubnameId int
SELECT @workStationId = MST_WorkStation_Id FROM MST_WorkStation where WorkStationName = :WorkStation and IsActive = 1 and isdeleted=0
SELECT @bomId = M_BOM_Id FROM M_BOM where M_BomNumber= :BOM
SELECT @defectId = MST_Defect_Id FROM MST_Defect where DefectCategory = :DefectCategory
SELECT @defectNameId = MST_DefectName_Id FROM MST_DefectName WHERE DefectName = :DefectName
SELECT  @defectSubnameId = MST_DefectSUBName_Id from MST_DefectSUBName where DefecSubName = :DefectSubName

Insert into TRN_StationDefect
(MST_Area_Id,MST_Line_Id,MST_WorkStation_Id, SerialNumber,OrderNumber, M_BOM_Id,MST_Defect_Id,MST_DefectName_Id,MST_DefectSubName_Id,Comments, MST_DefectStatus_Id,OperatorId, CreatedBy) 
VALUES (:Area,:Line, @workStationId,:SerialNumber,:OrderNo,@bomId,@defectId,@defectNameId,@defectSubnameId,:Comment,1, :OperatorId,:CreatedBy)
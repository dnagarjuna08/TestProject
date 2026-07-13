Declare 
@workStationId int, @bomId int , @defectId int , @defectNameId int
SELECT @workStationId = MST_WorkStation_Id FROM MST_WorkStation where WorkStationName = :WorkStation and IsActive = 1 and isdeleted=0
SELECT @bomId = M_BOM_Id FROM M_BOM where M_BomNumber= :BOM
SELECT @defectId = MST_Defect_Id FROM MST_Defect where DefectCategory = :DefectCategory
SELECT  @defectNameId = MST_DefectName_Id from MST_DefectName where DefectName = :DefectList

Insert into TRN_StationDefect
(MST_Area_Id,MST_Line_Id,MST_WorkStation_Id, SerialNumber,OrderNumber, M_BOM_Id,MST_Defect_Id,MST_DefectName_Id,Comments, MST_DefectStatus_Id,OperatorId, CreatedBy) 
VALUES (:Area,:Line, @workStationId,:SerialNumber,:OrderNo,@bomId,@defectId,@defectNameId,:Comment,1, :OperatorId,:CreatedBy)
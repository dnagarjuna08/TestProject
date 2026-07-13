Declare 
@workStationId int,
@modelId int

SELECT @workStationId = MST_WorkStation_Id FROM MST_WorkStation where WorkStationName =:WorkStationName
SELECT @modelId = MST_Model_Id FROM MST_Model where ModelName = :ModelName
SELECT CycleTime FROM MST_CycleTime WHERE MST_WorkStation_Id = @workStationId  and MST_Model_Id = @modelId
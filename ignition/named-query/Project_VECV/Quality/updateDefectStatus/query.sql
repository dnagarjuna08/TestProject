update TRN_StationDefect set MST_DefectStatus_Id = 2, 
ModifiedBy = :ModifiedBy, 
ModifiedDate = GETDATE(), 
OperatorID = :OperatorID 
where TRN_StationDefect_Id = :TRN_StationDefect_Id
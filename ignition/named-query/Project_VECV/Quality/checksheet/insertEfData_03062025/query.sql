-- 🔹 Declare and set variables in the same line
DECLARE 
    @MST_Area_Id INT             =  :MST_Area_Id ,
    @MST_Line_Id INT             =  :MST_Line_Id ,
    @MST_Shift_Id INT            =  :MST_Shift_Id ,
    @MST_WorkStation_Id INT      =  :MST_WorkStation_Id ,
    @MST_Event_Id INT            =  :MST_Event_Id ,
    @M_BOM_Id INT                =  :M_BOM_Id ,
    @OrderNumber VARCHAR(50)     = :OrderNumber ,
    @SerialNumber VARCHAR(50)    =  :SerialNumber ,
    @MST_OPDefinition_Id INT     = :MST_OPDefinition_Id ,
    @OperatorID INT              = :OperatorID ,
    @IsExceedTime BIT            =  :IsExceedTime ,
    @MST_Status_Id TINYINT       =  :MST_Status_Id ,
    @IsActive BIT                =  :IsActive ,
    @IsDeleted BIT               =  :IsDeleted ,
    @CreatedBy INT               =  :CreatedBy ,
    @MST_ErrorProof_id INT       =  :MST_ErrorProof_id ,
    @PartNumber VARCHAR(50)      =  :PartNumber ,
    @ConsumedSerialNumber VARCHAR(50) =  :ConsumedSerialNumber ,
    @ConsumedPartNumber VARCHAR(50)   =  :ConsumedPartNumber ;

-- 🔹 Insert into TRN_Station_Events
INSERT INTO TRN_Station_Events (
    MST_Area_Id,
    MST_Line_Id,
    MST_Shift_Id,
    MST_WorkStation_Id,
    MST_Event_Id,
    M_BOM_Id,
    OrderNumber,
    SerialNumber,
    MST_OPCode_Id,
    MST_OPDefinition_Id,
    OperatorID,
    IsExceedTime,
    MST_Status_Id,
    IsActive,
    IsDeleted,
    CreatedBy,
    CreatedDate,
    ModifiedBy,
    ModifiedDate,
    IsPurged
)
VALUES (
    @MST_Area_Id,
    @MST_Line_Id,
    @MST_Shift_Id,
    @MST_WorkStation_Id,
    @MST_Event_Id,
    @M_BOM_Id,
    @OrderNumber,
    @SerialNumber,
    NULL,
    @MST_OPDefinition_Id,
    @OperatorID,
    @IsExceedTime,
    @MST_Status_Id,
    @IsActive,
    @IsDeleted,
    @CreatedBy,
    GETDATE(),
    NULL,
    NULL,
    0
);

-- 🔹 Insert into TRN_ErrorProofQuality
INSERT INTO TRN_ErrorProofQuality (
    trn_station_event_id,
    MST_ErrorProofQG_Id,
    PartNumber,
    ConsumedSerialNumber,
    ConsumedPartNumber,
    [status],
    IsPurged,
    CreatedBy,
    CreatedDate,
    ModifiedBy,
    ModifiedDate
)
SELECT TOP (1)
    se.TRN_Station_Events_Id,
    @MST_ErrorProof_id,
    @PartNumber,
    @ConsumedSerialNumber,
    @ConsumedPartNumber,
    @MST_Status_Id,
    0,
    @CreatedBy,
    GETDATE(),
    NULL,
    NULL
FROM dbo.TRN_Station_Events AS se
WHERE se.SerialNumber        = @SerialNumber 
  AND se.MST_WorkStation_Id  = @MST_WorkStation_Id 
  AND se.MST_Event_Id        = @MST_Event_Id 
  AND se.MST_OPDefinition_Id = @MST_OPDefinition_Id 
ORDER BY se.CreatedDate DESC;

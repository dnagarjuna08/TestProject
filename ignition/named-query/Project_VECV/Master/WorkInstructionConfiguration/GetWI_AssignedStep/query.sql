select   MST_WIOPCode_Id  WIOPID,  WIOP.MST_OPCode_Id ID, SequenceNum Sequence, OPCode,
WIOP.MST_OPDefinition_Id as "OP Definition ID", OPC.Description,  OPD.OPDefinition, WI.MST_Model_Id,  ModelName Model from MST_WIOPCode WIOP
inner join  MST_WorkInstruction WI on WI.MST_WorkInstruction_Id =WIOP.MST_WorkInstruction_Id
inner join MST_OPCode OPC on  OPC.MST_OPCode_Id =  WIOP.MST_OPCode_Id
inner join  MST_OPDefinition OPD on WIOP.MST_OPDefinition_Id = OPD.MST_OPDefinition_Id 
Inner join  MST_Model M on WI. MST_Model_Id = M.MST_Model_Id
where  WIOP. MST_WorkInstruction_Id =:WIId

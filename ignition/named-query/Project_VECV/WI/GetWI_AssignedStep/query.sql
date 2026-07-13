select rWIS.id as 'WIStepId', ms.Id as 'StepId',rWIS.SequenceNo as 'Sequence',ms.StepName as 'Step Name',ms.Description,ms.StepClassId,
	rWIS.ReworkWPrev as 'Rework with Previous',rWIS.IsMandatory  as 'Mandatory',ms.SpecialInstruction as 'Rework special instruction',mS.IsDisassemble as 'Rework',ms.Edhr as 'eDHR'
	, rWIS.CompleteWPrev as 'Complete with Previous'  
	from MST_Step mS join REL_WorkInstructionStep rWIS on (ms.id=rWIS.StepId) 
	where rWIS.WorkInstructionId=:WIId and mS.isdeleted=0 and rWIS.isDeleted=0 order by Sequence ASC
select mWI.id as 'ID',mWI.name as 'Work instruction name',mWI.description as 'Description',mWI.CurriculumCode as 'Curriculum code',mWI.AreaId as 'Area Id',mWI.LineId as 'Line Id',
 mWI.WorkStationId,mP.name as 'Workstation',mWI.isActive as 'Active','' as 'Relation',mWI.RevisionNo as 'Revision number'
 ,mWI.IsReworkWI as 'Rework work instruction'
 from MST_WorkInstruction mWI join MST_Plant mP on (mWI.WorkStationId=mP.ID)
 where mWI.isDeleted=0
 order by mWI.IsActive desc,mWI.CreatedDate desc
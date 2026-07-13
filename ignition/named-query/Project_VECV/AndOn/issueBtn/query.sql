
insert into trn_issuebtn(Issue_type_id,start_time,createdBy,isActive,isDeleted,mst_workstation_id)
VALUES(:Issue_type_id,getdate(),:createdBy,1,0,:mst_workstation_id)
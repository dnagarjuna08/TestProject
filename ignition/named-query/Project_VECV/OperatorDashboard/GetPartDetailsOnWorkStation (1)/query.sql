@BOMId int,
@WorkStationId int,
@PartId int

BEGIN
 
select M.M_MaterialNumber as 'PartNumber', M.Description as 'PartDescription' from TRN_ErrorProof E
inner join M_Material M on M.M_Material_Id=E.M_Material_Id
where E.M_BOM_Id =@BOMId and E.MST_WorkStation_Id=@WorkStationId and E.IsActive = 1 and E.IsDeleted=0 and E.M_Material_Id=@PartId
 
END
 
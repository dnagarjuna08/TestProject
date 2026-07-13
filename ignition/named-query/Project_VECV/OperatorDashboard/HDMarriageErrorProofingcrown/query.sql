declare @PrevStation int;
set @PrevStation = (select MST_WorkStation_Id from mst_workstation where WorkStationName = 'LADH40')

select top 1 OD.ConsumedPartNumber from TRN_Station_Events as SE
INNER JOIN TRN_Operation_Data as OD on OD.TRN_Station_Events_Id =  SE.TRN_Station_Events_Id
where SE.MST_WorkStation_Id = @PrevStation and SE.SerialNumber = :SerialNumber and SE.MST_OPDefinition_Id = 3 order by SE.CreatedDate desc
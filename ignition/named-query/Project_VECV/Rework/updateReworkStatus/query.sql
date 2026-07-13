DECLARE @SerialNumber varchar(50)= :SerialNumber,
@ModifiedBy int= :ModifiedBy,
@Remarks nvarchar(max)=:Remarks ,
@AreaId int= :AreaId ,
@LineId int=:LineId, 
@BOM int= :BOM ,
@RouteId INT=0,
@Step INT=0,
@TakeinStationId INT= :TakeinStationId ;

update TRN_ReleasedProductionOrder set IsTakeout=0 where SerialNumber=@SerialNumber 

update TRN_TakeIn_TakeOut set TakeIn_Station=@TakeinStationId,TakeIn_Time=getdate(),TakeIn_OperatorID=@ModifiedBy,Remarks=@Remarks 
where SerialNumber=@SerialNumber and MST_Area_Id=@AreaId and MST_Line_Id=@LineId and M_BOM_Id=@BOM


-- Correcting the dynamic LIKE query
SELECT @RouteId = MST_LocationRoute_Id,
       @Step = StepNumber 
FROM TRN_RouteStep 
WHERE (MST_WorkStation_Id = @TakeinStationId OR ParallelStation LIKE '%' + CAST(@TakeinStationId AS VARCHAR(10)) + '%') 
      AND IsActive = 1;

-- Retrieving WorkStation Ids and Parallel Stations after the given step
DECLARE @InputString NVARCHAR(MAX);
set @InputString = (select STUFF((
    select ', ' + LTRIM(RTRIM(CAST(MST_WorkStation_Id AS VARCHAR))) +
           CASE 
               WHEN ParallelStation IS NOT NULL AND ParallelStation <> '' 
               THEN ' ,' + LTRIM(RTRIM(ParallelStation)) + ',' 
               ELSE '' 
           END
    from TRN_RouteStep
    where MST_LocationRoute_Id = @RouteId  
      and IsActive = 1 
      and StepNumber >= @Step
    FOR XML PATH(''), TYPE
).value('.', 'NVARCHAR(MAX)'), 1, 2, '') AS CommaSeparatedList)
 
update TRN_StationStatus set mst_status_id=3 where MST_WorkStation_Id in (
SELECT value
FROM STRING_SPLIT(@InputString, ',')
WHERE RTRIM(LTRIM(value)) <> '') and SerialNumber=@SerialNumber
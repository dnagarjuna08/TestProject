Select a.MST_WorkStation_Id as 'UnitId',  a.WorkStationName as 'Unit name', isnull(a.Description,'') as 'Unit description',i.LevelName as 'Unit level', b.LineName as 'Attached To',a.MST_Line_Id as 'MasterId', c. WorkStationType as 'Workstation Type', a.IPAddress as 'IP Address',  a.IsActive as 'Active' from MST_WorkStation a 
Inner join MST_Line b on a. MST_Line_Id =b. MST_Line_Id  inner join  MST_WorkStationType c on c. MST_WorkStationType_Id =a.MST_WorkStationType_Id Inner join MST_Level i on i.MST_Level_Id = a.MST_Level_Id
Union 
Select d.MST_Line_Id as 'UnitId', d.LineName as 'Unit name', isnull(d.Description,'') as 'Unit description', j.LevelName as 'Unit level',e.AreaName as 'Attached To',d. MST_Area_Id as 'MasterId','' as 'Workstation Type', '' as 'IP Address',  d.IsActive as 'Active' from   MST_Line d
Inner join MST_Area e on d.MST_Area_Id =e.MST_Area_Id Inner join MST_Level j on j.MST_Level_Id = d.MST_Level_Id
Union
Select f.MST_Area_Id as 'UnitId', f.AreaName as 'Unit name',isnull(f.Description,'') as 'Unit description',k.LevelName as 'Unit level', g.PlantName as 'Attached To',f.MST_Plant_Id as 'MasterId','' as 'Workstation Type', '' as 'IP Address',  f.IsActive as 'Active' from  MST_Area f
Inner join MST_Plant  g on g.MST_Plant_Id  =f.MST_Plant_Id Inner join MST_Level k on k.MST_Level_Id = f.MST_Level_Id
Union
Select h.MST_Plant_Id as 'UnitId', h.PlantName as 'Unit name', isnull(h.Description,'') as 'Unit description',l.LevelName as 'Unit level', '' as 'Attached To',-1 as 'MasterId','' as 'Workstation Type', '' as 'IP Address',  h.IsActive as 'Active' from MST_Plant h 
Inner join MST_Level l on l.MST_Level_Id = h.MST_Level_Id
--
--select a.MST_Plant_Id  as 'UnitId',a.PlantName  as 'Unit name' ,a.Description as 'Unit description',b. Name as 'Unit Level',b.Id as 'LevelID' ,'' as 'Attached To','' as 'Asset Number','' as 'Workstation Type','' as 'IP Address',a.IsActive as 'Active' from  MST_Plant a
--Inner join  MST_Level b on a.MST_Plant_Id=b. PlantId



--l.Name as 'Unit level' ,l.Id as 'LevelId'
--, 
--case when e.WorkStationTypeId is Null then '' 
--when e.WorkStationTypeId = -1 then ''
--else  e.WorkStationTypeId
--end as 'WorkStationTypeId', 
--
--case when e.WorkStationTypeId is Null then '' 
--when e.WorkStationTypeId = -1 then '' 
--when e.WorkStationTypeId = -1 then ''
--else(select WorkStationType from MST_WorkStationType where id = e.WorkStationTypeId) 
--end as 'WorkStation type',
--
--
--
--
--
--
--case when e.AttachedTo is Null then ''
-- when e.AttachedTo = 0 then ''
--  when e.AttachedTo = -1 then ''
--else (select Name from MST_Plant where id = e.AttachedTo) end as 'Attached to',
--
--case when e.AttachedTo is Null then -1
-- when e.AttachedTo = 0 then -1
--else e.AttachedTo end as 'MasterId',
--
--e.isActive as 'Active',
--
--case when e.DeviceTypeId is Null then -1 
--else  e.DeviceTypeId
--end as 'DeviceTypeId',
--
--case when e.DeviceTypeId is Null then ''
--when e.DeviceTypeId = -1 then ''
--else(select Name from MST_DeviceType where id = e.DeviceTypeId) 
--end as 'Device type',
--
--case when e.IPAddress is Null then ''
--when e.IPAddress = '' then ''
--else e.IPAddress
--end as 'IP address' ,
--
--case when e.Asset = '-1' then ''
--else e.Asset end as 'Asset Number' ,
--
--case when e.IsDualWorkStation is Null then -1
--else e.IsDualWorkStation end as 'DualWorkStation',
--
--case when d.AttachedWorkStationId is Null then -1
--else d.AttachedWorkStationId end as 'AttachedWorkStationId' , 
--
--case when d.AttachedWorkStationId is Null then ''
--when d.AttachedWorkStationId  =  -1 then ''
--else (select Name from MST_Plant where Id = d.AttachedWorkStationId) end as AttachedWorkStationName,
--
--case when e.IsDualWorkStation =  1 and (select count(*) from REL_DualWorkstation where AttachedWorkStationId = d.WorkStationId and isdeleted = 0) > 0 then 1
--else 0 end as 'IsDualWorkStationVisible' ,
--case when e.LineTypeId is null then -1
--else e.LineTypeId end as 'LineTypeId',
--
--case when e.PlcIndex is null then -1  
--else e.PlcIndex end as 'PlcIndex' ,
--
--case when e.PLCDevice is null then ''  
--else e.PLCDevice end as 'PLCDevice'
--
--from MST_Plant e join MST_Level l on e.levelId = l.Id  
--left join REL_DualWorkstation d on e.Id = d.WorkStationId
--where e.IsDeleted =0
--order by e.IsActive desc,e.CreatedDate desc
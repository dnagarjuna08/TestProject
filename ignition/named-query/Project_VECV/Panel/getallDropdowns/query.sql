-- 1 Area, 2 line, 3 Workstation, 4 linetype, 5 Workstationtype, 
-- 6 WIType, 7 ImageType, 8 DeviceType, 9 OPDefinition, 10 Model, 11 Level, 12 AllWorkStations, 13 Roles,
-- 14 get QualityGate WorkStation, 15 Defect type

exec usp_GetAllDropdowns @dropdowntype=:DropdownType, @areaid=:AreaID, @lineid=:LineID
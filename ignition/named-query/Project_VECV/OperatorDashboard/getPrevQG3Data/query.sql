declare @BOM varchar(20) =  :BOM ,
@Serial varchar(50) =  :Serial

BEGIN
	declare @BOM_Id int = 0;
	declare @Mode varchar(20);

	set @BOM_Id = (Select M_BOM_Id from M_BOM where M_BOMNumber = @BOM)


	set @Mode = (select Mode from MST_ModelConfiguration where M_BOM_Id = @BOM_Id AND IsActive = 1)

	if @Mode Like '%Titan EV Carrier%'
		BEGIN
			SELECT TOP(1) S.Status FROM TRN_StationStatus as ST 
			INNER JOIN MST_Status AS S ON S.MST_Status_Id = ST.MST_Status_Id where 
			ST.MST_WorkStation_Id = (select Mst_workstation_id from MST_WorkStation where workstationName = 'TAEV50' and Isactive = 1) AND ST.SerialNumber = @Serial AND 
			ST.IsActive = 1 ORDER BY ST.CreatedDate DESC;
		END

	if @Mode Like '%Titan Diesel Carrier%'
		BEGIN
			SELECT TOP(1) S.Status FROM TRN_StationStatus as ST 
			INNER JOIN MST_Status AS S ON S.MST_Status_Id = ST.MST_Status_Id where 
			ST.MST_WorkStation_Id = (select Mst_workstation_id from MST_WorkStation where workstationName = 'TADS30' and Isactive = 1) AND ST.SerialNumber = @Serial AND 
			ST.IsActive = 1 ORDER BY ST.CreatedDate DESC;
		END
END
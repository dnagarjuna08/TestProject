declare @MST_Area_Id int= :AreaId 

begin

	Declare @PRODUCTION_ORDER Table(
	order_number VARCHAR(200),
	serial_number NVARCHAR(200),
	M_BOMNumber VARCHAR(50),
	Description VARCHAR(200),
	OrderStatusid INT,
	OrderStatus VARCHAR(50),
	order_category VARCHAR(255),
	m_BOM_id INT,
	MST_Area_Id INT,
	MST_Event_Id INT,
	special_instruction VARCHAR(255),
	id INT,
	ActionT INT,
	psn INT
	);

	INSERT INTO @PRODUCTION_ORDER
	select PO.order_number,isnull(po.serial_number,'') as serial_number,
	mb.M_BOMNumber,mb.Description,POS.OrderStatusid,POS.OrderStatus,po.order_category
	,PO.m_BOM_id,PO.MST_Area_Id,se.MST_Event_Id,
	isnull(PO.special_instruction,'') as special_instruction,
	PO.id,0 as ActionT , PO.psn 
	from PRODUCTION_ORDER PO WITH(NOLOCK)
	inner join m_bom MB WITH(NOLOCK)  on PO.m_BOM_id=MB.m_BOM_id
	inner join MST_Production_OrderStatus POS WITH(NOLOCK) on POS.OrderStatusid=PO.OrderStatusid
	and POS.OrderStatusid in(2,4,6)
	left outer join TRN_Station_Events SE WITH(NOLOCK) on Se.SerialNumber=po.serial_number

	where (se.MST_Event_Id <>5 or se.MST_Event_Id is null)
	and PO.MST_Area_Id=@MST_Area_Id and LEN(M_BOMNumber)<=6
	order by PO.psn
	
	
	 delete from @PRODUCTION_ORDER 
	 where serial_number =(select top 1 SerialNumber from  TRN_Station_Events where  MST_Event_Id=5 and SerialNumber in(select serial_number from @PRODUCTION_ORDER ))
	 and serial_number IS NOT NULL and serial_number != ''

	 delete from @PRODUCTION_ORDER 
	 where serial_number =(select top 1 SerialNumber from  TRN_Station_Events where  MST_Event_Id=5 and SerialNumber in(select serial_number from @PRODUCTION_ORDER ))
	 and serial_number IS NOT NULL and serial_number != ''
	 
	 delete from @PRODUCTION_ORDER 
	 where serial_number in (select SerialNumber from TRN_StationStatus where SerialNumber IS NOT NULL and SerialNumber != '')
	
	if exists(select top 1 1  from @PRODUCTION_ORDER where OrderStatusid=6)
	begin
	update @PRODUCTION_ORDER
	set ActionT=2
	 where OrderStatusid=6

	 update @PRODUCTION_ORDER
	set ActionT=0
	 where OrderStatusid <> 6

	end
	else
	if exists(select top 1 1 from @PRODUCTION_ORDER where OrderStatusid=4)
	begin
	update @PRODUCTION_ORDER
	set ActionT=1
	 where OrderStatusid=4

	 update @PRODUCTION_ORDER
	set ActionT=0
	 where OrderStatusid <> 4
	END
select * from @PRODUCTION_ORDER  
order by psn
END

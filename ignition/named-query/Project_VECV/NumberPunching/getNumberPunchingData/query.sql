declare
@MST_Area_Id int= :AreaId ,
@PrevWorkStationID int= :PrevWorkStationID ,	
@WorkStationID int= :WorkStationID 
begin 

--SET NOCOUNT ON
declare @a varchar(20)=null

	--IF OBJECT_ID('tempdb..#tempPRODUCTION_ORDER') IS NOT NULL
    --DROP TABLE #tempPRODUCTION_ORDER
	--IF OBJECT_ID('tempdb..#newtempPRODUCTION_ORDER') IS NOT NULL
	--DROP TABLE #newtempPRODUCTION_ORDER

	Declare @tempPRODUCTION_ORDER TABLE(
	order_number VARCHAR(200),
	serial_number NVARCHAR(200),
	SrNo int,
	M_BOMNumber VARCHAR(200),
	Description VARCHAR(500),
	OrderStatusid INT,
	OrderStatus VARCHAR(200),
	order_category VARCHAR(255),
	psn INT,
	m_BOM_id INT,
	MST_Area_Id INT,
	MST_Event_Id INT,
	special_instruction VARCHAR(255),
	id INT,
	GearRation NVARCHAR(200),
	CreatedDate DATETIME,
	ActionT INT
	)
	INSERT INTO @tempPRODUCTION_ORDER
	select 
	distinct PO.order_number,isnull(po.serial_number,'') as serial_number,ROW_NUMBER() OVER (ORDER BY CreatedDate) AS SrNo,
	mb.M_BOMNumber,mb.Description,POS.OrderStatusid,POS.OrderStatus,
	po.order_category,psn
	,PO.m_BOM_id,PO.MST_Area_Id,se.MST_Event_Id,
	isnull(PO.special_instruction,'') as special_instruction,
	PO.id,cd.GearRation,se.CreatedDate 
	,0 as ActionT
	--into #tempPRODUCTION_ORDER 
	from PRODUCTION_ORDER PO WITH(NOLOCK)
	inner join m_bom MB WITH(NOLOCK) on PO.m_BOM_id=MB.m_BOM_id
	inner join MST_Production_OrderStatus POS WITH(NOLOCK) on POS.OrderStatusid=PO.OrderStatusid
	and POS.OrderStatusid in(6)
	inner join ClassificationData CD WITH(NOLOCK) on CD.m_BOM_id=MB.m_BOM_id
	and POS.OrderStatusid in(6)
	inner join TRN_Station_Events SE WITH(NOLOCK) on Se.SerialNumber=po.serial_number

	where (se.MST_Event_Id =5 )
	and PO.MST_Area_Id=@MST_Area_Id
	and se.MST_WorkStation_Id =@PrevWorkStationID and CD.IsActive=1
	order by se.CreatedDate 
	
	
	delete from @tempPRODUCTION_ORDER
	where serial_number in(
select SerialNumber from @tempPRODUCTION_ORDER tpm
inner join TRN_StationStatus TSS WITH(NOLOCK) on tss.SerialNumber=tpm.serial_number
where MST_WorkStation_Id = @WorkStationID
)

Declare @NewtempPRODUCTION_ORDER TABLE(
	order_number VARCHAR(200),
	serial_number NVARCHAR(200),
	SrNo int,
	M_BOMNumber VARCHAR(200),
	Description VARCHAR(500),
	OrderStatusid INT,
	OrderStatus VARCHAR(200),
	order_category VARCHAR(255),
	psn INT,
	m_BOM_id INT,
	MST_Area_Id INT,
	MST_Event_Id INT,
	special_instruction VARCHAR(255),
	id INT,
	GearRation NVARCHAR(200),
	CreatedDate DATETIME,
	ActionT INT
	)
Insert into @NewtempPRODUCTION_ORDER
select * 
 from @tempPRODUCTION_ORDER order by CreatedDate

 update top(1) @NewtempPRODUCTION_ORDER
 set ActionT=1 ,OrderStatus='Released'

update TPO
set ActionT=2,OrderStatus='Running'
from @NewtempPRODUCTION_ORDER TPO 
inner join TRN_Station_Events SE WITH(NOLOCK) on Se.SerialNumber=TPO.serial_number
where (se.MST_Event_Id =3 ) and (se.MST_WorkStation_Id=@WorkStationID) 



 select order_number ,
	SrNo,
	serial_number ,
	M_BOMNumber ,
	Description ,
	OrderStatusid ,
	case 
		when OrderStatus = 'Released' then 'Released'
		when OrderStatus = 'Running' then 'Running'
		else 'Sequenced'
		End as OrderStatus,
	order_category ,
	psn ,
	m_BOM_id ,
	MST_Area_Id ,
	MST_Event_Id ,
	special_instruction ,
	id ,
	GearRation ,
	CreatedDate ,
	ActionT  from @NewtempPRODUCTION_ORDER
END
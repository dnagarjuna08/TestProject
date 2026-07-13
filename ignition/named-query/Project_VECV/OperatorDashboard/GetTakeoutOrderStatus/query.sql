Declare
@SerialNumber nvarchar(50) =  :SerialNumber ,
@BOMId int =  :BOMId ,
@OrderNumber nvarchar(50) =  :OrderNumber,
@LineId int = :LineId  

Select IsTakeout from TRN_ReleasedProductionOrder R
inner join TRN_TakeIn_TakeOut T on T.SerialNumber=R.SerialNumber and T.TakeIn_Station IS NULL
inner join MST_Line L on L.MST_Line_Id=T.MST_Line_Id
where R.SerialNumber=@SerialNumber and R.M_BOM_ID=@BOMId AND R.OrderNumber=@OrderNumber and T.MST_Line_Id=@LineId
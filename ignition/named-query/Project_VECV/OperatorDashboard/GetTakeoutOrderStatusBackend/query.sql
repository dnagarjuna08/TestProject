Declare @LineId int;

set @LineId = (select  MST_Line_Id from  MST_Line where  LineName =  :LineName and IsActive = 1 and IsDeleted = 0)

Select IsTakeout from TRN_ReleasedProductionOrder R
inner join TRN_TakeIn_TakeOut T on T.SerialNumber=R.SerialNumber and T.TakeIn_Station IS NULL
inner join MST_Line L on L.MST_Line_Id=T.MST_Line_Id
where R.SerialNumber=  :SerialNumber and T.MST_Line_Id=@LineId
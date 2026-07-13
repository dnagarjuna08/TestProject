DECLARE @tbl TABLE
(Date varchar(10)
)
	insert into @tbl (Date) values 
		(convert(varchar(10),:Date,5))
select D.Date,isnull("Overall Actual",0)"Overall Actual" from @tbl D

left join 
(Select convert(varchar(10),Created_On ,5) date, count (*) as "Overall Actual" from TRN_ReleasedProductionOrder trp
inner join  M_BOM MB on  MB.M_BOMNumber=trp.M_BOMNumber 
inner join  (SELECT "M_BOM_Id",mst_shift_id, MAX(trn_stationevents_ID) as Txn
FROM TRN_StationEvents
where mst_shift_id in (1,2,3) and convert(varchar(10),CreatedDate ,120)=convert(varchar(10),:Date,120)
GROUP BY "M_BOM_Id",mst_shift_id) TRE on TRE.M_BOM_Id=MB.M_BOM_Id
where Mst_Area_Id=:AreaID and  IsCompleted=1 and convert(varchar(10),Created_On ,120)=convert(varchar(10),:Date,120)
group by convert(varchar(10),Created_On ,5))A on A.date=D.Date

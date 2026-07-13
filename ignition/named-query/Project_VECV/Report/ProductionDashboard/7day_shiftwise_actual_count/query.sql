DECLARE @tbl TABLE
(Date varchar(10)
)
	insert into @tbl (Date) values 
		(convert(varchar(10),DateAdd(DD,-6,:Date),5)),
		(convert(varchar(10),DateAdd(DD,-5,:Date),5)),
		(convert(varchar(10),DateAdd(DD,-4,:Date),5)),
		(convert(varchar(10),DateAdd(DD,-3,:Date),5)),
		(convert(varchar(10),DateAdd(DD,-2,:Date),5)),
		(convert(varchar(10),DateAdd(DD,-1,:Date),5)),
		(convert(varchar(10),:Date,5))
select D.Date,isnull("Actual A",0)"Actual A",isnull("Actual B",0) "Actual B",isnull("Actual C",0) "Actual C" from @tbl D

left join 
(Select convert(varchar(10),Created_On ,5) date, count (*) as "Actual A" from TRN_ReleasedProductionOrder trp
inner join  M_BOM MB on  MB.M_BOMNumber=trp.M_BOMNumber 
inner join  (SELECT "M_BOM_Id",mst_shift_id, MAX(trn_stationevents_ID) as Txn
FROM TRN_StationEvents
where mst_shift_id=1 and convert(varchar(10),CreatedDate ,120)=convert(varchar(10),:Date,120)
GROUP BY "M_BOM_Id",mst_shift_id) TRE on TRE.M_BOM_Id=MB.M_BOM_Id
where Mst_Area_Id=:AreaID and  IsCompleted=0 and convert(varchar(10),Created_On ,120)>=convert(varchar(10),DateAdd(DD,-6,:Date),120)
group by MST_Shift_Id, convert(varchar(10),Created_On ,5))A on A.date=D.Date

left join 
(Select convert(varchar(10),Created_On ,5) date, count (*) as "Actual B" from TRN_ReleasedProductionOrder trp
inner join  M_BOM MB on  MB.M_BOMNumber=trp.M_BOMNumber 
inner join  (SELECT "M_BOM_Id",mst_shift_id, MAX(trn_stationevents_ID) as Txn
FROM TRN_StationEvents
where mst_shift_id=2 and convert(varchar(10),CreatedDate ,120)=convert(varchar(10),:Date,120)
GROUP BY "M_BOM_Id",mst_shift_id) TRE on TRE.M_BOM_Id=MB.M_BOM_Id
where Mst_Area_Id=:AreaID and  IsCompleted=1 and convert(varchar(10),Created_On ,120)>=convert(varchar(10),DateAdd(DD,-6,:Date),120)
group by MST_Shift_Id, convert(varchar(10),Created_On ,5))B on B.date=D.Date

left join 
(Select convert(varchar(10),Created_On ,5) date, count (*) as "Actual C" from TRN_ReleasedProductionOrder trp
inner join  M_BOM MB on  MB.M_BOMNumber=trp.M_BOMNumber 
inner join  (SELECT "M_BOM_Id",mst_shift_id, MAX(trn_stationevents_ID) as Txn
FROM TRN_StationEvents
where mst_shift_id=3 and convert(varchar(10),CreatedDate ,120)=convert(varchar(10),:Date,120)
GROUP BY "M_BOM_Id",mst_shift_id) TRE on TRE.M_BOM_Id=MB.M_BOM_Id
where Mst_Area_Id=:AreaID and  IsCompleted=0 and convert(varchar(10),Created_On ,120)>=convert(varchar(10),DateAdd(DD,-6,:Date),120)
group by MST_Shift_Id, convert(varchar(10),Created_On ,5))C on C.date=D.Date

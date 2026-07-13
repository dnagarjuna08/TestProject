select convert(varchar(10),Created_On ,5) date, count(case when IsCompleted=1 then 1 end) Actual,
count(case when  IsTested=1 then 1 end) Tested,
count(case when  IsPainting =1 then 1 end) Painted,
count(case when IsPDI =1 then 1 end) PDI
from TRN_ReleasedProductionOrder TRP
inner join  M_BOM MB on TRP. M_BOMNumber =MB.M_BOMNumber
where convert(varchar(10),Created_On ,120)>=convert(varchar(10),DateAdd(DD,-6,:Date),120) and Mst_Area_Id =:AreaID
group by convert(varchar(10),Created_On ,5)
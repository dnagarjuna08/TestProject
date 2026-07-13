select sum(Daily_Target) as Shift_Target from [dbo].[MST_Plan] 
where MST_Shift_Id=:shiftId and mst_area_id = 1
DECLARE @startTime TIME;
DECLARE @endTime TIME;
select @startTime = ShiftStartTime, @endTime = ShiftEndTime from TRN_Shift where MST_Shift_Id = (select MST_Shift_Id from MST_Shift where ShiftName = :ShiftName)
select count(*) as Count from trn_releasedproductionorder where CAST(Modified_On AS TIME) BETWEEN @startTime AND @endTime and CAST(Modified_On  as DATE) = CAST(GETDATE() as DATE) and IsBooked = 1
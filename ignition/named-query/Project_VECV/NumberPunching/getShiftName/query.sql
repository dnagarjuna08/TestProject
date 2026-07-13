SELECT RIGHT(ShiftName, LEN(ShiftName) - CHARINDEX(' ', ShiftName)) as Shift, MST_Shift_Id from MST_Shift where MST_Shift_Id = (
SELECT MST_Shift_Id
FROM TRN_Shift
WHERE CONVERT(TIME, GETDATE()) BETWEEN ShiftStartTime AND ShiftEndTime and MST_Line_Id = :MST_Line_Id  and IsActive = 1)
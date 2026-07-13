Declare 
@workStationId int
SELECT @workStationId = MST_WorkStation_Id FROM MST_WorkStation where WorkStationName = :WorkStationName  and IsActive = 1
SELECT mdn.DefectName , tqd.Comments , mU.UserName
from TRN_StationDefect tqd 
join MST_User mU WITH (NOLOCK) on mU.MST_User_Id = tqd.CreatedBy
join MST_DefectName mdn WITH (NOLOCK) on mdn.MST_DefectName_Id = tqd.MST_DefectName_Id
where tqd.SerialNumber =  :SerialNumber  and tqd.MST_WorkStation_Id=@workStationId and tqd.OrderNumber=  :OrderNumber
and tqd.Isdeleted = 0 and mdn.Isdeleted = 0
Declare @defectnameId int
select @defectnameId=MST_DefectName_Id from MST_DefectName where DefectName=:DefectName
SELECT '' AS 'Select',tqd.DefecSubName as "Defect SubName", '' AS Comments
from MST_DefectSUBName tqd where tqd.MST_DefectName_Id=@defectnameId and Isdeleted = 0 

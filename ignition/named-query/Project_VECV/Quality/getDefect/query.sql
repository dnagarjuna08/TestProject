Declare 
@defectId int 
SELECT @defectId=MST_Defect_Id FROM MST_Defect where DefectCategory=:DefectCategory
SELECT '' AS 'Select', tqd.DefectName , '' AS Comments 
from MST_DefectName tqd where tqd.MST_Defect_Id= @defectId and Isdeleted = 0


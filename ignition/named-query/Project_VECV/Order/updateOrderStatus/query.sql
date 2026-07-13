declare @psn int;
set @psn = (SELECT  max(psn) FROM  [dbo].[PRODUCTION_ORDER] WHERE OrderStatusid IN (2,3,4,5,6,7,8,9) and MST_Area_Id =  :AreaID ) + 1
	
UPDATE [PRODUCTION_ORDER]
SET OrderStatusid =  :OrderStatus,
psn = @psn
WHERE id = :Id;
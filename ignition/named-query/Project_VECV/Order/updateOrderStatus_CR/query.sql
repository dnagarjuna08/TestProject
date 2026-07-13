
-- Check if OrderStatusid = 4 exists
-- Declare a variable to store the existence check result
DECLARE @Exists INT;

-- Check if OrderStatusid = 4 exists
SET @Exists = (SELECT COUNT(*) FROM [PRODUCTION_ORDER] WHERE OrderStatusid in (4,2) and  MST_Area_Id = :AreaID);
declare @psn int;
set @psn = (SELECT  max(psn) FROM  [dbo].[PRODUCTION_ORDER] WHERE OrderStatusid IN (2,3,4,5,6,7,8,9) and MST_Area_Id =  :AreaID ) + 1
-- Conditional update based on the existence check
IF @Exists in (0,1,2,3,4)
BEGIN
    -- If OrderStatusid = 4 exists, update the OrderStatusid to 4
    UPDATE [PRODUCTION_ORDER]
    SET OrderStatusid = 4,
    psn = @psn
    WHERE id = :Id;
END
ELSE
BEGIN
    -- If OrderStatusid = 4 does not exist, update to the provided OrderStatus
    UPDATE [PRODUCTION_ORDER]
    SET OrderStatusid =  :OrderStatus,
    psn = @psn
    WHERE id = :Id;
END


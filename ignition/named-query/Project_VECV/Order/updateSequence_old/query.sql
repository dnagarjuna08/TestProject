
DECLARE @psn BIGINT;

SELECT @psn = MAX(psn) 
FROM PRODUCTION_ORDER;

-- If the Index parameter is -1
IF :Index = -1
BEGIN
    -- Select the maximum psn value again (this is redundant but kept from original logic)
    SELECT @psn = MAX(psn) 
    FROM PRODUCTION_ORDER where  OrderStatusid in(2,3);

    -- Update the PRODUCTION_ORDER with psn + 1
    UPDATE [PRODUCTION_ORDER] 
    SET psn = @psn + 1 , ModifiedBy = :UserId, ModifiedDate = GETDATE()
    WHERE id = :Id;
END
ELSE 
BEGIN
    -- Update the PRODUCTION_ORDER with the provided Index value
    UPDATE [PRODUCTION_ORDER] 
    SET psn = :Index , ModifiedBy = :UserId, ModifiedDate = GETDATE()
    WHERE id = :Id;
END
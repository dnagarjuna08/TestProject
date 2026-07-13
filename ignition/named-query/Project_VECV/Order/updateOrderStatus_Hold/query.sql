UPDATE [PRODUCTION_ORDER]
SET OrderStatusid =  :OrderStatus,  ModifiedBy = :UserId,  hold_time  =  GETDATE()
WHERE id = :Id;
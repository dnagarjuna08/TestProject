
UPDATE [PRODUCTION_ORDER] 
SET psn = :Index , ModifiedBy = :UserId, ModifiedDate = GETDATE()
WHERE id = :Id;

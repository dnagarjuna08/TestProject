update PRODUCTION_ORDER set OrderStatusid=8,ModifiedDate=GETDATE(),booked_time=GETDATE(),ModifiedBy= :ModifiedBy  
where serial_number= :serial_number 

update TRN_ReleasedProductionOrder set IsBooked=1,Modified_By= :ModifiedBy ,Modified_On=GETDATE() where 
SerialNumber= :serial_number 
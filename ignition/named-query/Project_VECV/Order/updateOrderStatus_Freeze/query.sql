UPDATE [PRODUCTION_ORDER]
SET OrderStatusid =  :OrderStatus where OrderStatusid = :PrevOrder and  MST_Area_Id = :AreaID
SELECT COUNT(*) FROM PRODUCTION_ORDER WHERE serial_number =  :SerialNumber  AND MST_Area_Id = (SELECT MST_Area_Id FROM MST_Area WHERE AreaName = :AreaName AND IsActive = 1)

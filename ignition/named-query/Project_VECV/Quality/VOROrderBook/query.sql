SELECT CASE 
         WHEN EXISTS (
           SELECT 1 
           FROM PRODUCTION_ORDER 
           WHERE serial_number =  :serial_number 
             AND ISNULL(LTRIM(RTRIM(UPPER(special_instruction))), '') IN ('CSPD', 'VOR','VOR/CSPD','VOR /CSPD','VOR/ CSPD','VOR / CSPD')
         ) 
         THEN 1 
         ELSE 0 
       END AS result
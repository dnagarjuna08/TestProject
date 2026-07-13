SELECT  p.TRN_Painting_Id , m.MST_Model_Id , a.MST_Area_Id , l.MST_Line_Id , w.MST_WorkStation_Id , b.M_BOM_Id , s.id , p.Status 
FROM  TRN_Painting as p

INNER JOIN  MST_Model as m ON m.MST_Model_Id = p.MST_Model_Id
INNER JOIN  MST_Area as a ON a.MST_Area_Id = p.MST_Area_Id
INNER JOIN  MST_Line as l ON l.MST_Line_Id = p.MST_Line_Id
INNER JOIN  MST_WorkInstruction as w ON w.MST_WorkStation_Id = p.MST_WorkStation_Id
INNER JOIN  M_BOM as b ON b.M_BOM_Id = p.M_BOM_Id
INNER JOIN  SERIAL_NUMBER as s ON s.id = p.SerialNumber_Id
  

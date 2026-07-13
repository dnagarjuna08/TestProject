IF EXISTS (
  SELECT 1
  FROM TRN_Shift t
  LEFT JOIN MST_CycleTime ct ON
    t.MST_Shift_Id = ct.MST_Shift_Id
  WHERE
    ct.MST_Model_Id = :ModelID AND
    ct.MST_Line_Id = :LineID AND
    ct.MST_WorkStation_Id = :WorkstationID 
)
BEGIN
  SELECT TOP 1 ISNULL(ct.CycleTime, 0) AS CycleTime
  FROM TRN_Shift t
  LEFT JOIN MST_CycleTime ct ON
    t.MST_Shift_Id = ct.MST_Shift_Id
  WHERE
    ct.MST_Model_Id = :ModelID AND
    ct.MST_Line_Id = :LineID AND
    ct.MST_WorkStation_Id = :WorkstationID AND
	ct.IsActive = 1;

END
ELSE
BEGIN
  SELECT 0 AS CycleTime
END;

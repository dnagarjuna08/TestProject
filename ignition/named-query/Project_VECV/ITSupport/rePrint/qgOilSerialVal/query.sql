DECLARE @SerialNumber NVARCHAR(50) = :SerialNumber;

BEGIN
    SELECT ISNULL(
        (SELECT SerialNumber 
         FROM TRN_StationStatus 
         WHERE MST_WorkStation_Id = 331 
           AND MST_Status_Id = 2 
           AND SerialNumber = @SerialNumber), 0) AS SerialNumber;
END;

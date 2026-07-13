WITH OrderedData AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY CreatedDate DESC) AS [Sr. No.],
        Serial_Number
    FROM 
        SERIAL_NUMBER S inner join TRN_ReleasedProductionOrder RPO 
        on S.serial_number=RPO.SerialNumber
    WHERE 
        MST_Area_Id =   :Area  and LEN(M_BOMNumber)<=6
)
SELECT TOP 20 *
FROM OrderedData
ORDER BY [Sr. No.];
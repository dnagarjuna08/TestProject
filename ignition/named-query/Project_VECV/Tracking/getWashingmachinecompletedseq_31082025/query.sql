WITH OrderedData AS (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY CreatedDate DESC) AS [Sr. No.],
        Serial_Number
    FROM 
        SERIAL_NUMBER
    WHERE 
        MST_Area_Id =  :Area 
)
SELECT TOP 20 *
FROM OrderedData
ORDER BY [Sr. No.];

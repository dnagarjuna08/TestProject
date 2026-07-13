DECLARE @cols NVARCHAR(MAX), @sql NVARCHAR(MAX), @orderCol NVARCHAR(100), @AreaId INT;

-- Set your area ID dynamically or explicitly
SET @AreaId =  :AreaID ; -- Change to 2 as needed

-- Decide which column to use for ORDER BY
SET @orderCol = CASE 
    WHEN @AreaId = 1 THEN 'LAD10'
    WHEN @AreaId = 2 THEN 'TAWM02'
    ELSE 'LAD10' -- default fallback
END;

-- Step 1: Generate ordered column list using STRING_AGG with explicit ORDER BY inside
SELECT @cols = STRING_AGG(
    CAST(
        'MAX(CASE WHEN FE.MST_WorkStation_Id = ' 
        + CAST(MST_WorkStation_Id AS NVARCHAR) 
        + ' THEN CreatedDate END) AS [' 
        + WorkStationName 
        + ']'
    AS NVARCHAR(MAX)), ', '
) WITHIN GROUP (
    ORDER BY 
        CASE WHEN WorkStationName = 'LAPDI' THEN 1 ELSE 0 END,
        CASE 
            WHEN PATINDEX('%[0-9]%', WorkStationName) > 0 
                THEN LEFT(WorkStationName, PATINDEX('%[0-9]%', WorkStationName) - 1)
            ELSE WorkStationName 
        END,
        CASE 
            WHEN PATINDEX('%[0-9]%', WorkStationName) > 0 
                THEN TRY_CAST(SUBSTRING(WorkStationName, PATINDEX('%[0-9]%', WorkStationName), LEN(WorkStationName)) AS INT)
            ELSE NULL
        END
)
FROM MST_WorkStation
WHERE 
    MST_Area_Id = @AreaId 
    AND IsActive = 1 
    AND IsDeleted = 0 
    AND MST_WorkStationType_Id != 1
    AND WorkStationName NOT IN ('LAConveyor','LAH100','Spare Station');

-- Step 2: Construct dynamic SQL
SET @sql = '
WITH CompletedEvents AS (
    SELECT 
        SerialNumber, 
        TRN_Station_Events.MST_WorkStation_Id,
        WorkStationName,
        MST_Event_Id,
        TRN_Station_Events.CreatedDate
    FROM 
        TRN_Station_Events 
        INNER JOIN MST_Workstation ON MST_Workstation.MST_WorkStation_Id = TRN_Station_Events.MST_WorkStation_Id
        INNER JOIN production_order ON production_order.serial_number = TRN_Station_Events.SerialNumber
    WHERE 
        MST_Workstation.MST_Area_Id = ' + CAST(@AreaId AS NVARCHAR) + '
        AND MST_Workstation.IsActive = 1 
        AND MST_Workstation.IsDeleted = 0 
        AND MST_Workstation.MST_WorkStationType_Id != 1
        AND MST_Event_Id = 5 
        AND orderStatusId = 6
),
FilteredEvents AS (
    SELECT 
        SerialNumber,
        WorkStationName, 
        MST_WorkStation_Id,
        CreatedDate
    FROM 
        CompletedEvents
),
FinalResults AS (
    SELECT 
        SerialNumber, ' + @cols + '
    FROM 
        FilteredEvents FE
    GROUP BY 
        SerialNumber
)
SELECT 
    M_BOM.M_BOMNumber, FR.*
FROM 
    FinalResults FR
    INNER JOIN production_order PO ON PO.serial_number = FR.SerialNumber
    INNER JOIN M_BOM ON M_BOM.M_BOM_Id = PO.M_BOM_Id
ORDER BY [' + @orderCol + '] DESC;
';

-- Step 3: Execute the dynamic SQL
EXEC sp_executesql @sql;

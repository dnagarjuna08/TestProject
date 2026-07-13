DECLARE @StartTime DATETIME = :StartTime;
DECLARE @EndTime DATETIME = :EndTime;
DECLARE @AreaName NVARCHAR(60) = :AreaName;


-- CTE declaration with correct syntax
WITH A AS (
    SELECT 
        MST_Area.AreaName AS Area, 
        MST_WorkStation.WorkStationName AS Station,  
        MST_IssueType.issue_type AS IssueType, 
        TRN_issueBtn.createdDate AS StartTime,
        TRN_issueBtn.end_time AS EndTime,
        CAST(DATEDIFF(SECOND, TRN_issueBtn.start_time, TRN_issueBtn.end_time) / 60.0 AS DECIMAL(10, 2)) AS Downtime
    FROM 
        MST_Area 
    INNER JOIN 
        MST_WorkStation ON MST_WorkStation.MST_Area_Id = MST_Area.MST_Area_Id
    INNER JOIN 
        TRN_issueBtn ON TRN_issueBtn.mst_workstation_id = MST_WorkStation.MST_WorkStation_Id
    INNER JOIN 
        MST_IssueType ON MST_IssueType.Issue_Type_ID = TRN_issueBtn.Issue_type_id
    WHERE 
        MST_Area.AreaName = @AreaName
        AND (TRN_issueBtn.start_time >= @StartTime AND TRN_issueBtn.end_time <= @EndTime)  
        AND (MST_WorkStation.MST_WorkStation_Id = '408') 
        AND (MST_IssueType.Issue_Type_ID = '6')
)

-- Query using the CTE
SELECT 
    SUM(downtime) AS sum_downtime
FROM 
    A
WHERE 
    A.downtime > 0 ;

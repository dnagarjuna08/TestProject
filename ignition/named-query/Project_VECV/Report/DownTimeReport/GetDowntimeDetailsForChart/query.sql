DECLARE @cycleTime float = :cycleTime;
DECLARE @StartTime DATETIME = :StartTime;
DECLARE @EndTime DATETIME = :EndTime;
DECLARE @downtime INT = :downtime;  -- New parameter for downtime
declare @AreaName nvarchar(60) = :AreaName;
declare @ws nvarchar(60) = :Station;
declare @IssueType nvarchar(60) = :IssueType;

with A as (
SELECT 
    MST_Area.AreaName AS Area, 
    MST_WorkStation.WorkStationName AS Station,  
    MST_IssueType.issue_type AS IssueType, 
    TRN_issueBtn.createdDate AS StartTime,
    TRN_issueBtn.end_time AS EndTime,
    CAST(DATEDIFF(SECOND, TRN_issueBtn.createdDate, TRN_issueBtn.end_time) / 60 AS DECIMAL(10, 2)) AS Downtime

/*            cast(DATEDIFF(SECOND, TRN_issueBtn.createdDate, TRN_issueBtn.end_time)/60 as varchar) + ' Minutes ' +
                cast(DATEDIFF(SECOND, TRN_issueBtn.createdDate, TRN_issueBtn.end_time)%60 as varchar) + ' Seconds'
                AS Downtime1
*/
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
   and
   (TRN_issueBtn.createdDate >= @StartTime AND
   TRN_issueBtn.createdDate  <= @EndTime)  
   and (@ws IS NULL or @ws ='' OR MST_WorkStation.WorkStationName = @ws) 
   AND (@IssueType IS NULL or @IssueType ='' OR MST_IssueType.Issue_Type = @IssueType) 
   AND MST_WorkStation.workstationname!='LAconveyor')

Select -- *,
issuetype,sum(downtime) as downtime 
--cast(A.downtime/@cycleTime AS DECIMAL(10, 2)) as LossTime

/*cast( FLOOR(cast(A.downtime/@cycleTime AS DECIMAL(10, 2))) AS nvarchar(50)) + ' Minutes ' +
  cast(cast(ROUND((cast(A.downtime/@cycleTime AS DECIMAL(10, 2)) - FLOOR(cast(A.downtime/@cycleTime AS DECIMAL(10, 2)))) * 60, 0) as int) as nvarchar(50)) + ' Seconds'
as LossTime1*/

from A 
where a.downtime > 0 and (
@downtime is NUll or @downtime=''
or
A.downtime >= @downtime)
group by issuetype


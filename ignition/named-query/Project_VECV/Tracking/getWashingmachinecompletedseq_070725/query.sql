DECLARE @MST_Area_Id INT =  :Area,
        @SrNo INT;
 
BEGIN
    ;WITH data AS
    (
        SELECT TOP 20 
            TSS.SerialNumber AS 'Serial Number',
            TSS.CreatedDate
        FROM
            [dbo].[TRN_StationStatus] TSS
        INNER JOIN
            mst_workstation MW ON MW.MST_WorkStation_Id = TSS.MST_WorkStation_Id
        WHERE
            TSS.MST_Area_Id = @MST_Area_Id
            AND TSS.mst_status_id = 2
            AND TSS.IsActive = 1
            AND TSS.IsDeleted = 0
            AND MW.MST_WorkStationType_Id = 4
            AND MW.IsActive = 1
            AND MW.IsDeleted = 0
        ORDER BY
            TSS.CreatedDate DESC
    ),
    SrData AS
    (
        SELECT 
            [Serial Number],
            ROW_NUMBER() OVER (PARTITION BY data.[Serial Number] ORDER BY data.CreatedDate) AS SrNo
        FROM 
            data
    )
    SELECT [Serial Number] 
    FROM SrData 
    WHERE SrNo = 1;
END;
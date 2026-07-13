DECLARE 
    @row int = :row,
    @date DATE = :date;

BEGIN
    SET NOCOUNT ON;

    IF @row = 1
    BEGIN
        DECLARE @startDate DATETIME = CAST(@date AS DATETIME) + '07:30:00.000';
        DECLARE @endDate DATETIME = CAST(@date AS DATETIME) + '15:59:59.999';

        SELECT 
            UPPER(SerialNumber) AS SerialNumber,
            DefectCategory,
            DN.DefectName,
			SN.DefecSubName,
            OperatorID,
            Comments,
            [Status],
            SD.CreatedDate
		FROM 
			TRN_StationDefect SD
		INNER JOIN 
			MST_Defect D ON SD.MST_Defect_Id = D.MST_Defect_Id
		INNER JOIN 
			MST_DefectStatus DS ON SD.MST_DefectStatus_Id = DS.MST_DefectStatus_Id
		INNER JOIN 
			MST_DefectName DN ON DN.MST_DefectName_Id = SD.MST_DefectName_Id
		INNER JOIN
			MST_DefectSUBName SN ON SN.MST_DefectSUBName_Id = SD.MST_DefectSubName_Id
        WHERE 
            MST_WorkStation_Id = (select MST_WorkStation_Id 
			from MST_WorkStation 
			where WorkStationName =  :WorkStationName 
			and IsActive = 1)
            AND SD.CreatedDate BETWEEN @startDate AND @endDate;
    END

    ELSE IF @row = 2
    BEGIN
        DECLARE @startDate2 DATETIME = CAST(@date AS DATETIME) + '16:00:00.000';
        DECLARE @endDate2 DATETIME = CAST(@date AS DATETIME) + '23:59:59.999';

        SELECT 
            UPPER(SerialNumber) AS SerialNumber,
            DefectCategory,
            DN.DefectName,
			SN.DefecSubName,
            OperatorID,
            Comments,
            [Status],
            SD.CreatedDate
		FROM 
			TRN_StationDefect SD
		INNER JOIN 
			MST_Defect D ON SD.MST_Defect_Id = D.MST_Defect_Id
		INNER JOIN 
			MST_DefectStatus DS ON SD.MST_DefectStatus_Id = DS.MST_DefectStatus_Id
		INNER JOIN 
			MST_DefectName DN ON DN.MST_DefectName_Id = SD.MST_DefectName_Id
		INNER JOIN
			MST_DefectSUBName SN ON SN.MST_DefectSUBName_Id = SD.MST_DefectSubName_Id
        WHERE 
            MST_WorkStation_Id = (select MST_WorkStation_Id 
			from MST_WorkStation 
			where WorkStationName =  :WorkStationName 
			and IsActive = 1)
            AND SD.CreatedDate BETWEEN @startDate2 AND @endDate2;
    END

    ELSE IF @row = 3
    BEGIN
        DECLARE @date123 DATE = DATEADD(DAY, 1, @date);
        DECLARE @startDate3 DATETIME = CAST(@date123 AS DATETIME) + '00:00:00.000';
        DECLARE @endDate3 DATETIME = CAST(@date123 AS DATETIME) + '07:29:59.000';

        SELECT 
            UPPER(SerialNumber) AS SerialNumber,
            DefectCategory,
            DN.DefectName,
			SN.DefecSubName,
            OperatorID,
            Comments,
            [Status],
            SD.CreatedDate
		FROM 
			TRN_StationDefect SD
		INNER JOIN 
			MST_Defect D ON SD.MST_Defect_Id = D.MST_Defect_Id
		INNER JOIN 
			MST_DefectStatus DS ON SD.MST_DefectStatus_Id = DS.MST_DefectStatus_Id
		INNER JOIN 
			MST_DefectName DN ON DN.MST_DefectName_Id = SD.MST_DefectName_Id
		INNER JOIN
			MST_DefectSUBName SN ON SN.MST_DefectSUBName_Id = SD.MST_DefectSubName_Id
        WHERE 
            MST_WorkStation_Id = (select MST_WorkStation_Id 
			from MST_WorkStation 
			where WorkStationName =  :WorkStationName 
			and IsActive = 1)
            AND SD.CreatedDate BETWEEN @startDate3 AND @endDate3;
    END
    ELSE IF @row = 4
    BEGIN
        DECLARE @startDate4 DATETIME = CAST(@date AS DATETIME) + '07:30:00.000';
        DECLARE @shiftDate1234 DATE = DATEADD(DAY, 1, @date);
        DECLARE @endDate4 DATETIME = CAST(@shiftDate1234 AS DATETIME) + '07:29:59.000';

        SELECT 
            UPPER(SerialNumber) AS SerialNumber,
            DefectCategory,
            DN.DefectName,
			SN.DefecSubName,
            OperatorID,
            Comments,
            [Status],
            SD.CreatedDate
		FROM 
			TRN_StationDefect SD
		INNER JOIN 
			MST_Defect D ON SD.MST_Defect_Id = D.MST_Defect_Id
		INNER JOIN 
			MST_DefectStatus DS ON SD.MST_DefectStatus_Id = DS.MST_DefectStatus_Id
		INNER JOIN 
			MST_DefectName DN ON DN.MST_DefectName_Id = SD.MST_DefectName_Id
		INNER JOIN
			MST_DefectSUBName SN ON SN.MST_DefectSUBName_Id = SD.MST_DefectSubName_Id
        WHERE 
            MST_WorkStation_Id = (select MST_WorkStation_Id 
			from MST_WorkStation 
			where WorkStationName =  :WorkStationName 
			and IsActive = 1)
            AND SD.CreatedDate BETWEEN @startDate4 AND @endDate4;
    END  
    ELSE
    BEGIN
        SELECT result = 0
    END 
END

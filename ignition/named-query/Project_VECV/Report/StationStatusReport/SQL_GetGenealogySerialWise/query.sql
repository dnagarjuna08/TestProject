SELECT
		ROW_NUMBER() OVER (ORDER BY TE.CreatedDate) AS [Sr.No],
		(select Description from MST_WorkStation where MST_Workstation_Id = T.[MST_WorkStation_Id]) as 'Station Name',
		(select WorkStationName from MST_WorkStation where MST_Workstation_Id = T.[MST_WorkStation_Id]) as 'Station Code',
		(SELECT 
		CASE 
			WHEN TE.SerialNumber IS NULL THEN SerialNumber
			ELSE UPPER(TE.SerialNumber)
		END )AS SerialNumber,
		M.M_MaterialNumber as 'PartNumber', M.Description,
		count(DISTINCT T.M_Material_Id) as Required, 
		count(DISTINCT D.PartNumber) as 'Scanned',
		CASE
		WHEN CHARINDEX('#', D.ConsumedPartNumber) > 0
				AND CHARINDEX('#', D.ConsumedPartNumber, CHARINDEX('#', D.ConsumedPartNumber) + 1) > 0
		THEN SUBSTRING(
			D.ConsumedPartNumber,
			CHARINDEX('#', D.ConsumedPartNumber) + 2,
			CHARINDEX('#', D.ConsumedPartNumber, CHARINDEX('#', D.ConsumedPartNumber) + 1) - CHARINDEX('#', D.ConsumedPartNumber) - 2
		)
		ELSE ''
		END AS Traceability,
		 CASE
			WHEN CHARINDEX('#', D.ConsumedPartNumber) > 0
				 AND CHARINDEX('#', D.ConsumedPartNumber, CHARINDEX('#', D.ConsumedPartNumber) + 1) > 0
				 AND CHARINDEX('#', D.ConsumedPartNumber, CHARINDEX('#', D.ConsumedPartNumber, CHARINDEX('#', D.ConsumedPartNumber) + 1) + 1) > 0
			THEN SUBSTRING(
				D.ConsumedPartNumber,
				CHARINDEX('#', D.ConsumedPartNumber, CHARINDEX('#', D.ConsumedPartNumber) + 2) + 2,
				CHARINDEX('#', D.ConsumedPartNumber, CHARINDEX('#', D.ConsumedPartNumber, CHARINDEX('#', D.ConsumedPartNumber) + 1) + 1) - CHARINDEX('#', D.ConsumedPartNumber, CHARINDEX('#', D.ConsumedPartNumber) + 1) - 2
			)
			ELSE ''
		END AS Vendor,
		(SELECT COALESCE(
		(SELECT Event FROM MST_Event WHERE MST_Event_Id = TE.MST_Event_Id),
		'NotScanned')) AS Status,
		TE.CreatedDate as 'EventTime'
	FROM [dbo].[TRN_ErrorProof] T
	Inner join M_Material as M  WITH(NOLOCK) on M.M_Material_Id = T.M_Material_Id
	left Join TRN_Station_Events as TE WITH(NOLOCK) on TE.MST_WorkStation_Id = T.[MST_WorkStation_Id]  and TE.SerialNumber = :serialNumber and TE.MST_OPDefinition_Id = 3 and TE.MST_Event_Id = 5
	left join TRN_Operation_Data as D WITH(NOLOCK) on D.PartNumber = M.M_MaterialNumber and TE.TRN_Station_Events_Id = D.TRN_Station_Events_Id
	WHERE T.[M_BOM_Id] = (SELECT p.[M_BOM_Id] as BOM_Id
	FROM [dbo].[PRODUCTION_ORDER] p
	WHERE p.[serial_number] = :serialNumber)
		AND T.[IsActive] = 1 
		
		group by TE.SerialNumber,T.M_Material_Id,T.[MST_WorkStation_Id], M.M_MaterialNumber,TE.MST_Event_Id, M.Description, D.ConsumedPartNumber,TE.CreatedDate

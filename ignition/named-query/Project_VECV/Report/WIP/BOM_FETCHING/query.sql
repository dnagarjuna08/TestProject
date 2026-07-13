SELECT 'All' AS M_BOMNumber UNION ALL
SELECT M_BOMNumber
FROM  M_BOM
where  IsActive = 1
--order by  CreatedOn desc;
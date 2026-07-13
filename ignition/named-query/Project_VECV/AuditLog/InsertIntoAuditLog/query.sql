insert into TRN_AuditLog(Category,SubCategory,Description,CreatedBy,CreatedDate)
values(:Category,:SubCategory,:Description,:CreatedBy,:CreatedDate)

SELECT @@IDENTITY AS 'Identity'
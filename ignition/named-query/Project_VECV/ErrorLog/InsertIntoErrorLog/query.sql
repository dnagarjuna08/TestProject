insert into TRN_ErrorLog(ScreenName,FilePath,ErrorFunction,ErrorType,ErrorCode,Description,lineNumber,CreatedDate)
values(:ScreenName,:FilePath,:ErrorFunction,:ErrorType, :ErrorCode,:Description,:lineNumber,:CreatedDate)

SELECT @@IDENTITY AS 'Identity'
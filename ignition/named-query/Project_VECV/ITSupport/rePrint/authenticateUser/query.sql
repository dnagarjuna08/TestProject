Declare 
@User NVARCHAR(50)= :User ;
BEGIN
	SELECT ISNULL((select UserName from MST_User where IsActive=1 and IsDeleted=0 and MST_Role_Id in (68,1,62) and UserName=@User),0) AS isValidUser
END
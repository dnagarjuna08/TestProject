declare
@Id int= :Id ,
@ModifiedBy int= :ModifiedBy
--AS
BEGIN
--SET NOCOUNT ON;
	-- Update statements for procedure here
	UPDATE MST_User SET IsActive =0, IsDeleted = 1, ModifiedBy = @ModifiedBy, ModifiedDate=GETDATE() where MST_User_Id = @Id
	select 1 as 'result'
END
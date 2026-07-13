declare @active int= :isActive ,
@del int =  :isDeleted ,
@fromDate DateTime= :fromDate ,
@toDate DateTime = :toDate ;
begin

SELECT u.UserName,'EndUser' AS RoleName,
    CASE 
        WHEN u.IsActive = 0 AND u.IsDeleted = 1 THEN u.ModifiedDate
        WHEN u.IsActive = 1 AND u.IsDeleted = 0 THEN u.CreatedDate
        ELSE NULL
    END AS ActionDate,u.PasswordExpiryOn,u.last_login,u.IsActive,u.IsDeleted,u.ServiceNumber
FROM MST_User AS u
INNER JOIN MST_Role AS r ON u.MST_Role_Id = r.MST_Role_Id
WHERE r.RoleName IN ('End User', 'Quality', 'Temporary User','Supervisor')  AND (u.IsActive = @active AND u.IsDeleted = @del )
ORDER BY u.CreatedDate DESC
end;
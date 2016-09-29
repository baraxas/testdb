SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_RemoveRoleMember]
    @RoleName sysname,
    @MemberSid varbinary(85) = NULL,
    @MemberName sysname
AS

SET NOCOUNT ON

DECLARE @Status int
SET @Status = 0

-- temporary table is used to access results from dynamic queries of other databases

CREATE TABLE #Databases
(
    DatabaseName sysname COLLATE database_default NOT NULL,
    UserName     sysname COLLATE database_default NOT NULL
)

DECLARE @ProductVersion nvarchar(128), @SQLMajorVersion int

SELECT @ProductVersion = CONVERT(nvarchar(128), SERVERPROPERTY('ProductVersion'))
SELECT @SQLMajorVersion = CONVERT(int, SUBSTRING(@ProductVersion, 1, CHARINDEX(N'.', @ProductVersion)-1))


-- select user-defined database role
-- only user-defined database roles may be specified
-- user-defined roles
--    have a uid greater than or equal to 16400 in SQL 2000
--    have is_fixed_role set to 0 and principal_id >= 5 starting SQL 2005

DECLARE @RoleId smallint

IF (@SQLMajorVersion IS NULL) OR (@SQLMajorVersion < 9)
    SELECT @RoleId = uid FROM dbo.sysusers WHERE name = @RoleName AND issqlrole = 1 AND uid >= 16400
ELSE
    SELECT @RoleId = principal_id FROM sys.database_principals WHERE name = @RoleName AND is_fixed_role = 0 AND type = 'R' AND principal_id >= 5

IF @@ROWCOUNT = 0
BEGIN
    -- raise invalid role error
    RAISERROR(236807, -1, -1, @RoleName)
    RETURN 1
END

-- select database user

DECLARE @UserId smallint, @UserName sysname

IF @MemberSid IS NOT NULL
    SELECT @UserId = uid, @UserName = name FROM dbo.sysusers WHERE sid = @MemberSid
ELSE
    SELECT @UserId = uid, @UserName = name FROM dbo.sysusers WHERE name = @MemberName

IF @@ROWCOUNT > 0
BEGIN
    -- drop member from role if user is member of role

    IF EXISTS (SELECT * FROM dbo.sysmembers WHERE groupuid = @RoleId AND memberuid = @UserId)
    BEGIN
        EXEC @Status = sp_droprolemember @RoleName, @UserName

        IF @Status = 0
            -- raise member successfully removed from role
            RAISERROR(236805, -1, -1, @MemberName, @RoleName)
        ELSE
            RETURN 1
    END
    ELSE
    BEGIN
        -- raise not member of role warning
        RAISERROR(236806, -1, -1, @MemberName, @RoleName)
    END

    -- revoke database access if user is no longer a member of any roles

    IF NOT EXISTS (SELECT * FROM dbo.sysmembers WHERE memberuid = @UserId)
    BEGIN
        EXEC @Status = sp_revokedbaccess @UserName

        IF @Status <> 0
            RETURN 1
    END
    ELSE
    BEGIN
        RETURN 0
    END

END
ELSE
BEGIN
    -- raise not member of role warning
    RAISERROR(236806, -1, -1, @MemberName, @RoleName)
END

-- select login

DECLARE @LoginSid varbinary(85), @LoginName sysname

IF @MemberSid IS NOT NULL
    SELECT @LoginSid = sid, @LoginName = name FROM master.dbo.syslogins WHERE sid = @MemberSid
ELSE
    SELECT @LoginSid = sid, @LoginName = name FROM master.dbo.syslogins WHERE name = @MemberName

IF @@ROWCOUNT = 0
    RETURN 0

-- if the login is a member of a fixed server role then don't revoke the login

IF EXISTS
(
    SELECT
        *
    FROM
        master.dbo.syslogins
    WHERE
        (sid = @LoginSid)
        AND
        (
            sysadmin = 1
            OR
            securityadmin = 1
            OR
            serveradmin = 1
            OR
            setupadmin = 1
            OR
            processadmin = 1
            OR
            diskadmin = 1
            OR
            dbcreator = 1
            OR
            bulkadmin = 1
        )
)
BEGIN
    -- raise login is member of fixed server role warning
    RAISERROR(236802, -1, -1, @MemberName)
    RETURN 0
END

-- if login owns any databases then login will not be revoked

IF EXISTS (SELECT * FROM master.dbo.sysdatabases WHERE sid = @LoginSid)
BEGIN
    -- raise login is owner of one or more databases warning
    RAISERROR(236803, -1, -1, @MemberName)
    RETURN
END

-- if login is user in any databases then don't revoke login

DECLARE cursorDatabase CURSOR FOR SELECT name FROM master.dbo.sysdatabases
OPEN cursorDatabase
DECLARE @DatabaseName sysname
FETCH NEXT FROM cursorDatabase INTO @DatabaseName
WHILE @@FETCH_STATUS >= 0
BEGIN
    DECLARE @Statement nvarchar(768)
    SET @Statement =
        'USE ' + QUOTENAME(@DatabaseName , '[') + '
        INSERT INTO
            #Databases (DatabaseName, UserName)
        SELECT
            N' + QUOTENAME(@DatabaseName, '''') + ', U.name
        FROM
            dbo.sysusers AS U
        JOIN
            master.dbo.syslogins AS L ON L.sid = U.sid
        WHERE
            L.name = N' + QUOTENAME(@LoginName, '''')
    EXEC (@Statement)
    FETCH NEXT FROM cursorDatabase INTO @DatabaseName
END
CLOSE cursorDatabase
DEALLOCATE cursorDatabase

IF (SELECT COUNT(*) FROM #Databases) <> 0
BEGIN
    -- raise login is user in one or more databases warning
    RAISERROR(236804, -1, -1, @MemberName)
    RETURN
END

-- revoke login

EXEC @Status = sp_revokelogin @LoginName

IF @Status <> 0
    RETURN 1

RETURN 0


GO

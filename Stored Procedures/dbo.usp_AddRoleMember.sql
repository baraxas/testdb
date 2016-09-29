SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_AddRoleMember]
    @RoleName sysname,
    @MemberSid varbinary(85),
    @MemberName sysname
AS

SET NOCOUNT ON

DECLARE @Status int
SET @Status = 0

-- select user-defined database role
-- only user-defined database roles may be specified
-- user-defined roles
--    have a uid greater than or equal to 16400 in SQL 2000
--    have is_fixed_role set to 0 and principal_id >= 5 starting SQL 2005

DECLARE @RoleId smallint

DECLARE @ProductVersion nvarchar(128), @SQLMajorVersion int

SELECT @ProductVersion = CONVERT(nvarchar(128), SERVERPROPERTY('ProductVersion'))
SELECT @SQLMajorVersion = CONVERT(int, SUBSTRING(@ProductVersion, 1, CHARINDEX(N'.', @ProductVersion)-1))

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

-- Select user identifier (uid) from database users table.

DECLARE @MemberId smallint,
        @_MemberName sysname

SELECT @MemberId = uid, @_MemberName = name FROM dbo.sysusers WHERE sid = @MemberSid

-- If member found is the 'dbo' raise error as dbo cannot be added to roles.
-- As only dbo can be an alias for a Windows user account and only Windows accounts are
-- supported by ADMT a simple check against the dbo uid will suffice. The error message
-- also refers to specifically the dbo.

IF @MemberId IS NOT NULL AND @MemberId = 1 -- dbo
BEGIN
    -- raise account cannot be added to role because it is the dbo error
    RAISERROR(236808, -1, -1, @MemberName, @RoleName)
    RETURN 1
END

-- Grant access to SQL Server.

IF @MemberId IS NULL
BEGIN
    DECLARE @Name sysname

    SELECT @Name = name FROM master.dbo.syslogins WHERE sid = @MemberSid

    IF @Name IS NULL
    BEGIN
        EXEC @Status = sp_grantlogin @MemberName
        IF @Status <> 0
            RETURN 1

        EXEC sp_defaultdb @MemberName, N'ADMT'
    END
    ELSE
    BEGIN
        IF @Name <> @MemberName
        BEGIN
            -- raise login already exists under different name error
            RAISERROR(236801, -1, -1, @Name)
            RETURN 1
        END
    END
END

-- grant access to database

DECLARE @HasAccess int

SELECT
    @HasAccess = hasdbaccess
FROM
    dbo.sysusers
WHERE
    (@MemberId IS NOT NULL AND uid = @MemberId) OR sid = @MemberSid

IF @HasAccess IS NULL OR @HasAccess = 0
BEGIN
    IF @_MemberName IS NOT NULL
        EXEC @Status = sp_grantdbaccess @_MemberName
    ELSE
        EXEC @Status = sp_grantdbaccess @MemberName

    IF @Status <> 0
        RETURN 1
END

-- add member to role

IF @MemberId IS NULL
    SELECT @MemberId = uid, @_MemberName = name FROM dbo.sysusers WHERE sid = @MemberSid

IF NOT EXISTS (SELECT * FROM dbo.sysmembers WHERE groupuid = @RoleId AND memberuid = @MemberId)
BEGIN
    EXEC @Status = sp_addrolemember @RoleName, @_MemberName
    IF @Status <> 0
        RETURN 1
END

SET NOCOUNT OFF

RETURN 0


GO

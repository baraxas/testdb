SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_GetRolesAndMembers]
AS

DECLARE @ProductVersion nvarchar(128), @SQLMajorVersion int

SELECT @ProductVersion = CONVERT(nvarchar(128), SERVERPROPERTY('ProductVersion'))
SELECT @SQLMajorVersion = CONVERT(int, SUBSTRING(@ProductVersion, 1, CHARINDEX(N'.', @ProductVersion)-1))

-- Select all user defined roles and members of these roles.

IF (@SQLMajorVersion IS NULL) OR (@SQLMajorVersion < 9)

    SELECT
        R.RoleName AS RoleName,
        CASE WHEN M.MemberName IS NOT NULL THEN M.MemberName ELSE N'' END AS MemberName
    FROM
        (
            -- Select user defined roles.
            -- user-defined roles have a uid greater than or equal to 16400 in SQL 2000

            SELECT
                name AS RoleName, uid AS GroupId
            FROM
                dbo.sysusers
            WHERE
                uid >= 16400 AND issqlrole = 1

        )
        AS R LEFT JOIN
        (
            -- Select Windows users and/or groups which are members of a role.

            SELECT
                SU.name AS MemberName, SM.groupuid AS GroupId
            FROM
                dbo.sysmembers AS SM
                JOIN
                dbo.sysusers AS SU ON SM.memberuid = SU.uid AND SU.isntname = 1
        )
        AS M ON R.GroupId = M.GroupId
    ORDER BY
        R.GroupId, M.MemberName

ELSE

    SELECT
        R.RoleName AS RoleName,
        CASE WHEN M.MemberName IS NOT NULL THEN M.MemberName ELSE N'' END AS MemberName
    FROM
        (
            -- Select user defined roles.
            -- user-defined roles have is_fixed_role set to 0 and principal_id >= 5 starting SQL 2005

            SELECT
                name AS RoleName, principal_id AS GroupId
            FROM
                sys.database_principals
            WHERE
                type = 'R' AND is_fixed_role = 0 AND principal_id >= 5
            
        )
        AS R LEFT JOIN
        (
            -- Select Windows users and/or groups which are members of a role.

            SELECT
                SU.name AS MemberName, SM.groupuid AS GroupId
            FROM
                dbo.sysmembers AS SM
                JOIN
                dbo.sysusers AS SU ON SM.memberuid = SU.uid AND SU.isntname = 1
        )
        AS M ON R.GroupId = M.GroupId
    ORDER BY
        R.GroupId, M.MemberName


GO
GRANT EXECUTE ON  [dbo].[usp_GetRolesAndMembers] TO [Data Readers]
GO

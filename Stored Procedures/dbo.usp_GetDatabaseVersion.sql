SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_GetDatabaseVersion]
    @VersionMajor int OUTPUT,
    @VersionMinor int OUTPUT
AS

SELECT
    @VersionMajor = CAST(value AS int)
FROM
    ::fn_listextendedproperty(N'DatabaseVersionMajor', N'TYPE', N'version', default, default, default, default)

SELECT
    @VersionMinor = CAST(value AS int)
FROM
    ::fn_listextendedproperty(N'DatabaseVersionMinor', N'TYPE', N'version', default, default, default, default)


GO
GRANT EXECUTE ON  [dbo].[usp_GetDatabaseVersion] TO [Data Readers]
GO

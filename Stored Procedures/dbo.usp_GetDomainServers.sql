SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_GetDomainServers]
    @DomainName nvarchar(256),
    @SourceServerName nvarchar(256) OUTPUT,
    @TargetServerName nvarchar(256) OUTPUT
AS

SELECT
    @SourceServerName = SourceServerName,
    @TargetServerName = TargetServerName
FROM
    Servers
WHERE
    DomainName = @DomainName


GO
GRANT EXECUTE ON  [dbo].[usp_GetDomainServers] TO [Data Readers]
GO

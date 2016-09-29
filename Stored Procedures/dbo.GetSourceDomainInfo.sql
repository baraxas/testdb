SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[GetSourceDomainInfo]
    @Name nvarchar(256)
AS

SELECT
    Guid,
    Sid,
    DnsName,
    FlatName
FROM
    Domains
WHERE
    DnsName = @Name OR FlatName = @Name


GO
GRANT EXECUTE ON  [dbo].[GetSourceDomainInfo] TO [Data Readers]
GO

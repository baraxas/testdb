SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[GetUserProps]
    @Domain nvarchar(256),
    @Sam nvarchar(256)
AS

SELECT
    CASE WHEN D.DnsName IS NOT NULL THEN D.DnsName ELSE D.FlatName END AS SourceDomain,
    O.SamName AS SourceSam,
    O.Flags AS Flags,
    O.Expires AS Expires
FROM
    Objects AS O
    JOIN
    Domains AS D ON O.DomainId = D.DomainId
WHERE
    ( D.DnsName = @Domain OR D.FlatName = @Domain )
    AND
    O.SamName = @Sam


GO
GRANT EXECUTE ON  [dbo].[GetUserProps] TO [Data Readers]
GO

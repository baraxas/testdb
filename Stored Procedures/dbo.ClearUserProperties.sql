SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[ClearUserProperties]
    @SourceDomain nvarchar(256),
    @SourceSam nvarchar(256)
AS

UPDATE
    Objects
SET
    Flags = NULL,
    Expires = NULL
FROM
    Objects AS O
    JOIN
    Domains AS D ON D.DomainId = O.DomainId
WHERE
    (D.DnsName = @SourceDomain OR D.FlatName = @SourceDomain)
    AND
    O.SamName = @SourceSam

RETURN @@ERROR


GO
GRANT EXECUTE ON  [dbo].[ClearUserProperties] TO [Account Migrators]
GO

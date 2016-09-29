SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[GetAMigratedObjectToAnyDomain]
    @SourceDomainName nvarchar(256),
    @SourceObjectSamName nvarchar(256)
AS

SELECT TOP 1
    *
FROM
    MigratedObjectsView
WHERE
    (SourceDomainDns = @SourceDomainName OR SourceDomainFlat = @SourceDomainName)
    AND
    SourceSamName = @SourceObjectSamName
ORDER BY
    Time DESC


GO
GRANT EXECUTE ON  [dbo].[GetAMigratedObjectToAnyDomain] TO [Data Readers]
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[GetAMigratedObject]
    @SourceDomainName nvarchar(256),
    @SourceObjectSamName nvarchar(256),
    @TargetDomainName nvarchar(256)
AS

SELECT TOP 1
    *
FROM
    MigratedObjectsView
WHERE
    (SourceDomainDns = @SourceDomainName OR SourceDomainFlat = @SourceDomainName)
    AND
    SourceSamName = @SourceObjectSamName
    AND
    (TargetDomainDns = @TargetDomainName OR TargetDomainFlat = @TargetDomainName)
ORDER BY
    Time DESC



GO
GRANT EXECUTE ON  [dbo].[GetAMigratedObject] TO [Data Readers]
GO

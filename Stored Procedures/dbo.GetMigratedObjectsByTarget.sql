SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[GetMigratedObjectsByTarget]
    @TargetDomain nvarchar(256),
    @TargetSam nvarchar(256)
AS

SELECT
    *
FROM
    MigratedObjectsView
WHERE
    ( TargetDomainDns = @TargetDomain OR TargetDomainFlat = @TargetDomain )
    AND
    TargetSamName = @TargetSam


GO
GRANT EXECUTE ON  [dbo].[GetMigratedObjectsByTarget] TO [Data Readers]
GO

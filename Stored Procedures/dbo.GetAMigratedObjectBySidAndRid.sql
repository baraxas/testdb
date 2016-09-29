SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[GetAMigratedObjectBySidAndRid]
    @SourceDomainSid nvarchar(128),
    @SourceRid int
AS

SELECT TOP 1
    *
FROM
    MigratedObjectsView
WHERE
    SourceDomainSid = @SourceDomainSid
    AND
    SourceRid = @SourceRid
ORDER BY
    Time DESC


GO
GRANT EXECUTE ON  [dbo].[GetAMigratedObjectBySidAndRid] TO [Data Readers]
GO

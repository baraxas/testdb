SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[GetMigratedObjectByType]
    @TaskId int,
    @SourceDomain nvarchar(256),
    @Type nvarchar(64)
AS

SELECT
    *
FROM
    MigratedObjectsView
WHERE
    (
        (
            @TaskId IS NOT NULL AND TaskId = @TaskId
        )
        OR
        (
            @TaskId IS NULL
            AND
            (
                @SourceDomain IS NULL OR ( SourceDomainDns = @SourceDomain OR SourceDomainFlat = @SourceDomain )
            )
        )
    )
    AND
    (
        ( @Type = N'group' AND Type LIKE N'%group' ) OR Type = @Type
    )
ORDER BY
    Time


GO
GRANT EXECUTE ON  [dbo].[GetMigratedObjectByType] TO [Data Readers]
GO

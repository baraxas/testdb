SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[DeleteMigratedObjects]
    @SourceDomain nvarchar(256),
    @SourceSam nvarchar(256),
    @TargetDomain nvarchar(256),
    @TargetSam nvarchar(256)
AS

DECLARE
    @SourceObjectId uniqueidentifier,
    @TargetObjectId uniqueidentifier

SELECT
    @SourceObjectId = M.SourceObjectId,
    @TargetObjectId = M.TargetObjectId
FROM
    MigratedObjects AS M
    JOIN
    Objects AS S ON M.SourceObjectId = S.ObjectId
    JOIN
    Domains AS SD ON S.DomainId = SD.DomainId
    JOIN
    Objects AS T ON M.TargetObjectId = T.ObjectId
    JOIN
    Domains AS TD ON T.DomainId = TD.DomainId
WHERE
    ( SD.DnsName = @SourceDomain OR SD.FlatName = @SourceDomain )
    AND
    ( S.SamName = @SourceSam )
    AND
    ( TD.DnsName = @TargetDomain OR TD.FlatName = @TargetDomain )
    AND
    ( T.SamName = @TargetSam )

IF @SourceObjectId IS NOT NULL AND @TargetObjectId IS NOT NULL
BEGIN
    DELETE
        MigratedObjects
    WHERE
        SourceObjectId = @SourceObjectId
        AND
        TargetObjectId = @TargetObjectId

    DELETE
        Objects
    WHERE
        ObjectId = @SourceObjectId
        OR
        ObjectId = @TargetObjectId
END


GO
GRANT EXECUTE ON  [dbo].[DeleteMigratedObjects] TO [Account Migrators]
GO

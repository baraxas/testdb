SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[AreThereAnyMigratedObjectsForSecurityTranslation]
    @SourceDomain nvarchar(256),
    @TargetDomain nvarchar(256),
    @Count int OUTPUT
AS

SELECT
    @Count = COUNT(*)
FROM
    MigratedObjects AS M
    JOIN
    Objects AS S ON M.SourceObjectId = S.ObjectId
    JOIN
    Objects AS T ON M.TargetObjectId = T.ObjectId
    JOIN
    Domains AS SD ON S.DomainId = SD.DomainId
    JOIN
    Domains AS TD ON T.DomainId = TD.DomainId
WHERE
    ( SD.DnsName = @SourceDomain OR SD.FlatName = @SourceDomain )
    AND
    ( TD.DnsName = @TargetDomain OR TD.FlatName = @TargetDomain )
    AND
    ( S.Type = N'user' OR S.Type LIKE N'%group' )


GO
GRANT EXECUTE ON  [dbo].[AreThereAnyMigratedObjectsForSecurityTranslation] TO [Data Readers]
GO

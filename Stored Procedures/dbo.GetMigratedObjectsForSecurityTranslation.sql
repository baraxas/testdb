SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[GetMigratedObjectsForSecurityTranslation]
    @SourceDomain nvarchar(256),
    @TargetDomain nvarchar(256)
AS

SELECT
    S.ADsPath AS SourceAdsPath,
    T.ADsPath AS TargetAdsPath,
    S.SamName AS SourceSamName,
    T.SamName AS TargetSamName,
    S.Type AS Type,
    CASE WHEN S.Rid IS NOT NULL THEN S.Rid ELSE 0 END AS SourceRid,
    CASE WHEN T.Rid IS NOT NULL THEN T.Rid ELSE 0 END AS TargetRid
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
GRANT EXECUTE ON  [dbo].[GetMigratedObjectsForSecurityTranslation] TO [Data Readers]
GO

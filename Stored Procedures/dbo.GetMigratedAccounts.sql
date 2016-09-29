SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[GetMigratedAccounts]
AS

SELECT
    CASE WHEN SD.DnsName IS NOT NULL THEN SD.DnsName ELSE SD.FlatName END AS SourceDomain,
    CASE WHEN TD.DnsName IS NOT NULL THEN TD.DnsName ELSE TD.FlatName END AS TargetDomain,
    S.Type AS Type,
    S.ADsPath AS SourceAdsPath,
    T.ADsPath AS TargetAdsPath
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
    S.Type <> N'computer'
ORDER BY
    M.MigrationTime


GO
GRANT EXECUTE ON  [dbo].[GetMigratedAccounts] TO [Data Readers]
GO

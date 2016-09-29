SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[GetNameConflicts]
AS

SELECT
    C.Account,
    C.SourceRDN,
    C.SourceType,
    C.TargetType,
    C.Conflict,
    C.TargetCanonical
FROM
(
    SELECT
        S.Sam AS Account,
        S.Rdn AS SourceRDN,
        S.Type AS SourceType,
        T.Type AS TargetType,
        CASE
            WHEN S.Sam = T.Sam AND S.Rdn = T.Rdn THEN N'SAM,RDN'
            WHEN S.Sam = T.Sam THEN N'SAM'
            WHEN S.Rdn = T.Rdn THEN N'RDN'
            ELSE N''
        END AS Conflict,
        T.Canonical AS TargetCanonical
    FROM
        NameConflicts AS C
        JOIN
        NameConflictsDomains AS SD ON C.SourceDomainId = SD.DomainId
        JOIN
        NameConflictsDomains AS TD ON C.TargetDomainId = TD.DomainId
        JOIN
        NameConflictsNames AS S ON SD.DomainId = S.DomainId
        JOIN
        NameConflictsNames AS T ON TD.DomainId = T.DomainId
    WHERE
        S.Sam = T.Sam
    UNION
    SELECT
        S.Sam AS Account,
        S.Rdn AS SourceRDN,
        S.Type AS SourceType,
        T.Type AS TargetType,
        CASE
            WHEN S.Sam = T.Sam AND S.Rdn = T.Rdn THEN N'SAM,RDN'
            WHEN S.Sam = T.Sam THEN N'SAM'
            WHEN S.Rdn = T.Rdn THEN N'RDN'
            ELSE N''
        END AS Conflict,
        T.Canonical AS TargetCanonical
    FROM
        NameConflicts AS C
        JOIN
        NameConflictsDomains AS SD ON C.SourceDomainId = SD.DomainId
        JOIN
        NameConflictsDomains AS TD ON C.TargetDomainId = TD.DomainId
        JOIN
        NameConflictsNames AS S ON SD.DomainId = S.DomainId
        JOIN
        NameConflictsNames AS T ON TD.DomainId = T.DomainId
    WHERE
        S.Rdn = T.Rdn
) AS C
ORDER BY
    C.Account


GO
GRANT EXECUTE ON  [dbo].[GetNameConflicts] TO [Data Readers]
GO

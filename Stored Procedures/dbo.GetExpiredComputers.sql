SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[GetExpiredComputers]
    @MaxPasswordAge int
AS

SELECT
    C.UpdateTime AS Time,
    D.Name AS DomainName,
    C.Name AS CompName,
    C.Description AS Description,
    CAST((@MaxPasswordAge / 86400) AS nvarchar) + N' days' AS [Password Age]
FROM
    PasswordAgeComputers AS C
    JOIN
    PasswordAgeDomains AS D ON C.DomainId = D.DomainId
WHERE
    C.PasswordAge > @MaxPasswordAge
ORDER BY
    DomainName, CompName


GO
GRANT EXECUTE ON  [dbo].[GetExpiredComputers] TO [Data Readers]
GO

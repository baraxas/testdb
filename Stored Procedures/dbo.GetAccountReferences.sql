SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[GetAccountReferences]
AS

SELECT
    D.Name AS Domain,
    A.Name AS Account,
    A.Sid AS AccountSid,
    C.Name AS Server,
    R.RefCount AS RefCount,
    T.Type AS RefType
FROM
    [References] AS R
    JOIN
    RefAccounts AS A ON R.AccountId = A.AccountId
    JOIN
    RefComputers AS C ON R.ComputerId = C.ComputerId
    JOIN
    RefTypes AS T ON R.TypeId = T.TypeId
    JOIN
    RefDomains AS D ON A.DomainId = D.DomainId
WHERE
    R.RefCount > 0
ORDER BY
    Domain, Account, Server


GO
GRANT EXECUTE ON  [dbo].[GetAccountReferences] TO [Data Readers]
GO

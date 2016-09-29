SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[GetServiceAccount]
    @Account nvarchar(256)
AS

SELECT
    C.Name AS System,
    S.Name AS Service,
    S.DisplayName AS ServiceDisplayName,
    S.Account AS Account,
    S.Status AS Status
FROM
    Services AS S
    JOIN
    Computers AS C ON S.ComputerId = C.ComputerId
WHERE
    @Account IS NULL OR S.Account = @Account
ORDER BY
    C.Name, S.Name


GO
GRANT EXECUTE ON  [dbo].[GetServiceAccount] TO [Data Readers]
GO

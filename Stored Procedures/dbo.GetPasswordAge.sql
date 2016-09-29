SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[GetPasswordAge]
    @Domain nvarchar(256),
    @Computer nvarchar(256)
AS

SELECT
    C.Description AS Description,
    C.PasswordAge AS PwdAge,
    C.UpdateTime AS Time
FROM
    PasswordAgeComputers AS C
    JOIN
    PasswordAgeDomains AS D ON C.DomainId = D.DomainId
WHERE
    D.Name = @Domain
    AND
    C.Name = @Computer


GO
GRANT EXECUTE ON  [dbo].[GetPasswordAge] TO [Data Readers]
GO

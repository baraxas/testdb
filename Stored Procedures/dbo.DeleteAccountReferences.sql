SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[DeleteAccountReferences]
    @Computer nvarchar(256)
AS

DELETE
    [References]
FROM
    [References] AS R
    JOIN
    RefComputers AS C ON R.ComputerId = C.ComputerId
WHERE
    C.Name = @Computer

RETURN @@ERROR


GO
GRANT EXECUTE ON  [dbo].[DeleteAccountReferences] TO [Resource Migrators]
GO

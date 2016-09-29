SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SetServiceAcctEntryStatus]
    @Computer nvarchar(256),
    @Service nvarchar(256),
    @Account nvarchar(256),
    @Status int
AS

UPDATE
    Services
SET
    Account =
    CASE
        WHEN @Account IS NOT NULL THEN
            @Account
        ELSE
            Account
    END,
    Status = @Status
WHERE
    ComputerId = ( SELECT ComputerId FROM Computers WHERE Name = @Computer )
    AND
    Name = @Service

RETURN @@ERROR


GO
GRANT EXECUTE ON  [dbo].[SetServiceAcctEntryStatus] TO [Account Migrators]
GO

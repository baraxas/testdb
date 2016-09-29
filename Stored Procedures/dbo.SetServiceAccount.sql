SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SetServiceAccount]
    @Computer nvarchar(256),
    @Service nvarchar(256),
    @DisplayName nvarchar(256),
    @Account nvarchar(256)
AS

DECLARE
    @Error int,
    @RowCount int,
    @ComputerId int

SET @Error = 0

-- Computer

EXEC @Error = SetComputer @Computer, @ComputerId OUTPUT

-- Service

IF @Error = 0
BEGIN
    UPDATE
        Services
    SET
        DisplayName = @DisplayName,
        Account = @Account,
        Status = 0
    WHERE
        ComputerId = @ComputerId
        AND
        Name = @Service

    SELECT @Error = @@ERROR, @RowCount = @@ROWCOUNT

    IF @Error = 0 AND @RowCount = 0
    BEGIN
        INSERT Services
        (
            ComputerId, Name, DisplayName, Account, Status
        )
        VALUES
        (
            @ComputerId, @Service, @DisplayName, @Account, 0
        )

        SET @Error = @@ERROR
    END
END

RETURN @Error


GO
GRANT EXECUTE ON  [dbo].[SetServiceAccount] TO [Account Migrators]
GO

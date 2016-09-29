SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[AddAcctRef]
    @Domain nvarchar(256),
    @Account nvarchar(256),
    @Sid nvarchar(128),
    @Computer nvarchar(256),
    @Type nvarchar(64),
    @Count int
AS

DECLARE
    @Error int,
    @RowCount int,
    @DomainId int,
    @AccountId int,
    @ComputerId int,
    @TypeId int

SET @Error = 0

-- Domain

SELECT @DomainId = DomainId FROM RefDomains WHERE Name = @Domain

IF @DomainId IS NULL
BEGIN
    INSERT RefDomains ( Name ) VALUES ( @Domain )

    SET @Error = @@ERROR

    IF @Error = 0
        SELECT @DomainId = CAST(SCOPE_IDENTITY() AS int)
END

-- Account

IF @Error = 0
BEGIN
    SELECT @AccountId = AccountId FROM RefAccounts WHERE Name = @Account

    IF @AccountId IS NULL
    BEGIN
        INSERT RefAccounts ( DomainId, Name, Sid ) VALUES ( @DomainId, @Account, @Sid )

        SET @Error = @@ERROR

        IF @Error = 0
            SELECT @AccountId = CAST(SCOPE_IDENTITY() AS int)
    END
END

-- Computer

IF @Error = 0
BEGIN
    SELECT @ComputerId = ComputerId FROM RefComputers WHERE Name = @Computer

    IF @ComputerId IS NULL
    BEGIN
        INSERT RefComputers ( Name ) VALUES ( @Computer )

        SET @Error = @@ERROR

        IF @Error = 0
            SELECT @ComputerId = CAST(SCOPE_IDENTITY() AS int)
    END
END

-- Type

IF @Error = 0
BEGIN
    SELECT @TypeId = TypeId FROM RefTypes WHERE Type = @Type

    IF @TypeId IS NULL
    BEGIN
        INSERT RefTypes ( Type ) VALUES ( @Type )

        SET @Error = @@ERROR

        IF @Error = 0
            SELECT @TypeId = CAST(SCOPE_IDENTITY() AS int)
    END
END

-- Reference

IF @Error = 0
BEGIN
    UPDATE
        [References]
    SET
        RefCount = @Count
    WHERE
        AccountId = @AccountId
        AND
        ComputerId = @ComputerId
        AND
        TypeId = @TypeId

    SELECT @Error = @@ERROR, @RowCount = @@ROWCOUNT

    IF @Error = 0 AND @RowCount = 0
    BEGIN
        INSERT [References]
        (
            AccountId, ComputerId, TypeId, RefCount
        )
        VALUES
        (
            @AccountId, @ComputerId, @TypeId, @Count
        )
        
        SET @Error = @@ERROR
    END
END

RETURN @Error


GO
GRANT EXECUTE ON  [dbo].[AddAcctRef] TO [Resource Migrators]
GO

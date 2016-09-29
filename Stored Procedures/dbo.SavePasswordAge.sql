SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SavePasswordAge]
    @Domain nvarchar(256),
    @Computer nvarchar(256),
    @Description nvarchar(256),
    @Age int,
    @UpdateTime datetime = NULL
AS

DECLARE
    @Error int,
    @RowCount int,
    @DomainId int

SET @Error = 0

-- Domain

SELECT
    @DomainId = DomainId
FROM
    PasswordAgeDomains
WHERE
    Name = @Domain

IF @DomainId IS NULL
BEGIN
    INSERT PasswordAgeDomains
    (
        Name
    )
    VALUES
    (
        @Domain
    )

    SET @Error = @@ERROR
    
    IF @Error = 0
        SET @DomainId = CAST(SCOPE_IDENTITY() AS int)
END

-- Computer

IF @Error = 0
BEGIN
    UPDATE
        PasswordAgeComputers
    SET
        Description = @Description,
        PasswordAge = @Age,
        UpdateTime = CASE WHEN @UpdateTime IS NOT NULL THEN @UpdateTime ELSE GETUTCDATE() END
    WHERE
        DomainId = @DomainId
        AND
        Name = @Computer

    SELECT @Error = @@ERROR, @RowCount = @@ROWCOUNT

    IF @Error = 0 AND @RowCount = 0
    BEGIN
        INSERT PasswordAgeComputers
        (
            Name, DomainId, Description, PasswordAge, UpdateTime
        )
        VALUES
        (
            @Computer,
            @DomainId,
            @Description,
            @Age,
            CASE WHEN @UpdateTime IS NOT NULL THEN @UpdateTime ELSE GETUTCDATE() END
        )

        SET @Error = @@ERROR
    END
END

RETURN @Error


GO
GRANT EXECUTE ON  [dbo].[SavePasswordAge] TO [Resource Migrators]
GO

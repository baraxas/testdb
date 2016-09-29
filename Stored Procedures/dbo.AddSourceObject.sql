SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[AddSourceObject]
    @Source bit,
    @Domain nvarchar(256),
    @Sam nvarchar(256),
    @Rdn nvarchar(64) = NULL,
    @Canonical nvarchar(256) = NULL,
    @Type nvarchar(64)
AS

DECLARE
    @Error int,
    @DomainId int

SET @Error = 0

-- Domain

SELECT @DomainId = DomainId FROM NameConflictsDomains WHERE Name = @Domain

IF @DomainId IS NULL
BEGIN
    INSERT NameConflictsDomains ( Name ) VALUES ( @Domain )

    SET @Error = @@ERROR

    IF @Error = 0
        SELECT @DomainId = CAST(SCOPE_IDENTITY() AS int)
END

-- Object

IF @Error = 0
BEGIN

    INSERT NameConflictsNames
    (
        DomainId, Sam, Rdn, Canonical, Type
    )
    VALUES
    (
        @DomainId, @Sam, @Rdn, @Canonical, @Type
    )

    SET @Error = @@ERROR
END

-- Name Conflicts

IF @Error = 0
BEGIN
    IF (SELECT COUNT(*) FROM NameConflicts) = 0
    BEGIN
        INSERT NameConflicts ( SourceDomainId, TargetDomainId ) VALUES ( 0, 0 )

        SET @Error = @@ERROR
    END

    IF @Error = 0
        IF @Source <> 0
        BEGIN
            UPDATE
                NameConflicts
            SET
                SourceDomainId = @DomainId

            SET @Error = @@ERROR
        END
        ELSE
        BEGIN
            UPDATE
                NameConflicts
            SET
                TargetDomainId = @DomainId

            SET @Error = @@ERROR
        END
END

RETURN @Error


GO
GRANT EXECUTE ON  [dbo].[AddSourceObject] TO [Resource Migrators]
GO

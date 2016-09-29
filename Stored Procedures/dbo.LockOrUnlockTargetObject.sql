SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[LockOrUnlockTargetObject]
    @Lock bit,
    @DomainId uniqueidentifier,
    @SamName nvarchar(256),
    @DistinguishedName nvarchar(2048)
AS

DECLARE
    @Status int,
    @LockedOrUnlocked int

SET @Status = 0
SET @LockedOrUnlocked = 1

-- A transaction with an exclusive table lock is used to prevent concurrent reading/updating of
-- rows. The exclusive table lock is specified on the delete, insert and select statements.

BEGIN TRAN

-- A non-zero value specifies lock and a zero value specifies unlock.

IF @Lock <> 0
BEGIN
    -- The lock time is set equal to the current time plus 15 minutes.

    DECLARE
        @Time datetime,
        @LockTime datetime

    SET @Time = GETUTCDATE()
    SET @LockTime = DATEADD(minute, 15, @Time)

    -- Delete rows whose locktime has expired.

    DELETE FROM
        LockedObjects WITH (TABLOCKX)
    WHERE
        LockTime < @Time

    IF @@ERROR <> 0
        SET @Status = 1

    -- If there are no existing rows with the same distinguished name or domain\name pair then
    -- insert row.

    IF @Status = 0
    BEGIN
        IF NOT EXISTS
        (
            SELECT
                *
            FROM
                LockedObjects WITH (TABLOCKX)
            WHERE
                DistinguishedName = @DistinguishedName OR (DomainId = @DomainId AND SamName = @SamName)
        )
        BEGIN
            INSERT LockedObjects WITH (TABLOCKX)
            (
                LockTime, DomainId, SamName, DistinguishedName
            )
            VALUES
            (
                @LockTime, @DomainId, @SamName, @DistinguishedName
            )

            IF @@ERROR <> 0
                SET @Status = 1

            IF @Status = 0
                SET @LockedOrUnlocked = 0
        END
    END
END
ELSE
BEGIN
    -- Delete row having specified distinguished name and domain\name pair.

    DELETE FROM
        LockedObjects WITH (TABLOCKX)
    WHERE
        DistinguishedName = @DistinguishedName AND (DomainId = @DomainId AND SamName = @SamName)

    IF @@ERROR <> 0
        SET @Status = 1

    IF @Status = 0
        SET @LockedOrUnlocked = 0
END

IF @Status = 0
    COMMIT TRAN
ELSE
    ROLLBACK TRAN

RETURN @LockedOrUnlocked


GO
GRANT EXECUTE ON  [dbo].[LockOrUnlockTargetObject] TO [Resource Migrators]
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SaveMigratedObject]
    @TaskId               int,
    @SourceDomainGuid     nchar(32),
    @SourceDomainSid      nvarchar(128),
    @SourceDomainDnsName  nvarchar(256),
    @SourceDomainFlatName nvarchar(32),
    @SourceGuid           nchar(32),
    @SourceRid            int,
    @SourceADsPath        nvarchar(2048),
    @SourceSam            nvarchar(256),
    @SourceType           nvarchar(64),
    @SourceFlags          int = NULL,
    @SourceExpires        int = NULL,
    @TargetDomainGuid     nchar(32),
    @TargetDomainSid      nvarchar(128),
    @TargetDomainDnsName  nvarchar(256),
    @TargetDomainFlatName nvarchar(32),
    @TargetGuid           nchar(32),
    @TargetRid            int,
    @TargetADsPath        nvarchar(2048),
    @TargetSam            nvarchar(256),
    @TargetType           nvarchar(64),
    @TargetInvocationId   uniqueidentifier,
    @TargetUSN            bigint,
    @Status               int,
    @PasswordCopyTime     datetime = NULL
AS

SET NOCOUNT ON

DECLARE
    @Error          int,
    @RowCount       int,
    @SourceDomainId uniqueidentifier,
    @SourceObjectId uniqueidentifier,
    @TargetDomainId uniqueidentifier,
    @TargetObjectId uniqueidentifier,
    @GlobalTaskId   uniqueidentifier

SET @Error = 0

-- Source Domain

EXEC @Error = [dbo].[SetDomain]
    @SourceDomainSid,
    @SourceDomainDnsName,
    @SourceDomainFlatName,
    @SourceDomainId OUTPUT

-- Source Object

IF @Error = 0
    EXEC @Error = [dbo].[SetObject]
        @SourceDomainId,
        @SourceGuid,
        @SourceRid,
        @SourceADsPath,
        @SourceSam,
        @SourceType,
        @SourceFlags,
        @SourceExpires,
        default,
        default,
        @SourceObjectId OUTPUT

-- Target Domain

IF @Error = 0
    EXEC @Error = [dbo].[SetDomain]
        @TargetDomainSid,
        @TargetDomainDnsName,
        @TargetDomainFlatName,
        @TargetDomainId OUTPUT

-- Target Object

IF @Error = 0
    EXEC @Error = [dbo].[SetObject]
        @TargetDomainId,
        @TargetGuid,
        @TargetRid,
        @TargetADsPath,
        @TargetSam,
        @TargetType,
        default,
        default,
        @TargetInvocationId,
        @TargetUSN,
        @TargetObjectId OUTPUT

-- Global Task Identifier

IF @Error = 0
    SELECT
        @GlobalTaskId = GlobalTaskId
    FROM
        LocalTasks
    WHERE
        TaskId = @TaskId

-- Migrated Object

IF @Error = 0
BEGIN
    UPDATE
        MigratedObjects
    SET
        GlobalTaskId = @GlobalTaskId,
        Status = @Status,
        MigrationTime = GETUTCDATE(),
        PasswordCopyTime = @PasswordCopyTime
    WHERE
        SourceObjectId = @SourceObjectId
        AND
        TargetObjectId = @TargetObjectId

    SELECT @Error = @@ERROR, @RowCount = @@ROWCOUNT
    
    IF @Error = 0 AND @RowCount = 0
    BEGIN
        INSERT MigratedObjects
        (
            SourceObjectId, TargetObjectId, GlobalTaskId, Status, MigrationTime, PasswordCopyTime
        )
        VALUES
        (
            @SourceObjectId, @TargetObjectId, @GlobalTaskId, @Status, GETUTCDATE(), @PasswordCopyTime
        )

        SET @Error = @@ERROR
    END
END

RETURN @Error


GO
GRANT EXECUTE ON  [dbo].[SaveMigratedObject] TO [Account Migrators]
GO

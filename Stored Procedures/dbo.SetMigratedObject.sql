SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SetMigratedObject]
    @SourceObjectId uniqueidentifier,
    @TargetObjectId uniqueidentifier,
    @TaskId int,
    @Status int,
    @MigrationTime datetime = NULL,
    @PasswordCopyTime datetime = NULL
AS

DECLARE
    @Error int,
    @RowCount int,
    @GlobalTaskId uniqueidentifier

-- get global task identifier from local task identifier

SELECT
    @GlobalTaskId = GlobalTaskId
FROM
    LocalTasks
WHERE
    TaskId = @TaskId

-- update migrated object

UPDATE
    MigratedObjects
SET
    GlobalTaskId = @GlobalTaskId,
    Status = @Status,
    MigrationTime = CASE WHEN @MigrationTime IS NOT NULL THEN @MigrationTime ELSE GETUTCDATE() END,
    PasswordCopyTime = CASE WHEN @PasswordCopyTime IS NOT NULL THEN @PasswordCopyTime ELSE PasswordCopyTime END
WHERE
    SourceObjectId = @SourceObjectId
    AND
    TargetObjectId = @TargetObjectId

SELECT @Error = @@ERROR, @RowCount = @@ROWCOUNT

-- insert migrated object

IF @Error = 0 AND @RowCount = 0
BEGIN
    INSERT MigratedObjects
    (
        SourceObjectId,
        TargetObjectId,
        GlobalTaskId,
        Status,
        MigrationTime,
        PasswordCopyTime
    )
    VALUES
    (
        @SourceObjectId,
        @TargetObjectId,
        @GlobalTaskId,
        @Status,
        CASE WHEN @MigrationTime IS NOT NULL THEN @MigrationTime ELSE GETUTCDATE() END,
        @PasswordCopyTime
    )

    SET @Error = @@ERROR
END

RETURN @Error


GO
GRANT EXECUTE ON  [dbo].[SetMigratedObject] TO [Account Migrators]
GO

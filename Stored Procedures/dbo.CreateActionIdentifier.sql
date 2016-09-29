SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[CreateActionIdentifier]
    @AdmtId uniqueidentifier,
    @TaskId int OUTPUT
AS

DECLARE
    @Error int,
    @GlobalTaskId uniqueidentifier

SET @GlobalTaskId = NEWID()

INSERT GlobalTasks ( GlobalTaskId ) VALUES ( @GlobalTaskId )

SET @Error = @@ERROR

IF @Error = 0
BEGIN
    INSERT LocalTasks ( GlobalTaskId, AdmtId ) VALUES ( @GlobalTaskId, @AdmtId )

    SET @Error = @@ERROR

    IF @Error = 0
        SET @TaskId = CAST(SCOPE_IDENTITY() AS int)
END

RETURN @Error


GO
GRANT EXECUTE ON  [dbo].[CreateActionIdentifier] TO [Resource Migrators]
GO

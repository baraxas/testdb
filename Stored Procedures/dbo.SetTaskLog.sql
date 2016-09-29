SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SetTaskLog]
    @TaskId int,
    @LogStatus int,
    @LogFile image = NULL,
    @Status int OUTPUT
AS

-- Retrieve maximum distributed task log status from the distributed tasks table. The status will
-- be null if there are no distributed tasks associated with the current task or none of the agents
-- were dispatched successfully.

SELECT
    @Status = MAX(LogStatus)
FROM
    DistributedTasks
WHERE
    TaskId = @TaskId AND RetryTaskId IS NULL AND LogStatus IS NOT NULL

-- If status is null or the migration log status is greater than the maximum distributed task log
-- status then set the status equal to the migration log status.

IF @Status IS NULL OR @LogStatus > @Status
    SET @Status = @LogStatus

-- Update the status, migration log status and migration log in the local tasks table.

UPDATE
    LocalTasks
SET
    Status = @Status,
    LogStatus = @LogStatus,
    LogFile = @LogFile
WHERE
    TaskId = @TaskId


GO
GRANT EXECUTE ON  [dbo].[SetTaskLog] TO [Resource Migrators]
GO

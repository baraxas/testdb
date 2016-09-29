SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SetDistributedActionStatus]
    @TaskId int,
    @Computer nvarchar(256),
    @Status int,
    @StatusText nvarchar(1024),
    @RetryTaskId int = NULL,
    @LogStatus int = NULL,
    @LogFile image = NULL
AS

UPDATE
    DistributedTasks
SET
    Status = @Status,
    StatusText = @StatusText,
    RetryTaskId = @RetryTaskId,
    LogStatus = @LogStatus,
    LogFile = @LogFile
WHERE
    TaskId = @TaskId
    AND
    ComputerId = ( SELECT ComputerId FROM Computers WHERE Name = @Computer )


GO
GRANT EXECUTE ON  [dbo].[SetDistributedActionStatus] TO [Resource Migrators]
GO

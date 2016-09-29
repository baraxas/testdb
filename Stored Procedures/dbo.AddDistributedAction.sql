SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[AddDistributedAction]
    @TaskId int,
    @Computer nvarchar(256),
    @Status int,
    @StatusText nvarchar(1024),
    @Job image = NULL,
    @LogStatus int = NULL,
    @LogFile image = NULL
AS

DECLARE
    @Error int,
    @ComputerId int

SET @Error = 0

-- Computer

SELECT @ComputerId = ComputerId FROM Computers WHERE @Computer = Name

IF @ComputerId IS NULL
BEGIN
    INSERT Computers ( Name ) VALUES ( @Computer )
    
    SET @Error = @@ERROR
    
    IF @Error = 0
        SET @ComputerId = CAST(SCOPE_IDENTITY() AS int)
END

-- Distributed Tasks

IF @ComputerId IS NOT NULL
BEGIN
    INSERT INTO DistributedTasks
    (
        TaskId, ComputerId, Status, StatusText, Job, LogStatus, LogFile
    ) 
    VALUES
    (
        @TaskId, @ComputerId, @Status, @StatusText, @Job, @LogStatus, @LogFile
    )
END

RETURN @Error


GO
GRANT EXECUTE ON  [dbo].[AddDistributedAction] TO [Resource Migrators]
GO

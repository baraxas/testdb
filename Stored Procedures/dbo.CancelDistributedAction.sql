SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[CancelDistributedAction]
    @TaskId int,
    @Computer nvarchar(256)
AS

DELETE FROM
    DistributedTasks
WHERE
    TaskId = @TaskId
    AND
    ComputerId = ( SELECT ComputerId FROM Computers WHERE Name = @Computer )
    
RETURN @@ERROR


GO
GRANT EXECUTE ON  [dbo].[CancelDistributedAction] TO [Resource Migrators]
GO

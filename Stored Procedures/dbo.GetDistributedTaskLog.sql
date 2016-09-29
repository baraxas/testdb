SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[GetDistributedTaskLog]
    @TaskId int,
    @Computer nvarchar(256)
AS

SELECT
    D.LogFile
FROM
    DistributedTasks AS D
    JOIN
    Computers AS C ON D.ComputerId = C.ComputerId
WHERE
    (
        (RetryTaskId IS NULL AND D.TaskId = @TaskId)
        OR
        (RetryTaskId IS NOT NULL AND RetryTaskId = @TaskId)
    )
    AND
    C.Name = @Computer


GO
GRANT EXECUTE ON  [dbo].[GetDistributedTaskLog] TO [Data Readers]
GO

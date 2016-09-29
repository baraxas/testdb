SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[GetDistributedTaskInfo]
    @TaskId int,
    @LogStatus int
AS

SELECT
    C.Name AS Computer,
    D.LogStatus AS LogStatus
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
    (
        D.LogStatus IS NOT NULL
        AND
        (
            (@LogStatus & 1 <> 0 AND D.LogStatus = 0)
            OR
            (@LogStatus & 2 <> 0 AND D.LogStatus = 1)
            OR
            (@LogStatus & 4 <> 0 AND D.LogStatus = 2)
        )
    )


GO
GRANT EXECUTE ON  [dbo].[GetDistributedTaskInfo] TO [Data Readers]
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[GetDistributedActionJob]
    @TaskId int,
    @ServerName nvarchar(256)
AS

SELECT
    D.Job
FROM
    DistributedTasks AS D
    JOIN
    Computers AS C ON D.ComputerId = C.ComputerId
WHERE
    D.TaskId = @TaskId
    AND
    C.Name = @ServerName


GO
GRANT EXECUTE ON  [dbo].[GetDistributedActionJob] TO [Resource Migrators]
GO

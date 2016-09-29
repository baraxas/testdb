SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[GetDistributedActionStatus]
    @TaskId int,
    @ServerName nvarchar(256),
    @Status int OUTPUT
AS

SELECT
    @Status = A.Status
FROM
    DistributedTasks AS A
    JOIN
    Computers AS C ON A.ComputerId = C.ComputerId
WHERE
    A.TaskId = @TaskId
    AND
    C.Name = @ServerName


GO
GRANT EXECUTE ON  [dbo].[GetDistributedActionStatus] TO [Data Readers]
GO

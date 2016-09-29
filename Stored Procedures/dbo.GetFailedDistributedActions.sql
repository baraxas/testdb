SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[GetFailedDistributedActions]
    @TaskId int
AS

-- The error bit in the status is 0x80000000 therefore querying for statuses
-- with a value less than zero will return records with a failure status.

SELECT
    D.TaskId AS TaskId,
    (
        SELECT
            P.PropertyValue
        FROM
            TaskProperties AS P
        WHERE
            P.TaskId = D.TaskId
            AND
            P.PropertyName = N'Options.Wizard'
    ) AS Wizard,
    C.Name AS Computer,
    D.Status AS Status,
    D.StatusText AS StatusText
FROM
    DistributedTasks AS D
    JOIN
    Computers AS C ON D.ComputerId = C.ComputerId
WHERE
    (@TaskId IS NULL OR D.TaskId = @TaskId)
    AND
    (D.Status < 0)


GO
GRANT EXECUTE ON  [dbo].[GetFailedDistributedActions] TO [Data Readers]
GO

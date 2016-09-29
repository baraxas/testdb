SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_DeleteOldAccountFiles]
AS

-- Once a task is completed the log status is set to a non-null value.
-- The error bit in the status is 0x80000000 therefore querying for statuses
-- with a value less than zero will return records with a failure status.

UPDATE
    LocalTasks
SET
    AccountFile = NULL
FROM
    LocalTasks AS L
WHERE
    ( L.LogStatus IS NOT NULL AND L.AccountFile IS NOT NULL )
    AND
    ( NOT EXISTS ( SELECT * FROM DistributedTasks WHERE TaskId = L.TaskId AND Status < 0 ))


GO
GRANT EXECUTE ON  [dbo].[usp_DeleteOldAccountFiles] TO [Resource Migrators]
GO

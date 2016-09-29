SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_GetAccountFile]
    @TaskId int
AS

SELECT
    AccountFile
FROM
    LocalTasks
WHERE
    TaskId = @TaskId
    AND
    AccountFile IS NOT NULL


GO
GRANT EXECUTE ON  [dbo].[usp_GetAccountFile] TO [Resource Migrators]
GO

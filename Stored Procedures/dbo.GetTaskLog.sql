SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[GetTaskLog]
    @TaskId int
AS

SELECT
    LogFile
FROM
    LocalTasks
WHERE
    TaskId = @TaskId


GO
GRANT EXECUTE ON  [dbo].[GetTaskLog] TO [Data Readers]
GO

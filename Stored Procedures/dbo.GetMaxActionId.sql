SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[GetMaxActionId]
    @AdmtId uniqueidentifier,
    @TaskId int OUTPUT
AS

SELECT
    @TaskId = MAX(TaskId)
FROM
    LocalTasks


GO
GRANT EXECUTE ON  [dbo].[GetMaxActionId] TO [Data Readers]
GO

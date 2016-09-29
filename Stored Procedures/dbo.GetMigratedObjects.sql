SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[GetMigratedObjects]
    @TaskId int
AS

SELECT
    *
FROM
    MigratedObjectsView
WHERE
    @TaskId IS NULL OR TaskId = @TaskId


GO
GRANT EXECUTE ON  [dbo].[GetMigratedObjects] TO [Data Readers]
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[GetActionHistory]
    @TaskId int
AS

SELECT
    PropertyName AS Name,
    PropertyValue AS Value
FROM
    TaskProperties
WHERE
    TaskId = @TaskId


GO
GRANT EXECUTE ON  [dbo].[GetActionHistory] TO [Data Readers]
GO

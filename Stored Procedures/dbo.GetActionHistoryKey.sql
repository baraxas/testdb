SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[GetActionHistoryKey]
    @TaskId int,
    @Key nvarchar(256),
    @Value sql_variant OUTPUT
AS

SELECT
    @Value = PropertyValue
FROM
    TaskProperties
WHERE
    TaskId = @TaskId
    AND
    PropertyName = @Key


GO
GRANT EXECUTE ON  [dbo].[GetActionHistoryKey] TO [Data Readers]
GO

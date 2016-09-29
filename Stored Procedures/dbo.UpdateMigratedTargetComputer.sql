SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[UpdateMigratedTargetComputer]
    @Guid nchar(32),
    @ADsPath nvarchar(2048),
    @SamName nvarchar(256)
AS

UPDATE
    Objects
SET
    ADsPath = @ADsPath,
    SamName = @SamName
WHERE
    Guid = @Guid
    AND
    Type = N'Computer'

RETURN @@ERROR


GO
GRANT EXECUTE ON  [dbo].[UpdateMigratedTargetComputer] TO [Resource Migrators]
GO

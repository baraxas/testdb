SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[UpdateMigratedTargetObject]
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

RETURN @@ERROR


GO
GRANT EXECUTE ON  [dbo].[UpdateMigratedTargetObject] TO [Account Migrators]
GO

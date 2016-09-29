SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[UpdateMigratedObjectStatus]
    @TargetObjectGuid nchar(32),
    @Status int
AS

UPDATE
    MigratedObjects
SET
    Status = @Status
FROM
    MigratedObjects AS M
    JOIN
    Objects AS O ON M.TargetObjectId = O.ObjectId
WHERE
    O.Guid = @TargetObjectGuid

RETURN @@ERROR


GO
GRANT EXECUTE ON  [dbo].[UpdateMigratedObjectStatus] TO [Account Migrators]
GO

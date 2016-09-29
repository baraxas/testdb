SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SetComputer]
    @Name nvarchar(256),
    @Id int OUTPUT
AS

DECLARE @Error int

SET @Error = 0

SELECT @Id = ComputerId FROM Computers WHERE Name = @Name

IF @Id IS NULL
BEGIN
    INSERT Computers ( Name ) VALUES ( @Name )

    SET @Error = @@ERROR

    IF @Error = 0
        SET @Id = CAST(SCOPE_IDENTITY() AS int)
END

RETURN @Error


GO

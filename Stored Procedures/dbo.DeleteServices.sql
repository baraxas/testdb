SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[DeleteServices]
    @Computer nvarchar(256)
AS

DELETE
    Services
FROM
    Services AS S
    JOIN
    Computers AS C ON S.ComputerId = C.ComputerId
WHERE
    C.Name = @Computer

RETURN @@ERROR


GO
GRANT EXECUTE ON  [dbo].[DeleteServices] TO [Account Migrators]
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[AreThereAnyMigratedObjects]
    @Count int OUTPUT
AS

SELECT @Count = COUNT(*) FROM MigratedObjects


GO
GRANT EXECUTE ON  [dbo].[AreThereAnyMigratedObjects] TO [Data Readers]
GO

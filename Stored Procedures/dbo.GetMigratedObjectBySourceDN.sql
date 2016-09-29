SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[GetMigratedObjectBySourceDN]
    @SourceDn nvarchar(2048)
AS

SELECT TOP 1
    *
FROM
    MigratedObjectsView
WHERE
    SourceAdsPath LIKE N'%' + @SourceDn
ORDER BY
    Time DESC


GO
GRANT EXECUTE ON  [dbo].[GetMigratedObjectBySourceDN] TO [Data Readers]
GO

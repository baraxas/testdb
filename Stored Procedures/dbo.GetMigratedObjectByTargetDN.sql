SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[GetMigratedObjectByTargetDN]
    @TargetDn nvarchar(2048)
AS

SELECT TOP 1
    *
FROM
    MigratedObjectsView
WHERE
    TargetAdsPath LIKE N'%' + @TargetDn
ORDER BY
    Time DESC


GO
GRANT EXECUTE ON  [dbo].[GetMigratedObjectByTargetDN] TO [Data Readers]
GO

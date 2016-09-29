SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[GetSettings]
AS

SELECT
    SettingName AS Name,
    SettingValue AS Value
FROM
    Settings
ORDER BY
    SettingName


GO
GRANT EXECUTE ON  [dbo].[GetSettings] TO [Data Readers]
GO

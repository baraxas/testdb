SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[GetSetting]
    @Name nvarchar(256),
    @Value sql_variant OUTPUT
AS

SELECT
    @Value = SettingValue
FROM
    Settings
WHERE
    SettingName = @Name


GO
GRANT EXECUTE ON  [dbo].[GetSetting] TO [Data Readers]
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SetSetting]
    @Name nvarchar(256),
    @Value sql_variant
AS

DECLARE
    @Error int,
    @RowCount int

UPDATE
    Settings
SET
    SettingValue = @Value
WHERE
    SettingName = @Name

SELECT @Error = @@ERROR, @RowCount = @@ROWCOUNT

IF @Error = 0 AND @RowCount = 0
BEGIN
    INSERT Settings
    (
        SettingName, SettingValue
    )
    VALUES
    (
        @Name, @Value
    )

    SET @Error = @@ERROR
END

RETURN @Error


GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[GetServerNamesFromActionHistory]
    @TaskId int,
    @ServerName nvarchar(256),
    @DnsName nvarchar(256) OUTPUT,
    @FlatName nvarchar(32) OUTPUT
AS

-- Servers.#, flat name
-- Servers.#.DnsName, DNS name

DECLARE
    @Name nvarchar(256),
    @Value sql_variant

-- Query for task property row where task identifier is equal to specified task identifier,
-- property name begins with 'Servers.' and property value equals specified server name.

SELECT
    @Name = PropertyName,
    @Value = PropertyValue
FROM
    TaskProperties
WHERE
    TaskId = @TaskId
    AND
    PropertyName LIKE N'Servers.%'
    AND
    PropertyValue = @ServerName

-- If row found then retrieve server names.

IF @@ROWCOUNT > 0
    IF @Name LIKE N'Servers.%.DnsName'
    BEGIN
        -- Property name equals 'Servers.%.DnsName'. Set DNS name and query for
        -- flat name value from row where property name equals 'Servers.%'.

        SELECT @DnsName = CAST(@Value AS nvarchar(256))

        SELECT
            @FlatName = CAST(PropertyValue AS nvarchar(32))
        FROM
            TaskProperties
        WHERE
            TaskId = @TaskId
            AND
            PropertyName = SUBSTRING(@Name, 1, CHARINDEX(N'.DnsName', @Name) - 1)
    END
    ELSE
    BEGIN
        -- Property name equals 'Servers.%'. Set flat name and query for DNS name
        -- value from row where property name equals 'Servers.%.DnsName'.

        SELECT @FlatName = CAST(@Value AS nvarchar(32))

        SELECT
            @DnsName = CAST(PropertyValue AS nvarchar(256))
        FROM
            TaskProperties
        WHERE
            TaskId = @TaskId
            AND
            PropertyName = @Name + N'.DnsName'
    END


GO
GRANT EXECUTE ON  [dbo].[GetServerNamesFromActionHistory] TO [Data Readers]
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SetDomain]
    @Sid nvarchar(128),
    @DnsName nvarchar(256),
    @FlatName nvarchar(32),
    @Id uniqueidentifier OUTPUT
AS

DECLARE @Error int
SET @Error = 0

SELECT
    @Id = DomainId
FROM
    Domains
WHERE
    Sid = @Sid

IF @Id IS NOT NULL
BEGIN
    UPDATE
        Domains
    SET
        DnsName  = CASE WHEN (@DnsName IS NOT NULL AND LEN(@DnsName) > 0) THEN @DnsName ELSE NULL END,
        FlatName = @FlatName
    WHERE
        DomainId = @Id

    SET @Error = @@ERROR
END
ELSE
BEGIN
    SELECT @Id = NEWID()

    INSERT Domains
    (
        DomainId, Guid, Sid, DnsName, FlatName
    )
    VALUES
    (
        @Id,
        NULL,
        @Sid,
        CASE WHEN (@DnsName IS NOT NULL AND LEN(@DnsName) > 0) THEN @DnsName ELSE NULL END,
        @FlatName
    )

    SET @Error = @@ERROR
END

RETURN @Error


GO

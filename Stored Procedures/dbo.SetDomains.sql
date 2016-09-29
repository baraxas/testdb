SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SetDomains]
    @SourceGuid     nchar(32),
    @SourceSid      nvarchar(128),
    @SourceDnsName  nvarchar(256),
    @SourceFlatName nvarchar(32),
    @SourceId       uniqueidentifier OUTPUT,
    @TargetGuid     nchar(32),
    @TargetSid      nvarchar(128),
    @TargetDnsName  nvarchar(256),
    @TargetFlatName nvarchar(32),
    @TargetId       uniqueidentifier OUTPUT
AS

DECLARE @Error int
SET @Error = 0

-- Source Domain

EXEC @Error = [dbo].[SetDomain] @SourceSid, @SourceDnsName, @SourceFlatName, @SourceId OUTPUT

-- Target Domain

IF @Error = 0
    EXEC @Error = [dbo].[SetDomain] @TargetSid, @TargetDnsName, @TargetFlatName, @TargetId OUTPUT

RETURN @Error


GO
GRANT EXECUTE ON  [dbo].[SetDomains] TO [Resource Migrators]
GO

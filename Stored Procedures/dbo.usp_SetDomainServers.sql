SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[usp_SetDomainServers]
    @DomainName nvarchar(256),
    @SourceServerName nvarchar(256) = NULL,
    @TargetServerName nvarchar(256) = NULL
AS

IF @SourceServerName IS NOT NULL OR @TargetServerName IS NOT NULL
BEGIN
    UPDATE
        Servers
    SET
        SourceServerName = @SourceServerName,
        TargetServerName = @TargetServerName
    WHERE
        DomainName = @DomainName

    IF @@ERROR = 0 AND @@ROWCOUNT = 0
        INSERT Servers VALUES ( @DomainName, @SourceServerName, @TargetServerName )
END
ELSE
    DELETE Servers WHERE DomainName = @DomainName


GO

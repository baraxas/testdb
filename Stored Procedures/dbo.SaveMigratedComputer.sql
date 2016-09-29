SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SaveMigratedComputer]
    @TaskId               int,
    @SourceDomainGuid     nchar(32),
    @SourceDomainSid      nvarchar(128),
    @SourceDomainDnsName  nvarchar(256),
    @SourceDomainFlatName nvarchar(32),
    @SourceGuid           nchar(32),
    @SourceRid            int,
    @SourceADsPath        nvarchar(2048),
    @SourceSam            nvarchar(256),
    @SourceType           nvarchar(64),
    @SourceFlags          int = NULL,
    @SourceExpires        int = NULL,
    @TargetDomainGuid     nchar(32),
    @TargetDomainSid      nvarchar(128),
    @TargetDomainDnsName  nvarchar(256),
    @TargetDomainFlatName nvarchar(32),
    @TargetGuid           nchar(32),
    @TargetRid            int,
    @TargetADsPath        nvarchar(2048),
    @TargetSam            nvarchar(256),
    @TargetType           nvarchar(64),
    @TargetInvocationId   uniqueidentifier,
    @TargetUSN            bigint,
    @Status               int,
    @PasswordCopyTime     datetime = NULL
AS

-- Type is hard-coded as Computer so that caller cannot change

EXEC [dbo].[SaveMigratedObject]
    @TaskId,
    @SourceDomainGuid,
    @SourceDomainSid,
    @SourceDomainDnsName,
    @SourceDomainFlatName,
    @SourceGuid,
    @SourceRid,
    @SourceADsPath,
    @SourceSam,
    N'Computer',
    @SourceFlags,
    @SourceExpires,
    @TargetDomainGuid,
    @TargetDomainSid,
    @TargetDomainDnsName,
    @TargetDomainFlatName,
    @TargetGuid,
    @TargetRid,
    @TargetADsPath,
    @TargetSam,
    N'Computer',
    @TargetInvocationId,
    @TargetUSN,
    @Status,
    default


GO
GRANT EXECUTE ON  [dbo].[SaveMigratedComputer] TO [Resource Migrators]
GO

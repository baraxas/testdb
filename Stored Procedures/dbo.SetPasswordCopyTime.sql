SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SetPasswordCopyTime]
    @SourceDomainName nvarchar(256),
    @SourceObjectSamName nvarchar(256),
    @TargetDomainName nvarchar(256),
    @Time datetime = NULL
AS

UPDATE
    MigratedObjects
SET
    PasswordCopyTime = @Time
FROM
    MigratedObjects AS M
    JOIN
    Objects AS S ON M.SourceObjectId = S.ObjectId
    JOIN
    Domains AS SD ON S.DomainId = SD.DomainId
    JOIN
    Objects AS T ON M.TargetObjectId = T.ObjectId
    JOIN
    Domains AS TD ON T .DomainId = TD.DomainId
WHERE
    (SD.DnsName = @SourceDomainName OR SD.FlatName = @SourceDomainName)
    AND
    S.SamName = @SourceObjectSamName
    AND
    (TD.DnsName = @TargetDomainName OR TD.FlatName = @TargetDomainName)


GO
GRANT EXECUTE ON  [dbo].[SetPasswordCopyTime] TO [Account Migrators]
GO

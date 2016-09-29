SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[GetPasswordCopyTime]
    @SourceDomainName nvarchar(256),
    @SourceObjectSamName nvarchar(256),
    @TargetDomainName nvarchar(256),
    @Time datetime OUTPUT
AS

SELECT
    @Time = M.PasswordCopyTime
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
GRANT EXECUTE ON  [dbo].[GetPasswordCopyTime] TO [Data Readers]
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[DeleteNameConflictDomainNames]
    @Domain nvarchar(256)
AS

DELETE
    NameConflictsNames
FROM
    NameConflictsNames AS N
    JOIN
    NameConflictsDomains AS D ON N.DomainId = D.DomainId
WHERE
    D.Name = @Domain

RETURN @@ERROR


GO
GRANT EXECUTE ON  [dbo].[DeleteNameConflictDomainNames] TO [Resource Migrators]
GO

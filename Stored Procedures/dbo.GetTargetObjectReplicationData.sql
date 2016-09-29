SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[GetTargetObjectReplicationData]
    @TargetDomain  nvarchar(256),
    @TargetSam     nvarchar(256),
    @TargetADsPath nvarchar(2048)
AS

-- Note that target objects whose InvocationId or USN column are null are not returned as these
-- objects are assumed to be objects migrated using a previous version of ADMT and therefore the
-- the objects have replicated to all target domain controllers.

SELECT
    O.Guid         AS TargetGUID,
    O.InvocationId AS TargetInvocationId,
    O.USN          AS TargetUSN,
    O.ADsPath      AS TargetADsPath
FROM
    Objects AS O
    JOIN
    Domains AS D ON D.DomainId = O.DomainId
WHERE
    ( D.DnsName = @TargetDomain OR D.FlatName = @TargetDomain )
    AND
    ( O.SamName = @TargetSam OR (
                                    O.ADsPath = @TargetADsPath AND
                                    O.ADsPathTruncated = cast( @TargetADsPath AS nvarchar(400) )
                                )
    )
    AND
    ( O.InvocationId IS NOT NULL AND O.USN IS NOT NULL )


GO
GRANT EXECUTE ON  [dbo].[GetTargetObjectReplicationData] TO [Data Readers]
GO

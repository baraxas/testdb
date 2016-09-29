SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/* View MigratedObjectsView */

CREATE VIEW [dbo].[MigratedObjectsView]
AS
SELECT
	L.TaskId AS TaskId,
	M.MigrationTime AS Time,
	CASE WHEN SD.DnsName IS NOT NULL THEN SD.DnsName ELSE SD.FlatName END AS SourceDomain,
	SD.DnsName AS SourceDomainDns,
	SD.FlatName AS SourceDomainFlat,
	CASE WHEN TD.DnsName IS NOT NULL THEN TD.DnsName ELSE TD.FlatName END AS TargetDomain,
	TD.DnsName AS TargetDomainDns,
	TD.FlatName AS TargetDomainFlat,
	S.ADsPath AS SourceAdsPath,
	T.ADsPath AS TargetAdsPath,
	M.Status AS status,
	S.SamName AS SourceSamName,
	T.SamName AS TargetSamName,
	S.Type AS Type,
	T.Guid AS GUID,
	CASE WHEN S.Rid IS NOT NULL THEN S.Rid ELSE 0 END AS SourceRid,
	CASE WHEN T .Rid IS NOT NULL THEN T .Rid ELSE 0 END AS TargetRid,
	SD.Sid AS SourceDomainSid
FROM
	LocalTasks AS L
	JOIN
	GlobalTasks AS G ON L.GlobalTaskId = G.GlobalTaskId
	JOIN
	MigratedObjects AS M ON G.GlobalTaskId = M.GlobalTaskId
	JOIN
	Objects AS S ON M.SourceObjectId = S.ObjectId
	JOIN
	Domains AS SD ON S.DomainId = SD.DomainId
	JOIN
	Objects AS T ON M.TargetObjectId = T .ObjectId
	JOIN
	Domains AS TD ON T .DomainId = TD.DomainId



GO

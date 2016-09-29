CREATE TABLE [dbo].[LockedObjects]
(
[LockTime] [datetime] NOT NULL,
[DomainId] [uniqueidentifier] NOT NULL,
[SamName] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DistinguishedName] [nvarchar] (2048) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO

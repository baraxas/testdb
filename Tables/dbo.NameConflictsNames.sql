CREATE TABLE [dbo].[NameConflictsNames]
(
[DomainId] [int] NOT NULL,
[Sam] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Rdn] [nvarchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Canonical] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Type] [nvarchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[NameConflictsNames] ADD CONSTRAINT [PK_NameConflictsNames] PRIMARY KEY CLUSTERED  ([DomainId], [Sam]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[NameConflictsNames] WITH NOCHECK ADD CONSTRAINT [FK_NameConflictsNames_NameConflictsDomains] FOREIGN KEY ([DomainId]) REFERENCES [dbo].[NameConflictsDomains] ([DomainId]) NOT FOR REPLICATION
GO

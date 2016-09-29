CREATE TABLE [dbo].[NameConflicts]
(
[SourceDomainId] [int] NOT NULL,
[TargetDomainId] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[NameConflicts] ADD CONSTRAINT [PK_NameConflicts] PRIMARY KEY CLUSTERED  ([SourceDomainId], [TargetDomainId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[NameConflicts] WITH NOCHECK ADD CONSTRAINT [FK_NameConflicts_NameConflictsDomains_Source] FOREIGN KEY ([SourceDomainId]) REFERENCES [dbo].[NameConflictsDomains] ([DomainId]) NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[NameConflicts] WITH NOCHECK ADD CONSTRAINT [FK_NameConflicts_NameConflictsDomains_Target] FOREIGN KEY ([TargetDomainId]) REFERENCES [dbo].[NameConflictsDomains] ([DomainId]) NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[NameConflicts] NOCHECK CONSTRAINT [FK_NameConflicts_NameConflictsDomains_Source]
GO
ALTER TABLE [dbo].[NameConflicts] NOCHECK CONSTRAINT [FK_NameConflicts_NameConflictsDomains_Target]
GO

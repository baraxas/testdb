CREATE TABLE [dbo].[NameConflictsDomains]
(
[DomainId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Name] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[NameConflictsDomains] ADD CONSTRAINT [PK_NameConflictsDomains] PRIMARY KEY CLUSTERED  ([DomainId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[NameConflictsDomains] ADD CONSTRAINT [IX_NameConflictsDomains] UNIQUE NONCLUSTERED  ([Name]) ON [PRIMARY]
GO

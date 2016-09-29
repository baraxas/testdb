CREATE TABLE [dbo].[RefDomains]
(
[DomainId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Name] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RefDomains] ADD CONSTRAINT [PK_RefDomains] PRIMARY KEY CLUSTERED  ([DomainId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RefDomains] ADD CONSTRAINT [IX_RefDomains] UNIQUE NONCLUSTERED  ([Name]) ON [PRIMARY]
GO
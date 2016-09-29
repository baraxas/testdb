CREATE TABLE [dbo].[RefAccounts]
(
[AccountId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[DomainId] [int] NOT NULL,
[Name] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Sid] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RefAccounts] ADD CONSTRAINT [PK_RefAccounts] PRIMARY KEY CLUSTERED  ([AccountId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RefAccounts] ADD CONSTRAINT [IX_RefAccounts] UNIQUE NONCLUSTERED  ([Name]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RefAccounts] WITH NOCHECK ADD CONSTRAINT [FK_RefAccounts_RefDomains] FOREIGN KEY ([DomainId]) REFERENCES [dbo].[RefDomains] ([DomainId]) NOT FOR REPLICATION
GO

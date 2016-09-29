CREATE TABLE [dbo].[Domains]
(
[DomainId] [uniqueidentifier] NOT NULL ROWGUIDCOL CONSTRAINT [DF_Domains_DomainId] DEFAULT (newid()),
[Guid] [nchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sid] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DnsName] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FlatName] [nvarchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Domains] ADD CONSTRAINT [PK_Domains] PRIMARY KEY CLUSTERED  ([DomainId]) ON [PRIMARY]
GO

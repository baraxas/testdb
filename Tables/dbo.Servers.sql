CREATE TABLE [dbo].[Servers]
(
[DomainName] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SourceServerName] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TargetServerName] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Servers] ADD CONSTRAINT [PK_Servers] PRIMARY KEY CLUSTERED  ([DomainName]) ON [PRIMARY]
GO

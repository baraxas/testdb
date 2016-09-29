CREATE TABLE [dbo].[Computers]
(
[ComputerId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Name] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DnsName] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FlatName] [nvarchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Computers] ADD CONSTRAINT [PK_Computers] PRIMARY KEY CLUSTERED  ([ComputerId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Computers] ADD CONSTRAINT [IX_Computers] UNIQUE NONCLUSTERED  ([Name]) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Objects]
(
[ObjectId] [uniqueidentifier] NOT NULL ROWGUIDCOL,
[DomainId] [uniqueidentifier] NOT NULL,
[Guid] [nchar] (32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ADsPath] [nvarchar] (2048) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SamName] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Rid] [int] NOT NULL,
[Type] [nvarchar] (64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Flags] [int] NULL,
[Expires] [int] NULL,
[InvocationId] [uniqueidentifier] NULL,
[USN] [bigint] NULL,
[ADsPathTruncated] AS (CONVERT([nvarchar](400),[ADsPath],(0)))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Objects] ADD CONSTRAINT [PK_Objects] PRIMARY KEY CLUSTERED  ([ObjectId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_ADsPathTruncated_DomainId_Objects] ON [dbo].[Objects] ([ADsPathTruncated], [DomainId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Objects] ADD CONSTRAINT [IX_Objects_Domain_Rid] UNIQUE NONCLUSTERED  ([DomainId], [Rid]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Objects_Guid] ON [dbo].[Objects] ([Guid]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Objects_SamName_DomainId] ON [dbo].[Objects] ([SamName], [DomainId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Objects_Type] ON [dbo].[Objects] ([Type]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Objects] ADD CONSTRAINT [FK_Objects_Domains] FOREIGN KEY ([DomainId]) REFERENCES [dbo].[Domains] ([DomainId]) ON DELETE CASCADE
GO

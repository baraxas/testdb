CREATE TABLE [dbo].[MigratedObjects]
(
[SourceObjectId] [uniqueidentifier] NOT NULL,
[TargetObjectId] [uniqueidentifier] NOT NULL,
[GlobalTaskId] [uniqueidentifier] NOT NULL,
[Status] [int] NOT NULL,
[MigrationTime] [datetime] NOT NULL,
[PasswordCopyTime] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MigratedObjects] ADD CONSTRAINT [PK_MigratedObjects] PRIMARY KEY CLUSTERED  ([SourceObjectId], [TargetObjectId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_MigratedObjects_Time] ON [dbo].[MigratedObjects] ([MigrationTime]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MigratedObjects] ADD CONSTRAINT [FK_MigratedObjects_GlobalTasks] FOREIGN KEY ([GlobalTaskId]) REFERENCES [dbo].[GlobalTasks] ([GlobalTaskId]) ON DELETE CASCADE
GO
ALTER TABLE [dbo].[MigratedObjects] ADD CONSTRAINT [FK_MigratedObjects_Objects] FOREIGN KEY ([SourceObjectId]) REFERENCES [dbo].[Objects] ([ObjectId])
GO
ALTER TABLE [dbo].[MigratedObjects] ADD CONSTRAINT [FK_MigratedObjects_Objects1] FOREIGN KEY ([TargetObjectId]) REFERENCES [dbo].[Objects] ([ObjectId])
GO

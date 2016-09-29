CREATE TABLE [dbo].[TaskProperties]
(
[TaskId] [int] NOT NULL,
[PropertyName] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PropertyValue] [sql_variant] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TaskProperties] ADD CONSTRAINT [PK_TaskProperties] PRIMARY KEY CLUSTERED  ([TaskId], [PropertyName]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TaskProperties] WITH NOCHECK ADD CONSTRAINT [FK_TaskProperties_LocalTasks] FOREIGN KEY ([TaskId]) REFERENCES [dbo].[LocalTasks] ([TaskId]) ON DELETE CASCADE NOT FOR REPLICATION
GO
GRANT INSERT ON  [dbo].[TaskProperties] TO [Resource Migrators]
GO

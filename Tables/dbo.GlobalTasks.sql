CREATE TABLE [dbo].[GlobalTasks]
(
[GlobalTaskId] [uniqueidentifier] NOT NULL ROWGUIDCOL,
[TaskTime] [datetime] NOT NULL CONSTRAINT [DF_GlobalTasks_TaskTime] DEFAULT (getutcdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GlobalTasks] ADD CONSTRAINT [PK_GlobalTasks] PRIMARY KEY CLUSTERED  ([GlobalTaskId]) ON [PRIMARY]
GO

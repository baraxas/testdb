CREATE TABLE [dbo].[DistributedTasks]
(
[TaskId] [int] NOT NULL,
[ComputerId] [int] NOT NULL,
[Status] [int] NOT NULL,
[StatusText] [nvarchar] (1024) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Job] [image] NULL,
[RetryTaskId] [int] NULL,
[LogStatus] [int] NULL,
[LogFile] [image] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[DistributedTasks] ADD CONSTRAINT [PK_DistributedTasks] PRIMARY KEY CLUSTERED  ([TaskId], [ComputerId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DistributedTasks] WITH NOCHECK ADD CONSTRAINT [FK_DistributedTasks_Computers] FOREIGN KEY ([ComputerId]) REFERENCES [dbo].[Computers] ([ComputerId]) ON DELETE CASCADE NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[DistributedTasks] WITH NOCHECK ADD CONSTRAINT [FK_DistributedTasks_LocalTasks] FOREIGN KEY ([TaskId]) REFERENCES [dbo].[LocalTasks] ([TaskId]) ON DELETE CASCADE NOT FOR REPLICATION
GO

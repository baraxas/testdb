CREATE TABLE [dbo].[LocalTasks]
(
[TaskId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[GlobalTaskId] [uniqueidentifier] NOT NULL,
[AdmtId] [uniqueidentifier] NULL,
[AdmtComputer] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LocalTasks_AdmtComputer] DEFAULT (host_name()),
[AdmtUser] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_LocalTasks_AdmtUser] DEFAULT (suser_sname()),
[Status] [int] NULL,
[LogStatus] [int] NULL,
[LogFile] [image] NULL,
[AccountFile] [image] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[LocalTasks] ADD CONSTRAINT [PK_LocalTasks] PRIMARY KEY CLUSTERED  ([TaskId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LocalTasks] WITH NOCHECK ADD CONSTRAINT [FK_LocalTasks_GlobalTasks] FOREIGN KEY ([GlobalTaskId]) REFERENCES [dbo].[GlobalTasks] ([GlobalTaskId]) NOT FOR REPLICATION
GO

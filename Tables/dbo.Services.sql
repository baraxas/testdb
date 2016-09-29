CREATE TABLE [dbo].[Services]
(
[ComputerId] [int] NOT NULL,
[Name] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DisplayName] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Account] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services] ADD CONSTRAINT [PK_Services] PRIMARY KEY CLUSTERED  ([ComputerId], [Name]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Services_Account] ON [dbo].[Services] ([Account]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Services] WITH NOCHECK ADD CONSTRAINT [FK_Services_Computers] FOREIGN KEY ([ComputerId]) REFERENCES [dbo].[Computers] ([ComputerId]) ON DELETE CASCADE NOT FOR REPLICATION
GO

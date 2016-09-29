CREATE TABLE [dbo].[References]
(
[AccountId] [int] NOT NULL,
[ComputerId] [int] NOT NULL,
[TypeId] [int] NOT NULL,
[RefCount] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[References] ADD CONSTRAINT [PK_References] PRIMARY KEY CLUSTERED  ([AccountId], [ComputerId], [TypeId]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[References] WITH NOCHECK ADD CONSTRAINT [FK_References_RefAccounts] FOREIGN KEY ([AccountId]) REFERENCES [dbo].[RefAccounts] ([AccountId]) NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[References] WITH NOCHECK ADD CONSTRAINT [FK_References_RefComputers] FOREIGN KEY ([ComputerId]) REFERENCES [dbo].[RefComputers] ([ComputerId]) NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[References] WITH NOCHECK ADD CONSTRAINT [FK_References_RefTypes] FOREIGN KEY ([TypeId]) REFERENCES [dbo].[RefTypes] ([TypeId]) NOT FOR REPLICATION
GO

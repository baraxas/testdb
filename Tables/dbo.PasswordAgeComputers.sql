CREATE TABLE [dbo].[PasswordAgeComputers]
(
[Name] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DomainId] [int] NOT NULL,
[Description] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PasswordAge] [int] NOT NULL,
[UpdateTime] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PasswordAgeComputers] ADD CONSTRAINT [PK_PasswordAgeComputers] PRIMARY KEY CLUSTERED  ([Name]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PasswordAgeComputers] ADD CONSTRAINT [FK_PasswordAgeComputers_PasswordAgeDomains] FOREIGN KEY ([DomainId]) REFERENCES [dbo].[PasswordAgeDomains] ([DomainId])
GO

CREATE TABLE [dbo].[Settings]
(
[SettingName] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SettingValue] [sql_variant] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Settings] ADD CONSTRAINT [PK_Settings] PRIMARY KEY CLUSTERED  ([SettingName]) ON [PRIMARY]
GO

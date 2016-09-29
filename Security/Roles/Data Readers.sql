CREATE ROLE [Data Readers]
AUTHORIZATION [dbo]
GO
EXEC sp_addrolemember N'Data Readers', N'Resource Migrators'
GO

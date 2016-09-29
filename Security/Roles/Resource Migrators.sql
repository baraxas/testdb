CREATE ROLE [Resource Migrators]
AUTHORIZATION [dbo]
GO
EXEC sp_addrolemember N'Resource Migrators', N'Account Migrators'
GO

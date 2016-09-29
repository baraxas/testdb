CREATE TYPE [dbo].[version] FROM int NOT NULL
GO
GRANT REFERENCES ON TYPE:: [dbo].[version] TO [public]
GO
DECLARE @xp int
SELECT @xp=6
EXEC sp_addextendedproperty N'DatabaseVersionMajor', @xp, 'SCHEMA', N'dbo', 'TYPE', N'version', NULL, NULL
GO
DECLARE @xp int
SELECT @xp=0
EXEC sp_addextendedproperty N'DatabaseVersionMinor', @xp, 'SCHEMA', N'dbo', 'TYPE', N'version', NULL, NULL
GO

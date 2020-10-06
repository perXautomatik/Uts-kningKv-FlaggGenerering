# Uts-kningKv-FlaggGenerering

this branch except code to be run from GISDB01, and must therefore call tables internally rather than externaly.

------------------------ Länka med admsql01 --------------------------------------------------------------------------------





USE [master]
GO
EXEC master.dbo.sp_addlinkedserver
    @server = N'admsql01',
    @srvproduct=N'SQL Server' ;
GO

--test
SELECT name FROM [admsql01].master.sys.databases ;

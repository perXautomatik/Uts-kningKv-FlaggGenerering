--From the OPENQUERY documentation it states that:
--OPENQUERY does not accept variables for its arguments.

--Copied from: sql - including parameters in OPENQUERY - Stack Overflow - 2020-10-23 10:24:59 - <https://stackoverflow.com/questions/3378496/including-parameters-in-openquery>
--UPDATE:
--As suggested, I'm including the recommendations from the article below.
--Pass Basic Values
--When the basic Transact-SQL statement is known, but you have to pass in one or more specific values, use code that is similar to the following sample:

DECLARE @TSQL varchar(8000), @VAR char(2)
SELECT  @VAR = 'CA'
SELECT  @TSQL = 'SELECT * FROM OPENQUERY(MyLinkedServer,''SELECT * FROM pubs.dbo.authors WHERE state = ''''' + @VAR + ''''''')'
EXEC (@TSQL)
go
--Pass the Whole Query
--When you have to pass in the whole Transact-SQL query or the name of the linked server (or both), use code that is similar to the following sample:

DECLARE @OPENQUERY nvarchar(4000), @TSQL nvarchar(4000), @LinkedServer nvarchar(4000)
SET @LinkedServer = 'MyLinkedServer'
SET @OPENQUERY = 'SELECT * FROM OPENQUERY('+ @LinkedServer + ','''
SET @TSQL = 'SELECT au_lname, au_id FROM pubs..authors'')'
EXEC (@OPENQUERY+@TSQL)
go
--Use the Sp_executesql Stored Procedure
--To avoid the multi-layered quotes, use code that is similar to the following sample:

DECLARE @VAR char(2)
SELECT  @VAR = 'CA'
EXEC MyLinkedServer.master.dbo.sp_executesql
N'SELECT * FROM pubs.dbo.authors WHERE state = @state',
N'@state char(2)',
@VAR
go

--Copied from: How to pass a variable to a linked server query - 2020-10-23 10:19:17 - <https://support.microsoft.com/en-us/help/314520/how-to-pass-a-variable-to-a-linked-server-query>
--Summary
--This article describes how to pass a variable to a linked server query.
--When you query a linked server, you frequently perform a pass-through query that uses the OPENQUERY, OPENROWSET, or OPENDATASOURCE statement. You can view the examples in SQL Server Books Online to see how to do this by using pre-defined Transact-SQL strings, but there are no examples of how to pass a variable to these functions. This article provides three examples of how to pass a variable to a linked server query.
--To pass a variable to one of the pass-through functions, you must build a dynamic query.
--Any data that includes quotes needs particular handling. For more information, see the "Using char and varchar Data" topic in SQL Server Books Online and see the following article in the Microsoft Knowledge Base:
--156501 INF: QUOTED_IDENTIFIER and Strings with Single Quotation Marks
--Pass Basic Values
--When the basic Transact-SQL statement is known, but you have to pass in one or more specific values, use code that is similar to the following sample:

      DECLARE @TSQL varchar(8000), @VAR char(2)
      SELECT  @VAR = 'CA'
      SELECT  @TSQL = 'SELECT * FROM OPENQUERY(MyLinkedServer,''SELECT * FROM pubs.dbo.authors WHERE state = ''''' + @VAR + ''''''')'
      EXEC (@TSQL)

      go
--Pass the Whole Query
--When you have to pass in the whole Transact-SQL query or the name of the linked server (or both), use code that is similar to the following sample:
DECLARE @OPENQUERY nvarchar(4000), @TSQL nvarchar(4000), @LinkedServer nvarchar(4000)
SET @LinkedServer = 'MyLinkedServer'
SET @OPENQUERY = 'SELECT * FROM OPENQUERY('+ @LinkedServer + ','''
SET @TSQL = 'SELECT au_lname, au_id FROM pubs..authors'')'
EXEC (@OPENQUERY+@TSQL)

go
--Use the Sp_executesql Stored Procedure
--To avoid the multi-layered quotes, use code that is similar to the following sample:

DECLARE @VAR char(2)
SELECT  @VAR = 'CA'
EXEC MyLinkedServer.master.dbo.sp_executesql
     N'SELECT * FROM pubs.dbo.authors WHERE state = @state',
     N'@state char(2)',
     @VAR
go
--References
--For additional information, see the following topics in SQL Server Books Online:
--"OPENROWSET"
--"OPENQUERY"
--"OPENDATASOURCE"
--"Using sp_executesql"
--"sp_executesql"
--Last Updated: Aug 20, 2020


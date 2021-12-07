/*Insert Databases names into SQL Temp Table*/
IF OBJECT_ID('tempdb..#statusTable') IS not NULL begin    Drop table #statusTable end
create table #statusTable (medelande NVARCHAR(max),start smalldatetime,rader integer);

IF OBJECT_ID('tempdb..#execution') IS not NULL begin    Drop table #execution end
create table #execution (query NVARCHAR(max),"order" integer);

declare @folder  nvarchar(256);
set @folder = 'C:\Users\crbk01\AppData\Roaming\JetBrains\DataGrip2021.1\consoles\db\947f2b47-af0c-4354-9696-9462b1a4bf8b\Kv-FlaggGenerering\';
insert into #execution select dbo.trippleExecute(@folder,N'aFlaggUtsökWithVariables.sql'),1
set @folder = 'C:\Users\crbk01\AppData\Roaming\JetBrains\DataGrip2021.1\consoles\db\8cc23256-e02c-43ea-8477-e740c4580b62\modular\'
insert into #execution select dbo.trippleExecute(@folder,'1BadStatus.sql'),2
insert into #execution select dbo.trippleExecute(@folder,'1OanskadeHandlingar.sql'),3
insert into #execution select dbo.trippleExecute(@folder,'1OnskadeHandlingar.sql'),4
insert into #execution select dbo.trippleExecute(@folder,'1SocknarOfIntresse.sql'),5
insert into #execution select dbo.trippleExecute(@folder,'1Strangar.sql'),6
insert into #execution select dbo.trippleExecute(@folder,'2OppnaArendenIsocken.sql'),7

declare @query as NVARCHAR(max)
set @query = (select query from #execution where [order] = 1)

exec (@query) AT [gisdb01]
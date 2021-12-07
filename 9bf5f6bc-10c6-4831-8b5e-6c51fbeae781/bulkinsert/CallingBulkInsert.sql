

declare @folder varchar(max) = 'C:\Users\crbk01\AppData\Roaming\JetBrains\DataGrip2021.1\scratches\';
declare @scriptName varchar(max) = 'dateRange.sql';

declare @q nvarchar(MAX); set @q =  dbo.trippleExecute(@folder,@scriptname)

execute(@q)

delete from tempExcel.dbo.RemoteQuery where query is not null
delete from #RemoteQuery where query is not null
declare @folder varchar(max) = 'C:\Users\crbk01\AppData\Roaming\JetBrains\DataGrip2021.1\consoles\db\7e4fb899-0567-4da7-8a60-86bca3049c5c\Kv-FlaggGenerering\ExternalQuery\utsokningSocken\';
declare @q nvarchar(MAX);

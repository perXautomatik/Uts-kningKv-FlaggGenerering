-- we can't capsulate all code, as procedures is run by anoter session and therefore hacve other rights.
drop function if exists prepareBulk  ;
drop table if exists #RemoteQuery
create table #RemoteQuery (query nvarchar(max));
go
create function prepareBulk (@pfileToRead nvarchar(255) ) returns nvarchar(max)
    begin
declare @q nvarchar(MAX);
set @q=
    'BULK INSERT #RemoteQuery FROM ' + char(39) + @pfileToRead + char(39) + N'WITH(ROWTERMINATOR = ''едц'')'
return @q
    end
; go
drop function if exists moveToStorage;go
create function moveToStorage(
    @pserver varchar(60) = null
) returns nvarchar(max)
    begin

return 'insert into tempExcel.dbo.RemoteQuery
select query, ' + char(39) +isnull(@pserver,'null') + char(39)
          -- +', '+isnull(@pinputTables,'null')
         --  +','+isnull(@poutputTables,'null')
           +' from #RemoteQuery'
end

go

drop function if exists doubleExecute;go
create function doubleExecute( @folder varchar(250),@scriptName varchar(250)) returns nvarchar(max)
    begin
    declare @z nvarchar(MAX)
    set @z = ('declare @t nvarchar(MAX);declare @p nvarchar(MAX);' +
    ' set @p = ' + char(39) + @folder + @scriptName + char(39) + ';
    set @t = dbo.prepareBulk(@p);
    exec(@t);set @t =' + char(39) +@scriptName + char(39) +';
    set @t = dbo.moveToStorage(@t);
    exec(@t)');
return @z
end

go;
drop function if exists trippleExecute;go
create function trippleExecute( @folder varchar(250),@scriptName varchar(250)) returns nvarchar(max)
    begin
    declare @z nvarchar(MAX)
    set @z = ('declare @t nvarchar(MAX);declare @p nvarchar(MAX);' +
    ' set @p = ' + char(39) + @folder + @scriptName + char(39) + ';
    set @t = dbo.prepareBulk(@p);
    exec(@t);set @t =' + char(39) +@scriptName + char(39) +';
    set @t = dbo.moveToStorage(@t);
    exec(@t);
    declare @q nvarchar(max)
    set @q = (select top 1 query from tempExcel.dbo.RemoteQuery where queryName = '+ char(39) +@scriptName + char(39) +')
    EXEC (@q)');
return @z
end

go;


declare @folder varchar(max) = 'C:\Users\crbk01\AppData\Roaming\JetBrains\DataGrip2021.1\scratches\';
declare @scriptName varchar(max) = 'dateRange.sql';

declare @q nvarchar(MAX); set @q =  dbo.trippleExecute(@folder,@scriptname)

execute(@q)

delete from tempExcel.dbo.RemoteQuery where query is not null
delete from #RemoteQuery where query is not null
declare @folder varchar(max) = 'C:\Users\crbk01\AppData\Roaming\JetBrains\DataGrip2021.1\consoles\db\7e4fb899-0567-4da7-8a60-86bca3049c5c\Kv-FlaggGenerering\ExternalQuery\utsokningSocken\';
declare @q nvarchar(MAX);

SockenYtor:
declare @scriptName varchar(max) = 'sockenYtor.sql';
set @q =  dbo.trippleExecute(@folder,@scriptname)
execute(@q)
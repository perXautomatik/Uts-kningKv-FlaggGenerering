-- we can't capsulate all code, as procedures is run by anoter session and therefore hacve other rights.
drop function if exists dbo.prepareBulk  ;
drop table if exists #RemoteQuery
create table #RemoteQuery (query nvarchar(max));
go
create function dbo.prepareBulk (@pfileToRead nvarchar(255) ) returns nvarchar(max)
    begin
declare @q nvarchar(MAX);
set @q=
    'BULK INSERT #RemoteQuery FROM ' + char(39) + @pfileToRead + char(39) + N'WITH(ROWTERMINATOR = ''���'')'
return @q
    end
; go
drop function if exists dbo.moveToStorage;go
create function dbo.moveToStorage(
    @pserver varchar(60) = null
) returns nvarchar(max)
    begin

return 'insert into RemoteQuery
select query, ' + char(39) +isnull(@pserver,'null') + char(39)
           +' from #RemoteQuery'
end

go

drop function if exists doubleExecute;go
create function dbo.doubleExecute( @folder varchar(250),@scriptName varchar(250)) returns nvarchar(max)
    begin
    declare @z nvarchar(MAX)
    set @z = ('declare @t nvarchar(MAX);declare @p nvarchar(MAX);' +
    ' set @p = ' + char(39) + @folder + @scriptName + char(39) + ';
    set @t = tempExcel.dbo.prepareBulk(@p);
    exec(@t);set @t =' + char(39) +@scriptName + char(39) +';
    set @t = tempExcel.dbo.moveToStorage(@t);
    exec(@t)');
return @z
end

go;
drop function if exists trippleExecute;go
create function dbo.trippleExecute( @folder varchar(250),@scriptName varchar(250)) returns nvarchar(max)
    begin
return  ('declare @t nvarchar(MAX);declare @q nvarchar(MAX);
    set @q= ''BULK INSERT #RemoteQuery FROM ' + char(39)+ char(39) + @folder + @scriptName + char(39)+ char(39) + N'
          WITH(ROWTERMINATOR = ''''åäö'''')''
    exec(@q);    
    set @t = ''insert into RemoteQuery select query, ' + char(39)+ char(39) +isnull(@scriptName,'null') + char(39) +char(39) + '
    	from #RemoteQuery;
       	(select top 1 query from RemoteQuery where queryName = '+ char(39)+ char(39) +@scriptName + char(39)+ char(39) +')''
    EXEC (@t)')

end

go;

INSERT INTO #statusTable (medelande) select '#initiating' + @name + '' as alias;
declare @tid smalldatetime;
IF OBJECT_ID('tempdb..' + @name + '') IS not NULL begin
    if not (exists(select 1 from) + @name + '') drop table ;+@name+''
end

IF OBJECT_ID('tempdb..' + @name + '') IS NULL
    BEGIN try
	set @tid = CURRENT_TIMESTAMP
	INSERT INTO #statusTable (medelande) select 'Starting' + @name + '' as alias

	BEGIN TRANSACTION --B2
	CREATE TABLE +@name+'' (socken nvarchar(100), FAStighet nvarchar (250), Shape geometry)

	declare @externalQuery nvarchar(max), @externalparam nvarchar(255);

	set @externalparam = (select query from #execution where "order" = 7);
	exec dynamicASigne();
	--@dynamicVariableAsignment =  '@bjorke=@bjorke, @dalhem=@dalhem, @frojel=@frojel, @ganthem= @ganthem, @Halla=@Halla, @Klinte= @Klinte, @Roma=@Roma'
	--set @bjorke=N'björke'set @dalhem = 'Dalhem'set @frojel = N'Fröjel'set @ganthem = 'Ganthem'set @Halla = 'Halla'set @Klinte = 'Klinte'set @Roma = 'Roma';

	exec 'declare' + @externalparam
	        
	        --set @externalQuery =  (select query from #execution where "order" = 1);

	     'INSERT INTO '+@name+' exec gisdb01.master.dbo.sp_executesql' + (select query from #execution where "order" = 1) +','+ @externalparam + ', ' 
         +@dynamicVariableAsignment

	Commit Transaction --C2
    end try begin catch
	ROLLBACK TRANSACTION
	insert
	into #statusTable
	select ERROR_MESSAGE() "E", CURRENT_TIMESTAMP "C", @@ROWCOUNT as [@4]
	print 'failed to build'
    end catch

set @tid = CURRENT_TIMESTAMP - @tid
INSERT
INTO #statusTable
select 'rebuilt#' "a", @tid, @@ROWCOUNT as [@3]

exec 'INSERT INTO #statusTable select preloading,CURRENT_TIMESTAMP,count(*) from '+@name;
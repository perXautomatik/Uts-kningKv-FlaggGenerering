/*Insert Databases names into SQL Temp Table*/
IF OBJECT_ID('tempdb..#statusTable') IS not NULL begin    Drop table #statusTable end
create table #statusTable (medelande NVARCHAR(max),start smalldatetime,rader integer);

IF OBJECT_ID('tempdb..#execution') IS not NULL begin    Drop table #execution end
create table #execution (query NVARCHAR(max),"order" integer);

declare @folder  nvarchar(256);
set @folder = 'C:\Users\crbk01\AppData\Roaming\JetBrains\DataGrip2021.1\consoles\db\58e93225-fbe8-4239-b061-0a7800085c08\AutoUtsokning';

insert into #execution select dbo.trippleExecute(@folder,'1.sql'),1
insert into #execution select dbo.trippleExecute(@folder,'2.sql'),2
insert into #execution select dbo.trippleExecute(@folder,'3.sql'),3
insert into #execution select dbo.trippleExecute(@folder,'4.sql'),4
insert into #execution select dbo.trippleExecute(@folder,'5.sql'),5
insert into #execution select dbo.trippleExecute(@folder,'6.sql'),6
insert into #execution select N'@bjorke nvarchar(255) , @dalhem varchar(255) , @frojel nvarchar(255) , @ganthem varchar(255) , @Halla varchar(255) , @Klinte varchar(255) ,  @Roma varchar(255)',7


select * into #fastighetsfilter from (Select @bjorke "socken"
			  Union
			  Select @dalhem "a"
			  Union
			  Select @frojel "a"
			  Union
			  Select @ganthem "a"
			  Union
			  Select @Halla "a"
			  Union
			  Select @Klinte "a"
			  Union
			  Select @Roma "a") q


declare @externalQuery nvarchar(max), @externalparam nvarchar(1000), @bjorke nvarchar(255),@dalhem varchar(255),@frojel nvarchar(255),@ganthem varchar(255),@Halla varchar(255),@Klinte varchar(255),@Roma varchar(255),@cont nvarchar(250),@grund nvarchar(250),@overtra nvarchar(250),@hush nvarchar(250),@avctr nvarchar(250),@budsm nvarchar(250),@hyra nvarchar(250),@depoX nvarchar(250);
declare @tid smalldatetime;

set @bjorke=N'björke'set @dalhem = 'Dalhem'set @frojel = N'Fröjel'set @ganthem = 'Ganthem'set @Halla = 'Halla'set @Klinte = 'Klinte'set @Roma = 'Roma';
set @externalparam = (select query from #execution where "order" = 7)
-- dropTabels?

if (select 1) IS NULL BEGIN TRY
    BEGIN TRANSACTION --B1
	Drop table #SockenYtor
	Drop table #ByggnadPaFastighetISocken
	Drop table #Socken_tillstand
	Drop table #egetOmhandertagande
	Drop table #Spillvatten
	Drop table #slam
	Drop table #rodx
    Commit Transaction --C1
	end try begin catch ROLLBACK TRANSACTION
 		insert into #statusTable select ERROR_MESSAGE() "m",CURRENT_TIMESTAMP "t",@@ROWCOUNT  "c"print 'failed to build'  end catch set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO #statusTable select 'built#',@tid,@@ROWCOUNT ; --koden skall inte exekveras i läsordning, alla initiate test moste först slutföras, sedan går programmet till repportblocket.

go
    INSERT INTO #statusTable (medelande) select '#initiating#SockenYtor' as alias;
 declare @tid smalldatetime;
    IF OBJECT_ID('tempdb..#SockenYtor') IS not NULL
	 begin
	    if not (exists(select 1 from #SockenYtor))
			drop table #SockenYtor;
	 end
    IF OBJECT_ID('tempdb..#SockenYtor') IS NULL
        BEGIN try set @tid = CURRENT_TIMESTAMP

            CREATE TABLE #SockenYtor (socken nvarchar(100), FAStighet nvarchar (250), Shape geometry)
	    INSERT INTO #statusTable (medelande) select 'Starting#SockenYtor' as alias
	    BEGIN TRANSACTION --B2
	    declare @externalQuery nvarchar(max), @externalparam nvarchar(255), @bjorke nvarchar(255),@dalhem varchar(255),@frojel nvarchar(255),@ganthem varchar(255),@Halla varchar(255),@Klinte varchar(255),@Roma varchar(255) set @bjorke=N'björke'set @dalhem = 'Dalhem'set @frojel = N'Fröjel'set @ganthem = 'Ganthem'set @Halla = 'Halla'set @Klinte = 'Klinte'set @Roma = 'Roma';
	    set @externalparam = (select query from #execution where "order" = 7);
	    set @externalQuery =  (select query from #execution where "order" = 1);

	     INSERT INTO #SockenYtor
	    exec gisdb01.master.dbo.sp_executesql @externalQuery, @externalparam, @bjorke=@bjorke, @dalhem=@dalhem, @frojel=@frojel, @ganthem= @ganthem, @Halla=@Halla, @Klinte= @Klinte, @Roma=@Roma

	    Commit Transaction --C2
    	end try begin catch ROLLBACK TRANSACTION  insert into #statusTable
    	select ERROR_MESSAGE() "E" , CURRENT_TIMESTAMP "C" , @@ROWCOUNT as [@4] print 'failed to build' end catch set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO #statusTable select 'rebuilt#' "a" ,@tid, @@ROWCOUNT as [@3]
 	INSERT INTO #statusTable select 'preloading#SockenYtor',CURRENT_TIMESTAMP,count(*) from #SockenYtor;

go
    INSERT INTO #statusTable (medelande) select '#initiating#Byggnader' "a" ;
    IF OBJECT_ID(N'tempdb..#ByggnadPaFastighetISocken') is not null
        begin
            if not (exists(select 1 from #ByggnadPaFastighetISocken))
                drop table #ByggnadPaFastighetISocken
        end
    IF OBJECT_ID(N'tempdb..#ByggnadPaFastighetISocken') is null
        begin
            declare @tid smalldatetime;
            set @tid = CURRENT_TIMESTAMP INSERT INTO #statusTable (medelande)  select 'Starting#Byggnadsyta' "a"
	    CREATE TABLE #ByggnadPaFastighetISocken (Fastighetsbeteckning nvarchar (250), Byggnadstyp nvarchar(100), ByggShape geometry)

	    BEGIN TRY
		BEGIN TRANSACTION --B3
		    declare @externalQuery nvarchar(max), @externalparam nvarchar(255), @bjorke nvarchar(255),@dalhem varchar(255),@frojel nvarchar(255),@ganthem varchar(255),@Halla varchar(255),@Klinte varchar(255),@Roma varchar(255) set @bjorke=N'björke'set @dalhem = 'Dalhem'set @frojel = N'Fröjel'set @ganthem = 'Ganthem'set @Halla = 'Halla'set @Klinte = 'Klinte'set @Roma = 'Roma'; set @externalparam = (select query from #execution where "order" = 7)
		    set @externalQuery =  (select query from #execution where "order" = 2)

		   INSERT INTO #ByggnadPaFastighetISocken
		       exec gisdb01.master.dbo.sp_executesql @externalQuery, @externalparam, @bjorke=@bjorke, @dalhem=@dalhem, @frojel=@frojel, @ganthem= @ganthem, @Halla=@Halla, @Klinte= @Klinte, @Roma=@Roma
		   Commit Transaction --C3
	    end try
            begin catch
                ROLLBACK TRANSACTION insert into #statusTable select ERROR_MESSAGE() "E" , CURRENT_TIMESTAMP "C" , @@ROWCOUNT as [@5] print 'failed to build'
            end catch
            set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO #statusTable select 'rebuilt#' "a" ,@tid, @@ROWCOUNT as [@6]
        end  INSERT INTO #statusTable select 'preloading#ByggnadPaFastighetISocken', CURRENT_TIMESTAMP,     count(*) from #ByggnadPaFastighetISocken;
go
    declare @tid smalldatetime;INSERT INTO #statusTable (medelande) select N'#initiating#sockenTillstånd' "a" ;
    IF OBJECT_ID(N'tempdb..#Socken_tillstand') IS not  NULL
        begin
        if not  (exists(select 1 from #Socken_tillstand))
            drop table #Socken_tillstand
	 end
    IF OBJECT_ID(N'tempdb..#Socken_tillstand') IS NULL
        begin set @tid = CURRENT_TIMESTAMP INSERT INTO #statusTable (medelande) select 'Starting#Socken_tillstand' "a"
        CREATE TABLE #Socken_tillstand (FAStighet nvarchar (250), Diarienummer nvarchar (250), Fastighet_tillstand nvarchar (250), Beslut_datum smalldatetime, utförddatum smalldatetime, Anteckning nvarchar (max), AnlaggningsPunkt geometry, fstatus as (case when not (Beslut_datum > DATETIME2FROMPARTS(2003, 1, 1, 1, 1, 1, 1, 1) and utförddatum > DATETIME2FROMPARTS(2003, 1, 1, 1, 1, 1, 1, 1)) then N'röd' else N'grön' end))
    BEGIN TRY
	BEGIN TRANSACTION --B4
	    declare @externalQuery nvarchar(max), @externalparam nvarchar(255), @bjorke nvarchar(255),@dalhem varchar(255),@frojel nvarchar(255),@ganthem varchar(255),@Halla varchar(255),@Klinte varchar(255),@Roma varchar(255) set @bjorke=N'björke'set @dalhem = 'Dalhem'set @frojel = N'Fröjel'set @ganthem = 'Ganthem'set @Halla = 'Halla'set @Klinte = 'Klinte'set @Roma = 'Roma'; set @externalparam = (select query from #execution where "order" = 7)
	    set @externalQuery =  (select query from #execution where "order" = 3);

	     INSERT INTO #Socken_tillstand (FAStighet, Diarienummer, Fastighet_tillstand, Beslut_datum, utförddatum, Anteckning, AnlaggningsPunkt)
	    exec gisdb01.master.dbo.sp_executesql @externalQuery, @externalparam, @bjorke=@bjorke, @dalhem=@dalhem, @frojel=@frojel, @ganthem= @ganthem, @Halla=@Halla, @Klinte= @Klinte, @Roma=@Roma
	Commit Transaction --C4
    end try begin catch ROLLBACK TRANSACTION  insert into #statusTable select ERROR_MESSAGE() "M" , CURRENT_TIMESTAMP "C" , @@ROWCOUNT as [@7]print 'failed to build'  end catch set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO #statusTable select 'rebuilt#' "a" ,@tid, @@ROWCOUNT as [@8]
        end INSERT INTO #statusTable select 'preloading#Socken_tillstand',CURRENT_TIMESTAMP,count(*) from #Socken_tillstand;

go
    declare @tid smalldatetime;INSERT INTO #statusTable (medelande) select N'#initiating#egetOmhandertagande' "a" ;
    IF OBJECT_ID(N'tempdb..#egetOmhandertagande') IS not NULL
        begin if not  (exists(select 1 from #egetOmhandertagande))
            drop table #egetOmhandertagande end
    	IF OBJECT_ID(N'tempdb..#egetOmhandertagande') IS NULL
    	    begin set @tid = CURRENT_TIMESTAMP INSERT INTO #statusTable (medelande)  select 'Starting#egetOmhandertagande' "a"
    	    CREATE TABLE #egetOmhandertagande (Fastighet_ nvarchar(250), Fastighets nvarchar(250), Eget_omhän nvarchar(250), Lokalt_omh nvarchar(250), Fastighe00 nvarchar(250), Beslutsdat smalldatetime, Diarienr   nvarchar(250), Anteckning nvarchar(250), LocaltOmH  geometry, fastighet  nvarchar (250), egetOmhandertangandeInfo as (concat(nullif( 'DiaNr: '+ ltrim(Diarienr), 'DiaNr: '), nullif(' - ' + ltrim(Fastighe00), ' - '), nullif(' - ' + ltrim(Fastighet_), ' - '), nullif(' - ' + ltrim(Eget_omhän), ' - '), nullif(' - ' + ltrim(Lokalt_omh), ' - '), nullif(' - ' + ltrim(Anteckning), ' - '),nullif('. BeslDat: ' + FORMAT(Beslutsdat,'yyyy-MM-dd'), ' BeslDat: ')) ))
    BEGIN TRY
	BEGIN TRANSACTION --B5
	    declare @externalQuery nvarchar(max), @externalparam nvarchar(255), @bjorke nvarchar(255),@dalhem varchar(255),@frojel nvarchar(255),@ganthem varchar(255),@Halla varchar(255),@Klinte varchar(255),@Roma varchar(255) set @bjorke=N'björke'set @dalhem = 'Dalhem'set @frojel = N'Fröjel'set @ganthem = 'Ganthem'set @Halla = 'Halla'set @Klinte = 'Klinte'set @Roma = 'Roma'; set @externalparam = (select query from #execution where "order" = 7)
	    set @externalQuery =  (select query from #execution where "order" = 4);

	INSERT INTO #egetOmhandertagande (Fastighet_,Fastighets,Eget_omhän,Lokalt_omh,Fastighe00,Beslutsdat,Diarienr,Anteckning,LocaltOmH, fastighet)
	exec gisdb01.master.dbo.sp_executesql @externalQuery, @externalparam, @bjorke=@bjorke, @dalhem=@dalhem, @frojel=@frojel, @ganthem= @ganthem, @Halla=@Halla, @Klinte= @Klinte, @Roma=@Roma
	Commit Transaction --C5
    end try begin catch ROLLBACK TRANSACTION  insert into #statusTable select ERROR_MESSAGE() "E" , CURRENT_TIMESTAMP "C" , @@ROWCOUNT as [@4] print 'failed to build' end catch set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO #statusTable select 'rebuilt#' "a" ,@tid, @@ROWCOUNT as [@3]end INSERT INTO #statusTable select 'preloading#egetOmhandertagande',CURRENT_TIMESTAMP,count(*) from #egetOmhandertagande;

go
    declare @tid smalldatetime;INSERT INTO #statusTable (medelande) select '#initiating#Spillvatten' "a" ; IF OBJECT_ID('tempdb..#Spillvatten') IS not NULL begin if not (exists(select 1 from #Spillvatten)) begin drop table #Spillvatten end end IF OBJECT_ID('tempdb..#Spillvatten') IS NULL begin set @tid = CURRENT_TIMESTAMP INSERT INTO #statusTable (medelande)  select 'Starting#Spillvatten' "a" BEGIN TRY
    CREATE TABLE #Spillvatten (fastighet  nvarchar (250),typ nvarchar (max))
        BEGIN TRANSACTION --B6

    declare @externalQuery nvarchar(max), @externalparam nvarchar(255), @bjorke nvarchar(255),@dalhem varchar(255),@frojel nvarchar(255),@ganthem varchar(255),@Halla varchar(255),@Klinte varchar(255),@Roma varchar(255) set @bjorke=N'björke'set @dalhem = 'Dalhem'set @frojel = N'Fröjel'set @ganthem = 'Ganthem'set @Halla = 'Halla'set @Klinte = 'Klinte'set @Roma = 'Roma'; set @externalparam = (select query from #execution where "order" = 7)
	set @externalQuery =  (select query from #execution where "order" = 5);


     INSERT INTO #Spillvatten
        exec gisdb01.master.dbo.sp_executesql @externalQuery, @externalparam, @bjorke=@bjorke, @dalhem=@dalhem, @frojel=@frojel, @ganthem= @ganthem, @Halla=@Halla, @Klinte= @Klinte, @Roma=@Roma
    Commit Transaction --C6
    end try begin catch ROLLBACK TRANSACTION  insert into #statusTable select ERROR_MESSAGE() "E" , CURRENT_TIMESTAMP "C" , @@ROWCOUNT as [@4] print 'failed to build' end catch set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO #statusTable select 'rebuilt#' "a" ,@tid, @@ROWCOUNT as [@3]end INSERT INTO #statusTable select 'preloading#Spillvatten',CURRENT_TIMESTAMP,count(*) from #Spillvatten;

go
    declare @tid smalldatetime;INSERT INTO #statusTable (medelande) select '#initiating#slam' "a" ;
    IF OBJECT_ID('tempdb..#slam') IS not NULL begin if not (exists(select 1 from #slam ))
        drop table #slam end
    IF OBJECT_ID(N'tempdb..#slamx') IS not NULL
        DROP TABLE #slamx
    IF OBJECT_ID( N'tempdb..#slamx') IS NULL begin
        set @tid = CURRENT_TIMESTAMP INSERT INTO #statusTable (medelande)  select 'Starting#slam' "a"
        BEGIN TRY
    CREATE TABLE #slamx (strFastBeteckningHel nvarchar (250), decAnlXKoordinat float, decAnlYkoordinat float, intTjanstnr int, strDelprodukt nvarchar (250), strTaxebenamning nvarchar (250), stopDat datetime)
        BEGIN TRANSACTION --B7
    declare @externalQuery nvarchar(max), @externalparam nvarchar(1000), @bjorke nvarchar(255),@dalhem varchar(255),@frojel nvarchar(255),@ganthem varchar(255),@Halla varchar(255),@Klinte varchar(255),@Roma varchar(255),@cont nvarchar(250),@grund nvarchar(250),@overtra nvarchar(250),@hush nvarchar(250),@avctr nvarchar(250),@budsm nvarchar(250),@hyra nvarchar(250),@depoX nvarchar(250); set @depoX='DEPO' set @cont = 'CONT'set @grund = 'GRUNDR'set @overtra = N'ÖVRTRA'set @hush = 'HUSH'set @avctr=N'ÅVCTR'set @budsm = 'BUDSM'set @hyra = 'HYRA'set @bjorke=N'björke'set @dalhem = 'Dalhem'set @frojel = N'Fröjel'set @ganthem = 'Ganthem'set @Halla = 'Halla'set @Klinte = 'Klinte'set @Roma = 'Roma'; set @externalparam = (select query from #execution where "order" = 7) + ',@avctr nvarchar(255), @depoX varchar(255),@cont varchar(255),@grund varchar(255),@overtra nvarchar(255),@hush varchar(255),@budsm varchar(255),@hyra varchar(255)'
	set @externalQuery =  (select query from #execution where "order" = 6);

    INSERT INTO #slamx
        exec admsql01.master.dbo.sp_executesql @externalQuery, @externalparam, @bjorke=@bjorke, @dalhem=@dalhem, @frojel=@frojel, @ganthem= @ganthem, @Halla=@Halla, @Klinte= @Klinte, @Roma=@Roma,@depoX = @depoX ,@cont = @cont,@grund = @grund,@overtra = @overtra, @hush = @hush, @avctr=@avctr, @budsm = @budsm, @hyra = @hyra;
    with groupedMaxSlutdat as ( select max(stopDat) q2z,strDelprodukt, strTaxebenamning,strFastBeteckningHel, decAnlXKoordinat, decAnlYkoordinat from #slamx q group by strDelprodukt, strTaxebenamning,strFastBeteckningHel,decAnlXKoordinat,decAnlYkoordinat) , stuffedTypText as (select distinct strFastBeteckningHel, strDelprodukt, stuffing = STUFF((SELECT char(13) + nullif(' ' + concat(nullif(x.strTaxebenamning, ''), nullif(concat(' Avbrutet:', FORMAT(nullif(x.stopDat, smalldatetimefromparts(1900, 01, 01, 00, 00)), 'yyyy-MM-dd')), ' Avbrutet:')),' ') "c" FROM #slam x where q.strFastBeteckningHel = x.strFastBeteckningHel FOR XML PATH (''), root('MyString'), type).value('/MyString[1]','varchar(max)'), 1, 2, '')FROM groupedMaxSlutdat q group by strFastBeteckningHel, strDelprodukt)select *into #slam from (select strFastBeteckningHel, datStoppdatum =STUFF((SELECT char(13) + nullif(' ' + nullif(strDelprodukt + '|', '|') + stuffing, ' ') as n FROM stuffedTypText x where q.strFastBeteckningHel = x.strFastBeteckningHel FOR XML PATH (''), root('MyString'), type).value('/MyString[1]','varchar(max)'), 1, 2, '')from stuffedTypText q group by strFastBeteckningHel) stuffedWithStopDat;
    Commit Transaction --C7
    end try begin catch ROLLBACK TRANSACTION  insert into #statusTable select ERROR_MESSAGE() "E" , CURRENT_TIMESTAMP "C" , @@ROWCOUNT as [@4] print 'failed to build' end catch set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO #statusTable select 'rebuilt#' "a" ,@tid, @@ROWCOUNT as [@3]end INSERT INTO #statusTable select 'preloading#slam',CURRENT_TIMESTAMP,count(*) from #slamx
go

	declare @tid smalldatetime; begin try set @tid = CURRENT_TIMESTAMP INSERT INTO #statusTable (medelande)  select N'Starting#rodx' "a";
	BEGIN TRANSACTION --Bröd
	    IF OBJECT_ID(N'tempdb..#rodx') IS not NULL begin if (exists(select 1 from #rodx)) begin drop table #rodx INSERT INTO #statusTable (medelande)  select N'purged#rodx' "a";end end
	    Commit Transaction ;
	Begin TRANSACTION;
	with
             slam as (select strFastBeteckningHel, decAnlXKoordinat, decAnlYkoordinat, intTjanstnr, strDelprodukt, strTaxebenamning, stopDat datStoppdatum
		      from #slamx)
            ,socknarOfInteresse as (select distinct socken, fastighet from #SockenYtor )
            ,vaPlan as (select fastighet,typ  from #Spillvatten)
            ,egetOmhandertagande as ( select fastighet, egetOmhandertangandeInfo ,LocaltOmH from #egetOmhandertagande )
            ,bygFasAnl as (select anlaggningar.diarienummer,socknarOfInteresse.socken,socknarOfInteresse.fastighet,Byggnadstyp,Fastighet_tillstand,Beslut_datum,utförddatum,Anteckning, (case when anlaggningar.anlaggningspunkt is not null then anlaggningar.fstatus else '?' end) fstatus, coalesce(anlaggningar.anlaggningspunkt,ByggShape) flagga from socknarOfInteresse left outer join #ByggnadPaFastighetISocken byggnader on socknarOfInteresse.fastighet = byggnader.Fastighetsbeteckning left outer join #Socken_tillstand anlaggningar on socknarOfInteresse.fastighet = anlaggningar.fastighet where coalesce(anlaggningar.anlaggningspunkt,ByggShape) is not null)
            ,attUtsokaFran as (select *, row_number() over (partition by bygFasAnl.fastighet order by bygFasAnl.Anteckning desc ) flaggnr from bygFasAnl  where bygFasAnl.flagga is not null)
            ,q as (select attUtsokaFran.socken,attUtsokaFran.fastighet,attUtsokaFran.Fastighet_tillstand,attUtsokaFran.Diarienummer,attUtsokaFran.Byggnadstyp,Beslut_datum,utförddatum "utförddatum",attUtsokaFran.Anteckning,
                       VaPlan                   = (select top 1 typ from vaPlan where vaPlan.fastighet = attUtsokaFran.fastighet),fstatus,
                       egetOmhandertangandeInfo = (select top 1 egetOmhandertangandeInfo from egetOmhandertagande where attUtsokaFran.fastighet = egetOmhandertagande.fastighet),
                       slam                     = (select top 1 datStoppdatum from slam where attUtsokaFran.fastighet = slam.strFastBeteckningHel),flaggnr,flagga.STPointN(1) flagga from attUtsokaFran)
            ,rodx as (select socken,fastighet,Fastighet_tillstand,Byggnadstyp,Beslut_datum,utförddatum,Anteckning,VaPlan,egetOmhandertangandeInfo,slam,flaggnr,flagga,(case when (vaPlan is not null) then 'KomV' else case when fstatus = N'?' or fstatus = N'röd' then N'röd' else fstatus end end) Fstatus from q)

        select * into #rodx from rodx
	commit TRANSACTION --Cröd
	end try begin catch ROLLBACK TRANSACTION  insert into #statusTable select ERROR_MESSAGE() "E" , CURRENT_TIMESTAMP "C" , @@ROWCOUNT as [@4] print 'failed to build' end catch set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO #statusTable select 'rebuilt#' "a" ,@tid,@@ROWCOUNT as [@3]

	INSERT INTO #statusTable select N'rebuilt#rodx',CURRENT_TIMESTAMP,count(*) from #rodx


	    go IF OBJECT_ID(N'tempdb..#rodx') IS not NULL begin if not (exists(select 1 from #rodx)) begin try begin transaction IF OBJECT_ID(N'dbo..Inventering_bjorke') IS NULL       begin create table dbo.Inventering_bjorke( OBJECTID            int not null constraint invBj_pk primary key, FASTIGHET nvarchar(150),Fastighet_tillstand nvarchar(150),Arendenummer        nvarchar(50), Beslut_datum datetime2,Status              nvarchar(50),Utskick_datum       datetime2, Anteckning nvarchar(254),Utforddatum         datetime2,Slamhamtning        nvarchar(100), Antal_byggnader numeric(38, 8),alltidsant          int,Shape               geometry, GDB_GEOMATTR_DATA varbinary(max),skapad_datum        datetime2,andrad_datum        datetime2 )     /*--goto indexcheck else indexcheck: if not (exists(select 1 from sys.indexes WHERE name='YourIndexName' AND object_id = OBJECT_ID('dbo.Inventering') )) create*/end if exists(select 1 from Inventering_bjorke) begin delete from Inventering_bjorke where 1=1 end insert into dbo.Inventering_bjorke (OBJECTID, FASTIGHET,Fastighet_tillstand,  Beslut_datum,   Status,     Anteckning, Utforddatum,                Slamhamtning,                Antal_byggnader,    alltidsant,  Shape,  skapad_datum,   andrad_datum) select (row_number() over (order by fastighet,flaggnr)) "a",    fastighet,Fastighet_tillstand,  Beslut_datum,   Fstatus, concat(Byggnadstyp,' ',Anteckning,' ',nullif(concat('vaPlan: ',VaPlan,' '),'vaPlan:  '),nullif(concat('egetOmh: ',egetOmhandertangandeInfo,' '),'egetOmh:  ')), utförddatum,                slam, flaggnr,            1,           flagga, CURRENT_TIMESTAMP,CURRENT_TIMESTAMP
	       from #rodx where Socken = 'björke';
	    commit transaction end try begin catch rollback transaction end catch end go

	    go IF OBJECT_ID(N'tempdb..#rodx') IS not NULL begin if not (exists(select 1 from #rodx)) begin try begin transaction IF OBJECT_ID(N'dbo..Inventering_dalhem') IS NULL       begin create table dbo.Inventering_dalhem( OBJECTID            int not null constraint invBj_pk primary key, FASTIGHET nvarchar(150),Fastighet_tillstand nvarchar(150),Arendenummer        nvarchar(50), Beslut_datum datetime2,Status              nvarchar(50),Utskick_datum       datetime2, Anteckning nvarchar(254),Utforddatum         datetime2,Slamhamtning        nvarchar(100), Antal_byggnader numeric(38, 8),alltidsant          int,Shape               geometry, GDB_GEOMATTR_DATA varbinary(max),skapad_datum        datetime2,andrad_datum        datetime2 )     /*--goto indexcheck else indexcheck: if not (exists(select 1 from sys.indexes WHERE name='YourIndexName' AND object_id = OBJECT_ID('dbo.Inventering') )) create*/end if exists(select 1 from Inventering_dalhem) begin delete from Inventering_dalhem where 1=1 end insert into dbo.Inventering_dalhem (OBJECTID, FASTIGHET,Fastighet_tillstand,  Beslut_datum,   Status,     Anteckning, Utforddatum,                Slamhamtning,                Antal_byggnader,    alltidsant,  Shape,  skapad_datum,   andrad_datum) select (row_number() over (order by fastighet,flaggnr)) "a",    fastighet,Fastighet_tillstand,  Beslut_datum,   Fstatus, concat(Byggnadstyp,' ',Anteckning,' ',nullif(concat('vaPlan: ',VaPlan,' '),'vaPlan:  '),nullif(concat('egetOmh: ',egetOmhandertangandeInfo,' '),'egetOmh:  ')), utförddatum,                slam, flaggnr,            1,           flagga, CURRENT_TIMESTAMP,CURRENT_TIMESTAMP
	       from #rodx where Socken = 'dalhem';
	    commit transaction end try begin catch rollback transaction end catch end go

	    go IF OBJECT_ID(N'tempdb..#rodx') IS not NULL begin if not (exists(select 1 from #rodx)) begin try begin transaction IF OBJECT_ID(N'dbo..Inventering_frojel') IS NULL       begin create table dbo.Inventering_frojel( OBJECTID            int not null constraint invBj_pk primary key, FASTIGHET nvarchar(150),Fastighet_tillstand nvarchar(150),Arendenummer        nvarchar(50), Beslut_datum datetime2,Status              nvarchar(50),Utskick_datum       datetime2, Anteckning nvarchar(254),Utforddatum         datetime2,Slamhamtning        nvarchar(100), Antal_byggnader numeric(38, 8),alltidsant          int,Shape               geometry, GDB_GEOMATTR_DATA varbinary(max),skapad_datum        datetime2,andrad_datum        datetime2 )     /*--goto indexcheck else indexcheck: if not (exists(select 1 from sys.indexes WHERE name='YourIndexName' AND object_id = OBJECT_ID('dbo.Inventering') )) create*/end if exists(select 1 from Inventering_frojel) begin delete from Inventering_frojel where 1=1 end insert into dbo.Inventering_frojel (OBJECTID, FASTIGHET,Fastighet_tillstand,  Beslut_datum,   Status,     Anteckning, Utforddatum,                Slamhamtning,                Antal_byggnader,    alltidsant,  Shape,  skapad_datum,   andrad_datum) select (row_number() over (order by fastighet,flaggnr)) "a",    fastighet,Fastighet_tillstand,  Beslut_datum,   Fstatus, concat(Byggnadstyp,' ',Anteckning,' ',nullif(concat('vaPlan: ',VaPlan,' '),'vaPlan:  '),nullif(concat('egetOmh: ',egetOmhandertangandeInfo,' '),'egetOmh:  ')), utförddatum,                slam, flaggnr,            1,           flagga, CURRENT_TIMESTAMP,CURRENT_TIMESTAMP
	       from #rodx where Socken = 'fröjel';
	    commit transaction end try begin catch rollback transaction end catch end go

	    go IF OBJECT_ID(N'tempdb..#rodx') IS not NULL begin if not (exists(select 1 from #rodx)) begin try begin transaction IF OBJECT_ID(N'dbo..Inventering_Ganthem') IS NULL       begin create table dbo.Inventering_Ganthem( OBJECTID            int not null constraint invBj_pk primary key, FASTIGHET nvarchar(150),Fastighet_tillstand nvarchar(150),Arendenummer        nvarchar(50), Beslut_datum datetime2,Status              nvarchar(50),Utskick_datum       datetime2, Anteckning nvarchar(254),Utforddatum         datetime2,Slamhamtning        nvarchar(100), Antal_byggnader numeric(38, 8),alltidsant          int,Shape               geometry, GDB_GEOMATTR_DATA varbinary(max),skapad_datum        datetime2,andrad_datum        datetime2 )     /*--goto indexcheck else indexcheck: if not (exists(select 1 from sys.indexes WHERE name='YourIndexName' AND object_id = OBJECT_ID('dbo.Inventering') )) create*/end if exists(select 1 from Inventering_Ganthem) begin delete from Inventering_Ganthem where 1=1 end insert into dbo.Inventering_Ganthem (OBJECTID, FASTIGHET,Fastighet_tillstand,  Beslut_datum,   Status,     Anteckning, Utforddatum,                Slamhamtning,                Antal_byggnader,    alltidsant,  Shape,  skapad_datum,   andrad_datum) select (row_number() over (order by fastighet,flaggnr)) "a",    fastighet,Fastighet_tillstand,  Beslut_datum,   Fstatus, concat(Byggnadstyp,' ',Anteckning,' ',nullif(concat('vaPlan: ',VaPlan,' '),'vaPlan:  '),nullif(concat('egetOmh: ',egetOmhandertangandeInfo,' '),'egetOmh:  ')), utförddatum,                slam, flaggnr,            1,           flagga, CURRENT_TIMESTAMP,CURRENT_TIMESTAMP
	       from #rodx where Socken = 'Ganthem';
	    commit transaction end try begin catch rollback transaction end catch end go

	    go IF OBJECT_ID(N'tempdb..#rodx') IS not NULL begin if not (exists(select 1 from #rodx)) begin try begin transaction IF OBJECT_ID(N'dbo..Inventering_Halla') IS NULL       begin create table dbo.Inventering_Halla( OBJECTID            int not null constraint invBj_pk primary key, FASTIGHET nvarchar(150),Fastighet_tillstand nvarchar(150),Arendenummer        nvarchar(50), Beslut_datum datetime2,Status              nvarchar(50),Utskick_datum       datetime2, Anteckning nvarchar(254),Utforddatum         datetime2,Slamhamtning        nvarchar(100), Antal_byggnader numeric(38, 8),alltidsant          int,Shape               geometry, GDB_GEOMATTR_DATA varbinary(max),skapad_datum        datetime2,andrad_datum        datetime2 )     /*--goto indexcheck else indexcheck: if not (exists(select 1 from sys.indexes WHERE name='YourIndexName' AND object_id = OBJECT_ID('dbo.Inventering') )) create*/end if exists(select 1 from Inventering_Halla) begin delete from Inventering_Halla where 1=1 end insert into dbo.Inventering_Halla (OBJECTID, FASTIGHET,Fastighet_tillstand,  Beslut_datum,   Status,     Anteckning, Utforddatum,                Slamhamtning,                Antal_byggnader,    alltidsant,  Shape,  skapad_datum,   andrad_datum) select (row_number() over (order by fastighet,flaggnr)) "a",    fastighet,Fastighet_tillstand,  Beslut_datum,   Fstatus, concat(Byggnadstyp,' ',Anteckning,' ',nullif(concat('vaPlan: ',VaPlan,' '),'vaPlan:  '),nullif(concat('egetOmh: ',egetOmhandertangandeInfo,' '),'egetOmh:  ')), utförddatum,                slam, flaggnr,            1,           flagga, CURRENT_TIMESTAMP,CURRENT_TIMESTAMP
	       from #rodx where Socken = 'Halla';
	    commit transaction end try begin catch rollback transaction end catch end go

	    go IF OBJECT_ID(N'tempdb..#rodx') IS not NULL begin if not (exists(select 1 from #rodx)) begin try begin transaction IF OBJECT_ID(N'dbo..Inventering_Klinte') IS NULL       begin create table dbo.Inventering_Klinte( OBJECTID            int not null constraint invBj_pk primary key, FASTIGHET nvarchar(150),Fastighet_tillstand nvarchar(150),Arendenummer        nvarchar(50), Beslut_datum datetime2,Status              nvarchar(50),Utskick_datum       datetime2, Anteckning nvarchar(254),Utforddatum         datetime2,Slamhamtning        nvarchar(100), Antal_byggnader numeric(38, 8),alltidsant          int,Shape               geometry, GDB_GEOMATTR_DATA varbinary(max),skapad_datum        datetime2,andrad_datum        datetime2 )     /*--goto indexcheck else indexcheck: if not (exists(select 1 from sys.indexes WHERE name='YourIndexName' AND object_id = OBJECT_ID('dbo.Inventering') )) create*/end if exists(select 1 from Inventering_Klinte) begin delete from Inventering_Klinte where 1=1 end insert into dbo.Inventering_Klinte (OBJECTID, FASTIGHET,Fastighet_tillstand,  Beslut_datum,   Status,     Anteckning, Utforddatum,                Slamhamtning,                Antal_byggnader,    alltidsant,  Shape,  skapad_datum,   andrad_datum) select (row_number() over (order by fastighet,flaggnr)) "a",    fastighet,Fastighet_tillstand,  Beslut_datum,   Fstatus, concat(Byggnadstyp,' ',Anteckning,' ',nullif(concat('vaPlan: ',VaPlan,' '),'vaPlan:  '),nullif(concat('egetOmh: ',egetOmhandertangandeInfo,' '),'egetOmh:  ')), utförddatum,                slam, flaggnr,            1,           flagga, CURRENT_TIMESTAMP,CURRENT_TIMESTAMP
	       from #rodx where Socken = 'Klinte';
	    commit transaction end try begin catch rollback transaction end catch end go

	    go IF OBJECT_ID(N'tempdb..#rodx') IS not NULL begin if not (exists(select 1 from #rodx)) begin try begin transaction IF OBJECT_ID(N'dbo..Inventering_Roma') IS NULL       begin create table dbo.Inventering_Roma( OBJECTID            int not null constraint invBj_pk primary key, FASTIGHET nvarchar(150),Fastighet_tillstand nvarchar(150),Arendenummer        nvarchar(50), Beslut_datum datetime2,Status              nvarchar(50),Utskick_datum       datetime2, Anteckning nvarchar(254),Utforddatum         datetime2,Slamhamtning        nvarchar(100), Antal_byggnader numeric(38, 8),alltidsant          int,Shape               geometry, GDB_GEOMATTR_DATA varbinary(max),skapad_datum        datetime2,andrad_datum        datetime2 )     /*--goto indexcheck else indexcheck: if not (exists(select 1 from sys.indexes WHERE name='YourIndexName' AND object_id = OBJECT_ID('dbo.Inventering') )) create*/end if exists(select 1 from Inventering_Roma) begin delete from Inventering_Roma where 1=1 end insert into dbo.Inventering_Roma (OBJECTID, FASTIGHET,Fastighet_tillstand,  Beslut_datum,   Status,     Anteckning, Utforddatum,                Slamhamtning,                Antal_byggnader,    alltidsant,  Shape,  skapad_datum,   andrad_datum) select (row_number() over (order by fastighet,flaggnr)) "a",    fastighet,Fastighet_tillstand,  Beslut_datum,   Fstatus, concat(Byggnadstyp,' ',Anteckning,' ',nullif(concat('vaPlan: ',VaPlan,' '),'vaPlan:  '),nullif(concat('egetOmh: ',egetOmhandertangandeInfo,' '),'egetOmh:  ')), utförddatum,                slam, flaggnr,            1,           flagga, CURRENT_TIMESTAMP,CURRENT_TIMESTAMP
	       from #rodx where Socken = 'Roma';
	    commit transaction end try begin catch rollback transaction end catch end go

	    select * from #rodx
	    select * from #statusTable

	    select #rodx.* from #rodx
	    left outer join tempExcel.dbo.AllaFastigheter2020 on AllaFastigheter2020.fastighet = #rodx.fastighet OR #rodx.fastighet = AllaFastigheter2020.socken where AllaFastigheter2020.fastighet is null
	    and #rodx.fstatus = 'röd'
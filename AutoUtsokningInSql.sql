/*Insert Databases names into SQL Temp Table*/
IF OBJECT_ID('tempdb..#statusTable') IS not NULL begin    Drop table #statusTable end

create table #statusTable (medelande NVARCHAR(max),start smalldatetime,rader integer);
declare @tid smalldatetime;

-- dropTabels?

if (select 1) IS NULL BEGIN TRY
    BEGIN TRANSACTION
    Drop table #SockenYtor
    Drop table #ByggnadPaFastighetISocken
    Drop table #Socken_tillstand
    Drop table #egetOmhandertagande
    Drop table #Spillvatten
    Drop table #slam
    Drop table #rodx
    Commit Transaction
 end try begin catch
    ROLLBACK TRANSACTION  insert into #statusTable select ERROR_MESSAGE() "m",CURRENT_TIMESTAMP "t",@@ROWCOUNT  "c"print 'failed to build'  end catch
set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO #statusTable select 'built#',@tid,@@ROWCOUNT ; --koden skall inte exekveras i läsordning, alla initiate test moste först slutföras, sedan går programmet till repportblocket.

go
INSERT INTO #statusTable (medelande) select '#initiating#SockenYtor' as alias;
declare @tid smalldatetime;
IF OBJECT_ID('tempdb..#SockenYtor') IS not NULL
    begin if not (exists(select 1 from #SockenYtor)) begin drop table #SockenYtor;end end
IF OBJECT_ID('tempdb..#SockenYtor') IS NULL
    begin try
    set @tid = CURRENT_TIMESTAMP ;
    INSERT INTO #statusTable (medelande) select 'Starting#SockenYtor' as alias
BEGIN TRANSACTION

    declare @externalQuery nvarchar(max), @externalparam nvarchar(255), @bjorke nvarchar(255),@dalhem varchar(255),@frojel nvarchar(255),@ganthem varchar(255),@Halla varchar(255),@Klinte varchar(255),@Roma varchar(255)
    set @bjorke=N'björke'set @dalhem = 'Dalhem'set @frojel = N'Fröjel'set @ganthem = 'Ganthem'set @Halla = 'Halla'set @Klinte = 'Klinte'set @Roma = 'Roma';
    set @externalparam = N'@bjorke nvarchar(255) , @dalhem varchar(255) , @frojel nvarchar(255) , @ganthem varchar(255) , @Halla varchar(255) , @Klinte varchar(255) ,  @Roma varchar(255)'
    set @externalQuery =  'with fastighetsfilter as (Select  @bjorke  "socken" Union Select @dalhem  "a" Union Select @frojel  "a" Union Select  @ganthem "a" Union Select   @Halla "a" Union Select  @Klinte  "a" Union Select  @Roma   "a" )'+
                          ',socknarOfIntresse as (SELECT fastighetsFilter.socken SockenX,concat(Trakt,SPACE(1),Blockenhet) FAStighet, Shape from sde_gsd.gng.AY_0980 x inner join fastighetsFilter on left(x.TRAKT, len(fastighetsfilter.socken)) = fastighetsfilter.socken)' +
                          'select * from socknarOfIntresse'

    CREATE TABLE #SockenYtor
    (
        socken nvarchar(100),
        FAStighet nvarchar (250),
        Shape geometry
    )

    INSERT INTO #SockenYtor
    exec
        gisdb01.master.dbo.sp_executesql @externalQuery,
             @externalparam,
             @bjorke=@bjorke, @dalhem=@dalhem, @frojel=@frojel, @ganthem= @ganthem, @Halla=@Halla, @Klinte= @Klinte, @Roma=@Roma

Commit Transaction
    end try
        begin catch ROLLBACK TRANSACTION  insert into #statusTable select ERROR_MESSAGE() "E" , CURRENT_TIMESTAMP "C" , @@ROWCOUNT as [@4] print 'failed to build' end catch
    set @tid = CURRENT_TIMESTAMP - @tid
INSERT INTO #statusTable select 'rebuilt#' "a" ,@tid, @@ROWCOUNT as [@3] INSERT INTO #statusTable
select 'preloading#SockenYtor'
  ,CURRENT_TIMESTAMP,count(*) from #SockenYtor;

go
declare @tid smalldatetime;
INSERT INTO #statusTable (medelande) select '#initiating#Byggnader' "a" ;
IF OBJECT_ID(N'tempdb..#ByggnadPaFastighetISocken') is not null
    begin if not (exists(select 1 from #ByggnadPaFastighetISocken))
         begin drop table #ByggnadPaFastighetISocken;
         end end
 IF OBJECT_ID(N'tempdb..#ByggnadPaFastighetISocken') is null
         begin
set @tid = CURRENT_TIMESTAMP INSERT INTO #statusTable (medelande)  select 'Starting#Byggnadsyta' "a"
BEGIN TRY
    BEGIN TRANSACTION

    declare @externalQuery nvarchar(max), @externalparam nvarchar(255), @bjorke nvarchar(255),@dalhem varchar(255),@frojel nvarchar(255),@ganthem varchar(255),@Halla varchar(255),@Klinte varchar(255),@Roma varchar(255)
    set @bjorke=N'björke'set @dalhem = 'Dalhem'set @frojel = N'Fröjel'set @ganthem = 'Ganthem'set @Halla = 'Halla'set @Klinte = 'Klinte'set @Roma = 'Roma';
    set @externalparam = N'@bjorke nvarchar(255) , @dalhem varchar(255) , @frojel nvarchar(255) , @ganthem varchar(255) , @Halla varchar(255) , @Klinte varchar(255) ,  @Roma varchar(255)'
    set @externalQuery = 'with fastighetsfilter as (Select  @bjorke  "socken" Union Select @dalhem  "a" Union Select @frojel  "a" Union Select  @ganthem "a" Union Select   @Halla "a" Union Select  @Klinte  "a" Union Select  @Roma   "a" )'+
                        ',socknarOfIntresse as (SELECT fastighetsFilter.socken SockenX,concat(Trakt,SPACE(1),Blockenhet) FAStighet, Shape from sde_gsd.gng.AY_0980 x inner join fastighetsFilter on left(x.TRAKT, len(fastighetsFilter.socken)) = fastighetsFilter.socken )' +
                        ',byggnad_yta as (select andamal_1T Byggnadstyp, Shape from sde_gsd.gng.BY_0980),q as (Select Byggnadstyp, socknarOfIntresse.fastighet Fastighetsbeteckning, byggnad_yta.SHAPE from byggnad_yta inner join socknarOfIntresse on byggnad_yta.Shape.STIntersects(socknarOfIntresse.shape) = 1) ' +
                        'select Fastighetsbeteckning, Byggnadstyp,shape ByggShape from (select *, row_number() over (partition by Fastighetsbeteckning order by Byggnadstyp ) orderz from q) z where orderz = 1'
select @externalQuery
     CREATE TABLE #ByggnadPaFastighetISocken
    (
        Fastighetsbeteckning nvarchar (250),
        Byggnadstyp nvarchar(100),
        ByggShape geometry
    )

    INSERT INTO #ByggnadPaFastighetISocken
    exec
        gisdb01.master.dbo.sp_executesql @externalQuery,
             @externalparam,
             @bjorke=@bjorke, @dalhem=@dalhem, @frojel=@frojel, @ganthem= @ganthem, @Halla=@Halla, @Klinte= @Klinte, @Roma=@Roma

    Commit Transaction
--    drop table #ByggnadPaFastighetISocken
   end try begin catch
    ROLLBACK TRANSACTION  insert into #statusTable select ERROR_MESSAGE() "E" , CURRENT_TIMESTAMP "C" , @@ROWCOUNT as [@5] print 'failed to build'  end catch set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO #statusTable select 'rebuilt#' "a" ,@tid, @@ROWCOUNT as [@6]
end  INSERT INTO #statusTable select 'preloading#ByggnadPaFastighetISocken', CURRENT_TIMESTAMP,     count(*) from #ByggnadPaFastighetISocken;

go
declare @tid smalldatetime;
INSERT INTO #statusTable (medelande) select N'#initiating#sockenTillstånd' "a" ;
IF OBJECT_ID(N'tempdb..#Socken_tillstand') IS not  NULL
begin if not  (exists(select 1 from #Socken_tillstand))
        begin drop table #Socken_tillstand;
        end end
IF OBJECT_ID(N'tempdb..#Socken_tillstand') IS NULL
         begin
set @tid = CURRENT_TIMESTAMP INSERT INTO #statusTable (medelande)  select 'Starting#Socken_tillstand' "a"
BEGIN TRY
    BEGIN TRANSACTION

    declare @externalQuery nvarchar(max), @externalparam nvarchar(255), @bjorke nvarchar(255),@dalhem varchar(255),@frojel nvarchar(255),@ganthem varchar(255),@Halla varchar(255),@Klinte varchar(255),@Roma varchar(255)
    set @bjorke=N'björke'set @dalhem = 'Dalhem'set @frojel = N'Fröjel'set @ganthem = 'Ganthem'set @Halla = 'Halla'set @Klinte = 'Klinte'set @Roma = 'Roma';
    set @externalparam = N'@bjorke nvarchar(255) , @dalhem varchar(255) , @frojel nvarchar(255) , @ganthem varchar(255) , @Halla varchar(255) , @Klinte varchar(255) ,  @Roma varchar(255)'

    set @externalQuery = 'with fastighetsfilter as (Select  @bjorke  "socken" Union Select @dalhem  "a" Union Select @frojel  "a" Union Select  @ganthem "a" Union Select   @Halla "a" Union Select  @Klinte  "a" Union Select  @Roma   "a" )'+
                        ',socknarOfIntresse as (SELECT fastighetsFilter.socken SockenX,concat(Trakt,SPACE(1),Blockenhet) FAStighet, Shape from sde_gsd.gng.AY_0980 x inner join fastighetsFilter on left(x.TRAKT, len(fastighetsFilter.socken)) = fastighetsFilter.socken )' +
                          N',AnSoMedSocken as (select left(Fastighet_tillstand, case when charindex(SPACE(1), Fastighet_tillstand) = 0 then len(Fastighet_tillstand) + 1 else charindex(SPACE(1), Fastighet_tillstand) end - 1) socken,Diarienummer,Fastighet_tillstand   z,Beslut_datum,Utford_datum,Anteckning,Shape                 anlShape from sde_miljo_halsoskydd.gng.ENSKILT_AVLOPP_sodra_P), AnNoMedSocken as (select left(Fastighet_tillstand, case when charindex(SPACE(1), Fastighet_tillstand) = 0 then len(Fastighet_tillstand) + 1 else charindex(SPACE(1), Fastighet_tillstand) end - 1) socken,Diarienummer,Fastighet_tillstand   z,Beslut_datum,Utford_datum,Anteckning,Shape                 anlShape from sde_miljo_halsoskydd.gng.ENSKILT_AVLOPP_Norra_P), AnMeMedSocken as (select left(Fastighet_tilstand, case when charindex(SPACE(1), Fastighet_tilstand) = 0 then len(Fastighet_tilstand) + 1 else charindex(SPACE(1), Fastighet_tilstand) end - 1) socken,Diarienummer,Fastighet_tilstand                                                            z,Beslut_datum,Utford_datum,Anteckning,Shape               anlShape from sde_miljo_halsoskydd.gng.ENSKILT_AVLOPP_MELLERSTA_P),SodraFiltrerad as (select Diarienummer, z q, Beslut_datum, Utford_datum, Anteckning, AllaAvlopp.anlShape, FAStighet from AnSoMedSocken AllaAvlopp inner join(select FiltreradeFast.*from socknarOfIntresse FiltreradeFast inner join (select socken from AnSoMedSocken group by socken) q on socken = sockenX) FFast on AllaAvlopp.socken = ffast.SockenX and AllaAvlopp.anlShape.STIntersects(FFast.Shape) = 1), NorraFiltrerad as (select Diarienummer, z q, Beslut_datum, Utford_datum, Anteckning, AllaAvlopp.anlShape, FAStighet from AnNoMedSocken AllaAvlopp inner join(select FiltreradeFast.*from socknarOfIntresse FiltreradeFast inner join (select socken from AnNoMedSocken group by socken) q on socken = sockenX) FFast on AllaAvlopp.socken = ffast.SockenX and AllaAvlopp.anlShape.STIntersects(FFast.Shape) = 1), MellerstaFiltrerad as (select Diarienummer, z q, Beslut_datum, Utford_datum, Anteckning, AllaAvlopp.anlShape, FAStighet from AnMeMedSocken AllaAvlopp inner join(select FiltreradeFast.*from socknarOfIntresse FiltreradeFast inner join (select socken from AnMeMedSocken group by socken) q on socken = sockenX) FFast on AllaAvlopp.socken = ffast.SockenX and AllaAvlopp.anlShape.STIntersects(FFast.Shape) = 1), SammanSlagna as (select Diarienummer, q "Fastighet_tillstand",isnull(TRY_CONVERT(DateTime, Beslut_datum,102), DATETIME2FROMPARTS(1988, 1, 1, 1, 1, 1, 1, 1)) Beslut_datum, isnull(TRY_CONVERT(DateTime, Utford_datum,102), DATETIME2FROMPARTS(1988, 1, 1, 1, 1, 1, 1, 1)) Utford_datum, Anteckning, anlShape, FAStighet from (select * from SodraFiltrerad union all select * from NorraFiltrerad union all select * from MellerstaFiltrerad) z) ' +
                          N'select FAStighet,Diarienummer,Fastighet_tillstand,Beslut_datum,Utford_datum "utförddatum",Anteckning,anlShape     AnlaggningsPunkt from SammanSlagna'

     CREATE TABLE #Socken_tillstand
    (
        FAStighet nvarchar (250),
        Diarienummer nvarchar (250),
        Fastighet_tillstand nvarchar (250),
        Beslut_datum smalldatetime,
        utförddatum smalldatetime,
        Anteckning nvarchar (max),
        AnlaggningsPunkt geometry,
        fstatus as (case when not (Beslut_datum > DATETIME2FROMPARTS(2003, 1, 1, 1, 1, 1, 1, 1) and utförddatum > DATETIME2FROMPARTS(2003, 1, 1, 1, 1, 1, 1, 1)) then N'röd' else N'grön' end)
    )

    INSERT INTO #Socken_tillstand (FAStighet,
        Diarienummer,
        Fastighet_tillstand,
        Beslut_datum,
        utförddatum,
        Anteckning,
        AnlaggningsPunkt)
    exec
        gisdb01.master.dbo.sp_executesql @externalQuery,
             @externalparam,
             @bjorke=@bjorke, @dalhem=@dalhem, @frojel=@frojel, @ganthem= @ganthem, @Halla=@Halla, @Klinte= @Klinte, @Roma=@Roma

    Commit Transaction
    end try begin catch
    ROLLBACK TRANSACTION  insert into #statusTable select ERROR_MESSAGE() "M" , CURRENT_TIMESTAMP "C" , @@ROWCOUNT as [@7]
print 'failed to build'  end catch set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO #statusTable select 'rebuilt#' "a" ,@tid, @@ROWCOUNT as [@8]
end
    INSERT INTO #statusTable select 'preloading#Socken_tillstand',CURRENT_TIMESTAMP,count(*) from
#Socken_tillstand;

go
declare @tid smalldatetime;
INSERT INTO #statusTable (medelande) select N'#initiating#egetOmhandertagande' "a" ;
IF OBJECT_ID(N'tempdb..#egetOmhandertagande') IS not NULL
begin if not  (exists(select 1 from #egetOmhandertagande))
        begin drop table #egetOmhandertagande;
        end end
IF OBJECT_ID(N'tempdb..#egetOmhandertagande') IS NULL
    begin
set @tid = CURRENT_TIMESTAMP INSERT INTO #statusTable (medelande)  select 'Starting#egetOmhandertagande' "a"
BEGIN TRY
        BEGIN TRANSACTION

    declare @externalQuery nvarchar(max), @externalparam nvarchar(255), @bjorke nvarchar(255),@dalhem varchar(255),@frojel nvarchar(255),@ganthem varchar(255),@Halla varchar(255),@Klinte varchar(255),@Roma varchar(255)
    set @bjorke=N'björke'set @dalhem = 'Dalhem'set @frojel = N'Fröjel'set @ganthem = 'Ganthem'set @Halla = 'Halla'set @Klinte = 'Klinte'set @Roma = 'Roma';
    set @externalparam = N'@bjorke nvarchar(255) , @dalhem varchar(255) , @frojel nvarchar(255) , @ganthem varchar(255) , @Halla varchar(255) , @Klinte varchar(255) ,  @Roma varchar(255)'

    set @externalQuery = '
    with fastighetsfilter as (Select  @bjorke  "socken" Union Select @dalhem  "a" Union Select @frojel  "a" Union Select  @ganthem "a" Union Select   @Halla "a" Union Select  @Klinte  "a" Union Select  @Roma   "a" )'+
                          ',socknarOfIntresse as (SELECT fastighetsFilter.socken SockenX,concat(Trakt,SPACE(1),Blockenhet) FAStighet, Shape from sde_gsd.gng.AY_0980 x inner join fastighetsFilter on left(x.TRAKT, len(fastighetsFilter.socken)) = fastighetsFilter.socken )' +
                         N',LOKALT_SLAM_P as (select Diarienr,Fastighet_,Fastighe00,Eget_omhän,Lokalt_omh,Anteckning,Beslutsdat,shape from sde_miljo_halsoskydd.gng.MoH_Slam_Lokalt_p_evw),
                                                   Fas2 as (select *,concat(nullif(LOKALT_SLAM_P.Lokalt_omh + space(1), space(1)), nullif(LOKALT_SLAM_P.Fastighet_ + space(1), space(1)), nullif(LOKALT_SLAM_P.Fastighe00 + space(1), space(1))) fas from sde_miljo_halsoskydd.gng.MoH_Slam_Lokalt_p_evw LOKALT_SLAM_P),

                                                   Med_fastighet as (select Fastighet_,Fastighets,Eget_omhän,Lokalt_omh,Fastighe00,Beslutsdat,Diarienr,Anteckning,shape LocaltOmH,fas from Fas2 where fas is not null and charindex(char(58), fas) > 0),
                                                   utan_fastighet as (select Fastighet_,Fastighets,Eget_omhän,Lokalt_omh,Fastighe00,Beslutsdat,Diarienr,Anteckning,utan_fastighet.shape LocaltOmH,FAStighet            fas
                                                   from (select * from Fas2 where fas is null OR charindex(char(58), fas) = 0) utan_fastighet inner join socknarOfIntresse sYt on sYt.shape.STIntersects(utan_fastighet.Shape) = 1)

                                              select Fastighet_, Fastighets, Eget_omhän, Lokalt_omh, Fastighe00, Beslutsdat, Diarienr, Anteckning,LocaltOmH, FAStighet
                                                    from socknarOfIntresse sYt left outer join Med_fastighet on fas like char(37) + sYt.Fastighet + char(37) where fas is not null union all select * from utan_fastighet
                                              ';

     CREATE TABLE #egetOmhandertagande
    (
        Fastighet_ nvarchar(250),
        Fastighets nvarchar(250),
        Eget_omhän nvarchar(250),
        Lokalt_omh nvarchar(250),
        Fastighe00 nvarchar(250),
        Beslutsdat smalldatetime,
        Diarienr   nvarchar(250),
        Anteckning nvarchar(250),
        LocaltOmH  geometry,
        fastighet  nvarchar (250),
      egetOmhandertangandeInfo as (
  concat(nullif( 'DiaNr: '+ ltrim(Diarienr), 'DiaNr: '), nullif(' - ' + ltrim(Fastighe00), ' - '), nullif(' - ' + ltrim(Fastighet_), ' - '), nullif(' - ' + ltrim(Eget_omhän), ' - '), nullif(' - ' + ltrim(Lokalt_omh), ' - '), nullif(' - ' + ltrim(Anteckning), ' - '),nullif('. BeslDat: ' + FORMAT(Beslutsdat,'yyyy-MM-dd'), ' BeslDat: ')) )
    )
    INSERT INTO #egetOmhandertagande (Fastighet_,Fastighets,Eget_omhän,Lokalt_omh,Fastighe00,Beslutsdat,Diarienr,Anteckning,LocaltOmH,
        fastighet)
    exec
        gisdb01.master.dbo.sp_executesql @externalQuery,
             @externalparam,
             @bjorke=@bjorke, @dalhem=@dalhem, @frojel=@frojel, @ganthem= @ganthem, @Halla=@Halla, @Klinte= @Klinte, @Roma=@Roma
    Commit Transaction
--    drop table #egetOmhandertagande
    end try begin catch ROLLBACK TRANSACTION  insert into #statusTable select ERROR_MESSAGE() "E" , CURRENT_TIMESTAMP "C" , @@ROWCOUNT as [@4] print 'failed to build' end catch set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO #statusTable select 'rebuilt#' "a" ,@tid, @@ROWCOUNT as [@3]end INSERT INTO #statusTable select
'preloading#egetOmhandertagande'
  ,CURRENT_TIMESTAMP,count(*) from
#egetOmhandertagande;
go
declare @tid smalldatetime;
INSERT INTO #statusTable (medelande) select '#initiating#Spillvatten' "a" ;
IF OBJECT_ID('tempdb..#Spillvatten') IS not NULL
begin if not (exists(select 1 from #Spillvatten))
begin drop table #Spillvatten
    end end
IF OBJECT_ID('tempdb..#Spillvatten') IS NULL
    begin
set @tid = CURRENT_TIMESTAMP INSERT INTO #statusTable (medelande)  select 'Starting#Spillvatten' "a"
BEGIN TRY
    BEGIN TRANSACTION

    declare @externalQuery nvarchar(max), @externalparam nvarchar(255), @bjorke nvarchar(255),@dalhem varchar(255),@frojel nvarchar(255),@ganthem varchar(255),@Halla varchar(255),@Klinte varchar(255),@Roma varchar(255)
    set @bjorke=N'björke'set @dalhem = 'Dalhem'set @frojel = N'Fröjel'set @ganthem = 'Ganthem'set @Halla = 'Halla'set @Klinte = 'Klinte'set @Roma = 'Roma';
    set @externalparam = N'@bjorke nvarchar(255) , @dalhem varchar(255) , @frojel nvarchar(255) , @ganthem varchar(255) , @Halla varchar(255) , @Klinte varchar(255) ,  @Roma varchar(255)'

    set @externalQuery =  'with fastighetsfilter as (Select  @bjorke  "socken" Union Select @dalhem  "a" Union Select @frojel  "a" Union Select  @ganthem "a" Union Select   @Halla "a" Union Select  @Klinte  "a" Union Select  @Roma   "a" )'+
                          ',socknarOfIntresse as (SELECT fastighetsFilter.socken SockenX,concat(Trakt,SPACE(1),Blockenhet) FAStighet, Shape from sde_gsd.gng.AY_0980 x inner join fastighetsFilter on left(x.TRAKT, len(fastighetsFilter.socken)) = fastighetsFilter.socken )' +
                        N',Va_planomraden_171016_evw as (select shape,dp_i_omr,planprog,planansokn from sde_pipe.gng.Va_planomraden_171016_evw),q as ( select shape, concat(typkod,'':'',status,''(spill)'') typ from sde_pipe.gng.VO_Spillvatten_evw VO_Spillvatten_evw union all select shape, concat(''AVTALSABONNENT [Tabell_ObjID: '',OBJECTID,'']'') "c"  from sde_pipe.gng.AVTALSABONNENTER AVTALSABONNENTER union all select shape, concat(''GEMENSAMHETSANLAGGNING: '',GEMENSAMHETSANLAGGNINGAR.GA) "c"  from sde_pipe.gng.GEMENSAMHETSANLAGGNINGAR GEMENSAMHETSANLAGGNINGAR union all select shape,isnull(coalesce(nullif(concat(''dp_i_omr:'',dp_i_omr) ,''dp_i_omr:''), nullif(concat(''planprog:'',planprog) ,''planprog:''), nullif(concat(''planansokn:'',planansokn) ,''planansokn:'')),N''okändStatus'') "i"  from Va_planomraden_171016_evw)' +
                       N'select sYt.fastighet, q.typ  from socknarOfIntresse sYt inner join q on sYt.shape.STIntersects(q.Shape) = 1';

    CREATE TABLE #Spillvatten
    (
        fastighet  nvarchar (250),typ nvarchar (max)
    )
    INSERT INTO #Spillvatten
    exec
        gisdb01.master.dbo.sp_executesql @externalQuery,
             @externalparam,
             @bjorke=@bjorke, @dalhem=@dalhem, @frojel=@frojel, @ganthem= @ganthem, @Halla=@Halla, @Klinte= @Klinte, @Roma=@Roma
Commit Transaction


    end try begin catch ROLLBACK TRANSACTION  insert into #statusTable select ERROR_MESSAGE() "E" , CURRENT_TIMESTAMP "C" , @@ROWCOUNT as [@4] print 'failed to build' end catch set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO #statusTable select 'rebuilt#' "a" ,@tid, @@ROWCOUNT as [@3]end INSERT INTO #statusTable select
    'preloading#Spillvatten'
      ,CURRENT_TIMESTAMP,count(*) from
#Spillvatten;


go
declare @tid smalldatetime;
INSERT INTO #statusTable (medelande) select '#initiating#slam' "a" ;
    IF OBJECT_ID('tempdb..#slam') IS not NULL
    begin if not (exists(select 1 from #slam )) begin drop table #slam
        end end
IF OBJECT_ID(N'tempdb..#slamx') IS not NULL
        begin DROP TABLE #slamx end
IF OBJECT_ID(
 N'tempdb..#slam') IS NULL
 begin
set @tid = CURRENT_TIMESTAMP INSERT INTO #statusTable (medelande)  select 'Starting#slam' "a"
BEGIN TRY
    BEGIN TRANSACTION


    declare @externalQuery nvarchar(max), @externalparam nvarchar(1000), @bjorke nvarchar(255),@dalhem varchar(255),@frojel nvarchar(255),@ganthem varchar(255),@Halla varchar(255),@Klinte varchar(255),@Roma varchar(255)
    ,@cont nvarchar(250),@grund nvarchar(250),@overtra nvarchar(250),@hush nvarchar(250),@avctr nvarchar(250),@budsm nvarchar(250),@hyra nvarchar(250),@depoX nvarchar(250);
   set @depoX='DEPO' set @cont = 'CONT'set @grund = 'GRUNDR'set @overtra = N'ÖVRTRA'set @hush = 'HUSH'set @avctr=N'ÅVCTR'set @budsm = 'BUDSM'set @hyra = 'HYRA'
    set @bjorke=N'björke'set @dalhem = 'Dalhem'set @frojel = N'Fröjel'set @ganthem = 'Ganthem'set @Halla = 'Halla'set @Klinte = 'Klinte'set @Roma = 'Roma';
    set @externalparam = N'@bjorke nvarchar(255) , @dalhem varchar(255) , @frojel nvarchar(255) , @ganthem varchar(255) , @Halla varchar(255) , @Klinte varchar(255) ,  @Roma varchar(255)' +
                        ',@avctr nvarchar(255), @depoX varchar(255),@cont varchar(255),@grund varchar(255),@overtra nvarchar(255),@hush varchar(255),@budsm varchar(255),@hyra varchar(255)'
   set @externalQuery =
           'with fastighetsfilter as (Select  @bjorke  "socken" Union Select @dalhem  "a" Union Select @frojel  "a" Union Select  @ganthem "a" Union Select   @Halla "a" Union Select  @Klinte  "a" Union Select  @Roma   "a" )'+
    ',EjRelevanta as (select @depoX "strDelprodukt" union select @cont "a" union select @grund "a" union select @overtra "a" union select @hush "a" union select @avctr "a" union select @budsm "a" union select @hyra "a")
    ,anlFilteredByTjanst as (select left(anlaggning.strFastBeteckningHel, case when charindex(space(1), anlaggning.strFastBeteckningHel) = 0 then len(anlaggning.strFastBeteckningHel) + 1 else charindex(space(1), anlaggning.strFastBeteckningHel) end - 1) strSocken,anlaggning.strAnlnr,anlaggning.strAnlaggningsKategori,anlaggning.strFastBeteckningHel,decAnlXKoordinat,decAnlYkoordinat from EDPFutureGotland.dbo.vwAnlaggning anlaggning inner join EDPFutureGotland.dbo.vwTjanst tjanst on anlaggning.strAnlnr = tjanst.strAnlnr where tjanst.strAnlnr is not null and tjanst.strAnlnr != space(0))
    ,anlFilteredBySocken AS (select strSocken, strAnlnr, strAnlaggningsKategori, anlFilteredByTjanst.strFastBeteckningHel, decAnlXKoordinat, decAnlYkoordinat from anlFilteredByTjanst inner join fastighetsfilter on anlFilteredByTjanst.strSocken = fastighetsfilter.socken)
    ,vwRenhTjanstStatistik as (select tjsT.strTaxekod,tjsT.intTjanstnr,tjsT.strAnlOrt,datStoppdatum,tjsT.strTaxebenamning,tjsT.strDelprodukt,strAnlnr from EDPFutureGotland.dbo.vwRenhTjanstStatistik tjsT inner join EDPFutureGotland.dbo.vwTjanst tjanst on tjanst.intTjanstnr = tjsT.intTjanstnr where tjsT.intTjanstnr is not null and tjsT.intTjanstnr != 0 and tjsT.intTjanstnr !=space(0)and coalesce(tjsT.strDelprodukt,tjsT.strTaxebenamning) is not null)
    ,tjanFilOnAnl as (select vwRenhTjanstStatistik.* from vwRenhTjanstStatistik inner join anlFilteredBySocken on anlFilteredBySocken.strAnlnr = vwRenhTjanstStatistik.strAnlnr )
    ,tjanFilOnDelprodukt as (select strTaxekod,intTjanstnr,strAnlOrt,datStoppdatum,strTaxebenamning,vwRenhTjanstStatistik.strDelprodukt,strAnlnr from tjanFilOnAnl vwRenhTjanstStatistik left outer join EjRelevanta on vwRenhTjanstStatistik.strDelprodukt =   EjRelevanta.strDelprodukt where EjRelevanta.strDelprodukt is null )
    ,tjanFilOnTaxekod as (select strTaxekod,intTjanstnr,strAnlOrt,isnull(datStoppdatum, smalldatetimefromparts(1900, 01, 01, 00, 00)) datStop,strTaxebenamning,tjanFilOnDelprodukt.strDelprodukt,strAnlnr from tjanFilOnDelprodukt left outer join EjRelevanta on tjanFilOnDelprodukt.strTaxekod  = EjRelevanta.strDelprodukt where EjRelevanta.strDelprodukt IS NULL)
    ,groupdTjanste as (select intTjanstnr, strDelprodukt, strTaxebenamning, max(datStop) latestStop, max(strAnlnr) maxStrAnlnr from tjanFilOnTaxekod group by strTaxekod, intTjanstnr, strAnlOrt, strDelprodukt, strTaxebenamning)

    select anlaggning.strFastBeteckningHel, case when nullif(decAnlYkoordinat, 0) is not null then nullif(decAnlXKoordinat, 0) end decAnlXKoordinat, case when nullif(decAnlXKoordinat, 0) is not null then nullif(decAnlYkoordinat, 0) end decAnlYkoordinat, intTjanstnr, strDelprodukt, strTaxebenamning,latestStop from anlFilteredBySocken anlaggning inner join groupdTjanste on anlaggning.strAnlnr = maxStrAnlnr'

      CREATE TABLE #slamx
    (
        strFastBeteckningHel nvarchar (250), decAnlXKoordinat float, decAnlYkoordinat float, intTjanstnr int, strDelprodukt nvarchar (250), strTaxebenamning nvarchar (250), stopDat datetime
    )

    INSERT INTO #slamx
    exec
        admsql01.master.dbo.
        sp_executesql @externalQuery,
             @externalparam,
             @bjorke=@bjorke, @dalhem=@dalhem, @frojel=@frojel, @ganthem= @ganthem, @Halla=@Halla, @Klinte= @Klinte, @Roma=@Roma
            ,@depoX = @depoX ,@cont = @cont,@grund = @grund,@overtra = @overtra, @hush = @hush, @avctr=@avctr, @budsm = @budsm, @hyra = @hyra
        ;with
            groupedMaxSlutdat as ( select max(stopDat) q2z,strDelprodukt, strTaxebenamning,strFastBeteckningHel, decAnlXKoordinat, decAnlYkoordinat from #slamx q group by strDelprodukt, strTaxebenamning,strFastBeteckningHel,decAnlXKoordinat,decAnlYkoordinat)
            , stuffedTypText as (select distinct strFastBeteckningHel,
                                                 strDelprodukt,
                                                 stuffing = STUFF((SELECT char(13) + nullif(' ' +
                                                                          concat(nullif(x.strTaxebenamning, ''),
                                                                                 nullif(concat(' Avbrutet:', FORMAT(
                                                                                         nullif(x.stopDat, smalldatetimefromparts(1900, 01, 01, 00, 00)),
                                                                                         'yyyy-MM-dd')),
                                                                                        ' Avbrutet:')),' ') "c"
                                                                   FROM #slamx x
                                                                   where q.strFastBeteckningHel = x.strFastBeteckningHel
                                                                   FOR XML PATH (''), root('MyString'), type
).value('/MyString[1]','varchar(max)')
, 1, 2, '')
                                 FROM groupedMaxSlutdat q
                                 group by strFastBeteckningHel, strDelprodukt)
         select *
         into #slam
         from (select strFastBeteckningHel,
                      datStoppdatum =STUFF((SELECT char(13) + nullif(' ' + nullif(strDelprodukt + '|', '|') + stuffing, ' ') as n
                                            FROM stuffedTypText x
                                            where q.strFastBeteckningHel = x.strFastBeteckningHel
                                            FOR XML PATH (''), root('MyString'), type
).value('/MyString[1]','varchar(max)')
, 1, 2, '')
               from stuffedTypText q
               group by strFastBeteckningHel) stuffedWithStopDat;
  Commit Transaction
    end try begin catch ROLLBACK TRANSACTION  insert into #statusTable select ERROR_MESSAGE() "E" , CURRENT_TIMESTAMP "C" , @@ROWCOUNT as [@4] print 'failed to build' end catch set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO #statusTable select 'rebuilt#' "a" ,@tid, @@ROWCOUNT as [@3]end INSERT INTO #statusTable select
 'preloading#slam'
 ,CURRENT_TIMESTAMP,count(*) from
#slam



go
declare @tid smalldatetime;
    begin try 
        set @tid = CURRENT_TIMESTAMP INSERT INTO #statusTable (medelande)  select N'Starting#rodx' "a";
            BEGIN TRANSACTION
            IF OBJECT_ID(N'tempdb..#rodx') IS not NULL
                begin 
                    if (exists(select 1 from #rodx))
                        begin
                            drop table #rodx
                            INSERT INTO #statusTable (medelande)  select N'purged#rodx' "a";
                        end
                end
        Commit Transaction
        ;with
            slam as (select * from #slam)
            ,socknarOfInteresse as (select distinct socken, fastighet from #SockenYtor )
            , vaPlan as (select fastighet,typ  from #Spillvatten)
            ,egetOmhandertagande as ( select fastighet, egetOmhandertangandeInfo ,LocaltOmH from #egetOmhandertagande )
            ,bygFasAnl as (
                select anlaggningar.diarienummer,socknarOfInteresse.socken,socknarOfInteresse.fastighet,Byggnadstyp,Fastighet_tillstand,Beslut_datum,utförddatum,Anteckning,
                       (case when anlaggningar.anlaggningspunkt is not null then anlaggningar.fstatus else '?' end) fstatus,
                       coalesce(anlaggningar.anlaggningspunkt,ByggShape) flagga
                from socknarOfInteresse
                         left outer join #ByggnadPaFastighetISocken byggnader
                             on socknarOfInteresse.fastighet = byggnader.Fastighetsbeteckning
                         left outer join #Socken_tillstand anlaggningar on socknarOfInteresse.fastighet = anlaggningar.fastighet
                where coalesce(anlaggningar.anlaggningspunkt,ByggShape) is not null)
            , attUtsokaFran as (
                select *, row_number() over (partition by bygFasAnl.fastighet order by bygFasAnl.Anteckning desc ) flaggnr from
                    bygFasAnl  where bygFasAnl.flagga is not null)
            ,q as (select attUtsokaFran.socken,attUtsokaFran.fastighet,attUtsokaFran.Fastighet_tillstand,attUtsokaFran.Diarienummer,attUtsokaFran.Byggnadstyp,Beslut_datum,utförddatum "utförddatum",attUtsokaFran.Anteckning,
                       VaPlan                   = (select top 1 typ from vaPlan where vaPlan.fastighet = attUtsokaFran.fastighet),fstatus,
                       egetOmhandertangandeInfo = (select top 1 egetOmhandertangandeInfo from egetOmhandertagande where attUtsokaFran.fastighet = egetOmhandertagande.fastighet),
                       slam                     = (select top 1 datStoppdatum from slam where attUtsokaFran.fastighet = slam.strFastBeteckningHel),flaggnr,flagga.STPointN(1) flagga from attUtsokaFran)
            , rodx as (select socken,fastighet,Fastighet_tillstand,Byggnadstyp,Beslut_datum,utförddatum,Anteckning,VaPlan,egetOmhandertangandeInfo,slam,flaggnr,flagga,(case when (vaPlan is not null) then 'KomV' else case when fstatus = N'?' or fstatus = N'röd' then N'röd' else fstatus end end) Fstatus from q)
         select * into #rodx from rodx
    end try begin catch ROLLBACK TRANSACTION  insert into #statusTable select ERROR_MESSAGE() "E" , CURRENT_TIMESTAMP "C" ,
@@ROWCOUNT as [@4] print 'failed to build' end catch set @tid = CURRENT_TIMESTAMP - @tid
        INSERT INTO #statusTable select 'rebuilt#' "a" ,@tid,@@ROWCOUNT as [@3]

INSERT INTO #statusTable select
N'rebuilt#rodx'
 ,CURRENT_TIMESTAMP,count(*) from
 #rodx




go IF OBJECT_ID(N'tempdb..#rodx') IS not NULL begin if not (exists(select 1 from #rodx)) begin try begin transaction IF OBJECT_ID(N'dbo..Inventering_bjorke') IS NULL       begin create table dbo.Inventering_bjorke( OBJECTID            int not null constraint invBj_pk primary key, FASTIGHET nvarchar(150),Fastighet_tillstand nvarchar(150),Arendenummer        nvarchar(50), Beslut_datum datetime2,Status              nvarchar(50),Utskick_datum       datetime2, Anteckning nvarchar(254),Utforddatum         datetime2,Slamhamtning        nvarchar(100), Antal_byggnader numeric(38, 8),alltidsant          int,Shape               geometry, GDB_GEOMATTR_DATA varbinary(max),skapad_datum        datetime2,andrad_datum        datetime2 )     /*--goto indexcheck else indexcheck: if not (exists(select 1 from sys.indexes WHERE name='YourIndexName' AND object_id = OBJECT_ID('dbo.Inventering') )) create*/end if exists(select 1 from Inventering_bjorke) begin delete from Inventering_bjorke where 1=1 end insert into dbo.Inventering_bjorke (OBJECTID, FASTIGHET,Fastighet_tillstand,  Beslut_datum,   Status,     Anteckning, Utforddatum,                Slamhamtning,                Antal_byggnader,    alltidsant,  Shape,  skapad_datum,   andrad_datum) select (row_number() over (order by fastighet,flaggnr)) "a",    fastighet,Fastighet_tillstand,  Beslut_datum,   Fstatus, concat(Byggnadstyp,' ',Anteckning,' ',nullif(concat('vaPlan: ',VaPlan,' '),'vaPlan:  '),nullif(concat('egetOmh: ',egetOmhandertangandeInfo,' '),'egetOmh:  ')), utförddatum,                slam, flaggnr,            1,           flagga, CURRENT_TIMESTAMP,CURRENT_TIMESTAMP
   from #rodx where Socken = 'björke';commit transaction end try begin catch rollback transaction end catch end go

go IF OBJECT_ID(N'tempdb..#rodx') IS not NULL begin if not (exists(select 1 from #rodx)) begin try begin transaction IF OBJECT_ID(N'dbo..Inventering_dalhem') IS NULL       begin create table dbo.Inventering_dalhem( OBJECTID            int not null constraint invBj_pk primary key, FASTIGHET nvarchar(150),Fastighet_tillstand nvarchar(150),Arendenummer        nvarchar(50), Beslut_datum datetime2,Status              nvarchar(50),Utskick_datum       datetime2, Anteckning nvarchar(254),Utforddatum         datetime2,Slamhamtning        nvarchar(100), Antal_byggnader numeric(38, 8),alltidsant          int,Shape               geometry, GDB_GEOMATTR_DATA varbinary(max),skapad_datum        datetime2,andrad_datum        datetime2 )     /*--goto indexcheck else indexcheck: if not (exists(select 1 from sys.indexes WHERE name='YourIndexName' AND object_id = OBJECT_ID('dbo.Inventering') )) create*/end if exists(select 1 from Inventering_dalhem) begin delete from Inventering_dalhem where 1=1 end insert into dbo.Inventering_dalhem (OBJECTID, FASTIGHET,Fastighet_tillstand,  Beslut_datum,   Status,     Anteckning, Utforddatum,                Slamhamtning,                Antal_byggnader,    alltidsant,  Shape,  skapad_datum,   andrad_datum) select (row_number() over (order by fastighet,flaggnr)) "a",    fastighet,Fastighet_tillstand,  Beslut_datum,   Fstatus, concat(Byggnadstyp,' ',Anteckning,' ',nullif(concat('vaPlan: ',VaPlan,' '),'vaPlan:  '),nullif(concat('egetOmh: ',egetOmhandertangandeInfo,' '),'egetOmh:  ')), utförddatum,                slam, flaggnr,            1,           flagga, CURRENT_TIMESTAMP,CURRENT_TIMESTAMP
   from #rodx where Socken = 'dalhem';commit transaction end try begin catch rollback transaction end catch end go

go IF OBJECT_ID(N'tempdb..#rodx') IS not NULL begin if not (exists(select 1 from #rodx)) begin try begin transaction IF OBJECT_ID(N'dbo..Inventering_frojel') IS NULL       begin create table dbo.Inventering_frojel( OBJECTID            int not null constraint invBj_pk primary key, FASTIGHET nvarchar(150),Fastighet_tillstand nvarchar(150),Arendenummer        nvarchar(50), Beslut_datum datetime2,Status              nvarchar(50),Utskick_datum       datetime2, Anteckning nvarchar(254),Utforddatum         datetime2,Slamhamtning        nvarchar(100), Antal_byggnader numeric(38, 8),alltidsant          int,Shape               geometry, GDB_GEOMATTR_DATA varbinary(max),skapad_datum        datetime2,andrad_datum        datetime2 )     /*--goto indexcheck else indexcheck: if not (exists(select 1 from sys.indexes WHERE name='YourIndexName' AND object_id = OBJECT_ID('dbo.Inventering') )) create*/end if exists(select 1 from Inventering_frojel) begin delete from Inventering_frojel where 1=1 end insert into dbo.Inventering_frojel (OBJECTID, FASTIGHET,Fastighet_tillstand,  Beslut_datum,   Status,     Anteckning, Utforddatum,                Slamhamtning,                Antal_byggnader,    alltidsant,  Shape,  skapad_datum,   andrad_datum) select (row_number() over (order by fastighet,flaggnr)) "a",    fastighet,Fastighet_tillstand,  Beslut_datum,   Fstatus, concat(Byggnadstyp,' ',Anteckning,' ',nullif(concat('vaPlan: ',VaPlan,' '),'vaPlan:  '),nullif(concat('egetOmh: ',egetOmhandertangandeInfo,' '),'egetOmh:  ')), utförddatum,                slam, flaggnr,            1,           flagga, CURRENT_TIMESTAMP,CURRENT_TIMESTAMP
   from #rodx where Socken = 'fröjel';commit transaction end try begin catch rollback transaction end catch end go

go IF OBJECT_ID(N'tempdb..#rodx') IS not NULL begin if not (exists(select 1 from #rodx)) begin try begin transaction IF OBJECT_ID(N'dbo..Inventering_Ganthem') IS NULL       begin create table dbo.Inventering_Ganthem( OBJECTID            int not null constraint invBj_pk primary key, FASTIGHET nvarchar(150),Fastighet_tillstand nvarchar(150),Arendenummer        nvarchar(50), Beslut_datum datetime2,Status              nvarchar(50),Utskick_datum       datetime2, Anteckning nvarchar(254),Utforddatum         datetime2,Slamhamtning        nvarchar(100), Antal_byggnader numeric(38, 8),alltidsant          int,Shape               geometry, GDB_GEOMATTR_DATA varbinary(max),skapad_datum        datetime2,andrad_datum        datetime2 )     /*--goto indexcheck else indexcheck: if not (exists(select 1 from sys.indexes WHERE name='YourIndexName' AND object_id = OBJECT_ID('dbo.Inventering') )) create*/end if exists(select 1 from Inventering_Ganthem) begin delete from Inventering_Ganthem where 1=1 end insert into dbo.Inventering_Ganthem (OBJECTID, FASTIGHET,Fastighet_tillstand,  Beslut_datum,   Status,     Anteckning, Utforddatum,                Slamhamtning,                Antal_byggnader,    alltidsant,  Shape,  skapad_datum,   andrad_datum) select (row_number() over (order by fastighet,flaggnr)) "a",    fastighet,Fastighet_tillstand,  Beslut_datum,   Fstatus, concat(Byggnadstyp,' ',Anteckning,' ',nullif(concat('vaPlan: ',VaPlan,' '),'vaPlan:  '),nullif(concat('egetOmh: ',egetOmhandertangandeInfo,' '),'egetOmh:  ')), utförddatum,                slam, flaggnr,            1,           flagga, CURRENT_TIMESTAMP,CURRENT_TIMESTAMP
   from #rodx where Socken = 'Ganthem';commit transaction end try begin catch rollback transaction end catch end go

go IF OBJECT_ID(N'tempdb..#rodx') IS not NULL begin if not (exists(select 1 from #rodx)) begin try begin transaction IF OBJECT_ID(N'dbo..Inventering_Halla') IS NULL       begin create table dbo.Inventering_Halla( OBJECTID            int not null constraint invBj_pk primary key, FASTIGHET nvarchar(150),Fastighet_tillstand nvarchar(150),Arendenummer        nvarchar(50), Beslut_datum datetime2,Status              nvarchar(50),Utskick_datum       datetime2, Anteckning nvarchar(254),Utforddatum         datetime2,Slamhamtning        nvarchar(100), Antal_byggnader numeric(38, 8),alltidsant          int,Shape               geometry, GDB_GEOMATTR_DATA varbinary(max),skapad_datum        datetime2,andrad_datum        datetime2 )     /*--goto indexcheck else indexcheck: if not (exists(select 1 from sys.indexes WHERE name='YourIndexName' AND object_id = OBJECT_ID('dbo.Inventering') )) create*/end if exists(select 1 from Inventering_Halla) begin delete from Inventering_Halla where 1=1 end insert into dbo.Inventering_Halla (OBJECTID, FASTIGHET,Fastighet_tillstand,  Beslut_datum,   Status,     Anteckning, Utforddatum,                Slamhamtning,                Antal_byggnader,    alltidsant,  Shape,  skapad_datum,   andrad_datum) select (row_number() over (order by fastighet,flaggnr)) "a",    fastighet,Fastighet_tillstand,  Beslut_datum,   Fstatus, concat(Byggnadstyp,' ',Anteckning,' ',nullif(concat('vaPlan: ',VaPlan,' '),'vaPlan:  '),nullif(concat('egetOmh: ',egetOmhandertangandeInfo,' '),'egetOmh:  ')), utförddatum,                slam, flaggnr,            1,           flagga, CURRENT_TIMESTAMP,CURRENT_TIMESTAMP
   from #rodx where Socken = 'Halla';commit transaction end try begin catch rollback transaction end catch end go

go IF OBJECT_ID(N'tempdb..#rodx') IS not NULL begin if not (exists(select 1 from #rodx)) begin try begin transaction IF OBJECT_ID(N'dbo..Inventering_Klinte') IS NULL       begin create table dbo.Inventering_Klinte( OBJECTID            int not null constraint invBj_pk primary key, FASTIGHET nvarchar(150),Fastighet_tillstand nvarchar(150),Arendenummer        nvarchar(50), Beslut_datum datetime2,Status              nvarchar(50),Utskick_datum       datetime2, Anteckning nvarchar(254),Utforddatum         datetime2,Slamhamtning        nvarchar(100), Antal_byggnader numeric(38, 8),alltidsant          int,Shape               geometry, GDB_GEOMATTR_DATA varbinary(max),skapad_datum        datetime2,andrad_datum        datetime2 )     /*--goto indexcheck else indexcheck: if not (exists(select 1 from sys.indexes WHERE name='YourIndexName' AND object_id = OBJECT_ID('dbo.Inventering') )) create*/end if exists(select 1 from Inventering_Klinte) begin delete from Inventering_Klinte where 1=1 end insert into dbo.Inventering_Klinte (OBJECTID, FASTIGHET,Fastighet_tillstand,  Beslut_datum,   Status,     Anteckning, Utforddatum,                Slamhamtning,                Antal_byggnader,    alltidsant,  Shape,  skapad_datum,   andrad_datum) select (row_number() over (order by fastighet,flaggnr)) "a",    fastighet,Fastighet_tillstand,  Beslut_datum,   Fstatus, concat(Byggnadstyp,' ',Anteckning,' ',nullif(concat('vaPlan: ',VaPlan,' '),'vaPlan:  '),nullif(concat('egetOmh: ',egetOmhandertangandeInfo,' '),'egetOmh:  ')), utförddatum,                slam, flaggnr,            1,           flagga, CURRENT_TIMESTAMP,CURRENT_TIMESTAMP
   from #rodx where Socken = 'Klinte';commit transaction end try begin catch rollback transaction end catch end go

go IF OBJECT_ID(N'tempdb..#rodx') IS not NULL begin if not (exists(select 1 from #rodx)) begin try begin transaction IF OBJECT_ID(N'dbo..Inventering_Roma') IS NULL       begin create table dbo.Inventering_Roma( OBJECTID            int not null constraint invBj_pk primary key, FASTIGHET nvarchar(150),Fastighet_tillstand nvarchar(150),Arendenummer        nvarchar(50), Beslut_datum datetime2,Status              nvarchar(50),Utskick_datum       datetime2, Anteckning nvarchar(254),Utforddatum         datetime2,Slamhamtning        nvarchar(100), Antal_byggnader numeric(38, 8),alltidsant          int,Shape               geometry, GDB_GEOMATTR_DATA varbinary(max),skapad_datum        datetime2,andrad_datum        datetime2 )     /*--goto indexcheck else indexcheck: if not (exists(select 1 from sys.indexes WHERE name='YourIndexName' AND object_id = OBJECT_ID('dbo.Inventering') )) create*/end if exists(select 1 from Inventering_Roma) begin delete from Inventering_Roma where 1=1 end insert into dbo.Inventering_Roma (OBJECTID, FASTIGHET,Fastighet_tillstand,  Beslut_datum,   Status,     Anteckning, Utforddatum,                Slamhamtning,                Antal_byggnader,    alltidsant,  Shape,  skapad_datum,   andrad_datum) select (row_number() over (order by fastighet,flaggnr)) "a",    fastighet,Fastighet_tillstand,  Beslut_datum,   Fstatus, concat(Byggnadstyp,' ',Anteckning,' ',nullif(concat('vaPlan: ',VaPlan,' '),'vaPlan:  '),nullif(concat('egetOmh: ',egetOmhandertangandeInfo,' '),'egetOmh:  ')), utförddatum,                slam, flaggnr,            1,           flagga, CURRENT_TIMESTAMP,CURRENT_TIMESTAMP
   from #rodx where Socken = 'Roma';commit transaction end try begin catch rollback transaction end catch end go

select * from #rodx
select * from #statusTable

select #rodx.* from #rodx
left outer join tempExcel.dbo.AllaFastigheter2020 on AllaFastigheter2020.fastighet = #rodx.fastighet OR #rodx.fastighet = AllaFastigheter2020.socken where AllaFastigheter2020.fastighet is null
and #rodx.fstatus = 'röd'
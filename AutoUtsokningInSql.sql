/*Insert Databases names into SQL Temp Table*/
begin try
declare @statusTable table(medelande NVARCHAR(max),start smalldatetime,rader integer);
declare @object nvarchar(max);
TableInitiate:

-- dropTabels?

INSERT INTO @statusTable (medelande) select '#initiating#slam' as alias234;
IF OBJECT_ID('tempdb..#slam') IS NULL RAISERROR ( 18,-1,-1,'taxekodTabell saknas, exekvera om slaminitate');  else begin if not                     (exists(select 1 from #slam)) begin drop table #slam;  RAISERROR ( 18,-1,-1,N'taxekod Var olämplig,tabell förstörd, exekvera-om slaminitiate') end end INSERT INTO @statusTable select 'preloading#slam',CURRENT_TIMESTAMP,count(*) from #slam;
INSERT INTO @statusTable (medelande) select '#initiating#sockenYtor' as alias2345; IF OBJECT_ID('tempdb..#SockenYtor')                     IS NULL goto SockenYtor else begin if not                   (exists(select 1 from #SockenYtor)) begin drop table #SockenYtor;                                  goto SockenYtor; end end INSERT INTO @statusTable select 'preloading#SockenYtor',CURRENT_TIMESTAMP,count(*) from #SockenYtor;

INSERT INTO @statusTable (medelande) select '#initiating#Byggnader' as alias23456; IF OBJECT_ID(N'tempdb..#ByggnadPaFastighetISocken')     IS NULL goto ByggnadPaFastighetISocken else begin if not    (exists(select 1 from #ByggnadPaFastighetISocken)) begin drop table #ByggnadPaFastighetISocken;    goto ByggnadPaFastighetISocken;end end INSERT INTO @statusTable select 'preloading#ByggnadPaFastighetISocken', CURRENT_TIMESTAMP, count(*)from #ByggnadPaFastighetISocken;
INSERT INTO @statusTable (medelande) select N'#initiating#sockenTillstånd' as alias2345678910; IF OBJECT_ID(N'tempdb..#Socken_tillstand')              IS NULL goto Socken_tillstand else begin if not             (exists(select 1 from #Socken_tillstand)) begin drop table #Socken_tillstand;                      goto Socken_tillstand; end end INSERT INTO @statusTable select 'preloading#Socken_tillstand',CURRENT_TIMESTAMP,count(*) from #Socken_tillstand;
INSERT INTO @statusTable (medelande) select N'#initiating#egetOmhandertagande' as alias23456789;IF OBJECT_ID(N'tempdb..#egetOmhandertagande')           IS NULL goto egetOmhandertagande  else begin if not         (exists(select 1 from #egetOmhandertagande)) begin drop table #egetOmhandertagande;                goto egetOmhandertagande; end end INSERT INTO @statusTable select 'preloading#egetOmhandertagande',CURRENT_TIMESTAMP,count(*) from #egetOmhandertagande;
INSERT INTO @statusTable (medelande) select '#initiating#Spillvatten' as alias234567;IF OBJECT_ID('tempdb..#spillvaten')                     IS NULL goto spillvaten  else begin if not                  (exists(select 1 from #spillvaten)) begin drop table #spillvaten;                                  goto spillvaten; end end INSERT INTO @statusTable select 'preloading#spillvaten',CURRENT_TIMESTAMP,count(*) from #spillvaten;
INSERT INTO @statusTable (medelande) select N'#initiating#röd' as alias234567891011;IF OBJECT_ID(N'tempdb..#röd')                           IS NULL goto rodx  else begin if not                         (exists(select 1 from #rodx)) begin drop table #rodx;                                                goto rodx; end end INSERT INTO @statusTable select 'preloading#röd',CURRENT_TIMESTAMP,count(*) from #rodx
INSERT INTO @statusTable (medelande) select '#goingToRepport' as alias2345678;goto repport


if (select 1) IS NULL BEGIN TRY BEGIN TRANSACTION
    Drop table #SockenYtor
    Drop table #ByggnadPaFastighetISocken
    Drop table #Socken_tillstand
    Drop table #egetOmhandertagande
    Drop table #spillvaten
    Drop table #slam
    Drop table #rodx
Commit Transaction end try begin catch ROLLBACK Transaction end catch

goto TableInitiate --koden skall inte exekveras i läsordning, alla initiate test moste först slutföras, sedan går programmet till repportblocket.

SockenYtor:
declare @tid smalldatetime set @tid = CURRENT_TIMESTAMP INSERT INTO @statusTable (medelande)  select 'Starting#SockenYtor' "a"  BEGIN TRY BEGIN TRANSACTION


    --set @object = N'with socknarOfIntresse as (SELECT socken SockenX,concat(Trakt,SPACE(0),Blockenhet) FAStighet, Shape from sde_gsd.gng.AY_0980 x inner join (Select N''Björke'' "socken"  Union Select ''Dalhem'' as alias2 Union Select N''Fröjel'' as alias234567 Union Select ''Ganthem'' as alias23 Union Select ''Halla'' as alias234 Union Select ''Klinte'' as alias2345 Union Select ''Roma'' as alias23456) socknarOfIntresse on left(x.TRAKT, len(socknarOfIntresse.socken)) = socknarOfIntresse.socken ) select * from socknarOfIntresse'
;



    Commit Transaction end try begin catch ROLLBACK TRANSACTION  insert into @statusTable select ERROR_MESSAGE() as EM, CURRENT_TIMESTAMP as CT2, @@ROWCOUNT as [@4]
print 'failed to build' end catch set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO @statusTable select 'rebuilt#' as alias23,@tid, @@ROWCOUNT as [@3]
goto TableInitiate
ByggnadPaFastighetISocken:

set @tid = CURRENT_TIMESTAMP INSERT INTO @statusTable (medelande)  select 'Starting#Byggnadsyta' as alias23456789101112
BEGIN TRY BEGIN TRANSACTION
  set @object =  N'
    with socknarOfIntresse as (SELECT socken SockenX,concat(Trakt,SPACE(0),Blockenhet) FAStighet, Shape from sde_gsd.gng.AY_0980 x inner join (Select N''Björke'' "socken"  Union Select ''Dalhem'' as alias2 Union Select N''Fröjel'' as alias234567 Union Select ''Ganthem'' as alias23 Union Select ''Halla'' as alias234 Union Select ''Klinte'' as alias2345 Union Select ''Roma'' as alias23456) socknarOfIntresse on left(x.TRAKT, len(socknarOfIntresse.socken)) = socknarOfIntresse.socken )

 ,byggnad_yta as (select andamal_1T Byggnadstyp, Shape from sde_gsd.gng.BY_0980),
        q as (Select Byggnadstyp, socknarOfIntresse.fastighet Fastighetsbeteckning, byggnad_yta.SHAPE from byggnad_yta inner join socknarOfIntresse on byggnad_yta.Shape.STWithin(socknarOfIntresse.shape) = 1)
        select Fastighetsbeteckning, Byggnadstyp,shape ByggShape from (select *, row_number() over (partition by Fastighetsbeteckning order by Byggnadstyp ) orderz from q) z where orderz = 1
	'select * into #ByggnadPaFastighetISocken from openquery(gisdb01,@object);
Commit Transaction end try begin catch ROLLBACK TRANSACTION  insert into @statusTable select ERROR_MESSAGE() as E, CURRENT_TIMESTAMP as CT3, @@ROWCOUNT as [@5]
print 'failed to build'  end catch set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO @statusTable select 'rebuilt#' as alias234567891011121314,@tid, @@ROWCOUNT as [@6]
goto TableInitiate

;Socken_tillstand:
set @tid = CURRENT_TIMESTAMP INSERT INTO @statusTable (medelande)  select 'Starting#Socken_tillstand' as alias2345678910111213
BEGIN TRY BEGIN TRANSACTION

 set @object =  N'
   with socknarOfIntresse as (SELECT socken SockenX,concat(Trakt,SPACE(0),Blockenhet) FAStighet, Shape from sde_gsd.gng.AY_0980 x inner join (Select N''Björke'' "socken"  Union Select ''Dalhem'' as alias2 Union Select N''Fröjel'' as alias234567 Union Select ''Ganthem'' as alias23 Union Select ''Halla'' as alias234 Union Select ''Klinte'' as alias2345 Union Select ''Roma'' as alias23456) socknarOfIntresse on left(x.TRAKT, len(socknarOfIntresse.socken)) = socknarOfIntresse.socken )

       ,AnSoMedSocken as (select left(Fastighet_tillstand, case when charindex(SPACE(0), Fastighet_tillstand) = 0 then len(Fastighet_tillstand) + 1 else charindex(SPACE(0), Fastighet_tillstand) end - 1) socken,Diarienummer,Fastighet_tillstand                                                             z,Beslut_datum,Utford_datum,Anteckning,Shape                                                                           anlShape from sde_miljo_halsoskydd.gng.ENSKILT_AVLOPP_sodra_P),
       AnNoMedSocken as (select left(Fastighet_tillstand, case when charindex(SPACE(0), Fastighet_tillstand) = 0 then len(Fastighet_tillstand) + 1 else charindex(SPACE(0), Fastighet_tillstand) end - 1) socken,Diarienummer,Fastighet_tillstand                                                             z,Beslut_datum,Utford_datum,Anteckning,Shape                                                                           anlShape from sde_miljo_halsoskydd.gng.ENSKILT_AVLOPP_Norra_P),
       AnMeMedSocken as (select left(Fastighet_tilstand, case when charindex(SPACE(0), Fastighet_tilstand) = 0 then len(Fastighet_tilstand) + 1 else charindex(SPACE(0), Fastighet_tilstand) end - 1) socken,Diarienummer,Fastighet_tilstand                                                            z,Beslut_datum,Utford_datum,Anteckning,Shape                                                                         anlShape from sde_miljo_halsoskydd.gng.ENSKILT_AVLOPP_MELLERSTA_P),
       SodraFiltrerad as (select Diarienummer, z q, Beslut_datum, Utford_datum, Anteckning, AllaAvlopp.anlShape, FAStighet from AnSoMedSocken AllaAvlopp inner join(select FiltreradeFast.*from socknarOfIntresse FiltreradeFast inner join (select socken from AnSoMedSocken group by socken) q on socken = sockenX) FFast on AllaAvlopp.socken = ffast.SockenX and AllaAvlopp.anlShape.STIntersects(FFast.Shape) = 1),
       NorraFiltrerad as (select Diarienummer, z q, Beslut_datum, Utford_datum, Anteckning, AllaAvlopp.anlShape, FAStighet from AnNoMedSocken AllaAvlopp inner join(select FiltreradeFast.*from socknarOfIntresse FiltreradeFast inner join (select socken from AnNoMedSocken group by socken) q on socken = sockenX) FFast on AllaAvlopp.socken = ffast.SockenX and AllaAvlopp.anlShape.STIntersects(FFast.Shape) = 1),
       MellerstaFiltrerad as (select Diarienummer, z q, Beslut_datum, Utford_datum, Anteckning, AllaAvlopp.anlShape, FAStighet from AnMeMedSocken AllaAvlopp inner join(select FiltreradeFast.*from socknarOfIntresse FiltreradeFast inner join (select socken from AnMeMedSocken group by socken) q on socken = sockenX) FFast on AllaAvlopp.socken = ffast.SockenX and AllaAvlopp.anlShape.STIntersects(FFast.Shape) = 1),
       SammanSlagna as (select Diarienummer, q "Fastighet_tillstand",isnull(TRY_CONVERT(DateTime, Beslut_datum,102), DATETIME2FROMPARTS(1988, 1, 1, 1, 1, 1, 1, 1)) Beslut_datum, isnull(TRY_CONVERT(DateTime, Utford_datum,102), DATETIME2FROMPARTS(1988, 1, 1, 1, 1, 1, 1, 1)) Utford_datum, Anteckning, anlShape, FAStighet from (select * from SodraFiltrerad union all select * from NorraFiltrerad union all select * from MellerstaFiltrerad) z)
      select FAStighet,Diarienummer,Fastighet_tillstand,Beslut_datum,Utford_datum "utförddatum",Anteckning,anlShape     AnlaggningsPunkt from SammanSlagna
      '
select * into #Socken_tillstand from openquery(gisdb01,@object);
    Commit Transaction end try begin catch ROLLBACK TRANSACTION  insert into @statusTable select ERROR_MESSAGE() as M, CURRENT_TIMESTAMP as CT4, @@ROWCOUNT as [@7]
print 'failed to build'  end catch set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO @statusTable select 'rebuilt#' as alias23456789101112131415,@tid, @@ROWCOUNT as [@8]
goto TableInitiate

;egetOmhandertagande:
set @tid = CURRENT_TIMESTAMP INSERT INTO @statusTable (medelande)  select 'Starting#egetOmhandertagande' as alias2345678910111213141516
BEGIN TRY BEGIN TRANSACTION

 set @object =  N'
   with socknarOfIntresse as (SELECT socken SockenX,concat(Trakt,SPACE(0),Blockenhet) FAStighet, Shape from sde_gsd.gng.AY_0980 x inner join (Select N''Björke'' "socken"  Union Select ''Dalhem'' as alias2 Union Select N''Fröjel'' as alias234567 Union Select ''Ganthem'' as alias23 Union Select ''Halla'' as alias234 Union Select ''Klinte'' as alias2345 Union Select ''Roma'' as alias23456) socknarOfIntresse on left(x.TRAKT, len(socknarOfIntresse.socken)) = socknarOfIntresse.socken )

      , LOKALT_SLAM_P as (select Diarienr,Fastighet_,Fastighe00,Eget_omhän,Lokalt_omh,Anteckning,Beslutsdat,shape
                          from sde_miljo_halsoskydd.gng.MoH_Slam_Lokalt_p_evw)
      , Med_fastighet as ( select * from (select *,
                                       concat(nullif(LOKALT_SLAM_P.Lokalt_omh,SPACE(0)),
                                                     nullif(LOKALT_SLAM_P.Fastighet_,SPACE(0)),
                                                            nullif(LOKALT_SLAM_P.Fastighe00,SPACE(0))) fas from
                                              sde_miljo_halsoskydd.gng.MoH_Slam_Lokalt_p_evw LOKALT_SLAM_P) as [*2]
                                where fas is not null
                                  and charindex('' :'', fas) > 0),
                               utan_fastighet as (
   select OBJECTID,Fastighet_,Fastighets,Eget_omhän,Lokalt_omh,Fastighe00,Beslutsdat,Diarienr,Anteckning,utan_fastighet.Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID,FAStighet
   from (select *
         from sde_miljo_halsoskydd.gng.MoH_Slam_Lokalt_p_evw LOKALT_SLAM_P
         where charindex('':'', concat(nullif(LOKALT_SLAM_P.Lokalt_omh,SPACE(0)), SPACE(0), nullif(LOKALT_SLAM_P.Fastighet_,SPACE(0)), SPACE(0),
                                     nullif(LOKALT_SLAM_P.Fastighe00,SPACE(0)))) = 0) utan_fastighet inner join socknarOfIntresse sYt on sYt.shape.STIntersects(utan_fastighet.Shape) = 1) select fastighet,concat(nullif(Diarienr+'' -'','' - ''), nullif(Fastighe00+'' - '','' - ''), nullif(Fastighet_+'' - '','' -''), nullif(Eget_omhän+'' - '','' - ''), nullif(Lokalt_omh+'' - '','' -''), nullif(Anteckning+'' - '','' - ''),FORMAT(Beslutsdat,'' yyyy - MM - dd'')) egetOmhandertangandeInfo,Shape  LocaltOmH from (select OBJECTID,Fastighet_,Fastighets,Eget_omhän,Lokalt_omh,Fastighe00,Beslutsdat,Diarienr,Anteckning,Med_fastighet.Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID,FAStighet from socknarOfIntresse sYt left outer join Med_fastighet on fas like '' %'' + sYt.Fastighet + '' %'' where fas is not null union all select * from utan_fastighet) as [sYMfuf*]
	'
select * into #egetOmhandertagande from openquery(gisdb01,@object);
Commit Transaction end try begin catch ROLLBACK TRANSACTION  insert into @statusTable select ERROR_MESSAGE() as EM2, CURRENT_TIMESTAMP as CT5,
                                                                                             @@ROWCOUNT      as [@9]
print 'failed to build'  end catch set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO @statusTable select 'rebuilt#' as alias234567891011121314151617, @tid,
                                                                                                       @@ROWCOUNT as [@10]
goto TableInitiate

spillvaten:
set @tid = CURRENT_TIMESTAMP INSERT INTO @statusTable (medelande)  select 'Starting#spillvaten' as alias23456789101112131415161718
BEGIN TRY BEGIN TRANSACTION



    ;      set @object =
                                N'
with socknarOfIntresse as (SELECT socken SockenX,concat(Trakt,SPACE(0),Blockenhet) FAStighet, Shape from sde_gsd.gng.AY_0980 x inner join (Select N''Björke'' "socken"  Union Select ''Dalhem'' as alias2 Union Select N''Fröjel'' as alias234567 Union Select ''Ganthem'' as alias23 Union Select ''Halla'' as alias234 Union Select ''Klinte'' as alias2345 Union Select ''Roma'' as alias23456) socknarOfIntresse on left(x.TRAKT, len(socknarOfIntresse.socken)) = socknarOfIntresse.socken )

       ,Va_planomraden_171016_evw as   (select shape,dp_i_omr,planprog,planansokn from sde_pipe.gng.Va_planomraden_171016_evw),q as ( select shape, concat(typkod,'':'',status,''(spill)'') typ from sde_pipe.gng.VO_Spillvatten_evw VO_Spillvatten_evw union all select shape, concat(''AVTALSABONNENT [Tabell_ObjID: '',OBJECTID,'']'') as c from sde_pipe.gng.AVTALSABONNENTER AVTALSABONNENTER union all select shape, concat(''GEMENSAMHETSANLAGGNING: '',GEMENSAMHETSANLAGGNINGAR.GA) as c2 from sde_pipe.gng.GEMENSAMHETSANLAGGNINGAR GEMENSAMHETSANLAGGNINGAR union all select shape,isnull(coalesce(nullif(concat(''dp_i_omr:'',dp_i_omr) ,''dp_i_omr:''), nullif(concat(''planprog:'',planprog) ,''planprog:''), nullif(concat(''planansokn:'',planansokn) ,''planansokn:'')),N''okändStatus'') as i from Va_planomraden_171016_evw) select sYt.fastighet, q.typ  from socknarOfIntresse sYt inner join q on sYt.shape.STIntersects(q.Shape) = 1'

    select * into #spillvaten from openquery(gisdb01,@object);

Commit Transaction end try begin catch ROLLBACK TRANSACTION  insert into @statusTable select ERROR_MESSAGE() "m",CURRENT_TIMESTAMP "t",@@ROWCOUNT  "c"print 'failed to build'  end catch set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO @statusTable select 'rebuilt#',@tid,@@ROWCOUNT goto TableInitiate
;taxekod:
IF OBJECT_ID(N'tempdb..#Taxekod')  is null
    begin BEGIN TRY DROP TABLE #Taxekod END TRY BEGIN CATCH select 1 END CATCH;


        declare @object Nvarchar(max)
    set @object =  N'

with anlaggning as (select strAnlnr,strAnlaggningsKategori,strFastBeteckningHel,case when nullif(decAnlYkoordinat, 0) is not null then nullif(decAnlXKoordinat, 0) end decAnlXKoordinat,case when nullif(decAnlXKoordinat, 0) is not null then nullif(decAnlYkoordinat, 0) end decAnlYkoordinat from (select left(strFastBeteckningHel, case when charindex('' '', strFastBeteckningHel) = 0 then len(strFastBeteckningHel) + 1 else charindex('' '', strFastBeteckningHel) end - 1) strSocken,strAnlnr,strAnlaggningsKategori,strFastBeteckningHel,decAnlXKoordinat,decAnlYkoordinat from (select strAnlnr, strAnlaggningsKategori, strFastBeteckningHel, decAnlXKoordinat, decAnlYkoordinat from (select anlaggning.* from EDPFutureGotland.dbo.vwAnlaggning anlaggning inner join EDPFutureGotland.dbo.vwTjanst tjanst on anlaggning.strAnlnr = tjanst.strAnlnr) t) vwAnlaggning) x inner join (select ''Roma'' "socken" union select N''Björke'' union select ''Dalhem'' union select ''Halla'' union select ''Sjonhem'' union select ''Ganthem'' union select N''Hörsne'' union select ''Bara'' union select N''Källunge'' union select ''Vallstena'' union select ''Norrlanda'' union select ''Klinte'' union select N''Fröjel'' union select ''Eksta'') fastighetsfilter on strSocken = fastighetsfilter.socken)
                   , FilteredTjanste as (select strTaxekod, intTjanstnr, strAnlOrt, q2, strTaxebenamning, strDelprodukt, strAnlnr from (select strTaxekod,intTjanstnr,strAnlOrt,isnull(datStoppdatum, smalldatetimefromparts(1900, 01, 01, 00, 00)) q2,strTaxebenamning,vwRenhTjanstStatistik.strDelprodukt,strAnlnr from (select formated.strTaxekod,formated.intTjanstnr,formated.strAnlOrt,datStoppdatum,formated.strTaxebenamning,formated.strDelprodukt,strAnlnr from EDPFutureGotland.dbo.vwRenhTjanstStatistik formated inner join EDPFutureGotland.dbo.vwTjanst tjanst on tjanst.intTjanstnr = formated.intTjanstnr where formated.intTjanstnr is not null and formated.intTjanstnr != 0 and formated.intTjanstnr != '''' ) vwRenhTjanstStatistik left outer join (select N''DEPO'' "strDelprodukt" union select N''CONT'' union select N''GRUNDR'' union select N''ÖVRTRA'' union select N''ÖVRTRA'' union select ''HUSH'' union select N''ÅVCTR'') q on vwRenhTjanstStatistik.strDelprodukt = q.strDelprodukt where q.strDelprodukt is null) p where strTaxekod != ''BUDSM'' AND left(strTaxekod, ''4'') != ''HYRA'' and coalesce(strDelprodukt,strTaxebenamning) is not null)
                   , formated as (select intTjanstnr, strDelprodukt, strTaxebenamning, max(q2) q2z,max(strAnlnr) strAnlnrx from FilteredTjanste group by strTaxekod, intTjanstnr, strAnlOrt, strDelprodukt, strTaxebenamning)
                select strFastBeteckningHel, decAnlXKoordinat, decAnlYkoordinat, intTjanstnr, strDelprodukt, strTaxebenamning, q2z from anlaggning inner join formated on anlaggning.strAnlnr = formated.strAnlnrx END'
        select @object
    select * into #taxekod from openquery(admsql01,@object);
    INSERT INTO @statusTable select N'rebuilt#Taxekod' as alias, CURRENT_TIMESTAMP as CT, @@ROWCOUNT as [@]
    end else INSERT INTO @statusTable select N'preloading#Taxekod' as alias2, CURRENT_TIMESTAMP as T, @@ROWCOUNT as [@2]
goto TableInitiate
;
rodx:
set @tid = CURRENT_TIMESTAMP INSERT INTO @statusTable (medelande)  select N'Starting#Röd' as alias2345678910111213141516171819
BEGIN TRY BEGIN TRANSACTION
         BEGIN TRY DROP TABLE #slam END TRY BEGIN CATCH select 1 END CATCH
        ;with
            taxekod as (select * from #taxekod )
            ,slam as ( select max(q2z) q2z,strDelprodukt, strTaxebenamning,strFastBeteckningHel, decAnlXKoordinat, decAnlYkoordinat
                        from taxekod q group by strDelprodukt, strTaxebenamning,strFastBeteckningHel,decAnlXKoordinat,decAnlYkoordinat)
            select * into #slam from slam;
        ;with
             slamm as (select strFastBeteckningHel,strDelprodukt,z2 = STUFF((SELECT distinct ','+ concat(nullif(x.strTaxebenamning,''), nullif(concat(' Avbrutet:', FORMAT(nullif(x.q2z, smalldatetimefromparts(1900, 01, 01, 00, 00)), 'yyyy-MM-dd')), ' Avbrutet:')) as c
            FROM #slam x where q.strFastBeteckningHel = x.strFastBeteckningHel FOR XML PATH ('')), 1, 1, '')FROM #slam q group by strFastBeteckningHel,strDelprodukt)
            ,slam as (select strFastBeteckningHel,datStoppdatum =STUFF((SELECT distinct ','+nullif(strDelprodukt+'|','|')+z2 as nadas FROM slamm x where q.strFastBeteckningHel = x.strFastBeteckningHel FOR XML PATH ('')), 1, 1, '')from slamm q group by strFastBeteckningHel)
            ,socknarOfInteresse as (select distinct sockenX socken, fastighet from #SockenYtor )
            ,byggnader as (select Fastighetsbeteckning fastighet, Byggnadstyp,ByggShape from #ByggnadPaFastighetISocken)
            ,vaPlan as (select fastighet,typ  from #spillvaten)
            ,egetOmhandertagande as (select  fastighet,egetOmhandertangandeInfo,LocaltOmH from #egetOmhandertagande )
            ,anlaggningar as (select diarienummer,Fastighet,Fastighet_tillstand,Beslut_datum,utförddatum,Anteckning,(case when not (Beslut_datum > DATETIME2FROMPARTS(2003, 1, 1, 1, 1, 1, 1, 1) and utförddatum > DATETIME2FROMPARTS(2003, 1, 1, 1, 1, 1, 1, 1)) then N'röd' else N'grön' end) fstatus,anlaggningspunkt from #Socken_tillstand)
            , attUtsokaFran as (select *, row_number() over (partition by q.fastighet order by q.Anteckning desc ) flaggnr from (select anlaggningar.diarienummer,(case when anlaggningar.anlaggningspunkt is not null then anlaggningar.fstatus else '?' end) fstatus, socknarOfInteresse.socken,socknarOfInteresse.fastighet,Byggnadstyp,Fastighet_tillstand,Beslut_datum,utförddatum,Anteckning,(case when anlaggningar.anlaggningspunkt is not null then anlaggningar.anlaggningspunkt else ByggShape end) flagga from socknarOfInteresse left outer join byggnader on socknarOfInteresse.fastighet = byggnader.fastighet left outer join anlaggningar on socknarOfInteresse.fastighet = anlaggningar.fastighet) q  where q.flagga is not null)
            ,q as (select attUtsokaFran.socken,attUtsokaFran.fastighet,attUtsokaFran.Fastighet_tillstand,attUtsokaFran.Diarienummer,attUtsokaFran.Byggnadstyp,Beslut_datum,utförddatum "utförddatum",attUtsokaFran.Anteckning,
                    VaPlan                   = (select top 1 typ from vaPlan where vaPlan.fastighet = attUtsokaFran.fastighet),fstatus,
                    egetOmhandertangandeInfo = (select top 1 egetOmhandertangandeInfo from egetOmhandertagande where attUtsokaFran.fastighet = egetOmhandertagande.fastighet),
                    slam                     = (select top 1 datStoppdatum from slam where attUtsokaFran.fastighet = slam.strFastBeteckningHel),flaggnr,flagga.STPointN(1) flagga from attUtsokaFran)
            ,rodx as ( select socken,fastighet,Fastighet_tillstand,Byggnadstyp,Beslut_datum,utförddatum,Anteckning,VaPlan,egetOmhandertangandeInfo,slam,flaggnr,flagga, (case when fstatus = N'röd' then (case when (vaPlan is null and egetOmhandertangandeInfo is null) then N'röd' else (case when VaPlan is not null then 'KomV?' else (case when null is not null then 'gem' else '?' end) end) end) else fstatus end ) Fstatus from q)
            select *into #rodx from rodx
Commit Transaction end try begin catch ROLLBACK TRANSACTION  insert into @statusTable select ERROR_MESSAGE() "m",CURRENT_TIMESTAMP "t",@@ROWCOUNT  "c"print 'failed to build'  end catch set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO @statusTable select 'rebuilt#',@tid,@@ROWCOUNT goto TableInitiate

repport:
    --begin try
select * from @statusTable
end try begin catch
    insert into @statusTable select ERROR_MESSAGE() "e",CURRENT_TIMESTAMP "t",@@ROWCOUNT "c"
    select * from @statusTable end catch

--Kopierade tabellföreteckning från gng.FLAGGSKIKTET_P
set @tid = CURRENT_TIMESTAMP INSERT INTO @statusTable (medelande)  select 'tableCreate#Inventering_Bjorke' "a"  BEGIN TRY BEGIN TRANSACTION
create table gng.Inventering_Bjorke
(
    OBJECTID            int not null
        constraint invBj_pk
            primary key,
    FASTIGHET           nvarchar(150),
    Fastighet_tillstand nvarchar(150),
    Arendenummer        nvarchar(50),
    Beslut_datum        datetime2,
    Status              nvarchar(50),
    Utskick_datum       datetime2,
    Anteckning          nvarchar(254),
    Utforddatum         datetime2,
    Slamhamtning        nvarchar(100),
    Antal_byggnader     numeric(38, 8),
    alltidsant          int,
    Shape               geometry,
    GDB_GEOMATTR_DATA   varbinary(max),
    skapad_datum        datetime2,
    andrad_datum        datetime2
) end try begin catch ROLLBACK TRANSACTION  insert into @statusTable select ERROR_MESSAGE() "m",CURRENT_TIMESTAMP "t",@@ROWCOUNT  "c"print 'failed to build'  end catch set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO @statusTable select 'built#',@tid,@@ROWCOUNT 
go
set @tid = CURRENT_TIMESTAMP INSERT INTO @statusTable (medelande)  select 'createIndex#Inventering_Bjorke' "a"  BEGIN TRY
create index invBj_idx
    on gng.Inventering_Bjorke (Shape)
end try begin catch ROLLBACK TRANSACTION  insert into @statusTable select ERROR_MESSAGE() "m",CURRENT_TIMESTAMP "t",@@ROWCOUNT  "c"print 'failed to build'  end catch set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO @statusTable select 'built#',@tid,@@ROWCOUNT
Commit Transaction
go
BEGIN TRANSACTION
insert into gng.Inventering_Bjorke (OBJECTID,                                           FASTIGHET,Fastighet_tillstand,  Beslut_datum,   Status,     Anteckning,                                                                                                                                                                 Utforddatum,                Slamhamtning,                Antal_byggnader,    alltidsant,  Shape,  skapad_datum,   andrad_datum)
select                             (row_number() over (order by fastighet,flaggnr)),    fastighet,Fastighet_tillstand,  Beslut_datum,   Fstatus,    concat(Byggnadstyp,' ',Anteckning,' ',nullif(concat('vaPlan: ',VaPlan,' '),'vaPlan:  '),nullif(concat('egetOmh: ',egetOmhandertangandeInfo,' '),'egetOmh:  ')),             utförddatum,                slam,                        flaggnr,            1,           flagga, CURRENT_TIMESTAMP,CURRENT_TIMESTAMP
from #rodx where Socken = N'Björke';
Commit Transaction
select * from #rodx where left(fastighet, len('Halla')) = 'Halla';

set @tid = CURRENT_TIMESTAMP INSERT INTO @statusTable (medelande)  select 'tableCreate#Inventering_dalhem' "a"  BEGIN TRY BEGIN TRANSACTION
create table gng.Inventering_dalhem
(
    OBJECTID            int not null
        constraint invdalhem_pk
            primary key,
    FASTIGHET           nvarchar(150),
    Fastighet_tillstand nvarchar(150),
    Arendenummer        nvarchar(50),
    Beslut_datum        datetime2,
    Status              nvarchar(50),
    Utskick_datum       datetime2,
    Anteckning          nvarchar(254),
    Utforddatum         datetime2,
    Slamhamtning        nvarchar(100),
    Antal_byggnader     numeric(38, 8),
    alltidsant          int,
    Shape               geometry,
    GDB_GEOMATTR_DATA   varbinary(max),
    skapad_datum        datetime2,
    andrad_datum        datetime2
) end try begin catch ROLLBACK TRANSACTION  insert into @statusTable select ERROR_MESSAGE() "m",CURRENT_TIMESTAMP "t",@@ROWCOUNT  "c"print 'failed to build'  end catch set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO @statusTable select 'built#',@tid,@@ROWCOUNT 
go
set @tid = CURRENT_TIMESTAMP INSERT INTO @statusTable (medelande)  select 'createIndex#Inventering_dalhem' "a"  BEGIN TRY
create index invdalhem_idx
    on gng.Inventering_dalhem (Shape)
end try begin catch ROLLBACK TRANSACTION  insert into @statusTable select ERROR_MESSAGE() "m",CURRENT_TIMESTAMP "t",@@ROWCOUNT  "c"print 'failed to build'  end catch set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO @statusTable select 'built#',@tid,@@ROWCOUNT
Commit Transaction
go
BEGIN TRANSACTION
insert into gng.Inventering_Dalhem (OBJECTID,                                           FASTIGHET,Fastighet_tillstand,  Beslut_datum,   Status,     Anteckning,                                                                                                                                                                 Utforddatum,                Slamhamtning,                Antal_byggnader,    alltidsant,  Shape,  skapad_datum,   andrad_datum)
select                             (row_number() over (order by fastighet,flaggnr)),    fastighet,Fastighet_tillstand,  Beslut_datum,   Fstatus,    concat(Byggnadstyp,' ',Anteckning,' ',nullif(concat('vaPlan: ',VaPlan,' '),'vaPlan:  '),nullif(concat('egetOmh: ',egetOmhandertangandeInfo,' '),'egetOmh:  ')),             utförddatum,                slam,                        flaggnr,            1,           flagga, CURRENT_TIMESTAMP,CURRENT_TIMESTAMP
from #rodx where Socken = 'Dalhem';
Commit Transaction


set @tid = CURRENT_TIMESTAMP INSERT INTO @statusTable (medelande)  select 'tableCreate#Inventering_frojel' "a"  BEGIN TRY BEGIN TRANSACTION
create table gng.Inventering_frojel
(
    OBJECTID            int not null
        constraint invfrojel_pk
            primary key,
    FASTIGHET           nvarchar(150),
    Fastighet_tillstand nvarchar(150),
    Arendenummer        nvarchar(50),
    Beslut_datum        datetime2,
    Status              nvarchar(50),
    Utskick_datum       datetime2,
    Anteckning          nvarchar(254),
    Utforddatum         datetime2,
    Slamhamtning        nvarchar(100),
    Antal_byggnader     numeric(38, 8),
    alltidsant          int,
    Shape               geometry,
    GDB_GEOMATTR_DATA   varbinary(max),
    skapad_datum        datetime2,
    andrad_datum        datetime2
) end try begin catch ROLLBACK TRANSACTION  insert into @statusTable select ERROR_MESSAGE() "m",CURRENT_TIMESTAMP "t",@@ROWCOUNT  "c"print 'failed to build'  end catch set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO @statusTable select 'built#',@tid,@@ROWCOUNT
go
set @tid = CURRENT_TIMESTAMP INSERT INTO @statusTable (medelande)  select 'createIndex#Inventering_frojel' "a"  BEGIN TRY
create index invfrojel_idx
    on gng.Inventering_frojel (Shape)
end try begin catch ROLLBACK TRANSACTION  insert into @statusTable select ERROR_MESSAGE() "m",CURRENT_TIMESTAMP "t",@@ROWCOUNT  "c"print 'failed to build'  end catch set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO @statusTable select 'built#',@tid,@@ROWCOUNT
Commit Transaction
go
BEGIN TRANSACTION
insert into gng.Inventering_frojel (OBJECTID,                                           FASTIGHET,Fastighet_tillstand,  Beslut_datum,   Status,     Anteckning,                                                                                                                                                                 Utforddatum,                Slamhamtning,                Antal_byggnader,    alltidsant,  Shape,  skapad_datum,   andrad_datum)
select                             (row_number() over (order by fastighet,flaggnr)),    fastighet,Fastighet_tillstand,  Beslut_datum,   Fstatus,    concat(Byggnadstyp,' ',Anteckning,' ',nullif(concat('vaPlan: ',VaPlan,' '),'vaPlan:  '),nullif(concat('egetOmh: ',egetOmhandertangandeInfo,' '),'egetOmh:  ')),             utförddatum,                slam,                        flaggnr,            1,           flagga, CURRENT_TIMESTAMP,CURRENT_TIMESTAMP
from #rodx where Socken = 'fröjel';
COMMIT TRANSACTION

set @tid = CURRENT_TIMESTAMP INSERT INTO @statusTable (medelande)  select 'tableCreate#Inventering_ganthem' "a"  BEGIN TRY BEGIN TRANSACTION
create table gng.Inventering_ganthem
(
    OBJECTID            int not null
        constraint invganthem_pk
            primary key,
    FASTIGHET           nvarchar(150),
    Fastighet_tillstand nvarchar(150),
    Arendenummer        nvarchar(50),
    Beslut_datum        datetime2,
    Status              nvarchar(50),
    Utskick_datum       datetime2,
    Anteckning          nvarchar(254),
    Utforddatum         datetime2,
    Slamhamtning        nvarchar(100),
    Antal_byggnader     numeric(38, 8),
    alltidsant          int,
    Shape               geometry,
    GDB_GEOMATTR_DATA   varbinary(max),
    skapad_datum        datetime2,
    andrad_datum        datetime2
) end try begin catch ROLLBACK TRANSACTION  insert into @statusTable select ERROR_MESSAGE() "m",CURRENT_TIMESTAMP "t",@@ROWCOUNT  "c"print 'failed to build'  end catch set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO @statusTable select 'built#',@tid,@@ROWCOUNT 
go
set @tid = CURRENT_TIMESTAMP INSERT INTO @statusTable (medelande)  select 'createIndex#Inventering_ganthem' "a"  BEGIN TRY
create index invganthem_idx
    on gng.Inventering_ganthem (Shape)
end try begin catch ROLLBACK TRANSACTION  insert into @statusTable select ERROR_MESSAGE() "m",CURRENT_TIMESTAMP "t",@@ROWCOUNT  "c"print 'failed to build'  end catch set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO @statusTable select 'built#',@tid,@@ROWCOUNT
Commit Transaction
go
BEGIN TRANSACTION
insert into gng.Inventering_ganthem (OBJECTID,                                           FASTIGHET,Fastighet_tillstand,  Beslut_datum,   Status,     Anteckning,                                                                                                                                                                 Utforddatum,                Slamhamtning,                Antal_byggnader,    alltidsant,  Shape,  skapad_datum,   andrad_datum)
select                             (row_number() over (order by fastighet,flaggnr)),    fastighet,Fastighet_tillstand,  Beslut_datum,   Fstatus,    concat(Byggnadstyp,' ',Anteckning,' ',nullif(concat('vaPlan: ',VaPlan,' '),'vaPlan:  '),nullif(concat('egetOmh: ',egetOmhandertangandeInfo,' '),'egetOmh:  ')),             utförddatum,                slam,                        flaggnr,            1,           flagga, CURRENT_TIMESTAMP,CURRENT_TIMESTAMP
from #rodx where Socken = 'ganthem';
Commit Transaction


set @tid = CURRENT_TIMESTAMP INSERT INTO @statusTable (medelande)  select 'tableCreate#Inventering_halla' "a"  BEGIN TRY BEGIN TRANSACTION
create table gng.Inventering_halla
(
    OBJECTID            int not null
        constraint invhalla_pk
            primary key,
    FASTIGHET           nvarchar(150),
    Fastighet_tillstand nvarchar(150),
    Arendenummer        nvarchar(50),
    Beslut_datum        datetime2,
    Status              nvarchar(50),
    Utskick_datum       datetime2,
    Anteckning          nvarchar(254),
    Utforddatum         datetime2,
    Slamhamtning        nvarchar(100),
    Antal_byggnader     numeric(38, 8),
    alltidsant          int,
    Shape               geometry,
    GDB_GEOMATTR_DATA   varbinary(max),
    skapad_datum        datetime2,
    andrad_datum        datetime2
) end try begin catch ROLLBACK TRANSACTION  insert into @statusTable select ERROR_MESSAGE() "m",CURRENT_TIMESTAMP "t",@@ROWCOUNT  "c"print 'failed to build'  end catch set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO @statusTable select 'built#',@tid,@@ROWCOUNT
go
set @tid = CURRENT_TIMESTAMP INSERT INTO @statusTable (medelande)  select 'createIndex#Inventering_halla' "a"  BEGIN TRY
create index invhalla_idx
    on gng.Inventering_halla (Shape)
end try begin catch ROLLBACK TRANSACTION  insert into @statusTable select ERROR_MESSAGE() "m",CURRENT_TIMESTAMP "t",@@ROWCOUNT  "c"print 'failed to build'  end catch set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO @statusTable select 'built#',@tid,@@ROWCOUNT
Commit Transaction
go
BEGIN TRANSACTION
insert into gng.Inventering_halla (OBJECTID,                                           FASTIGHET,Fastighet_tillstand,  Beslut_datum,   Status,     Anteckning,                                                                                                                                                                 Utforddatum,                Slamhamtning,                Antal_byggnader,    alltidsant,  Shape,  skapad_datum,   andrad_datum)
select                             (row_number() over (order by fastighet,flaggnr)),    fastighet,Fastighet_tillstand,  Beslut_datum,   Fstatus,    concat(Byggnadstyp,' ',Anteckning,' ',nullif(concat('vaPlan: ',VaPlan,' '),'vaPlan:  '),nullif(concat('egetOmh: ',egetOmhandertangandeInfo,' '),'egetOmh:  ')),             utförddatum,                slam,                        flaggnr,            1,           flagga, CURRENT_TIMESTAMP,CURRENT_TIMESTAMP
from #rodx where Socken = 'halla';
Commit Transaction

set @tid = CURRENT_TIMESTAMP INSERT INTO @statusTable (medelande)  select 'tableCreate#Inventering_klinte' "a"  BEGIN TRY BEGIN TRANSACTION
create table gng.Inventering_klinte
(
    OBJECTID            int not null
        constraint invklinte_pk
            primary key,
    FASTIGHET           nvarchar(150),
    Fastighet_tillstand nvarchar(150),
    Arendenummer        nvarchar(50),
    Beslut_datum        datetime2,
    Status              nvarchar(50),
    Utskick_datum       datetime2,
    Anteckning          nvarchar(254),
    Utforddatum         datetime2,
    Slamhamtning        nvarchar(100),
    Antal_byggnader     numeric(38, 8),
    alltidsant          int,
    Shape               geometry,
    GDB_GEOMATTR_DATA   varbinary(max),
    skapad_datum        datetime2,
    andrad_datum        datetime2
) end try begin catch ROLLBACK TRANSACTION  insert into @statusTable select ERROR_MESSAGE() "m",CURRENT_TIMESTAMP "t",@@ROWCOUNT  "c"print 'failed to build'  end catch set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO @statusTable select 'built#',@tid,@@ROWCOUNT 
go
set @tid = CURRENT_TIMESTAMP INSERT INTO @statusTable (medelande)  select 'createIndex#Inventering_klinte' "a"  BEGIN TRY
create index invklinte_idx
    on gng.Inventering_klinte (Shape)
end try begin catch ROLLBACK TRANSACTION  insert into @statusTable select ERROR_MESSAGE() "m",CURRENT_TIMESTAMP "t",@@ROWCOUNT  "c"print 'failed to build'  end catch set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO @statusTable select 'built#',@tid,@@ROWCOUNT
Commit Transaction
go
BEGIN TRANSACTION
insert into gng.Inventering_klinte (OBJECTID,                                           FASTIGHET,Fastighet_tillstand,  Beslut_datum,   Status,     Anteckning,                                                                                                                                                                 Utforddatum,                Slamhamtning,                Antal_byggnader,    alltidsant,  Shape,  skapad_datum,   andrad_datum)
select                             (row_number() over (order by fastighet,flaggnr)),    fastighet,Fastighet_tillstand,  Beslut_datum,   Fstatus,    concat(Byggnadstyp,' ',Anteckning,' ',nullif(concat('vaPlan: ',VaPlan,' '),'vaPlan:  '),nullif(concat('egetOmh: ',egetOmhandertangandeInfo,' '),'egetOmh:  ')),             utförddatum,                slam,                        flaggnr,            1,           flagga, CURRENT_TIMESTAMP,CURRENT_TIMESTAMP
from #rodx where Socken = 'klinte';
Commit Transaction

set @tid = CURRENT_TIMESTAMP INSERT INTO @statusTable (medelande)  select 'tableCreate#Inventering_Roma' "a"  BEGIN TRY BEGIN TRANSACTION
create table gng.Inventering_Roma
(
    OBJECTID            int not null
        constraint invRoma_pk
            primary key,
    FASTIGHET           nvarchar(150),
    Fastighet_tillstand nvarchar(150),
    Arendenummer        nvarchar(50),
    Beslut_datum        datetime2,
    Status              nvarchar(50),
    Utskick_datum       datetime2,
    Anteckning          nvarchar(254),
    Utforddatum         datetime2,
    Slamhamtning        nvarchar(100),
    Antal_byggnader     numeric(38, 8),
    alltidsant          int,
    Shape               geometry,
    GDB_GEOMATTR_DATA   varbinary(max),
    skapad_datum        datetime2,
    andrad_datum        datetime2
) end try begin catch ROLLBACK TRANSACTION  insert into @statusTable select ERROR_MESSAGE() "m",CURRENT_TIMESTAMP "t",@@ROWCOUNT  "c"print 'failed to build'  end catch set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO @statusTable select 'built#',@tid,@@ROWCOUNT
go
set @tid = CURRENT_TIMESTAMP INSERT INTO @statusTable (medelande)  select 'createIndex#Inventering_Roma' "a"  BEGIN TRY
create index invRoma_idx
    on gng.Inventering_Roma (Shape)
end try begin catch ROLLBACK TRANSACTION  insert into @statusTable select ERROR_MESSAGE() "m",CURRENT_TIMESTAMP "t",@@ROWCOUNT  "c"print 'failed to build'  end catch set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO @statusTable select 'built#',@tid,@@ROWCOUNT
Commit Transaction
go
BEGIN TRANSACTION
insert into gng.Inventering_Roma (OBJECTID,                                           FASTIGHET,Fastighet_tillstand,  Beslut_datum,   Status,     Anteckning,                                                                                                                                                                 Utforddatum,                Slamhamtning,                Antal_byggnader,    alltidsant,  Shape,  skapad_datum,   andrad_datum)
select                             (row_number() over (order by fastighet,flaggnr)),    fastighet,Fastighet_tillstand,  Beslut_datum,   Fstatus,    concat(Byggnadstyp,' ',Anteckning,' ',nullif(concat('vaPlan: ',VaPlan,' '),'vaPlan:  '),nullif(concat('egetOmh: ',egetOmhandertangandeInfo,' '),'egetOmh:  ')),             utförddatum,                slam,                        flaggnr,            1,           flagga, CURRENT_TIMESTAMP,CURRENT_TIMESTAMP
from #rodx where Socken = 'Roma';
Commit Transaction




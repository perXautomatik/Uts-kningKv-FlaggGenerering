/*Insert Databases names into SQL Temp Table*/
declare @statusTable table(one NVARCHAR(max),start datetime,rader integer);
declare @rebuiltStatus1 as binary = 0;
declare @rebuiltStatus2 as binary = 0;
declare @socknarOfInterest table (Socken nvarchar (100) not null , shape geometry)

insert into @socknarOfInterest
select SOCKEN,Shape from
          STRING_SPLIT(N'Björke,Dalhem,Fröjel,Ganthem,Halla,Klinte,Roma', ',') socknarOfIntresse
          inner join
              sde_regionstyrelsen.gng.nyko_socknar_y_evw
                  on SOCKEN = value

-- dropTabels?

if (select null) IS NULL
    BEGIN
        TRY
Drop table #FastighetsYtor
Drop table #ByggnadPåFastighetISocken
Drop table #Socken_tillstånd
Drop table #egetOmhändertagande
Drop table #spillvaten
Drop table #taxekod
Drop table #röd
        INSERT INTO @statusTable
        select '#Rebuilding',CURRENT_TIMESTAMP,@@ROWCOUNT END TRY BEGIN CATCH SELECT 1 END CATCH else INSERT INTO @statusTable select 'preloading#DidNotDiscard'
             ,CURRENT_TIMESTAMP,@@ROWCOUNT
;


TableInitiate:
IF OBJECT_ID('tempdb..#FastighetsYtor') IS NULL goto FastighetsYtor else
 INSERT INTO @statusTable
        select 'preloading#FastighetsYtor'
             ,CURRENT_TIMESTAMP,(select count(*) from #FastighetsYtor)
;
IF OBJECT_ID('tempdb..#ByggnadPåFastighetISocken') IS NULL goto ByggnadPåFastighetISocken else
 INSERT INTO @statusTable
        select 'preloading#ByggnadPåFastighetISocken'
             ,CURRENT_TIMESTAMP,(select count(*) from #ByggnadPåFastighetISocken)
;
IF OBJECT_ID('tempdb..#Socken_tillstånd') IS NULL goto Socken_tillstånd else
 INSERT INTO @statusTable
        select 'preloading#Socken_tillstånd'
             ,CURRENT_TIMESTAMP,(select count(*) from #Socken_tillstånd)
;
IF OBJECT_ID('tempdb..#egetOmhändertagande') IS NULL goto egetOmhändertagande else
 INSERT INTO @statusTable
        select 'preloading#egetOmhändertagande'
             ,CURRENT_TIMESTAMP,(select count(*) from #egetOmhändertagande)
;
IF OBJECT_ID('tempdb..#spillvaten') IS NULL goto spillvaten else
 INSERT INTO @statusTable
        select 'preloading#spillvaten'
             ,CURRENT_TIMESTAMP,(select count(*) from #spillvaten)
;
IF OBJECT_ID('tempdb..#taxekod') IS NULL goto taxekod else
 INSERT INTO @statusTable
        select 'preloading#taxekod'
             ,CURRENT_TIMESTAMP,(select count(*) from #taxekod)
;
IF OBJECT_ID('tempdb..#röd') IS NULL goto röd;
 else
 INSERT INTO @statusTable
        select 'preloading#röd'
             ,CURRENT_TIMESTAMP,(select count(*) from #röd)
;

 FastighetsYtor:
IF OBJECT_ID('tempdb..#FastighetsYtor') IS NULL
    Begin BEGIN TRY DROP TABLE #FastighetsYtor END TRY BEGIN CATCH select 1 END CATCH;

    with 
 fasWithShape as (select fa.FNR,fa.BETECKNING , fa.TRAKT, yt.Shape 
    	from sde_geofir_gotland.gng.FA_FASTIGHET fa inner join sde_gsd.gng.REGISTERENHET_YTA yt on fa.FNR = yt.FNR_FDS)
    	
     ,fasInnomSocken as (
    	    	SELECT BETECKNING FAStighet, x.Shape,so.socken, fnr Fnr_FDS
    		from  x
             inner join @socknarOfInterest so on x.Shape.STIntersects(so.shape) = 1
	)
    select * INTO #FastighetsYtor 
	from fasInnomSocken;

        INSERT INTO @statusTable select 'rebuilt#FastighetsYtor',CURRENT_TIMESTAMP,@@ROWCOUNT
    set @rebuiltStatus1 = 1 end else INSERT INTO @statusTable select 'preloading#FastighetsYtor',CURRENT_TIMESTAMP,@@ROWCOUNT
goto TableInitiate;
ByggnadPåFastighetISocken:
IF OBJECT_ID(N'tempdb..#ByggnadPåFastighetISocken') is null OR @rebuiltStatus1 = 1
       --ByggBeslut as (select Ärendenummer,                         Byggnadstyp,                    Fastighetsbeteckning,  concat(Inkommande_datum,Registereringsdatum,År,Beslutsdatum,Status,Planbedömning,Beslutsnivå,Ärendetyp) rest,   GDB_GEOMATTR_DATA,  Shape, OBJECTID  from sde_bygglov.gng.BYGGLOVSPUNKTER union all select concat(DIARIENR,ANSÖKAN),   ÄNDAMÅL,                     Beteckning,               concat(DATUM,BESLUT,ANTAL,concat(URSPRUNG,id, Kod),AVSER,ANVÄNDNING),                                   GDB_GEOMATTR_DATA,  Shape, OBJECTID  from sde_bygglov.gng.BYGGLOVREG_ALDRE_P union all select concat(DIARIENR,ANSÖKAN),   concat(BYGGNADSTY,ÄNDAMÅL),     AVSER,                 concat(DATUM,BESLUT,År,ANTAL,ANMÄRKNIN,ANM,ANSÖKAN_A),                                            GDB_GEOMATTR_DATA,  Shape, OBJECTID  from sde_bygglov.gng.BYGGLOVSREG_2007_2019_P union all select DIARIENR,                   BYGGNADSTY,                     ANSÖKAN_AV,            concat(ANM,BESLUT),                                                                      GDB_GEOMATTR_DATA,  Shape, OBJECTID  from sde_bygglov.gng.BYGGLOVSREGISTRERING_CA_1999_2007_P),

    begin BEGIN TRY DROP TABLE #ByggnadPåFastighetISocken END TRY BEGIN CATCH select 1 END CATCH
          --BEGIN TRY DROP TABLE #temp_byggnad_yta END TRY BEGIN CATCH select 1 END CATCH
      ;
    with
     fastighetsYtor      as (select * from  #fastighetsYtor)
 ,   byggnad_yta         as (select andamal1 Byggnadstyp, Shape from sde_gsd.gng.BYGGNAD),
  	byggnaderISocken as 
     (Select Byggnadstyp, fastighetsYtor.fastighet Fastighetsbeteckning, byggnad_yta.SHAPE 
     from byggnad_yta
		inner join @socknarOfInterest so on
	    byggnad_yta.
		shape.STIntersects(
	    fastighetsYtor.shape) = 1)

  	   ,ByggnadPaFastighetISocken as (  select      sy.FAStighet,sy.Fnr_FDS, bis.*  from #FastighetsYtor sy inner join byggnaderISocken bIS on bis.Shape.STIntersects(sy.Shape) = 1)         
,    withRownr           as (
	select *, 
	count(shape) over (partition by Fastighetsbeteckning) bygTot,
	   row_number() over (partition by sy.FAStighet order by bis.andamal1 ) orderz,    
	  from q)
   , OnlyOnePerFastighet as (        select Fastighetsbeteckning, Byggnadstyp,bygTot,shape
	from  withRownr     where orderz = 1 )
select * into #ByggnadPåFastighetISocken
 from OnlyOnePerFastighet
    ;
         INSERT INTO @statusTable select  N'rebuilt#ByggnadPåFastighetISocken',CURRENT_TIMESTAMP,@@ROWCOUNT
        END
    else INSERT INTO @statusTable select  N'preloading#ByggnadPåFastighetISocken',CURRENT_TIMESTAMP,@@ROWCOUNT
goto TableInitiate
;Socken_tillstånd:
IF (OBJECT_ID(N'tempdb..#Socken_tillstånd') IS NULL) OR @rebuiltStatus1 = 1
    begin
          BEGIN TRY DROP TABLE #Socken_tillstånd  END TRY BEGIN CATCH select 1 END CATCH;
       
          with
    fastighetsYtor   
	      as (select socken SockenX, FAStighet, Shape 
	      from #FastighetsYtor),
	, socknarOfIntresse as (select * from @socknarOfInterest)
        , AnSoMedSocken     as (select left(Fastighet_tillstand, IIF(charindex(' ', Fastighet_tillstand) = 0, len(Fastighet_tillstand) + 1, charindex(' ', Fastighet_tillstand)) - 1) socken,Diarienummer,Fastighet_tillstand z,Beslut_datum,Utford_datum,Anteckning,Shape anlShape from sde_miljo_halsoskydd.gng.ENSKILT_AVLOPP_sodra_P)
        , AnNoMedSocken     as (select left(Fastighet_tillstand, IIF(charindex(' ', Fastighet_tillstand) = 0, len(Fastighet_tillstand) + 1, charindex(' ', Fastighet_tillstand)) - 1) socken,Diarienummer,Fastighet_tillstand z,Beslut_datum,Utford_datum,Anteckning,Shape anlShape from sde_miljo_halsoskydd.gng.ENSKILT_AVLOPP_Norra_P)
        , AnMeMedSocken as (select left(Fastighet_tilstand, IIF(charindex(' ', Fastighet_tilstand) = 0, len(Fastighet_tilstand) + 1, charindex(' ', Fastighet_tilstand)) - 1) socken,Diarienummer,Fastighet_tilstand z,Beslut_datum,Utford_datum,Anteckning,Shape anlShape from sde_miljo_halsoskydd.gng.ENSKILT_AVLOPP_MELLERSTA_P)
   	, allaAv as (select socken, Diarienummer, z q, Beslut_datum, Utford_datum, Anteckning, anlShape from AnSoMedSocken union all select *from AnNoMedSocken union all select *from AnMeMedSocken)
	, geoAv as (select SockenX socken, Diarienummer, fastighetsYtor.FAStighet, Beslut_datum, Utford_datum, Anteckning, anlShape from (select *from allaAv where socken is null) UtanSocken inner join fastighetsYtor  on anlShape.STIntersects(fastighetsYtor.Shape) = 1)
                 sodra_p as (select Diarienummer, z q, Beslut_datum, Utford_datum, Anteckning, AllaAvlopp.anlShape, FAStighet from aSo AllaAvlopp inner join(select FiltreradeFast.*from FiltreradeFast inner join (select socken from aso group by socken) q on socken = sockenX) FFast on AllaAvlopp.socken = ffast.SockenX and AllaAvlopp.anlShape.STIntersects(FFast.Shape) = 1),
               Norra_p as (select Diarienummer, z q, Beslut_datum, Utford_datum, Anteckning, AllaAvlopp.anlShape, FAStighet from aNo AllaAvlopp inner join(select FiltreradeFast.*from FiltreradeFast inner join (select socken from aNo group by socken) q on socken = sockenX) FFast on AllaAvlopp.socken = ffast.SockenX and AllaAvlopp.anlShape.STIntersects(FFast.Shape) = 1),
               Mellersta_p as (select Diarienummer, z q, Beslut_datum, Utford_datum, Anteckning, AllaAvlopp.anlShape, FAStighet from aMo AllaAvlopp inner join(select FiltreradeFast.*from FiltreradeFast inner join (select socken from aMo group by socken) q on socken = sockenX) FFast on AllaAvlopp.socken = ffast.SockenX and AllaAvlopp.anlShape.STIntersects(FFast.Shape) = 1)
       	, SammanSlagna as (select Diarienummer, q "Fastighet_tillstand",isnull(TRY_CONVERT(DateTime, Beslut_datum,102), DATETIME2FROMPARTS(1988, 1, 1, 1, 1, 1, 1, 1)) Beslut_datum, isnull(TRY_CONVERT(DateTime, Utford_datum,102), DATETIME2FROMPARTS(1988, 1, 1, 1, 1, 1, 1, 1)) Utford_datum, Anteckning, anlShape, z.q fastighet from (select * from allaAv union all select * from geoAv) z inner join socknarOfIntresse x on x.socken = z.socken)
	, slamz	as (select IIF(
       			(
       			  IIF(Beslut_datum < @rodDatum, 1, 0) +	IIF(Utford_datum < @rodDatum, 1, 0) +
			  IIF(Utford_datum is null, 1, 0)) > 0 , N'röd', 'ok') statusx,
	  FAStighet,Diarienummer,Fastighet_tillstand,Beslut_datum,Utford_datum "utförddatum",Anteckning,anlShape AnlaggningsPunkt from SammanSlagna)
	,withRownr as (select *, row_number() over (partition by fastighet order  by coalesce(utförddatum,Beslut_datum) desc) as x from slamz)
	,OnePerFastighet as (select statusx, FAStighet, Diarienummer, Fastighet_tillstand, Beslut_datum, utförddatum, Anteckning, AnlaggningsPunkt
			     from withRownr where x = 1)

          select FAStighet,
                 Diarienummer,
                 q            "Fastighet_tillstand",
                 Beslut_datum,
                 Utford_datum "utförddatum",
                 Anteckning,
                 anlShape     AnlaggningsPunkt
          into #Socken_tillstånd
from OnePerFastighet 

    INSERT INTO @statusTable select N'rebuilt#Socken_tillstånd',CURRENT_TIMESTAMP,@@ROWCOUNT end else
        INSERT INTO @statusTable select N'preloading#Socken_tillstånd',CURRENT_TIMESTAMP,@@ROWCOUNT
goto TableInitiate
;egetOmhändertagande:
IF OBJECT_ID(N'tempdb..#egetOmhändertagande') is null  OR @rebuiltStatus1 = 1
    begin BEGIN TRY DROP TABLE #egetOmhändertagande END TRY BEGIN CATCH select 1 END CATCH
    ;with
fastighetsYtor as (select * 
	  from #FastighetsYtor)
          ,LOKALT_SLAM_P as ( select Diarienr,
       (case
	   when charindex(':', Fastighet_) <> 0 then Fastighet_
	   when charindex(':', Fastighe00) <> 0 then Fastighe00
	   when charindex(':', Lokalt_omh) <> 0 then Lokalt_omh end
   ) Fastighet
           ,Fastighet_,Fastighe00,Lokalt_omh, Anteckning,Beslutsdat,Eget_omhän, shape,
	    concat( nullif(LOKALT_SLAM_P.Lokalt_omh,''),' ',
	    	nullif(LOKALT_SLAM_P.Fastighet_,''),' ',
		nullif(LOKALT_SLAM_P.Fastighe00,'')) fas 
		from sde_miljo_halsoskydd.gng.MoH_Slam_Lokalt_p_evw LOKALT_SLAM_P) 
		where fas is not null and charindex(':',fas) > 0),
    
      , utan_fastighet2 as (select
	OBJECTID,Fastighet_,Fastighets,Eget_omhän,Lokalt_omh,Fastighe00,Beslutsdat,Diarienr,Anteckning,utan_fastighet.Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID,FAStighet
	 
      from LOKALT_SLAM_P
	  where
       Fastighet is null)
      , Med_fastighet as (select Diarienr, fastighetsYtor.Fastighet, Fastighet_, Fastighe00, Lokalt_omh, Anteckning, Beslutsdat, Eget_omhän, LOKALT_SLAM_P.shape, fases
      from LOKALT_SLAM_P inner join fastighetsYtor on  LOKALT_SLAM_P.fases
   	like '%' + fastighetsYtor.FAStighet + '%'),
       
       geoFast as (
	   select Fastighet_,Eget_omhän,Lokalt_omh,Fastighe00,Beslutsdat,Diarienr,Anteckning,utan_fastighet2.Shape,sYt.FAStighet
	   from  utan_fastighet2
	    inner join
       fastighetsYtor 
       sYt on sYt.shape.STIntersects(utan_fastighet2.Shape) = 1)
   
      ,MedOchUtanFas as (select 				Diarienr, Fastighet, Fastighet_, Fastighe00, Lokalt_omh, Anteckning, Beslutsdat, Eget_omhän, shape
			 from med_fastighet union all select 	Diarienr, FAStighet, Fastighet_, Fastighe00, Lokalt_omh, Anteckning, Beslutsdat, Eget_omhän, Shape
			 from geoFast)

  ,egetOmh as ( 
  select distinct fastighet,
  concat(nullif(ltrim(Diarienr)+' - ',' - '), nullif(ltrim(Fastighe00)+' - ',' - '),
           nullif(ltrim(Fastighet_)+' - ',' - '), nullif(ltrim(Eget_omhän)+' - ',' - '),
	    nullif(ltrim(Lokalt_omh)+' - ',' - '), nullif(ltrim(Anteckning)+' - ',' - '),
           FORMAT(Beslutsdat,' yyyy-MM-dd')) egetOmhändertangandeInfo 
	   from MedOchUtanFas sYMfuf)
         , egetOmhx as (select distinct * from egetOmh)
,egetOmhy as (
      select distinct fastighet
			      , STUFF((
    SELECT ', ' + CAST(egetOmhx.egetOmhändertangandeInfo AS VARCHAR(MAX))
    FROM egetOmhx
    WHERE (egetOmhx.FAStighet = r.FAStighet)
    FOR XML PATH(''),TYPE).value('(./text())[1]','VARCHAR(MAX)')
  ,1,2,'') AS vaTyp from egetOmhx r)

select * 
 into #egetOmhändertagande 
 from egetOmhy    ;       

    INSERT INTO @statusTable select N'rebuilt#egetOmhändertagande',CURRENT_TIMESTAMP,@@ROWCOUNT END else
        INSERT INTO @statusTable select N'preloading#egetOmhändertagande',CURRENT_TIMESTAMP,@@ROWCOUNT
goto TableInitiate
;spillvaten:
IF OBJECT_ID('tempdb..#spillvaten')is null  OR @rebuiltStatus1 = 1
    begin BEGIN TRY DROP TABLE #spillvaten END TRY BEGIN CATCH select 1 END CATCH

     ;with
        ,sYt as (select socken SockenX, FAStighet, Shape
		 from
	    --(select fa.FNR,fa.BETECKNING , fa.TRAKT, yt.Shape from sde_geofir_gotland.gng.FA_FASTIGHET fa inner join sde_gsd.gng.REGISTERENHET_YTA yt on fa.FNR = yt.FNR_FDS) x inner join(SELECT value "socken" from STRING_SPLIT(N'Björke,Dalhem,Fröjel,Ganthem,Halla,Klinte,Roma', ',')) as socknarOfIntresse on x.TRAKT like socknarOfIntresse.socken + '%')
	#FastighetsYtor
            )
    ,planOmr as   (select shape,dp_i_omr,planprog,planansokn from sde_VA.gng.Va_planomraden_171016),

    spillAvtalGemPlanAnsok as (
	select shape, concat(typkod,':',status,'(spill)') typ
	from sde_VA.gng.VO_Spillvatten VO_Spillvatten
    union all 
    select shape, 'AVTALSABONNENT [Tabell_ObjID: ]' as c
	from sde_VA.gng.AVTALSABONNENTER AVTALSABONNENTER
    union all 
    select shape, concat('GEMENSAMHETSANLAGGNING: ',GEMENSAMHETSANLAGGNINGAR.GA) as c2
	from sde_VA.gng.GEMENSAMHETSANLAGGNINGAR GEMENSAMHETSANLAGGNINGAR
    	union all 
	select shape,
	isnull(coalesce(
	nullif(concat('dp_i_omr:',dp_i_omr) ,'dp_i_omr:'), 
	nullif(concat('planprog:',planprog) ,'planprog:'), 
	nullif(concat('planansokn:',planansokn) ,'planansokn:')),
    N'okändStatus') as i 
    from planOmr)
      , vax as (select distinct sYt.fastighet, q.typ  from fastighetsYtor sYt inner join spillAvtalGemPlanAnsok q on sYt.shape.STIntersects(q.Shape) = 1)
,va as (

      select distinct fastighet
			      , STUFF((
    SELECT ', ' + CAST(vax.typ AS VARCHAR(MAX))
    FROM vax
    WHERE (vax.FAStighet = r.FAStighet)
    FOR XML PATH(''),TYPE).value('(./text())[1]','VARCHAR(MAX)')
  ,1,2,'') AS vaTyp			 from vax r)
  select left(fastighet,100), left(vaTyp,273) 
   into #spillvaten
 from va

    INSERT INTO @statusTable select 'rebuilt#spillvaten',CURRENT_TIMESTAMP,@@ROWCOUNT END else INSERT INTO @statusTable select 'preloading#spillvaten',
           CURRENT_TIMESTAMP,@@ROWCOUNT
goto TableInitiate
;taxekod:
IF OBJECT_ID(N'tempdb..#Taxekod')  is null   OR @rebuiltStatus2 = 1
    begin BEGIN TRY DROP TABLE #Taxekod END TRY BEGIN CATCH select 1 END CATCH;
	select 2 a into #taxekod
   --     select * into #taxekod from openquery(admsql01,'with anlaggning as (select strAnlnr,strAnlaggningsKategori,strFastBeteckningHel,case when nullif(decAnlYkoordinat, 0) is not null then nullif(decAnlXKoordinat, 0) end decAnlXKoordinat,case when nullif(decAnlXKoordinat, 0) is not null then nullif(decAnlYkoordinat, 0) end decAnlYkoordinat from (select left(strFastBeteckningHel, case when charindex('' '', strFastBeteckningHel) = 0 then len(strFastBeteckningHel) + 1 else charindex('' '', strFastBeteckningHel) end - 1) strSocken,strAnlnr,strAnlaggningsKategori,strFastBeteckningHel,decAnlXKoordinat,decAnlYkoordinat from (select strAnlnr, strAnlaggningsKategori, strFastBeteckningHel, decAnlXKoordinat, decAnlYkoordinat from (select anlaggning.* from EDPFutureGotland.dbo.vwAnlaggning anlaggning inner join EDPFutureGotland.dbo.vwTjanst tjanst on anlaggning.strAnlnr = tjanst.strAnlnr) t) vwAnlaggning) x inner join (select ''Roma'' "socken" union select N''Björke'' union select ''Dalhem'' union select ''Halla'' union select ''Sjonhem'' union select ''Ganthem'' union select N''Hörsne'' union select ''Bara'' union select N''Källunge'' union select ''Vallstena'' union select ''Norrlanda'' union select ''Klinte'' union select N''Fröjel'' union select ''Eksta'') fastighetsfilter on strSocken = fastighetsfilter.socken) , FilteredTjanste as (select strTaxekod, intTjanstnr, strAnlOrt, q2, strTaxebenamning, strDelprodukt, strAnlnr from (select strTaxekod,intTjanstnr,strAnlOrt,isnull(datStoppdatum, smalldatetimefromparts(1900, 01, 01, 00, 00)) q2,strTaxebenamning,vwRenhTjanstStatistik.strDelprodukt,strAnlnr from (select formated.strTaxekod,formated.intTjanstnr,formated.strAnlOrt,datStoppdatum,formated.strTaxebenamning,formated.strDelprodukt,strAnlnr from EDPFutureGotland.dbo.vwRenhTjanstStatistik formated inner join EDPFutureGotland.dbo.vwTjanst tjanst on tjanst.intTjanstnr = formated.intTjanstnr where formated.intTjanstnr is not null and formated.intTjanstnr != 0 and formated.intTjanstnr != '''' ) vwRenhTjanstStatistik left outer join (select N''DEPO'' "strDelprodukt" union select N''CONT'' union select N''GRUNDR'' union select N''ÖVRTRA'' union select N''ÖVRTRA'' union select ''HUSH'' union select N''ÅVCTR'') q on vwRenhTjanstStatistik.strDelprodukt = q.strDelprodukt where q.strDelprodukt is null) p where strTaxekod != ''BUDSM'' AND left(strTaxekod, ''4'') != ''HYRA'' and coalesce(strDelprodukt,strTaxebenamning) is not null) , formated as (select intTjanstnr, strDelprodukt, strTaxebenamning, max(q2) q2z,max(strAnlnr) strAnlnrx from FilteredTjanste group by strTaxekod, intTjanstnr, strAnlOrt, strDelprodukt, strTaxebenamning) select strFastBeteckningHel, decAnlXKoordinat, decAnlYkoordinat, intTjanstnr, strDelprodukt, strTaxebenamning, q2z from anlaggning inner join formated on anlaggning.strAnlnr = formated.strAnlnrx');
    INSERT INTO @statusTable select N'rebuilt#Taxekod',CURRENT_TIMESTAMP,@@ROWCOUNT end else INSERT INTO @statusTable select N'preloading#Taxekod',CURRENT_TIMESTAMP,@@ROWCOUNT
goto TableInitiate
;
röd:
IF OBJECT_ID(N'tempdb..#Röd')  is null   OR @rebuiltStatus2 = 1
    begin BEGIN TRY DROP TABLE #Röd END TRY BEGIN CATCH select 1 END CATCH
            BEGIN TRY DROP TABLE #slam END TRY BEGIN CATCH select 1 END CATCH
    declare @internalStatus table(one NVARCHAR(max),start datetime);
    ;
  
    with
            taxekod as (select * from #taxekod )
            ,slam as
			(select null q2z,null strDelprodukt,null  strTaxebenamning,null strFastBeteckningHel,null  decAnlXKoordinat,null  decAnlYkoordinat )
              --  ( select max(q2z) q2z,strDelprodukt, strTaxebenamning,strFastBeteckningHel, decAnlXKoordinat, decAnlYkoordinat from taxekod q group by strDelprodukt, strTaxebenamning,strFastBeteckningHel,decAnlXKoordinat,decAnlYkoordinat)
    		select * into #slam from slam
            INSERT INTO @internalStatus select N'(slam,taxekod)#Röd',CURRENT_TIMESTAMP
        ; 
	with
	    vaPlan as (select fastighet,typ  from #spillvaten)   
	    ,byggnader as (select fastighet, andamal1 Byggnadstyp,shape ByggShape from #ByggnadPåFastighetISocken)
 	     ,egetOmhandertagande as (select  fastighet,egetOmhändertangandeInfo,LocaltOmH from #egetOmhändertagande )
	     , socknarOfInteresse as (select distinct fastighet from #FastighetsYtor )
            ,anlaggningar as (select diarienummer,Fastighet,Fastighet_tillstand,Beslut_datum,utförddatum,Anteckning,(case when not( isnull(Beslut_datum, DATETIME2FROMPARTS(1988, 1, 1, 1, 1, 1, 1, 1)) > (select DATETIME2FROMPARTS(2003, 1, 1, 1, 1, 1, 1, 1) datum) and isnull(utförddatum, DATETIME2FROMPARTS(1988, 1, 1, 1, 1, 1, 1, 1)) > (select DATETIME2FROMPARTS(2003, 1, 1, 1, 1, 1, 1, 1) datum)) then N'röd' else N'grön' end) fstatus,anlaggningspunkt from #Socken_tillstånd)
            
	     ,slamm as (select strFastBeteckningHel,strDelprodukt,z2 = STUFF((SELECT distinct ','+ concat( nullif(x.strTaxebenamning,''), nullif(concat(' Avbrutet:', FORMAT(nullif(x.q2z, smalldatetimefromparts(1900, 01, 01, 00, 00)),'yyyy-MM-dd')), ' Avbrutet:'))FROM #slam x  where q.strFastBeteckningHel = x.strFastBeteckningHel  FOR XML PATH ('')), 1, 1, '')FROM #slam q group by strFastBeteckningHel,strDelprodukt)
             ,slam as (select strFastBeteckningHel,datStoppdatum =STUFF((SELECT distinct ','+nullif(strDelprodukt+'|','|')+z2 FROM slamm x  where q.strFastBeteckningHel = x.strFastBeteckningHel  FOR XML PATH ('')), 1, 1, '')from slamm q group by strFastBeteckningHel)
             
                   
           ,attUtsokaFran as (select *, row_number() over (partition by q.fastighet order by q.Anteckning desc ) flaggnr from (select anlaggningar.diarienummer,(case when anlaggningar.anlaggningspunkt is not null then anlaggningar.fstatus else '?' end) fstatus,socknarOfInteresse.fastighet,Byggnadstyp,Fastighet_tillstand,Beslut_datum,utförddatum,Anteckning,(case when anlaggningar.anlaggningspunkt is not null then anlaggningar.anlaggningspunkt else ByggShape end) flagga from socknarOfInteresse left outer join byggnader on socknarOfInteresse.fastighet = byggnader.fastighet left outer join anlaggningar on socknarOfInteresse.fastighet = anlaggningar.fastighet) q  where q.flagga is not null)

            ,gul as (select null "fstat" ) -- from fastighets_Anslutningar_Gemensamhetanläggningar)

    toTeamVatten as (
	    select   
      							   coalesce(fastighetsYtor.FAStighet, egetOmh.fastighet, va.fastighet, Fastighetsbeteckning,anlaggningar.FAStighet) fastighet,
       Fastighet_tillstand, Diarienummer, 
                                                          
                                                           FORMAT(nullif(attUtsokaFran.Beslut_datum, smalldatetimefromparts(1900, 01, 01, 00, 00)),'yyyy-MM-dd') Beslut_datum,
                                                           FORMAT(nullif(attUtsokaFran.utförddatum, smalldatetimefromparts(1900, 01, 01, 00, 00)),'yyyy-MM-dd') utförddatum,
       Anteckning 
							   
, Byggnadstyp typ, Byggnadstyp , 
     , typ VAantek
	         ,
statusx,
     , egetOmh.egetOmhändertangandeInfo
                                slam                     = (SELECT '')--(select top 1 datStoppdatum from slam where attUtsokaFran.fastighet = slam.strFastBeteckningHel)
           ,
     bygTot,
       coalesce(AnlaggningsPunkt,flagga).STPointN(1)  flagga 
	from fastighetsYtor
	full outer join anlaggningar on anlaggningar.FAStighet = fastighetsYtor.FAStighet
	full outer join egetOmh on fastighetsYtor.FAStighet = egetOmh.FAStighet
	full outer join  va on fastighetsYtor.FAStighet = va.FAStighet
	full outer join byggs on fastighetsYtor.FAStighet = byggs.Fastighetsbeteckning


    ,flaggKorrigering as (select
		    (case when fstatus = N'röd'
                 	 then (case when (
			 vaPlan is null 
			 and egetOmhändertangandeInfo is null) then N'röd'
                      		else (case when VaPlan is not null
                          		then 'KomV?'
					 else (case when null is not null
                              			then 'gem' else '?' end) end) end) 
						else fstatus end ) Fstatus
		
		
		fastighet,Fastighet_tillstand,Beslut_datum,utförddatum,Anteckning,egetOmhändertangandeInfo,Byggnadstyp,
		VaPlan,flagga,   
                  slam,
	 bygTot, 
		    from correctTypOVa)

            select * into #röd from  q2

    INSERT INTO @statusTable (one, start)  select one, start from @internalStatus

            INSERT INTO @statusTable select N'rebuilt#Röd',CURRENT_TIMESTAMP,@@ROWCOUNT end else INSERT INTO @statusTable select N'preloading#Röd',CURRENT_TIMESTAMP,@@ROWCOUNT;

repport:
select * from @statusTable

select * from #röd
--select * from #röd where left(fastighet, len('Björke')) = 'Björke';
--select * from #röd where left(fastighet, len('Dalhem')) = 'Dalhem';
--select * from #röd where left(fastighet, len('Fröjel')) = 'Fröjel';
--select * from #röd where left(fastighet, len('Ganthem')) = 'Ganthem';
--select * from #röd where left(fastighet, len('Halla')) = 'Halla';
--select * from #röd where left(fastighet, len('Halla')) = 'Halla';
--select * from #röd where left(fastighet, len('Roma')) = 'Roma';


              --select *
--        ifall ansökan på ärende på fastigheten, skriv diarenummer
--        anteckning + anmärkning
--        fastighets_Anslutningar_Gemensamhetanläggningar (gemNamn)
--        from  färdigt

--select * from grön
--union all
--select * from röd




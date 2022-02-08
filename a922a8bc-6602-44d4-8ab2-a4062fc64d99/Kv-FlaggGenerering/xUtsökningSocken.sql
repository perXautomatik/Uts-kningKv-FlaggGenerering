IF OBJECT_ID('tempdb..#statusTable') IS not null
        drop table #statusTable;
	create table #statusTable (one NVARCHAR(max),start datetime,rader integer);
go

IF OBJECT_ID('tempdb..#settingTable') IS not NULL
    drop table #settingTable;
   begin try
    create Table #settingTable (
    rodDatum datetime
    ,RebuildStatus integer
    );

    insert into #settingTable (rodDatum, RebuildStatus)
    select DATETIME2FROMPARTS(2006, 10, 1, 1, 1, 1, 1, 1),  1
-- dropTabels?
	end try begin catch select '' end catch
go

IF OBJECT_ID('tempdb..#socknarOfInterest') IS not NULL
    drop table #socknarOfInterest;

    create table #socknarOfInterest (Socken nvarchar (100) not null , shape geometry);

insert into #socknarOfInterest
select SOCKEN,Shape from
          STRING_SPLIT(N'Eksta,Hemse,Hablingbo,Havdhem,grötlingbo,Fide,Öja'
              , ',')
	   socknarOfIntresse
          inner join
              sde_regionstyrelsen.gng.nyko_socknar_y_evw
                  on SOCKEN = value

       INSERT INTO #statusTable
        select '',CURRENT_TIMESTAMP,@@ROWCOUNT
;
go

TableInitiate:
-- dropTabels?

if (select null) IS NULL BEGIN TRY Drop table #FastighetsYtor end try begin catch select '' end catch
if (select null) IS NULL BEGIN TRY Drop table #ByggnadPåFastighetISocken end try begin catch select '' end catch
if (select null) IS NULL BEGIN TRY Drop table #Socken_tillstånd end try begin catch select '' end catch
if (select '') IS NULL BEGIN TRY Drop table #egetOmhändertagande end try begin catch select '' end catch
if (select '') IS NULL BEGIN TRY Drop table #spillvatten end try begin catch select '' end catch
if (select '') IS NULL BEGIN TRY Drop table #taxekod end try begin catch select '' end catch
if (select null) IS NULL BEGIN TRY Drop table #röd end try begin catch select '' end catch
;
go

 FastighetsYtor:
IF OBJECT_ID('tempdb..#FastighetsYtor') IS NULL
       OR (select top 1 RebuildStatus from #settingTable) = 1
    Begin BEGIN TRY DROP TABLE #FastighetsYtor END TRY BEGIN CATCH select 1 END CATCH;

    with 
       fasWithShape as (select fa.FNR,fa.BETECKNING , fa.TRAKT, yt.Shape from sde_geofir_gotland.gng.FA_FASTIGHET fa inner join sde_gsd.gng.REGISTERENHET_YTA yt on fa.FNR = yt.FNR_FDS)
     ,fasInnomSocken as (
    	    	SELECT BETECKNING FAStighet, x.Shape,so.socken, fnr Fnr_FDS
    		from  fasWithShape x
             inner join #socknarOfInterest so on x.Shape.STIntersects(so.shape) = 1
	)
    select * INTO #FastighetsYtor 
	from fasInnomSocken;

    INSERT INTO #statusTable select 'rebuilt#FastighetsYtor',CURRENT_TIMESTAMP,@@ROWCOUNT
    --set @rebuiltStatus1 = 1
        end
    else INSERT INTO #statusTable select 'preloading#FastighetsYtor',CURRENT_TIMESTAMP,@@ROWCOUNT
----goto TableInitiate;
 go
ByggnadPåFastighetISocken:
IF OBJECT_ID(N'tempdb..#ByggnadPåFastighetISocken') is null
       OR (select top 1 RebuildStatus from #SettingTable) = 1
       --ByggBeslut as (select Ärendenummer,                         Byggnadstyp,                    Fastighetsbeteckning,  concat(Inkommande_datum,Registereringsdatum,År,Beslutsdatum,Status,Planbedömning,Beslutsnivå,Ärendetyp) rest,   GDB_GEOMATTR_DATA,  Shape, OBJECTID  from sde_bygglov.gng.BYGGLOVSPUNKTER union all select concat(DIARIENR,ANSÖKAN),   ÄNDAMÅL,                     Beteckning,               concat(DATUM,BESLUT,ANTAL,concat(URSPRUNG,id, Kod),AVSER,ANVÄNDNING),                                   GDB_GEOMATTR_DATA,  Shape, OBJECTID  from sde_bygglov.gng.BYGGLOVREG_ALDRE_P union all select concat(DIARIENR,ANSÖKAN),   concat(BYGGNADSTY,ÄNDAMÅL),     AVSER,                 concat(DATUM,BESLUT,År,ANTAL,ANMÄRKNIN,ANM,ANSÖKAN_A),                                            GDB_GEOMATTR_DATA,  Shape, OBJECTID  from sde_bygglov.gng.BYGGLOVSREG_2007_2019_P union all select DIARIENR,                   BYGGNADSTY,                     ANSÖKAN_AV,            concat(ANM,BESLUT),                                                                      GDB_GEOMATTR_DATA,  Shape, OBJECTID  from sde_bygglov.gng.BYGGLOVSREGISTRERING_CA_1999_2007_P),

    begin BEGIN TRY DROP TABLE #ByggnadPåFastighetISocken END TRY BEGIN CATCH select 1 END CATCH
          --BEGIN TRY DROP TABLE #temp_byggnad_yta END TRY BEGIN CATCH select 1 END CATCH
      ;
    with
     fastighetsYtor      as (select * from  #fastighetsYtor)
 ,   byggnad_yta         as (select andamal1 Byggnadstyp, Shape from sde_gsd.gng.BYGGNAD),
  	byggnaderISocken as 
			     (Select Byggnadstyp, so.socken, byggnad_yta.SHAPE
			     from byggnad_yta
					inner join #socknarOfInterest so on
				    byggnad_yta.
					shape.STIntersects(
				    so.shape) = 1)
   ,ByggnadPaFastighetISocken as (  select  sy.FAStighet,sy.Fnr_FDS, bis.*  from fastighetsYtor sy
       inner join byggnaderISocken bIS on bis.Shape.STIntersects(sy.Shape) = 1)

,    withRownr           as (
	select *, 
	count(shape) over (partition by FAStighet) bygTot,
	   row_number() over (partition by FAStighet order by Byggnadstyp ) orderz
	  from ByggnadPaFastighetISocken )

    select FAStighet, Byggnadstyp, bygTot, shape
    into #ByggnadPåFastighetISocken
    from withRownr  where orderz = 1

    ;
         INSERT INTO #statusTable select  N'rebuilt#ByggnadPåFastighetISocken',CURRENT_TIMESTAMP,@@ROWCOUNT
        END
    else INSERT INTO #statusTable select  N'preloading#ByggnadPåFastighetISocken',CURRENT_TIMESTAMP,@@ROWCOUNT

----goto TableInitiate
go
;Socken_tillstånd:
	IF (OBJECT_ID(N'tempdb..#Socken_tillstånd') IS NULL) OR (select top 1 RebuildStatus from #SettingTable) = 1
	begin
	    begin try drop table #Socken_tillstånd end try begin catch select '' end catch;
          with
    socknarOfinterest as (select socken from #socknarOfInterest)

    , fastighetsYtor
	      as (select socken SockenX, FAStighet, Shape 
	      from #FastighetsYtor)

        , AnSoMedSocken     as (select left(fastighet, IIF(charindex(' ', fastighet) = 0, len(fastighet) + 1, charindex(' ', fastighet)) - 1) socken,*
               from (select (case when charindex(':', Fastighet_tillstand) > 0 then Fastighet_tillstand
               else case when charindex(':', fastighet_rening) > 0 then fastighet_rening
               else case when charindex(':', Anteckning) > 0 then Anteckning
               end end end) as fastighet,    Diarienummer,Fastighet_tillstand z,Beslut_datum,Utford_datum,Anteckning,Shape anlShape from  sde_miljo_halsoskydd.gng.ENSKILT_AVLOPP_sodra_P) q)
        , AnNoMedSocken   as (select left(fastighet, IIF(charindex(' ', fastighet) = 0, len(fastighet) + 1, charindex(' ', fastighet)) - 1) socken,*
               from (select (case when charindex(':', Fastighet_tillstand) > 0 then Fastighet_tillstand
               else case when charindex(':', fastighet_rening) > 0 then fastighet_rening
               else case when charindex(':', Anteckning) > 0 then Anteckning
               end end end) as fastighet,    Diarienummer,Fastighet_tillstand z,Beslut_datum,Utford_datum,Anteckning,Shape anlShape from  sde_miljo_halsoskydd.gng.ENSKILT_AVLOPP_Norra_P) q)
        , AnMeMedSocken as (select left(fastighet, IIF(charindex(' ', fastighet) = 0, len(fastighet) + 1, charindex(' ', fastighet)) - 1) socken,*
               from (select (case when charindex(':', Fastighet_tilstand) > 0 then Fastighet_tilstand
               else case when charindex(':', fastighet_rening) > 0 then fastighet_rening
               else case when charindex(':', Anteckning) > 0 then Anteckning
               end end end) as fastighet,    Diarienummer,Fastighet_tilstand z,Beslut_datum,Utford_datum,Anteckning,Shape anlShape from  sde_miljo_halsoskydd.gng.ENSKILT_AVLOPP_MELLERSTA_P) q)

       , sodra_p as (select Diarienummer, z q, Beslut_datum, Utford_datum, Anteckning, AllaAvlopp.anlShape, FFast.FAStighet,FFast.sockenX from AnSoMedSocken AllaAvlopp inner join
	   fastighetsytor FFast on AllaAvlopp.socken = ffast.SockenX and AllaAvlopp.anlShape.STIntersects(FFast.Shape) = 1)
	, Norra_p as (select Diarienummer, z q, Beslut_datum, Utford_datum, Anteckning, AllaAvlopp.anlShape, FFast.FAStighet,FFast.sockenX from AnNoMedSocken AllaAvlopp inner join
	   fastighetsytor FFast on AllaAvlopp.socken = ffast.SockenX and AllaAvlopp.anlShape.STIntersects(FFast.Shape) = 1)
	, Mellersta_p as (select Diarienummer, z q, Beslut_datum, Utford_datum, Anteckning, AllaAvlopp.anlShape, FFast.FAStighet,FFast.sockenX from AnMeMedSocken AllaAvlopp inner join
	   fastighetsytor FFast on AllaAvlopp.socken = ffast.SockenX and AllaAvlopp.anlShape.STIntersects(FFast.Shape) = 1)

	, allaAv as (select sockenX socken, Diarienummer, q, Beslut_datum, Utford_datum, Anteckning, anlShape from  (select * from sodra_p union all select *from norra_p union all select *from mellersta_p) a)
	, utanSocken as (select *from allaAv where socken is null)

	 , geoAv as (select SockenX socken, Diarienummer, fy.FAStighet, Beslut_datum, Utford_datum, Anteckning, anlShape from
	    UtanSocken inner join
	     fastighetsYtor fY on anlShape.STIntersects(fy.Shape) = 1)

	,SammanSlagna as (select * from allaAv union all select * from geoAv)

            ,filtreradeEfterSocken as (select Diarienummer, q "Fastighet_tillstand",
       	       TRY_CONVERT(DateTime, Beslut_datum,102) Beslut_datum,
       	       TRY_CONVERT(DateTime, Utford_datum,102) Utford_datum,
       	       Anteckning, anlShape, SammanSlagna.q fastighet from
       	      SammanSlagna inner join socknarOfinterest x on x.socken = SammanSlagna.socken)

             , WithSatus as
                 	(select
			IIF(
			    (IIF(isnull(Beslut_datum,
			    DATETIME2FROMPARTS(1988, 1, 1, 1, 1, 1, 1, 1)) < rodDatum, 1, 0) + IIF(isnull(Utford_datum,
			    DATETIME2FROMPARTS(1988, 1, 1, 1, 1, 1, 1, 1)) < rodDatum, 1, 0) + IIF(Utford_datum is null, 1, 0)) > 0
			    , N'röd', null) statusx,
			    FAStighet,Diarienummer,Fastighet_tillstand,Beslut_datum,Utford_datum "utförddatum", Anteckning,anlShape AnlaggningsPunkt
			    from filtreradeEfterSocken,#settingTable
                 	)
	,withRownr as (select *, row_number() over (partition by fastighet order  by statusx desc) as x from WithSatus) --null is first, ressulting in non-red first

          select FAStighet, Diarienummer, Fastighet_tillstand,
                 FORMAT(Beslut_datum, 'yyyy-MM-dd')                                                       Beslut_datum,
                 FORMAT(utförddatum, 'yyyy-MM-dd')                                                        "utförddatum",
                 Anteckning, AnlaggningsPunkt, 	statusx fstatus
          into #Socken_tillstånd
from withRownr where x = 1

    INSERT INTO #statusTable select N'rebuilt#Socken_tillstånd',CURRENT_TIMESTAMP,@@ROWCOUNT end
else
        INSERT INTO #statusTable select N'preloading#Socken_tillstånd',CURRENT_TIMESTAMP,@@ROWCOUNT
----goto TableInitiate
go
;egetOmhändertagande:
IF OBJECT_ID(N'tempdb..#egetOmhändertagande') is null --OR (select top 1 RebuildStatus from #SettingTable) = 1
    begin BEGIN TRY DROP TABLE #egetOmhändertagande END TRY BEGIN CATCH select 1 END CATCH
    ; with
fastighetsYtor as (select *
	  from #FastighetsYtor)

          ,LOKALT_SLAM_P as ( select Diarienr,
	   (case
	       when charindex(':', Fastighet_) <> 0 then Fastighet_
	       when charindex(':', Fastighe00) <> 0 then Fastighe00
	       when charindex(':', Lokalt_omh) <> 0 then Lokalt_omh end
	    ) Fastighet

	    ,nullif(rtrim(concat( nullif(LOKALT_SLAM_P.Lokalt_omh,''),' ',
	    	nullif(LOKALT_SLAM_P.Fastighet_,''),' ',
		nullif(LOKALT_SLAM_P.Fastighe00,''))),'') fas

           ,Fastighet_,Fastighe00,Lokalt_omh, Anteckning,Beslutsdat,Eget_omhän, shape
		from sde_miljo_halsoskydd.gng.MoH_Slam_Lokalt_p_evw LOKALT_SLAM_P
              )

           ,noShapeLikeMatch as (select Diarienr, fy.Fastighet, Fastighet_, Fastighe00, Lokalt_omh, Anteckning, Beslutsdat, Eget_omhän, fy.shape
			      from LOKALT_SLAM_P wf
				  left outer join fastighetsYtor fY
				  on wf.Fastighet like '%' + fy.FAStighet + '%')
  ,egetOmh as (
	      select row_number() over (partition by Fastighet order by Beslutsdat) Nr,
	             fastighet,shape,
	      concat(nullif(ltrim(Diarienr)+' - ',' - '), nullif(ltrim(Fastighe00)+' - ',' - '),
		       nullif(ltrim(Fastighet_)+' - ',' - '), nullif(ltrim(Eget_omhän)+' - ',' - '),
			nullif(ltrim(Lokalt_omh)+' - ',' - '), nullif(ltrim(Anteckning)+' - ',' - '),
		       FORMAT(Beslutsdat,' yyyy-MM-dd')) egetOmhändertangandeInfo
		       from noShapeLikeMatch  sYMfuf)
       ,egetOmhy as (
	      select fastighet,shape, nr
				      , STUFF((
	    SELECT ', ' + CAST(egetOmh.egetOmhändertangandeInfo AS VARCHAR(MAX))
	    FROM egetOmh
	    WHERE (egetOmh.FAStighet = r.FAStighet)
	    FOR XML PATH(''),TYPE).value('(./text())[1]','VARCHAR(MAX)')
	  ,1,2,'') AS  LocaltOmH from egetOmh r)

      select fastighet, shape, LocaltOmH
      into #egetOmhändertagande from egetOmhy where nr = 1  ;

    INSERT INTO #statusTable select N'rebuilt#egetOmhändertagande',CURRENT_TIMESTAMP,@@ROWCOUNT END else
        INSERT INTO #statusTable select N'preloading#egetOmhändertagande',CURRENT_TIMESTAMP,@@ROWCOUNT
----goto TableInitiate */
        go
;spillvatten:
IF OBJECT_ID('tempdb..#spillvatten')is null OR (select top 1 RebuildStatus from #settingtable) = 1-- OR @rebuiltStatus1 = 1
    begin BEGIN TRY DROP TABLE #spillvatten END TRY BEGIN CATCH select 1 END CATCH

     ;with
        fastighetsYtor as (select socken SockenX, FAStighet, Shape from #FastighetsYtor)
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
	    from planOmr
	    )
      , vax as (select distinct syt.fastighet, q.typ  from fastighetsYtor sYt inner join spillAvtalGemPlanAnsok q on sYt.shape.STIntersects(q.Shape) = 1)
,va as (
      select row_number() over (partition by FAStighet order by typ) nr,
             fastighet
	  , STUFF((
    SELECT ', ' + CAST(vax.typ AS VARCHAR(MAX))
    FROM vax
    WHERE (vax.FAStighet = r.FAStighet)
    FOR XML PATH(''),TYPE).value('(./text())[1]','VARCHAR(MAX)')
  ,1,2,'') AS vaTyp			 from vax r)

     select left(fastighet,100) fastighet, left(vaTyp,273) vaTyp
   	into #spillvatten
      from va where nr = 1

    INSERT INTO #statusTable select 'rebuilt#spillvatten',CURRENT_TIMESTAMP,@@ROWCOUNT END
    else INSERT INTO #statusTable select 'preloading#spillvatten',
           CURRENT_TIMESTAMP,@@ROWCOUNT
----goto TableInitiate
    go

;taxekod:
IF OBJECT_ID(N'tempdb..#Taxekod')  is null  -- OR @rebuiltStatus2 = 1
    begin BEGIN TRY DROP TABLE #Taxekod END TRY BEGIN CATCH select 1 END CATCH;

        select null q2z
			  , null strDelprodukt
			  , null strTaxebenamning
			  , null strFastBeteckningHel
			  , null decAnlXKoordinat
			  , null decAnlYkoordinat into #taxekod;

    BEGIN TRY DROP TABLE #slam END TRY BEGIN CATCH select 1 END CATCH declare @internalStatus table (one NVARCHAR(max), start datetime);;

	    with
		taxekod as (select * from #taxekod)
	      , slam    as
		    (select null q2z
			  , null strDelprodukt
			  , null strTaxebenamning
			  , null strFastBeteckningHel
			  , null decAnlXKoordinat
			  , null decAnlYkoordinat)
		--  ( select max(q2z) q2z,strDelprodukt, strTaxebenamning,strFastBeteckningHel, decAnlXKoordinat, decAnlYkoordinat from taxekod q group by strDelprodukt, strTaxebenamning,strFastBeteckningHel,decAnlXKoordinat,decAnlYkoordinat)
	    select *into #slam from slam

	INSERT INTO #statusTable (One,start,rader) select N'(slam,taxekod)#Röd', CURRENT_TIMESTAMP,0;
;
    with slamm               as (select strFastBeteckningHel
					 , strDelprodukt
					 , z2 = STUFF((SELECT distinct ',' + concat(nullif(x.strTaxebenamning, ''),
					nullif(concat(' Avbrutet:', FORMAT(
						nullif(x.q2z, smalldatetimefromparts(1900, 01, 01, 00, 00)),
						'yyyy-MM-dd')),
					       ' Avbrutet:'))
				       FROM #slam x
				       where q.strFastBeteckningHel = x.strFastBeteckningHel
				       FOR XML PATH ('')), 1, 1, '')
				    FROM #slam q
				    group by strFastBeteckningHel, strDelprodukt)

	  , slam                as (select strFastBeteckningHel
					 , datStoppdatum =STUFF(
					(SELECT distinct ',' + nullif(strDelprodukt + '|', '|') + z2
					 FROM slamm x
					 where q.strFastBeteckningHel = x.strFastBeteckningHel
					 FOR XML PATH ('')), 1, 1, '')
				    from slamm q
				    group by strFastBeteckningHel)
	select * from #taxekod


      -- select * into #taxekod from openquery(admsql01,'with anlaggning as (select strAnlnr,strAnlaggningsKategori,strFastBeteckningHel,case when nullif(decAnlYkoordinat, 0) is not null then nullif(decAnlXKoordinat, 0) end decAnlXKoordinat,case when nullif(decAnlXKoordinat, 0) is not null then nullif(decAnlYkoordinat, 0) end decAnlYkoordinat from (select left(strFastBeteckningHel, case when charindex('' '', strFastBeteckningHel) = 0 then len(strFastBeteckningHel) + 1 else charindex('' '', strFastBeteckningHel) end - 1) strSocken,strAnlnr,strAnlaggningsKategori,strFastBeteckningHel,decAnlXKoordinat,decAnlYkoordinat from (select strAnlnr, strAnlaggningsKategori, strFastBeteckningHel, decAnlXKoordinat, decAnlYkoordinat from (select anlaggning.* from EDPFutureGotland.dbo.vwAnlaggning anlaggning inner join EDPFutureGotland.dbo.vwTjanst tjanst on anlaggning.strAnlnr = tjanst.strAnlnr) t) vwAnlaggning) x inner join (select ''Roma'' "socken" union select N''Björke'' union select ''Dalhem'' union select ''Halla'' union select ''Sjonhem'' union select ''Ganthem'' union select N''Hörsne'' union select ''Bara'' union select N''Källunge'' union select ''Vallstena'' union select ''Norrlanda'' union select ''Klinte'' union select N''Fröjel'' union select ''Eksta'') fastighetsfilter on strSocken = fastighetsfilter.socken) , FilteredTjanste as (select strTaxekod, intTjanstnr, strAnlOrt, q2, strTaxebenamning, strDelprodukt, strAnlnr from (select strTaxekod,intTjanstnr,strAnlOrt,isnull(datStoppdatum, smalldatetimefromparts(1900, 01, 01, 00, 00)) q2,strTaxebenamning,vwRenhTjanstStatistik.strDelprodukt,strAnlnr from (select formated.strTaxekod,formated.intTjanstnr,formated.strAnlOrt,datStoppdatum,formated.strTaxebenamning,formated.strDelprodukt,strAnlnr from EDPFutureGotland.dbo.vwRenhTjanstStatistik formated inner join EDPFutureGotland.dbo.vwTjanst tjanst on tjanst.intTjanstnr = formated.intTjanstnr where formated.intTjanstnr is not null and formated.intTjanstnr != 0 and formated.intTjanstnr != '''' ) vwRenhTjanstStatistik left outer join (select N''DEPO'' "strDelprodukt" union select N''CONT'' union select N''GRUNDR'' union select N''ÖVRTRA'' union select N''ÖVRTRA'' union select ''HUSH'' union select N''ÅVCTR'') q on vwRenhTjanstStatistik.strDelprodukt = q.strDelprodukt where q.strDelprodukt is null) p where strTaxekod != ''BUDSM'' AND left(strTaxekod, ''4'') != ''HYRA'' and coalesce(strDelprodukt,strTaxebenamning) is not null) , formated as (select intTjanstnr, strDelprodukt, strTaxebenamning, max(q2) q2z,max(strAnlnr) strAnlnrx from FilteredTjanste group by strTaxekod, intTjanstnr, strAnlOrt, strDelprodukt, strTaxebenamning) select strFastBeteckningHel, decAnlXKoordinat, decAnlYkoordinat, intTjanstnr, strDelprodukt, strTaxebenamning, q2z from anlaggning inner join formated on anlaggning.strAnlnr = formated.strAnlnrx');
    --INSERT INTO #statusTable select N'rebuilt#Taxekod',CURRENT_TIMESTAMP,@@ROWCOUNT end else INSERT INTO #statusTable select N'preloading#Taxekod',CURRENT_TIMESTAMP,@@ROWCOUNT
----goto TableInitiate

end
    go
    ;
röd:
repport:
IF OBJECT_ID(N'tempdb..#Röd') is null
    begin
	BEGIN TRY DROP TABLE #Röd END TRY BEGIN CATCH select 1 END CATCH
;
	with
	    fastigheterx as (select * from #FastighetsYtor)
	   , gul                 as (select null "fstat") -- from fastighets_Anslutningar_Gemensamhetanläggningar)
	    ,vaPlan              as (select fastighet, vaTyp from #spillvatten)
	  , byggnader           as (select fastighet, Byggnadstyp, shape ByggShape, bygTot
				    from #ByggnadPåFastighetISocken)
	  , egetOmhandertagande as (select fastighet, LocaltOmH,shape from #egetOmhändertagande)
	  , anlaggningar        as (select diarienummer, Fastighet, Fastighet_tillstand, Beslut_datum, utförddatum, Anteckning,fstatus, anlaggningspunkt
				    from #Socken_tillstånd)
	  , joinedInOne        as (
				    select fastigheterX.socken,
					   coalesce(byggNader.FAStighet, anlaggningar.FAStighet, egetOmh.fastighet, va.fastighet, fastigheterX.fastighet)
						   fastighet
					 ,Fastighet_tillstand,
					   Diarienummer, Beslut_datum, utförddatum, Anteckning, Byggnadstyp
					 , vatyp vaPlan
					 , anlaggningar.fstatus fstatus
					 , LocaltOmH , ''                                                                         slam--(select top 1 datStoppdatum from slam where attUtsokaFran.fastighet = slam.strFastBeteckningHel)
					 , byggnader.bygTot
					 , coalesce(AnlaggningsPunkt, egetOmh.shape, byggnader.ByggShape).STPointN(1) flagga
					from byggnader
					    left outer join anlaggningar
						on anlaggningar.FAStighet = byggNader.FAStighet
					    left outer join egetOmhandertagande egetOmh
						on byggNader.FAStighet = egetOmh.FAStighet
					    left outer join vaPlan va
						on byggNader.FAStighet = va.FAStighet
    					    inner join fastigheterX
						on byggNader.FAStighet = fastigheterX.fastighet
				    )

	    , flaggKorrigering as (select
	           			(case when fstatus = N'röd' or FSTATUS is null
						then
						    (case
						        when (vaPlan is null and LocaltOmH is null)
						            then N'röd'
						     	else case when VaPlan is not null
							    then 'KomV?'
						    	else case when LocaltOmH is not null
						    	    then 'Lokalt' end
						      --else (case when null is not null then 'gem' else '?' end)
        					end end)
					    else
					        coalesce(fstatus,'?') end
					   ) status
	         			, socken, fastighet,Diarienummer,Fastighet_tillstand,Beslut_datum,utförddatum
	         			,Anteckning, LocaltOmH egetOmhändertagandeInfo, Byggnadstyp, VaPlan [Va-Spill], flagga, bygTot
				   from joinedInOne)
	select *
	into #röd
	from flaggKorrigering

	--INSERT INTO #statusTable (one, start) select one, start from @internalStatus
	INSERT INTO #statusTable select N'rebuilt#Röd', CURRENT_TIMESTAMP, @@ROWCOUNT
    end else INSERT INTO #statusTable select N'preloading#Röd', CURRENT_TIMESTAMP, @@ROWCOUNT;

select * from #statusTable
;
with q as (select distinct status,'' handläggare,socken,fastighet, Diarienummer,Fastighet_tillstand,Beslut_datum,utförddatum,Anteckning,egetOmhändertagandeInfo egetOmhändertangandeInfo,[Va-Spill],Byggnadstyp,bygTot from #röd)
    ,z as (select *,row_number() over (order by status,fastighet) rwnr from q)

select top 4000 status, handläggare, socken, fastighet, Diarienummer, Fastighet_tillstand, Beslut_datum, utförddatum, Anteckning, egetOmhändertangandeInfo, [Va-Spill], Byggnadstyp, bygTot
from z
	where rwnr > 500
	order by status desc



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




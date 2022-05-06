
 --:C:/Users/crbk01/AppData/Roaming/JetBrains/DataGrip2021.1/consoles/db/a922a8bc-6602-44d4-8ab2-a4062fc64d99/Kv-FlaggGenerering/RunConfig/a1createStatusTable.sql
begin try drop table #statusTable end try begin catch end catch create table #statusTable (one NVARCHAR(max), start datetime, rader integer);

declare @f as int;set @f = 0; begin try if OBJECT_ID('tempdb..#FastighetsYtor') IS not NULL set @f = (select count(*) from #FastighetsYtor)end try begin catch select '' end catch INSERT INTO #statusTable (one, start, rader) values('#FastighetsYtor', sysdatetime(),@f ) go
declare @f as int;set @f = 0; begin try if OBJECT_ID('tempdb..#ByggnadPåFastighetISocken') IS not NULL set @f = (select count(*) from #ByggnadPåFastighetISocken)end try begin catch select '' end catch INSERT INTO #statusTable (one, start, rader) values(	'#ByggnadP', sysdatetime(),@f ) go
declare @f as int;set @f = 0; begin try if OBJECT_ID('tempdb..#Socken_tillstånd 	') IS not NULL set @f = (select count(*) from #Socken_tillstånd )end try begin catch select '' end catch INSERT INTO #statusTable (one, start, rader) values(		'#Socken_tillstån', sysdatetime(),@f ) go
declare @f as int;set @f = 0; begin try if OBJECT_ID('tempdb..#egetOmhändertagande ') IS not NULL set @f = (select count(*) from #egetOmhändertagande)end try begin catch select '' end catch INSERT INTO #statusTable (one, start, rader) values(		'#egetOmhändertagand', sysdatetime(),@f ) go
declare @f as int;set @f = 0; begin try if OBJECT_ID('tempdb..#spillvatten') IS not NULL set @f = (select count(*) from #spillvatten )end try begin catch select '' end catch INSERT INTO #statusTable (one, start, rader) values(				'#spillvatten', sysdatetime(),@f ) go
declare @f as int;set @f = 0; begin try if OBJECT_ID('tempdb..#taxekod') IS not NULL set @f = (select count(*) from #taxekod )end try begin catch select '' end catch INSERT INTO #statusTable (one, start, rader) values(					'#taxekod', sysdatetime(),@f ) go
declare @f as int;set @f = 0; begin try if OBJECT_ID('tempdb..#röd') IS not NULL set @f = (select count(*) from #röd )end try begin catch select '' end catch INSERT INTO #statusTable (one, start, rader) values(						'#röd', sysdatetime(),@f ) go

select * from #statustable
go
 --:C:/Users/crbk01/AppData/Roaming/JetBrains/DataGrip2021.1/consoles/db/a922a8bc-6602-44d4-8ab2-a4062fc64d99/Kv-FlaggGenerering/RunConfig/a3SettingTable.sql
begin try drop table #settingTable end try begin catch select 'failed to drop setting table' end catch

create Table #settingTable (
rodDatum datetime
,RebuildStatus integer
,socknar nvarchar(300)
)

insert into #settingTable (rodDatum, RebuildStatus,socknar)
select DATETIME2FROMPARTS(2006, 10, 1, 1, 1, 1, 1, 1),
       0,
	N'Bara,Hörsne,Källunge,Norrlanda,Stenkyrka,Vallsten'
go

 --:C:/Users/crbk01/AppData/Roaming/JetBrains/DataGrip2021.1/consoles/db/a922a8bc-6602-44d4-8ab2-a4062fc64d99/Kv-FlaggGenerering/RunConfig/a2CleanUp.sql
/*todo: if buildTime delta bigger than a day, or if socknar not inside fastigheter
initiate complete rebuild */

if (select null) IS NULL BEGIN TRY Drop table #socknarOfInterest end try begin catch select 'error Drop table #socknarOfInterest' end catch
if (select null) IS NULL BEGIN TRY Drop table #FastighetsYtor end try begin catch select 'error Drop table #FastighetsYtor' end catch
if (select null) IS NULL BEGIN TRY Drop table #ByggnadPåFastighetISocken end try begin catch select 'error Drop table #ByggnadPåFastighetISocken' end catch
if (select null) IS NULL BEGIN TRY Drop table #Socken_tillstånd end try begin catch select 'error Drop table #Socken_tillstånd' end catch
if (select null) IS NULL BEGIN TRY Drop table #egetOmhändertagande end try begin catch select 'error Drop table #egetOmhändertagande ' end catch
if (select null) IS NULL BEGIN TRY Drop table #spillvatten end try begin catch select 'error Drop table #spillvatten' end catch
if (select null) IS NULL BEGIN TRY Drop table #taxekod end try begin catch select 'error Drop table #taxekod ' end catch
if (select null) IS NULL BEGIN TRY Drop table #röd end try begin catch select 'error Drop table #röd' end catch
if (select null) IS NULL BEGIN TRY Drop table #FiltreraMotFlaggskiktet  end try begin catch select 'error Drop table #FiltreraMotFlaggskiktet' end catch
go

 --:C:/Users/crbk01/AppData/Roaming/JetBrains/DataGrip2021.1/consoles/db/a922a8bc-6602-44d4-8ab2-a4062fc64d99/Kv-FlaggGenerering/RunConfig/bCreateSockenTable.sql
IF OBJECT_ID('tempdb..#socknarOfInterest') IS not null OR (select top 1 RebuildStatus from #settingTable) = 1
    BEGIN TRY DROP TABLE #socknarOfInterest END TRY BEGIN CATCH select 'could not drop #socknarOfInterest' END CATCH;
go;
IF OBJECT_ID('tempdb..#socknarOfInterest') IS null
begin
create table #socknarOfInterest (Socken nvarchar (100) not null , shape geometry)
insert into #socknarOfInterest
select SOCKEN,Shape from
          STRING_SPLIT((select socknar from #settingtable), ',')
	   socknarOfIntresse
          inner join
              sde_regionstyrelsen.gng.nyko_socknar_y_evw
                  on SOCKEN = value
end
go

 --:C:/Users/crbk01/AppData/Roaming/JetBrains/DataGrip2021.1/consoles/db/a922a8bc-6602-44d4-8ab2-a4062fc64d99/Kv-FlaggGenerering/RunConfig/cFastighetsYtor.sql
IF OBJECT_ID('tempdb..#FastighetsYtor') IS not null OR (select top 1 RebuildStatus from #settingTable) = 1
    BEGIN TRY DROP TABLE #FastighetsYtor END TRY BEGIN CATCH select 'could not drop FastighetsYtor' END CATCH;
go;
IF OBJECT_ID('tempdb..#FastighetsYtor') IS null
    Begin

    with 
       fasWithShape as (select fa.FNR,fa.BETECKNING , fa.TRAKT, yt.Shape from sde_geofir_gotland.gng.FA_FASTIGHET fa inner join sde_gsd.gng.REGISTERENHET_YTA yt on fa.FNR = yt.FNR_FDS)
     ,fasInnomSocken as (
    	    	SELECT BETECKNING FAStighet, x.Shape,so.socken, fnr Fnr_FDS
    		from  fasWithShape x
             inner join #socknarOfInterest so on left(x.BETECKNING,len(Socken)) = socken
	)
    select *
    INTO #FastighetsYtor
	from fasInnomSocken

    INSERT INTO #statusTable select 'rebuilt#FastighetsYtor',CURRENT_TIMESTAMP,@@ROWCOUNT
    --set @rebuiltStatus1 = 1
        end
    else INSERT INTO #statusTable select 'preloading#FastighetsYtor',CURRENT_TIMESTAMP,@@ROWCOUNT


----goto TableInitiate;
 go
 --:C:/Users/crbk01/AppData/Roaming/JetBrains/DataGrip2021.1/consoles/db/a922a8bc-6602-44d4-8ab2-a4062fc64d99/Kv-FlaggGenerering/RunConfig/dByggnader.sql
IF OBJECT_ID(N'tempdb..#ByggnadPåFastighetISocken') is not null OR (select top 1 RebuildStatus from #SettingTable) = 1
     BEGIN TRY DROP TABLE #ByggnadPåFastighetISocken END TRY BEGIN CATCH select 'error DROP TABLE #ByggnadPåFastighetISocken' END CATCH
          --BEGIN TRY DROP TABLE #temp_byggnad_yta END TRY BEGIN CATCH select 1 END CATCH
       --ByggBeslut as (select Ärendenummer,                         Byggnadstyp,                    Fastighetsbeteckning,  concat(Inkommande_datum,Registereringsdatum,År,Beslutsdatum,Status,Planbedömning,Beslutsnivå,Ärendetyp) rest,   GDB_GEOMATTR_DATA,  Shape, OBJECTID  from sde_bygglov.gng.BYGGLOVSPUNKTER union all select concat(DIARIENR,ANSÖKAN),   ÄNDAMÅL,                     Beteckning,               concat(DATUM,BESLUT,ANTAL,concat(URSPRUNG,id, Kod),AVSER,ANVÄNDNING),                                   GDB_GEOMATTR_DATA,  Shape, OBJECTID  from sde_bygglov.gng.BYGGLOVREG_ALDRE_P union all select concat(DIARIENR,ANSÖKAN),   concat(BYGGNADSTY,ÄNDAMÅL),     AVSER,                 concat(DATUM,BESLUT,År,ANTAL,ANMÄRKNIN,ANM,ANSÖKAN_A),                                            GDB_GEOMATTR_DATA,  Shape, OBJECTID  from sde_bygglov.gng.BYGGLOVSREG_2007_2019_P union all select DIARIENR,                   BYGGNADSTY,                     ANSÖKAN_AV,            concat(ANM,BESLUT),                                                                      GDB_GEOMATTR_DATA,  Shape, OBJECTID  from sde_bygglov.gng.BYGGLOVSREGISTRERING_CA_1999_2007_P),
go;
IF OBJECT_ID(N'tempdb..#ByggnadPåFastighetISocken') is null
   begin
      ;
    with
     fastighetsYtor      as (select * from  #fastighetsYtor)
 ,   byggnad_yta         as (select andamal1 Byggnadstyp, Shape from sde_gsd.gng.BYGGNAD),
  	byggnaderISocken as 
			     (Select Byggnadstyp, so.socken, byggnad_yta.SHAPE
			     from byggnad_yta
					inner join #socknarOfInterest so on
				    so.
					shape.STContains(
				    byggnad_yta.shape) = 1)
   ,ByggnadPaFastighetISocken as (  select  sy.FAStighet,sy.Fnr_FDS, bis.*  from fastighetsYtor sy
       inner join byggnaderISocken bIS on bis.Shape.STIntersects(sy.Shape) = 1)

,    withRownr           as (
	select *, 
	count(shape) over (partition by FAStighet) bygTot,
	   row_number() over (partition by FAStighet order by Byggnadstyp ) orderz
	  from ByggnadPaFastighetISocken )
	, OnlyOnePerFastighet 	as (  select FAStighet, Byggnadstyp,bygTot,shape from  withRownr     where orderz = 1 )
    select FAStighet, Byggnadstyp, bygTot, shape
    into #ByggnadPåFastighetISocken
				      from OnlyOnePerFastighet

    ;
         INSERT INTO #statusTable select  N'rebuilt#ByggnadPåFastighetISocken',CURRENT_TIMESTAMP,@@ROWCOUNT
        END
    else INSERT INTO #statusTable select  N'preloading#ByggnadPåFastighetISocken',CURRENT_TIMESTAMP,@@ROWCOUNT

----goto TableInitiate
go
 --:C:/Users/crbk01/AppData/Roaming/JetBrains/DataGrip2021.1/consoles/db/a922a8bc-6602-44d4-8ab2-a4062fc64d99/Kv-FlaggGenerering/RunConfig/eAnlaggningar.sql
IF (OBJECT_ID(N'tempdb..#Socken_tillstånd') IS not NULL)  and (select top 1 RebuildStatus from #SettingTable) = 1
    begin try drop table #Socken_tillstånd end try begin catch select 'failed to drop sockentillstånd' end catch;
	go;
IF (OBJECT_ID(N'tempdb..#Socken_tillstånd') IS NULL)
	begin
	    declare @AllIndexed table (indexI 		int identity, socken 	nvarchar (40), 	fastighet 	nvarchar(200), Diarienummer 	varchar(100), 	Fastighet_tillstand nvarchar(200),	Beslut_datum 	date,	Utford_datum	date, Anteckning	nvarchar(max), Shape 	geometry unique (indexI,socken,fastighet,Beslut_datum,Utford_datum))
	    declare @soIndexed table (indexI		int identity, socken	nvarchar (40), 	fastighet 	nvarchar(200), Diarienummer 	varchar(100), 	Fastighet_tillstand nvarchar(200),	Beslut_datum 	date, 	Utford_datum 	date, Anteckning 	nvarchar(max), Shape 	geometry unique (indexI,socken,fastighet,Beslut_datum,Utford_datum))
	    declare @NoIndexed table (indexI        	int identity, socken	nvarchar(40), 	fastighet       nvarchar(200), Diarienummer     varchar(100), 	Fastighet_tillstand nvarchar(200), 	Beslut_datum    date, 	Utford_datum  	date, Anteckning        nvarchar(max), Shape    geometry unique (indexI,socken,fastighet,Beslut_datum,Utford_datum))
	    declare @MeIndexed table (indexI        	int identity, socken	nvarchar(40), 	fastighet       nvarchar(200), Diarienummer     varchar(100), 	Fastighet_tillstand nvarchar(200), 	Beslut_datum    date, 	Utford_datum	date, Anteckning        nvarchar(max), Shape    geometry unique (indexI,socken,fastighet,Beslut_datum,Utford_datum))

	--Typ_byggnad, Antal_hushall_tillstand, Fastighet_rening, Typ_slamavskiljare, Storlek_m3, Typ_rening, Storlek_m2, Typ_sluten_tank, Storlek_m, Avgift, Tillstand_giltigt_tom, alltidsant, GDB_GEOMATTR_DATA, skapad_datum, andrad_datum,
	;with DateStandardisation as(select
	       left(IIF(charindex(':', Fastighet_tillstand) > 0, Fastighet_tillstand, IIF(charindex(':', fastighet_rening) > 0, fastighet_rening, case when charindex(':', Anteckning) > 0 then Anteckning end)), 200)
		   as fastighet,
	       OBJECTID, left(Diarienummer,100) Diarienummer, left(Fastighet_tillstand,200) Fastighet_tillstand,
	       TRY_CONVERT(Date, Beslut_datum,102) Beslut_datum, TRY_CONVERT(Date, Utford_datum,102) Utford_datum -- input is a datetimeColumn, so can never contain bogus info
	     , Anteckning, Shape from  sde_miljo_halsoskydd.gng.ENSKILT_AVLOPP_sodra_P)
	insert into @soIndexed (socken, fastighet, Diarienummer, Fastighet_tillstand, Beslut_datum, Utford_datum, Anteckning, Shape)
	select
	   left(left(fastighet, IIF(charindex(' ', fastighet) = 0, len(fastighet) + 1, charindex(' ', fastighet)) - 1),40) socken, fastighet
	       , Diarienummer, Fastighet_tillstand,beslut_datum,Utford_datum,
			    left( concat(
				case when
				    (try_cast(isnull(beslut_datum, DateFromParts(1988,1,1)) as nvarchar) <> try_cast(isnull(nullif(ltrim(Beslut_datum),''), DateFromParts(1987,1,1)) as nvarchar)
				     AND nullif(bda,'') is not null)
				    then concat('bes: ', bda) end ,
				case when
				    (try_cast(isnull(Utford_datum, DateFromParts(1988,1,1)) as nvarchar) <> try_cast(isnull(nullif(ltrim(Utford_datum),''), DateFromParts(1987,1,1)) as nvarchar)
				    AND nullif(uda,'') is not null)
				    then concat(' utf: ', uda)end
			  ,ltrim(Anteckning)),300) Anteckning
	     ,Shape anlShape
	       from (select *,ltrim(try_cast(Beslut_datum as nvarchar)) bda,ltrim(try_cast(Utford_datum as nvarchar)) uda from DateStandardisation) q
	;
	INSERT INTO #statusTable select N'rebuilt#Socken_tillstånd:Södra',CURRENT_TIMESTAMP,@@ROWCOUNT
	;
	;with DateStandardisation as(select OBJECTID, Diarienummer, Fastighet_tillstand, Typ_byggnad, Antal_hushall_tillstand, Fastighet_rening, Typ_slamavskiljare, Storlek_m3, Typ_rening, Storlek_m2, Typ_sluten_tank, Storlek_m,
	       TRY_CONVERT(Date, Beslut_datum,102) Beslut_datum, TRY_CONVERT(Date, Utford_datum,102) Utford_datum, Avgift, Tillstand_giltigt_tom, Anteckning, alltidsant, Shape, GDB_GEOMATTR_DATA, skapad_datum, andrad_datum
		   from
		sde_miljo_halsoskydd.gng.ENSKILT_AVLOPP_Norra_P)
	insert into @NoIndexed
				select
	   left(left(fastighet, IIF(charindex(' ', fastighet) = 0, len(fastighet) + 1, charindex(' ', fastighet)) - 1),40) socken,*
	       from (select left(IIF(charindex(':', Fastighet_tillstand) > 0, Fastighet_tillstand,
				     IIF(charindex(':', fastighet_rening) > 0, fastighet_rening,
					 case when charindex(':', Anteckning) > 0 then Anteckning
					 end)), 200) as fastighet,
					 left(Diarienummer,100) Diarienummer,left(Fastighet_tillstand,200)
					 Fastighet_tillstand,

					 beslut_datum,Utford_datum,
			    left(
			    concat( case when
				(try_cast(isnull(beslut_datum, DateFromParts(1988,1,1)) as nvarchar) <> try_cast(isnull(nullif(ltrim(Beslut_datum),''), DateFromParts(1987,1,1)) as nvarchar)

				 AND nullif(ltrim(try_cast(Beslut_datum as nvarchar)),'') is not null)
				then concat('bes: ', ltrim(try_cast(Beslut_datum as nvarchar))) end
			    ,
				case when
				(try_cast(isnull(Utford_datum, DateFromParts(1988,1,1)) as nvarchar)  <> try_cast(isnull(nullif(ltrim(Utford_datum),''), DateFromParts(1987,1,1)) as nvarchar)

				AND nullif(ltrim(try_cast(Utford_datum as nvarchar)),'') is not null)
				then concat(' utf: ', ltrim(try_cast(Utford_datum as nvarchar)))end
			  ,ltrim(Anteckning)),300)
				Anteckning,Shape                        anlShape
	   from DateStandardisation ) q
	;
	INSERT INTO #statusTable select N'rebuilt#Socken_tillstånd:Norra',CURRENT_TIMESTAMP,@@ROWCOUNT
	;
	;with DateStandardisation as(select OBJECTID, Diarienummer, Fastighet_tilstand, Typ_byggnad, Antal_hushall_tillstand, Fastighet_rening, Typ_slamavskiljare, Storlek_m3, Typ_rening, Storlek_m2, Typ_sluten_tank, Storlek_m,
	       TRY_CONVERT(Date, Beslut_datum,102) Beslut_datum, TRY_CONVERT(Date, Utford_datum,102) Utford_datum, Avgift, Tillstand_giltigt_tom, Anteckning, alltidsant, Shape, GDB_GEOMATTR_DATA, skapad_datum, andrad_datum
	   from  sde_miljo_halsoskydd.gng.ENSKILT_AVLOPP_MELLERSTA_P)
	insert into @MeIndexed
				select
	   left(left(fastighet, IIF(charindex(' ', fastighet) = 0, len(fastighet) + 1, charindex(' ', fastighet)) - 1),40) socken,*
	       from (select left(IIF(charindex(':', Fastighet_tilstand) > 0, Fastighet_tilstand,
				     IIF(charindex(':', fastighet_rening) > 0, fastighet_rening,
					 case when charindex(':', Anteckning) > 0 then Anteckning
					end)), 200) as fastighet,
		      left(Diarienummer,100) Diarienummer,left(Fastighet_tilstand,200) Fastighet_tillstand,beslut_datum, Utford_datum Utford_datum,
			    left(concat(
				  case when
				(try_cast(isnull(beslut_datum, DateFromParts(1988,1,1)) as nvarchar) <> try_cast(isnull(nullif(ltrim(Beslut_datum),''), DateFromParts(1987,1,1)) as nvarchar) AND nullif(ltrim(try_cast(Beslut_datum as nvarchar)),'') is not null)
				then concat('bes: ', ltrim(try_cast(Beslut_datum as nvarchar))) end
			    ,
				    case when
				(try_cast(isnull(Utford_datum, DateFromParts(1988,1,1)) as nvarchar)  <> try_cast(isnull(nullif(ltrim(Utford_datum),''), DateFromParts(1987,1,1)) as nvarchar) AND nullif(ltrim(try_cast(Utford_datum as nvarchar)),'') is not null)
				then concat(' utf: ', ltrim(try_cast(Utford_datum as nvarchar)))end
			  ,ltrim(Anteckning)),300)
				Anteckning,Shape                        anlShape
	       from DateStandardisation ) q
	;
	INSERT INTO #statusTable select N'rebuilt#Socken_tillstånd:mellersta',CURRENT_TIMESTAMP,@@ROWCOUNT
	;

	if exists(select zxxc.*,soi.Socken from (select socken,count(*) c from @soIndexed group by socken) zxxc inner join #socknarOfInterest soi on zxxc.socken = soi.Socken)
		begin insert into @AllIndexed select socken, fastighet, Diarienummer, Fastighet_tillstand, Beslut_datum, Utford_datum, Anteckning, Shape from @soIndexed end
	if exists(select zxxc.*,soi.Socken from (select socken,count(*) c from @NoIndexed group by socken) zxxc inner join #socknarOfInterest soi on zxxc.socken = soi.Socken)
		begin insert into @AllIndexed select socken, fastighet, Diarienummer, Fastighet_tillstand, Beslut_datum, Utford_datum, Anteckning, Shape from @NoIndexed end
	if exists(select zxxc.*,soi.Socken from (select socken,count(*) c from @meIndexed group by socken) zxxc inner join #socknarOfInterest soi on zxxc.socken = soi.Socken)
		begin insert into @AllIndexed select socken, fastighet, Diarienummer, Fastighet_tillstand, Beslut_datum, Utford_datum, Anteckning, Shape from @MeIndexed end
	; with
	    socknarOfinterest as (select socken from #socknarOfInterest)
  	  , fastighetsYtor as (select socken SockenX, FAStighet, Shape from #FastighetsYtor)
	    , withSocken     as (select so.* from @AllIndexed so left outer join socknarOfinterest sOI2 on sOI2.Socken = so.socken where sOI2.Socken is not null),
    		withoutSocken   as (select so.* from @AllIndexed so left outer join socknarOfinterest sOI2 on sOI2.Socken = so.socken where sOI2.Socken is null)
      	 , MatchedSocken as (select Diarienummer, Fastighet_tillstand, Beslut_datum, Utford_datum, Anteckning, so.Shape,
              FFast.FAStighet  fastighetx,so.fastighet, FFast.sockenX, so.socken from withSocken so left outer join fastighetsytor FFast on so.fastighet = ffast.FAStighet)
   	, geoIndexed as (select Diarienummer, Fastighet_tillstand, Beslut_datum, Utford_datum, Anteckning, no.Shape,
	       FFast.FAStighet  fastighetx,no.fastighet, FFast.sockenX, no.socken
	from
	     (select *from (select socken, fastighet, Diarienummer, Fastighet_tillstand, Beslut_datum, Utford_datum, Anteckning, Shape from MatchedSocken where fastighetx is null) qq union all select socken, fastighet, Diarienummer, Fastighet_tillstand, Beslut_datum, Utford_datum, Anteckning, Shape from withoutSocken)
	         no
	         inner join
	   fastighetsytor FFast on no.Shape.STIntersects(FFast.Shape) = 1)

	   ,allaAv as (select coalesce(sockenX,socken) socken, coalesce(fastighetx,fastighet) fastighet,Diarienummer, Fastighet_tillstand, Beslut_datum, Utford_datum, Anteckning,
		Shape from (select * from (select * from MatchedSocken where fastighetx is not null) matchedFastighet union all select *from geoIndexed) unionedX)

   	, slamz	as (select
		    IIF(	(IIF(isnull(Beslut_datum, DateFromParts(1988,1,1)) < rodDatum, 1, 0)
			     + IIF(isnull(Utford_datum, DateFromParts(1988,1,1)) < rodDatum, 1, 0) +
			    IIF(Utford_datum is null, 1, 0)) > 0 , N'röd', 'ok') fstatus,

			    FAStighet,Diarienummer,Fastighet_tillstand,Beslut_datum,Utford_datum "utförddatum",
			    Anteckning,Shape AnlaggningsPunkt
			    from
				 allaAv,#settingTable)
	,withRownr as (select *, row_number() over (partition by fastighet order  by coalesce(utförddatum,Beslut_datum) desc) as x from slamz)
        ,OnePerFastighet as (select fstatus, FAStighet, Diarienummer, Fastighet_tillstand, Beslut_datum, utförddatum Utford_datum, Anteckning, AnlaggningsPunkt
			     from withRownr where x = 1)
  select FAStighet, Diarienummer, Fastighet_tillstand
       , FORMAT(Beslut_datum, 'yyyy-MM-dd') Beslut_datum
       , FORMAT(Utford_datum, 'yyyy-MM-dd') "utförddatum"
       , Anteckning, AnlaggningsPunkt
       , fstatus                            fstatus
  into #Socken_tillstånd
  from OnePerFastighet

    INSERT INTO #statusTable select N'rebuilt#Socken_tillstånd',CURRENT_TIMESTAMP,@@ROWCOUNT end
else
        INSERT INTO #statusTable select N'preloading#Socken_tillstånd',CURRENT_TIMESTAMP,@@ROWCOUNT
----goto TableInitiate
go
 --:C:/Users/crbk01/AppData/Roaming/JetBrains/DataGrip2021.1/consoles/db/a922a8bc-6602-44d4-8ab2-a4062fc64d99/Kv-FlaggGenerering/RunConfig/fegetOmhandertagande.sql
IF OBJECT_ID(N'tempdb..#egetOmhändertagande') is not null OR (select top 1 RebuildStatus from #SettingTable) = 1
     BEGIN TRY DROP TABLE #egetOmhändertagande END TRY BEGIN CATCH select 'error DROP TABLE #egetOmhändertagande' END CATCH
go;
IF OBJECT_ID(N'tempdb..#egetOmhändertagande') is null
 begin
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
 --:C:/Users/crbk01/AppData/Roaming/JetBrains/DataGrip2021.1/consoles/db/a922a8bc-6602-44d4-8ab2-a4062fc64d99/Kv-FlaggGenerering/RunConfig/gVa.sql
 IF OBJECT_ID('tempdb..#spillvatten') is not null OR (select top 1 RebuildStatus from #settingtable) = 1-- OR @rebuiltStatus1 = 1
     BEGIN TRY DROP TABLE #spillvatten END TRY BEGIN CATCH select 'error DROP TABLE #spillvatten' END CATCH
go;
IF OBJECT_ID('tempdb..#spillvatten') is null
    begin
     ;with
        fastighetsYtor as (select socken SockenX, FAStighet, Shape from #FastighetsYtor)
    	,planOmr as   (select shape,dp_i_omr,planprog,planansokn from sde_VA.gng.Va_planomraden_171016),

    spillAvtalGemPlanAnsok as (
				    select shape, concat(typkod,':',status,'(spill)') typ
					from sde_VA.gng.VO_Spillvatten					union all
					select shape, 'AVTALSABONNENT [Tabell_ObjID: ]' as c
					    from sde_VA.gng.AVTALSABONNENTER					union all
					select shape, concat('GEMENSAMHETSANLAGGNING: ',GEMENSAMHETSANLAGGNINGAR.GA) as c2
					    from sde_VA.gng.GEMENSAMHETSANLAGGNINGAR					    union all
					    select shape,
					    isnull(coalesce(
					    nullif(concat('dp_i_omr:',dp_i_omr) ,'dp_i_omr:'),
					    nullif(concat('planprog:',planprog) ,'planprog:'),
					    nullif(concat('planansokn:',planansokn) ,'planansokn:')),
					N'okändStatus') as i
					from planOmr)
      , vax as (select distinct syt.fastighet, q.typ 
       from fastighetsYtor sYt
        inner join spillAvtalGemPlanAnsok q on sYt.shape.STIntersects(q.Shape) = 1)
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
    -- döoom vaPlan till komVa
-- dela upp till separat column om gemensam anläggning, gemensamhetsanläggning
    INSERT INTO #statusTable select 'rebuilt#spillvatten',CURRENT_TIMESTAMP,@@ROWCOUNT END
    else INSERT INTO #statusTable select 'preloading#spillvatten',
           CURRENT_TIMESTAMP,@@ROWCOUNT
----goto TableInitiate
go
 --:C:/Users/crbk01/AppData/Roaming/JetBrains/DataGrip2021.1/consoles/db/a922a8bc-6602-44d4-8ab2-a4062fc64d99/Kv-FlaggGenerering/RunConfig/hTaxeKod.sql
IF OBJECT_ID(N'tempdb..#Taxekod')  is null and (select null) is not null
    begin BEGIN TRY DROP TABLE #Taxekod END TRY BEGIN CATCH select 1 END CATCH;
select '' status into #taxekod
end
    go;
 --:C:/Users/crbk01/AppData/Roaming/JetBrains/DataGrip2021.1/consoles/db/a922a8bc-6602-44d4-8ab2-a4062fc64d99/Kv-FlaggGenerering/RunConfig/iRod.sql
IF OBJECT_ID(N'tempdb..#Röd') is not null OR (select top 1 RebuildStatus from #settingtable) = 1
        BEGIN TRY DROP TABLE #Röd END TRY BEGIN CATCH select 'failed to drop #röd' END CATCH
go;
IF OBJECT_ID(N'tempdb..#Röd') is null
    begin
        declare @rod table
	(
		fastighet nvarchar(200), Fastighet_tillstand nvarchar(200), Diarienummer nvarchar(100), Beslut_datum nvarchar(40), utförddatum nvarchar(40), Anteckning nvarchar(max), Byggnadstyp nvarchar(100), vaPlan varchar(max), fstatus nvarchar(30), LocaltOmH varchar(max), slam varchar, bygTot int, flagga geometry
		unique (fastighet,Fastighet_tillstand,Diarienummer,Beslut_datum,utförddatum,Byggnadstyp,fstatus,bygTot)
		with (ignore_dup_key = on)
	)
        ;
	with
	    anlaggningar        as (select Fastighet, diarienummer, Fastighet_tillstand, Beslut_datum, utförddatum, Anteckning,fstatus, anlaggningspunkt
				    from #Socken_tillstånd)
	  , fastigheterx 	as (select FAStighet,socken 					from #FastighetsYtor)
	  , vaPlan              as (select fastighet, vaTyp 					from #spillvatten)
	  , byggnader           as (select fastighet, Byggnadstyp,bygTot,shape ByggShape 	from #ByggnadPåFastighetISocken)
	  , egetOmhandertagande as (select fastighet, LocaltOmH,	shape 			from #egetOmhändertagande)

	  , toTeamVatten        as (
	    select coalesce(byggNader.FAStighet, anlaggningar.FAStighet, egetOmh.fastighet, va.fastighet, fastigheterX.fastighet) fastighet
		 , socken , Fastighet_tillstand, Diarienummer, Beslut_datum, utförddatum, Anteckning, Byggnadstyp , LocaltOmH, bygTot
		 , vatyp                                                                       vaPlan
	         , anlaggningar.fstatus                                                       fstatus
		 , coalesce(AnlaggningsPunkt, egetOmh.shape, byggnader.ByggShape).STPointN(1) flagga
	    from byggnader
		full outer join anlaggningar
			on anlaggningar.FAStighet = byggNader.FAStighet
		left outer join egetOmhandertagande egetOmh
			on byggNader.FAStighet = egetOmh.FAStighet
		left outer join vaPlan va
			on byggNader.FAStighet = va.FAStighet
		inner join fastigheterX
			on byggNader.FAStighet = fastigheterX.fastighet
	)
	  , flaggKorrigering as (select
				     socken, fastighet,Diarienummer,Fastighet_tillstand,Beslut_datum,utförddatum
				      ,Anteckning, LocaltOmH, Byggnadstyp, VaPlan, flagga, bygTot,
				     (case when fstatus = N'röd' or FSTATUS is null
					       then
					       (case
						   when (vaPlan is null and LocaltOmH is null)
						       then N'röd'
						       else case when VaPlan is not null
								     then 'KomV?'
								     else case when LocaltOmH is not null
										   then 'Lokalt' end
							    end end)
					       else
					       case when fstatus = 'ok' then 'grön' else
						   coalesce(fstatus,'?') end end ) Fstatus
				 from toTeamVatten)

	insert into @rod (Fstatus, fastighet, Fastighet_tillstand, 	Beslut_datum, 		utförddatum, 	Anteckning, LocaltOmH, Byggnadstyp, VaPlan, flagga, slam, bygTot)
	select 		  Fstatus, fastighet, Fastighet_tillstand, left(Beslut_datum,40), left(utförddatum,40), Anteckning, LocaltOmH, Byggnadstyp, VaPlan, flagga, '', bygTot
	from flaggKorrigering

	; select *into #röd from @rod;	select * from #röd
			--where fastighet like N'Hörsne%'
		--where fstatus !='grön'
	order by Fstatus desc
	;
;
        --gul from fastighets_Anslutningar_Gemensamhetanläggningar) , gul                 as (select null "fstat")
	    --slam (select top 1 datStoppdatum from slam where attUtsokaFran.fastighet = slam.strFastBeteckningHel)
	    --gem else (case when null is not null then 'gem' else '?' end)
	    --aliases: [Va-Spill] -- egetOmhändertagandeInfo
--INSERT INTO #statusTable (one, start) select one, start from @internalStatus
INSERT INTO #statusTable select N'rebuilt#Röd', CURRENT_TIMESTAMP, @@ROWCOUNT end else INSERT INTO #statusTable select N'preloading#Röd', CURRENT_TIMESTAMP, @@ROWCOUNT;

go
 --:C:/Users/crbk01/AppData/Roaming/JetBrains/DataGrip2021.1/consoles/db/a922a8bc-6602-44d4-8ab2-a4062fc64d99/Kv-FlaggGenerering/RunConfig/motFlaggskikt.sql
;
with
	-- fastighetsytor inclusive shiften
    	fs as (Select q.FAStighet, Status from sde_miljo_halsoskydd.gng.FLAGGSKIKTET_P flaggor inner join (select * from  #fastighetsYtor) q on flaggor.Shape.STWithin(q.shape) = 1 or q.fastighet = isnull(flaggor.FASTIGHET,'') )
    ,	FiltreraMotFlaggskiktet as(
	select
	  /* case when (fstatus = 'röd' OR (fstatus is null AND  harbyggtypInteIVa  = 'true' ))
	    then 'x' end IrodUtsokning,
	   case when (fs.fastighet not in(select fastighet from #röd toTeamVatten where fstatus = 'röd') and  harbyggtypInteIVa  = 'true' )
		then 'x' end IgronUtsokning
	    ,case when isnull(harbyggtypInteIVa,'nej') = 'true' then 'nej' else 'ja' end bla*/
	    ttv.*
	    from
		 #röd ttv left outer join
		     fs on fs.FASTIGHET = ttv.fastighet
	    where fs.Status is null and fstatus is not null
)
select * into #FiltreraMotFlaggskiktet -- fastighet, fstatus,Status, flagga --, concat('röd:',isnull(IrodUtsokning,'inteRöd'),',Va:',bla)
from FiltreraMotFlaggskiktet
;
/*
select distinct count(*) over ( partition by IrodUtsokning,IgronUtsokning,bla) c,IrodUtsokning,IgronUtsokning,bla
from FiltreraMotFlaggskiktet
order by bla,IgronUtsokning,IrodUtsokning,fstatus,Byggnadstyp, coalesce(fstatus, Diarienummer, Fastighet_tillstand, try_cast(Beslut_datum as varchar), try_cast(utförddatum as varchar),
    Anteckning, egetOmhändertangandeInfo, VAantek, typ, Byggnadstyp, try_cast( bygTot as varchar)
)*/
--order by fstatus desc,fastighet,typ,egetOmhändertangandeInfo
--;
--select count(*) c, 'slam' a from @slamz union select count(*) c, 'egetomh' a  from @egetomh union select count(*) c, 'va' a  from @va union select count(*) c, 'byggs' a  from @byggs
--drop table #FiltreraMotFlaggskiktet
select * from #FiltreraMotFlaggskiktet
go
 --:C:/Users/crbk01/AppData/Roaming/JetBrains/DataGrip2021.1/consoles/db/a922a8bc-6602-44d4-8ab2-a4062fc64d99/Kv-FlaggGenerering/RunConfig/toTemplate.sql
 IF OBJECT_ID(N'tempdb..#rodaForFlaggskikt') is not null OR (select top 1 RebuildStatus from #settingtable) = 1
        BEGIN TRY DROP TABLE #rodaForFlaggskikt END TRY BEGIN CATCH select 'failed to drop #rodaForFlaggskikt' END CATCH
go;
IF OBJECT_ID(N'tempdb..#rodaForFlaggskikt') is null
    begin
declare @rödaFörFlaggskikt  table (
				 FASTIGHET                                     nvarchar(150),
				 Fastighet_tillstand                           nvarchar(150),
				 Arendenummer                                  nvarchar(50),
				 Beslut_datum                                  datetime2,
				 Status                                        nvarchar(50),
				 Utskick_datum                                 datetime2,
				 Anteckning                                    nvarchar(254),
				 Utforddatum                                   datetime2,
				 Slamhamtning                                  nvarchar(100),
				 Antal_byggnader                               numeric(38, 8),
				 x						bigint		,
                                y						bigint
)

;
with alias as (select * from #FiltreraMotFlaggskiktet where
    (fstatus = 'röd' OR (fstatus is null AND  Byggnadstyp is not null and (isnull(VaPlan,'') <> 'Spillvatten:Antaget(spill)' AND isnull(VaPlan,'') <> 'Avlopp:Antaget(spill)'))))
insert into @rödaFörFlaggskikt (FASTIGHET, Fastighet_tillstand, Arendenummer, Beslut_datum, Status, Utskick_datum, Anteckning
, Utforddatum, Slamhamtning, Antal_byggnader,x,y)
select
    left(fastighet,150),
    left(Fastighet_tillstand,150),
    left(Diarienummer,50),
     Beslut_datum,
     left(iif(fstatus='ok','grön',fstatus),50), --SockenX,
       null,
       left(CASE WHEN len(Anteckning) != 1 THEN anteckning END, 254),
     utförddatum
     ,left(concat( LocaltOmH,nullif(concat(' va: ',VaPlan),' va: '), nullif(concat(' bygtyp: ' , Byggnadstyp),' bygtyp: ')),100) VAantek
     , bygTot,flagga.STX flaggax,flagga.STY flaggay
from alias
select * into #rodaForFlaggskikt from @rödaFörFlaggskikt
end
;
 IF OBJECT_ID(N'tempdb..#gronaForFlaggskikt') is not null OR (select top 1 RebuildStatus from #settingtable) = 1
        BEGIN TRY DROP TABLE #gronaForFlaggskikt END TRY BEGIN CATCH select 'failed to drop #gronaForFlaggskikt' END CATCH
go;
IF OBJECT_ID(N'tempdb..#gronaForFlaggskikt') is null
    begin
;declare @grönaFörFlaggskikt  table (
				 FASTIGHET                                     nvarchar(150),
				 Fastighet_tillstand                           nvarchar(150),
				 Arendenummer                                  nvarchar(50),
				 Beslut_datum                                  datetime2,
				 Status                                        nvarchar(50),
				 Utskick_datum                                 datetime2,
				 Anteckning                                    nvarchar(254),
				 Utforddatum                                   datetime2,
				 Slamhamtning                                  nvarchar(100),
				 Antal_byggnader                               numeric(38, 8),
				 x						bigint		,
                                y						bigint
                                unique (FASTIGHET)
                                with (ignore_dup_key = on)
)
;
with alias as (select * from #FiltreraMotFlaggskiktet)
insert into @grönaFörFlaggskikt (FASTIGHET, Fastighet_tillstand, Arendenummer, Beslut_datum, Status, Utskick_datum, Anteckning
, Utforddatum, Slamhamtning, Antal_byggnader,x,y)
select
    left(fastighet,150),
    left(Fastighet_tillstand,150),
    left(Diarienummer,50),
     Beslut_datum,
     left(iif(fstatus='ok','grön',fstatus),50), --SockenX,
       null,
       left(CASE WHEN len(Anteckning) != 1 THEN anteckning END, 254),
     utförddatum
     ,left(concat( LocaltOmH,nullif(concat(' va: ',VaPlan),' va: '), nullif(concat(' bygtyp: ' , Byggnadstyp),' bygtyp: ')),100) VAantek
     , bygTot,flagga.STX flaggax,flagga.STY flaggay
from alias
	where fastighet not in(select fastighet from alias where fstatus = 'röd') and  Byggnadstyp is not null
	      and (isnull(VaPlan,'') <> 'Spillvatten:Antaget(spill)' AND isnull(VaPlan,'') <> 'Avlopp:Antaget(spill)')
select * into #gronaForFlaggskikt from @grönaFörFlaggskikt
end
go
select * from #statusTable

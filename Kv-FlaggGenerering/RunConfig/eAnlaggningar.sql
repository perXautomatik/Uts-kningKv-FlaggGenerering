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

IF OBJECT_ID(N'tempdb..#Röd') is null -- OR @rebuiltStatus2 = 1
    begin
	BEGIN TRY DROP TABLE #Röd END TRY BEGIN CATCH select 1 END CATCH BEGIN TRY DROP TABLE #slam END TRY BEGIN CATCH select 1 END CATCH declare @internalStatus table (one NVARCHAR(max), start datetime);;

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

	with
	    fastigheterx as (select * from #FastighetsYtor)
	    ,vaPlan              as (select fastighet, vaTyp from #spillvatten)
	  , byggnader           as (select fastighet, Byggnadstyp, shape ByggShape, bygTot
				    from #ByggnadPåFastighetISocken)
	  , egetOmhandertagande as (select fastighet, LocaltOmH,shape from #egetOmhändertagande)
	  , socknarOfInteresse  as (select distinct fastighet from #FastighetsYtor)
	  , anlaggningar        as (select diarienummer
					 , Fastighet
					 , Fastighet_tillstand
					 , Beslut_datum
					 , utförddatum
					 , Anteckning
					 , (case when not (
			isnull(Beslut_datum, DATETIME2FROMPARTS(1988, 1, 1, 1, 1, 1, 1, 1)) >
			(select DATETIME2FROMPARTS(2003, 1, 1, 1, 1, 1, 1, 1) datum) and
			isnull(utförddatum, DATETIME2FROMPARTS(1988, 1, 1, 1, 1, 1, 1, 1)) >
			(select DATETIME2FROMPARTS(2003, 1, 1, 1, 1, 1, 1, 1) datum)) then N'röd'
										      else N'grön'
					    end) fstatus
					 , anlaggningspunkt
				    from #Socken_tillstånd)

	  , slamm               as (select strFastBeteckningHel
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

	    , q as (select anlaggningar.diarienummer
			 , (case when anlaggningar.anlaggningspunkt is not null then anlaggningar.fstatus else '?' end) fstatus
			 , socknarOfInteresse.fastighet
			 , Byggnadstyp
			 , Fastighet_tillstand
			 , Beslut_datum
			 , utförddatum
			 , Anteckning
			 , (case when anlaggningar.anlaggningspunkt is not null then anlaggningar.anlaggningspunkt else ByggShape end) flagga
		    from socknarOfInteresse
			left outer join byggnader on socknarOfInteresse.fastighet = byggnader.fastighet
			left outer join anlaggningar on socknarOfInteresse.fastighet = anlaggningar.fastighet)

	   , oneFlaggaPerFas as (select *
				     , row_number() over (partition by q.fastighet order by q.Anteckning desc ) flaggnr
				from  q
				where q.flagga is not null)

	  , gul                 as (select null "fstat") -- from fastighets_Anslutningar_Gemensamhetanläggningar)

	  , toTeamVatten        as (
	    select coalesce(byggNader.FAStighet, anlaggningar.FAStighet, egetOmh.fastighet, va.fastighet,
			    fastigheterX.fastighet)                                           fastighet
		 , Fastighet_tillstand
		 , Diarienummer
		 , FORMAT(nullif(Beslut_datum, smalldatetimefromparts(1900, 01, 01, 00, 00)),
			  'yyyy-MM-dd')                                                       Beslut_datum
		 , FORMAT(nullif(utförddatum, smalldatetimefromparts(1900, 01, 01, 00, 00)),
			  'yyyy-MM-dd')                                                       utförddatum
		 , Anteckning
		 , Byggnadstyp
		 , vatyp                                                                       vaPlan
		 , anlaggningar.fstatus                                                       fstatus
		 , LocaltOmH
		 , ''                                                                         slam--(select top 1 datStoppdatum from slam where attUtsokaFran.fastighet = slam.strFastBeteckningHel)
		 , byggnader.bygTot
		 , coalesce(AnlaggningsPunkt, egetOmh.shape, byggnader.ByggShape).STPointN(1) flagga

	    from byggnader
		full outer join anlaggningar
		on anlaggningar.FAStighet = byggNader.FAStighet

		full outer join egetOmhandertagande egetOmh
		on byggNader.FAStighet = egetOmh.FAStighet
		full outer join vaPlan va
		on byggNader.FAStighet = va.FAStighet
		inner join fastigheterX
		on byggNader.FAStighet = fastigheterX.fastighet
	)

		,flaggKorrigering as (select
		(case when fstatus = N'röd'
		then (case when (
		vaPlan is null
		and LocaltOmH is null) then N'röd'
		else (case when VaPlan is not null
		then 'KomV?'
		else (case when null is not null
		then 'gem' else '?' end) end) end)
		else fstatus end ) Fstatus
		,fastighet,Fastighet_tillstand,Beslut_datum,utförddatum,Anteckning,LocaltOmH,Byggnadstyp,
		VaPlan,flagga,
		slam,
		bygTot
		from toTeamVatten)

	select *
	into #röd
	from flaggKorrigering

	INSERT INTO #statusTable (one, start) select one, start from @internalStatus

	INSERT INTO #statusTable select N'rebuilt#Röd', CURRENT_TIMESTAMP, @@ROWCOUNT
    end else INSERT INTO #statusTable select N'preloading#Röd', CURRENT_TIMESTAMP, @@ROWCOUNT;


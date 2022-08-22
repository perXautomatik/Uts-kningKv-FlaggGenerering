IF OBJECT_ID(N'tempdb..#R�d') is null -- OR @rebuiltStatus2 = 1
    begin
	BEGIN TRY DROP TABLE #R�d END TRY BEGIN CATCH select 1 END CATCH
;
	with
	    fastigheterx as (select * from #FastighetsYtor)
	   , gul                 as (select null "fstat") -- from fastighets_Anslutningar_Gemensamhetanl�ggningar)
	    ,vaPlan              as (select fastighet, vaTyp from #spillvatten)
	  , byggnader           as (select fastighet, Byggnadstyp, shape ByggShape, bygTot
				    from #ByggnadP�FastighetISocken)
	  , egetOmhandertagande as (select fastighet, LocaltOmH,shape from #egetOmh�ndertagande)
	  , anlaggningar        as (select diarienummer, Fastighet, Fastighet_tillstand, Beslut_datum, utf�rddatum, Anteckning,fstatus, anlaggningspunkt
				    from #Socken_tillst�nd)

	  , toTeamVatten        as (
	    select coalesce(byggNader.FAStighet, anlaggningar.FAStighet, egetOmh.fastighet, va.fastighet,
			    fastigheterX.fastighet)                                           fastighet

	         , Fastighet_tillstand, Diarienummer, Beslut_datum, utf�rddatum, Anteckning, Byggnadstyp
		 , vatyp                                                                       vaPlan
		 , anlaggningar.fstatus                                                       fstatus
		 , LocaltOmH , ''                                                                         slam--(select top 1 datStoppdatum from slam where attUtsokaFran.fastighet = slam.strFastBeteckningHel)
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

	    , flaggKorrigering as (select (case when fstatus = N'r�d'
						    then (case when (
		    vaPlan is null
		    and LocaltOmH is null) then N'r�d'
					   else (case when VaPlan is not null
							  then 'KomV?'
							  else (case when null is not null
									 then 'gem'
									 else '?'
								end)end)end)
						    else fstatus
					   end) Fstatus
					, fastighet, Fastighet_tillstand, Beslut_datum, utf�rddatum, Anteckning, LocaltOmH, Byggnadstyp, VaPlan, flagga, slam, bygTot
				   from toTeamVatten)
	select *
	into #r�d
	from flaggKorrigering

	--INSERT INTO #statusTable (one, start) select one, start from @internalStatus
	INSERT INTO #statusTable select N'rebuilt#R�d', CURRENT_TIMESTAMP, @@ROWCOUNT
    end else INSERT INTO #statusTable select N'preloading#R�d', CURRENT_TIMESTAMP, @@ROWCOUNT;


IF OBJECT_ID(N'tempdb..#enatSkikt') is not null OR (select top 1 RebuildStatus from #settingtable) = 1
        BEGIN TRY DROP TABLE #enatSkikt END TRY BEGIN CATCH select 'failed to drop #enatSkikt' END CATCH
go;
IF OBJECT_ID(N'tempdb..#enatSkikt') is null
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

	; select *into #enatSkikt from @rod;	select * from #enatSkikt
			--where fastighet like N'Hörsne%'
		--where fstatus !='grön'
	order by Fstatus desc
	;
;
        select * from #enatSkikt
        --gul from fastighets_Anslutningar_Gemensamhetanläggningar) , gul                 as (select null "fstat")
	    --slam (select top 1 datStoppdatum from slam where attUtsokaFran.fastighet = slam.strFastBeteckningHel)
	    --gem else (case when null is not null then 'gem' else '?' end)
	    --aliases: [Va-Spill] -- egetOmhändertagandeInfo
--INSERT INTO #statusTable (one, start) select one, start from @internalStatus
INSERT INTO #statusTable select N'rebuilt#enatSkikt', CURRENT_TIMESTAMP, @@ROWCOUNT end else INSERT INTO #statusTable select N'preloading#enatSkikt', CURRENT_TIMESTAMP, @@ROWCOUNT;

go

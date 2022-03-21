IF OBJECT_ID(N'tempdb..#Röd') is null
    begin
	BEGIN TRY DROP TABLE #Röd END TRY BEGIN CATCH select 1 END CATCH
;
	declare @rod table
	(
		fastighet nvarchar(200), Fastighet_tillstand nvarchar(200), Diarienummer nvarchar(100), Beslut_datum nvarchar(40), utförddatum nvarchar(40), Anteckning nvarchar(max), Byggnadstyp nvarchar(100), vaPlan varchar(max), fstatus nvarchar(30), LocaltOmH varchar(max), slam varchar, bygTot int, flagga geometry
		unique (fastighet,Fastighet_tillstand,Diarienummer,Beslut_datum,utförddatum,Byggnadstyp,fstatus,bygTot)
		with (ignore_dup_key = on)
	)
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
	  , toTeamVatten        as (
	    select coalesce(byggNader.FAStighet, anlaggningar.FAStighet, egetOmh.fastighet, va.fastighet, fastigheterX.fastighet)
	        	fastighet, socken
	         , Fastighet_tillstand, Diarienummer, Beslut_datum, utförddatum, Anteckning, Byggnadstyp
		 , vatyp                                                                       vaPlan
		 , anlaggningar.fstatus                                                       fstatus
	 	, LocaltOmH , '' slam--(select top 1 datStoppdatum from slam where attUtsokaFran.fastighet = slam.strFastBeteckningHel)
		 , byggnader.bygTot
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
					        case when fstatus = 'ok' then 'grön' else
					        coalesce(fstatus,'?') end end ) Fstatus
	         			, socken, fastighet,Diarienummer,Fastighet_tillstand,Beslut_datum,utförddatum
	         			,Anteckning, LocaltOmH -- egetOmhändertagandeInfo
	         			 , Byggnadstyp, VaPlan
	         			 --[Va-Spill]
	         			 , flagga, bygTot
	    				, slam
				  from toTeamVatten)

	insert into @rod (Fstatus, fastighet, Fastighet_tillstand, Beslut_datum, utförddatum, Anteckning, LocaltOmH, Byggnadstyp, VaPlan, flagga, slam, bygTot)
	select Fstatus, fastighet, Fastighet_tillstand, left(Beslut_datum,40), left(utförddatum,40), Anteckning, LocaltOmH, Byggnadstyp, VaPlan, flagga, slam, bygTot
	from flaggKorrigering

	--INSERT INTO #statusTable (one, start) select one, start from @internalStatus
	; select *into #röd from @rod;

	select * from #röd
		--where fastighet like N'Hörsne%'
		where fstatus !='grön'
order by Fstatus desc
	INSERT INTO #statusTable select N'rebuilt#Röd', CURRENT_TIMESTAMP, @@ROWCOUNT
    end else INSERT INTO #statusTable select N'preloading#Röd', CURRENT_TIMESTAMP, @@ROWCOUNT;

go
if (select '')  is not null
    begin
    	repport:
		select * from #statusTable
		    ;
with
    q as (select distinct Fstatus
			, ''                      handläggare
			, socken, fastighet, Diarienummer, Fastighet_tillstand, Beslut_datum, utförddatum, Anteckning
			, egetOmhändertagandeInfo egetOmhändertangandeInfo
			, [Va-Spill], Byggnadstyp, bygTot
	  from #röd)
  , z as (select *, row_number() over (order by status,fastighet) rwnr from q)

select top 4000 status
	      , handläggare, socken, fastighet, Diarienummer, Fastighet_tillstand, Beslut_datum, utförddatum, Anteckning, egetOmhändertangandeInfo, [Va-Spill], Byggnadstyp, bygTot
from z
where rwnr > 500
order by status desc
    end

; select * from #röd




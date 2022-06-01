IF OBJECT_ID(N'tempdb..#R�d') is null OR @rebuiltStatus2 = 1
    begin
	BEGIN TRY
	    DROP TABLE #R�d
	END TRY BEGIN CATCH
	    select 1
	END CATCH
	BEGIN TRY
	    DROP TABLE #slam
	END TRY BEGIN CATCH
	    select 1
	END CATCH
	declare @internalStatus table (one NVARCHAR(max), start datetime);
	;
	with
	    taxekod as (select * from #taxekod)
	  , slam    as (select max(q2z) q2z
			     , strDelprodukt
			     , strTaxebenamning
			     , strFastBeteckningHel
			     , decAnlXKoordinat
			     , decAnlYkoordinat
			from taxekod q
			group by strDelprodukt, strTaxebenamning, strFastBeteckningHel, decAnlXKoordinat
			       , decAnlYkoordinat)
	select *
	into #slam
	from slam
	INSERT INTO @internalStatus select N'(slam,taxekod)#R�d', CURRENT_TIMESTAMP;

	with
	    slamm               as (select strFastBeteckningHel
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
	  , socknarOfInteresse  as (select distinct fastighet from #SockenYtor)
	  , byggnader           as (select Fastighetsbeteckning fastighet, Byggnadstyp, ByggShape
				    from #ByggnadP�FastighetISocken)
	  , vaPlan              as (select fastighet, typ from #spillvaten)
	  , egetOmhandertagande as (select fastighet, egetOmh�ndertangandeInfo, LocaltOmH from #egetOmh�ndertagande)
	  , anlaggningar        as (select diarienummer
					 , Fastighet
					 , Fastighet_tillstand
					 , Beslut_datum
					 , utf�rddatum
					 , Anteckning
					 , (case when not (
			isnull(Beslut_datum, DATETIME2FROMPARTS(1988, 1, 1, 1, 1, 1, 1, 1)) >
			(select DATETIME2FROMPARTS(2003, 1, 1, 1, 1, 1, 1, 1) datum) and
			isnull(utf�rddatum, DATETIME2FROMPARTS(1988, 1, 1, 1, 1, 1, 1, 1)) >
			(select DATETIME2FROMPARTS(2003, 1, 1, 1, 1, 1, 1, 1) datum)) then N'r�d'
										      else N'gr�n'
					    end) fstatus
					 , anlaggningspunkt
				    from #Socken_tillst�nd)
	  , attUtsokaFran       as (select *
					 , row_number() over (partition by q.fastighet order by q.Anteckning desc ) flaggnr
				    from (select anlaggningar.diarienummer
					       , (case when anlaggningar.anlaggningspunkt is not null
							   then anlaggningar.fstatus else '?' end)                fstatus
					       , socknarOfInteresse.fastighet
					       , Byggnadstyp
					       , Fastighet_tillstand
					       , Beslut_datum
					       , utf�rddatum
					       , Anteckning
					       , (case when anlaggningar.anlaggningspunkt is not null
							   then anlaggningar.anlaggningspunkt else ByggShape end) flagga
					  from socknarOfInteresse
					      left outer join byggnader on socknarOfInteresse.fastighet = byggnader.fastighet
					      left outer join anlaggningar on socknarOfInteresse.fastighet = anlaggningar.fastighet) q
				    where q.flagga is not null)
	  , gul                 as (select null "fstat") -- from fastighets_Anslutningar_Gemensamhetanl�ggningar)

	select fastighet
	     , Fastighet_tillstand
	     , Byggnadstyp
	     , Beslut_datum
	     , utf�rddatum
	     , Anteckning
	     , VaPlan
	     , egetOmh�ndertangandeInfo
	     , slam
	     , flaggnr
	     , flagga
	     , (case when fstatus = N'r�d'
			 then (case when (vaPlan is null and egetOmh�ndertangandeInfo is null) then N'r�d'
											       else (case when VaPlan is not null
													      then 'KomV?'
													      else (case when null is not null then 'gem' else '?' end)
												     end)
			       end)
			 else fstatus
		end) Fstatus
	into #r�d
	from (select                            attUtsokaFran.fastighet
		   ,                            attUtsokaFran.Fastighet_tillstand
		   ,                            attUtsokaFran.Diarienummer
		   ,                            attUtsokaFran.Byggnadstyp
		   ,                            FORMAT(nullif(attUtsokaFran.Beslut_datum,
							      smalldatetimefromparts(1900, 01, 01, 00, 00)),
						       'yyyy-MM-dd') Beslut_datum
		   ,                            FORMAT(nullif(attUtsokaFran.utf�rddatum,
							      smalldatetimefromparts(1900, 01, 01, 00, 00)),
						       'yyyy-MM-dd') utf�rddatum
		   ,                            attUtsokaFran.Anteckning
		   , VaPlan                   = (select top 1 typ
						 from vaPlan
						 where vaPlan.fastighet = attUtsokaFran.fastighet)
		   ,                            fstatus
		   , egetOmh�ndertangandeInfo = (select top 1 egetOmh�ndertangandeInfo
						 from egetOmhandertagande
						 where attUtsokaFran.fastighet = egetOmhandertagande.fastighet)
		   , slam                     = (select top 1 datStoppdatum
						 from slam
						 where attUtsokaFran.fastighet = slam.strFastBeteckningHel)
		   ,                            flaggnr
		   ,                            flagga.STPointN(1)   flagga
	      from attUtsokaFran) q
	INSERT INTO @statusTable (one, start) select one, start from @internalStatus

	INSERT INTO @statusTable select N'rebuilt#R�d', CURRENT_TIMESTAMP, @@ROWCOUNT
    end else INSERT INTO @statusTable select N'preloading#R�d', CURRENT_TIMESTAMP, @@ROWCOUNT;
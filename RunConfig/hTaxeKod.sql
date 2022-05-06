IF OBJECT_ID(N'tempdb..#Taxekod')  is null  -- OR @rebuiltStatus2 = 1
    begin BEGIN TRY DROP TABLE #Taxekod END TRY BEGIN CATCH select 1 END CATCH;

        select 2 a into #taxekod;

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
select * from slam


      -- select * into #taxekod from openquery(admsql01,'with anlaggning as (select strAnlnr,strAnlaggningsKategori,strFastBeteckningHel,case when nullif(decAnlYkoordinat, 0) is not null then nullif(decAnlXKoordinat, 0) end decAnlXKoordinat,case when nullif(decAnlXKoordinat, 0) is not null then nullif(decAnlYkoordinat, 0) end decAnlYkoordinat from (select left(strFastBeteckningHel, case when charindex('' '', strFastBeteckningHel) = 0 then len(strFastBeteckningHel) + 1 else charindex('' '', strFastBeteckningHel) end - 1) strSocken,strAnlnr,strAnlaggningsKategori,strFastBeteckningHel,decAnlXKoordinat,decAnlYkoordinat from (select strAnlnr, strAnlaggningsKategori, strFastBeteckningHel, decAnlXKoordinat, decAnlYkoordinat from (select anlaggning.* from EDPFutureGotland.dbo.vwAnlaggning anlaggning inner join EDPFutureGotland.dbo.vwTjanst tjanst on anlaggning.strAnlnr = tjanst.strAnlnr) t) vwAnlaggning) x inner join (select ''Roma'' "socken" union select N''Björke'' union select ''Dalhem'' union select ''Halla'' union select ''Sjonhem'' union select ''Ganthem'' union select N''Hörsne'' union select ''Bara'' union select N''Källunge'' union select ''Vallstena'' union select ''Norrlanda'' union select ''Klinte'' union select N''Fröjel'' union select ''Eksta'') fastighetsfilter on strSocken = fastighetsfilter.socken) , FilteredTjanste as (select strTaxekod, intTjanstnr, strAnlOrt, q2, strTaxebenamning, strDelprodukt, strAnlnr from (select strTaxekod,intTjanstnr,strAnlOrt,isnull(datStoppdatum, smalldatetimefromparts(1900, 01, 01, 00, 00)) q2,strTaxebenamning,vwRenhTjanstStatistik.strDelprodukt,strAnlnr from (select formated.strTaxekod,formated.intTjanstnr,formated.strAnlOrt,datStoppdatum,formated.strTaxebenamning,formated.strDelprodukt,strAnlnr from EDPFutureGotland.dbo.vwRenhTjanstStatistik formated inner join EDPFutureGotland.dbo.vwTjanst tjanst on tjanst.intTjanstnr = formated.intTjanstnr where formated.intTjanstnr is not null and formated.intTjanstnr != 0 and formated.intTjanstnr != '''' ) vwRenhTjanstStatistik left outer join (select N''DEPO'' "strDelprodukt" union select N''CONT'' union select N''GRUNDR'' union select N''ÖVRTRA'' union select N''ÖVRTRA'' union select ''HUSH'' union select N''ÅVCTR'') q on vwRenhTjanstStatistik.strDelprodukt = q.strDelprodukt where q.strDelprodukt is null) p where strTaxekod != ''BUDSM'' AND left(strTaxekod, ''4'') != ''HYRA'' and coalesce(strDelprodukt,strTaxebenamning) is not null) , formated as (select intTjanstnr, strDelprodukt, strTaxebenamning, max(q2) q2z,max(strAnlnr) strAnlnrx from FilteredTjanste group by strTaxekod, intTjanstnr, strAnlOrt, strDelprodukt, strTaxebenamning) select strFastBeteckningHel, decAnlXKoordinat, decAnlYkoordinat, intTjanstnr, strDelprodukt, strTaxebenamning, q2z from anlaggning inner join formated on anlaggning.strAnlnr = formated.strAnlnrx');
    --INSERT INTO #statusTable select N'rebuilt#Taxekod',CURRENT_TIMESTAMP,@@ROWCOUNT end else INSERT INTO #statusTable select N'preloading#Taxekod',CURRENT_TIMESTAMP,@@ROWCOUNT
--goto TableInitiate



end
    ;
    with
	 fastighetsfilter  as (select * FROM #fastighetsfilter)
      ,  EjRelevanta      as (select @depoX "strDelprodukt"
			      union
			      select @cont "a"
			      union
			      select @grund "a"
			      union
			      select @overtra "a"
			      union
			      select @hush "a"
			      union
			      select @avctr "a"
			      union
			      select @budsm "a"
			      union
			      select @hyra "a")
	,anlFilteredByTjanst as (select left(anlaggning.strFastBeteckningHel, case when charindex(space(1), anlaggning.strFastBeteckningHel) = 0 then len(anlaggning.strFastBeteckningHel) + 1 else charindex(space(1), anlaggning.strFastBeteckningHel) end - 1) strSocken,anlaggning.strAnlnr,anlaggning.strAnlaggningsKategori,anlaggning.strFastBeteckningHel,decAnlXKoordinat,decAnlYkoordinat from EDPFutureGotland.dbo.vwAnlaggning anlaggning inner join EDPFutureGotland.dbo.vwTjanst tjanst on anlaggning.strAnlnr = tjanst.strAnlnr where tjanst.strAnlnr is not null and tjanst.strAnlnr != space(0))
	,anlFilteredBySocken AS (select strSocken, strAnlnr, strAnlaggningsKategori, anlFilteredByTjanst.strFastBeteckningHel, decAnlXKoordinat, decAnlYkoordinat from anlFilteredByTjanst inner join fastighetsfilter on anlFilteredByTjanst.strSocken = fastighetsfilter.socken)
	,vwRenhTjanstStatistik as (select tjsT.strTaxekod,tjsT.intTjanstnr,tjsT.strAnlOrt,datStoppdatum,tjsT.strTaxebenamning,tjsT.strDelprodukt,strAnlnr from EDPFutureGotland.dbo.vwRenhTjanstStatistik tjsT inner join EDPFutureGotland.dbo.vwTjanst tjanst on tjanst.intTjanstnr = tjsT.intTjanstnr where tjsT.intTjanstnr is not null and tjsT.intTjanstnr != 0 and tjsT.intTjanstnr !=space(0)and coalesce(tjsT.strDelprodukt,tjsT.strTaxebenamning) is not null)
	,tjanFilOnAnl as (select vwRenhTjanstStatistik.* from vwRenhTjanstStatistik inner join anlFilteredBySocken on anlFilteredBySocken.strAnlnr = vwRenhTjanstStatistik.strAnlnr )
	,tjanFilOnDelprodukt as (select strTaxekod,intTjanstnr,strAnlOrt,datStoppdatum,strTaxebenamning,vwRenhTjanstStatistik.strDelprodukt,strAnlnr from tjanFilOnAnl vwRenhTjanstStatistik left outer join EjRelevanta on vwRenhTjanstStatistik.strDelprodukt =   EjRelevanta.strDelprodukt where EjRelevanta.strDelprodukt is null )
	,tjanFilOnTaxekod as (select strTaxekod,intTjanstnr,strAnlOrt,isnull(datStoppdatum, smalldatetimefromparts(1900, 01, 01, 00, 00)) datStop,strTaxebenamning,tjanFilOnDelprodukt.strDelprodukt,strAnlnr from tjanFilOnDelprodukt left outer join EjRelevanta on tjanFilOnDelprodukt.strTaxekod  = EjRelevanta.strDelprodukt where EjRelevanta.strDelprodukt IS NULL)
	,groupdTjanste as (select intTjanstnr, strDelprodukt, strTaxebenamning, max(datStop) latestStop, max(strAnlnr) maxStrAnlnr from tjanFilOnTaxekod group by strTaxekod, intTjanstnr, strAnlOrt, strDelprodukt, strTaxebenamning)
  select anlaggning.strFastBeteckningHel, case when nullif(decAnlYkoordinat, 0) is not null then nullif(decAnlXKoordinat, 0) end decAnlXKoordinat, case when nullif(decAnlXKoordinat, 0) is not null then nullif(decAnlYkoordinat, 0) end decAnlYkoordinat, intTjanstnr, strDelprodukt, strTaxebenamning,latestStop from anlFilteredBySocken anlaggning inner join groupdTjanste on anlaggning.strAnlnr = maxStrAnlnr
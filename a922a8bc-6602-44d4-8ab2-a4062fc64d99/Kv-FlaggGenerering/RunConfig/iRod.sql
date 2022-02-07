IF OBJECT_ID(N'tempdb..#R�d')  is null  -- OR @rebuiltStatus2 = 1
    begin BEGIN TRY DROP TABLE #R�d END TRY BEGIN CATCH select 1 END CATCH
            BEGIN TRY DROP TABLE #slam END TRY BEGIN CATCH select 1 END CATCH
    declare @internalStatus table(one NVARCHAR(max),start datetime);
    ;
  
    with
            taxekod as (select * from #taxekod )
            ,slam as
			(select null q2z,null strDelprodukt,null  strTaxebenamning,null strFastBeteckningHel,null  decAnlXKoordinat,null  decAnlYkoordinat )
              --  ( select max(q2z) q2z,strDelprodukt, strTaxebenamning,strFastBeteckningHel, decAnlXKoordinat, decAnlYkoordinat from taxekod q group by strDelprodukt, strTaxebenamning,strFastBeteckningHel,decAnlXKoordinat,decAnlYkoordinat)
    		select * into #slam from slam
            INSERT INTO @internalStatus select N'(slam,taxekod)#R�d',CURRENT_TIMESTAMP
        ; 
	with
	    vaPlan as (select fastighet,typ  from #spillvatten)   
	    ,byggnader as (select fastighet, andamal1 Byggnadstyp,shape ByggShape from #ByggnadP�FastighetISocken)
 	     ,egetOmhandertagande as (select  fastighet,egetOmh�ndertangandeInfo,LocaltOmH from #egetOmh�ndertagande )
	     , socknarOfInteresse as (select distinct fastighet from #FastighetsYtor )
            ,anlaggningar as (select diarienummer,Fastighet,Fastighet_tillstand,Beslut_datum,utf�rddatum,Anteckning,(case when not( isnull(Beslut_datum, DATETIME2FROMPARTS(1988, 1, 1, 1, 1, 1, 1, 1)) > (select DATETIME2FROMPARTS(2003, 1, 1, 1, 1, 1, 1, 1) datum) and isnull(utf�rddatum, DATETIME2FROMPARTS(1988, 1, 1, 1, 1, 1, 1, 1)) > (select DATETIME2FROMPARTS(2003, 1, 1, 1, 1, 1, 1, 1) datum)) then N'r�d' else N'gr�n' end) fstatus,anlaggningspunkt from #Socken_tillst�nd)
            
	     ,slamm as (select strFastBeteckningHel,strDelprodukt,z2 = STUFF((SELECT distinct ','+ concat( nullif(x.strTaxebenamning,''), nullif(concat(' Avbrutet:', FORMAT(nullif(x.q2z, smalldatetimefromparts(1900, 01, 01, 00, 00)),'yyyy-MM-dd')), ' Avbrutet:'))FROM #slam x  where q.strFastBeteckningHel = x.strFastBeteckningHel  FOR XML PATH ('')), 1, 1, '')FROM #slam q group by strFastBeteckningHel,strDelprodukt)
             ,slam as (select strFastBeteckningHel,datStoppdatum =STUFF((SELECT distinct ','+nullif(strDelprodukt+'|','|')+z2 FROM slamm x  where q.strFastBeteckningHel = x.strFastBeteckningHel  FOR XML PATH ('')), 1, 1, '')from slamm q group by strFastBeteckningHel)
             
                   
           ,attUtsokaFran as (select *, row_number() over (partition by q.fastighet order by q.Anteckning desc ) flaggnr from (select anlaggningar.diarienummer,(case when anlaggningar.anlaggningspunkt is not null then anlaggningar.fstatus else '?' end) fstatus,socknarOfInteresse.fastighet,Byggnadstyp,Fastighet_tillstand,Beslut_datum,utf�rddatum,Anteckning,(case when anlaggningar.anlaggningspunkt is not null then anlaggningar.anlaggningspunkt else ByggShape end) flagga from socknarOfInteresse left outer join byggnader on socknarOfInteresse.fastighet = byggnader.fastighet left outer join anlaggningar on socknarOfInteresse.fastighet = anlaggningar.fastighet) q  where q.flagga is not null)

            ,gul as (select null "fstat" ) -- from fastighets_Anslutningar_Gemensamhetanl�ggningar)

    toTeamVatten as (
	    select   
      							   coalesce(fastighetsYtor.FAStighet, egetOmh.fastighet, va.fastighet, Fastighetsbeteckning,anlaggningar.FAStighet) fastighet,
       Fastighet_tillstand, Diarienummer, 
                                                          
                                                           FORMAT(nullif(attUtsokaFran.Beslut_datum, smalldatetimefromparts(1900, 01, 01, 00, 00)),'yyyy-MM-dd') Beslut_datum,
                                                           FORMAT(nullif(attUtsokaFran.utf�rddatum, smalldatetimefromparts(1900, 01, 01, 00, 00)),'yyyy-MM-dd') utf�rddatum,
       Anteckning 
							   
, Byggnadstyp typ, Byggnadstyp , 
     , typ VAantek
	         ,
statusx,
     , egetOmh.egetOmh�ndertangandeInfo
                                slam                     = (SELECT '')--(select top 1 datStoppdatum from slam where attUtsokaFran.fastighet = slam.strFastBeteckningHel)
           ,
     bygTot,
       coalesce(AnlaggningsPunkt,flagga).STPointN(1)  flagga 
	from fastighetsYtor
	full outer join anlaggningar on anlaggningar.FAStighet = fastighetsYtor.FAStighet
	full outer join egetOmh on fastighetsYtor.FAStighet = egetOmh.FAStighet
	full outer join  va on fastighetsYtor.FAStighet = va.FAStighet
	full outer join byggs on fastighetsYtor.FAStighet = byggs.Fastighetsbeteckning


    ,flaggKorrigering as (select
		    (case when fstatus = N'r�d'
                 	 then (case when (
			 vaPlan is null 
			 and egetOmh�ndertangandeInfo is null) then N'r�d'
                      		else (case when VaPlan is not null
                          		then 'KomV?'
					 else (case when null is not null
                              			then 'gem' else '?' end) end) end) 
						else fstatus end ) Fstatus
		
		
		fastighet,Fastighet_tillstand,Beslut_datum,utf�rddatum,Anteckning,egetOmh�ndertangandeInfo,Byggnadstyp,
		VaPlan,flagga,   
                  slam,
	 bygTot, 
		    from correctTypOVa)

            select * into #r�d from  q2

    INSERT INTO #statusTable (one, start)  select one, start from @internalStatus

            INSERT INTO #statusTable select N'rebuilt#R�d',CURRENT_TIMESTAMP,@@ROWCOUNT end else INSERT INTO #statusTable select N'preloading#R�d',CURRENT_TIMESTAMP,@@ROWCOUNT;


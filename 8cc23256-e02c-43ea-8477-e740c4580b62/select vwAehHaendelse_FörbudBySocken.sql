with
	  socknarOFinterest as (select '%ollingbo%' socken union
			  select  '%ejdeby%' socken union
			   select  '%okrume%' socken union
			    select  '%artebo%' socken union
			    select  N'%räkumla%' socken union
			    select  '%isby%' socken union
			    select  N'%ästerhejde%' socken
			 )
    ,     HandelserArendenInteForHa as (select * from EDPVisionRegionGotland.dbo.vwAehHaendelse
			   where strRubrik
				     in (
				         N'Reviderad ansökan ensklit avlopp',
				         N'Reviderad ansökan',
					 N'Kompletteringsbegäran skickad',
				         N'Kompletteringsbegäran',
					 'Komplettering-situationsplan',
				         'Komplettering,' +
				         'situationsplan',
					 'Komplettering',
				         N'Komplett ansökan',
					 N'Information om- Komplettering av ansökan begärd',
					 N'Beslut om enskild avloppsanläggning BDT+ WC',
					 N'Beslut om enskild avloppsanläggning BDT + Tank',
					 N'Besiktningsprotokoll – provgrop',
				         N'Avlopp - utförandeintyg',
					 N'Ansökan/anmälan om enskild avloppsanläggning',
				         N'Ansökan med underskrift'
				        )
			  )
   	, inputArende               as (select vwAehAerende.*from EDPVisionRegionGotland.dbo.vwAehAerende vwAehAerende
				  left outer join HandelserArendenInteForHa
				    on vwAehAerende.recAerendeID = HandelserArendenInteForHa.recAerendeID
					where vwAehAerende.strEnhetKod = 'Vatten' and
				     vwAehAerende.strAerendeStatusPresent <> 'Assault' AND
				     vwAehAerende.strAerendemening like 'Klart Vatten%'
          			and HandelserArendenInteForHa.recAerendeID is null)


      ,   arendeMedBeteckning       as (select strDiarienummer
					    , recAerendeID, strFnrID, strSoekbegrepp, strFastighetsbeteckning,
            			(IIF(strFnrID is null AND strSoekbegrepp <> strFastighetsbeteckning,
				    case when strFastighetsbeteckning is null
					     then strSoekbegrepp
					 when strSoekbegrepp is null
					     then strFastighetsbeteckning
					 when strSoekbegrepp like concat('%', strFastighetsbeteckning, '%')
					     then strSoekbegrepp
					     else concat(strSoekbegrepp, ' // ', strFastighetsbeteckning)
				    end, strFastighetsbeteckning)) beteckning
			       from inputArende vwAehAerende
     				    )
    	, filterBySocken as (select arendeMedBeteckning.* from arendeMedBeteckning inner join socknarOfinterest on beteckning like socken)

	, arendeWhomDoesNotHaveHandling as (
	  	select filterBySocken.strDiarienummer, filterBySocken.beteckning, strRubrik, handelse.strRubrik hrubrik
		,handelse.strText htext ,strText, datHaendelseDatum
	  	,IIF(strText is null, datHaendelseDatum, cast(datHaendelseDatum as int) + 1000) datx
	  	from filterBySocken left outer join EDPVisionRegionGotland.dbo.vwAehHaendelse handelse on filterBySocken.recAerendeID = handelse.recAerendeID
      )
    ,     handelseBydateAndArende as (select strDiarienummer
		 , beteckning
		 , (IIF(
	    (strRubrik = 'Klart vatten - information om avlopp' OR strRubrik = 'Klart vatten information om avlopp'),
		    N'först. utskick', hRubrik))	strRubrik
		    , (replace(hText, '\n', ''))        HandelseText
		 , row_number() over (partition by strDiarienummer order by datx desc) senaste
	    from arendeWhomDoesNotHaveHandling)

	select *from  handelseBydateAndArende where senaste = 1 order by strDiarienummer, senaste



	--filter out rubriker that's irrelevant
    with RubrikerNotInterested as (
	    select N'Uppf�ljning utf�randeintyg' rubrik union
	    select N'Mottagningskvitto' rubrik union
	    select N'P�minnelse om �tg�rd - 18 m�nader' rubrik union
	    select N'Fakturering av avlopps�rende' rubrik union
	    select N'Bekr�ftelsekort'  rubrik union
	    select N'Klart vatten - information om avlopp' rubrik union
	    select N'Provgropsprotokoll' rubrik
    )
    ,rubrikersNotInterestedInlike as (
	    select '%Besiktningsprotokoll%' rubrik union
	    select  '%Beslut om%' rubrik union
	    select  N'%Bekr�ftelse%' rubrik union
	    select  '%Reviderad%' rubrik union
	    select  N'%Ans�kan%' rubrik
    )
    ,textOfnotInterst as (

        select N'�rendet skickat till L�nsstyrelsen f�r bed�mning om dispens g�llande riksintresse Gotlands kusten.' [text] union
	select N'Remiss �ter fr�n LST. �rendet kr�ver ingen dispens g�llande naturreservat Gotlands kusten eller fr�n strandskyddet.' [text]
    )

    SELECT
           Fastighet, Diarienummer, Rubrik, H�ndelsedatum, text
    into #h�ndelserFiltered
		   FROM (select o.* from #Orginal_listFilter o
		       left outer join RubrikerNotInterested r on r.rubrik = o.rubrik
		       left outer join rubrikersNotInterestedInlike l on o.rubrik like l.rubrik
		       left outer join textOfnotInterst t on o.text = t.text
		   	where coalesce(l.rubrik,o.rubrik,t.text) is null

		   ) x

            WHERE
		    [Text] is not null
			AND x.[Riktning] <> 'utg�ende'

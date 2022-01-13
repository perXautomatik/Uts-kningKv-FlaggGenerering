	--filter out rubriker that's irrelevant
    with RubrikerNotInterested as (
	    select N'Uppföljning utförandeintyg' rubrik union
	    select N'Mottagningskvitto' rubrik union
	    select N'Påminnelse om åtgärd - 18 månader' rubrik union
	    select N'Fakturering av avloppsärende' rubrik union
	    select N'Bekräftelsekort'  rubrik union
	    select N'Klart vatten - information om avlopp' rubrik union
	    select N'Provgropsprotokoll' rubrik
    )
    ,rubrikersNotInterestedInlike as (
	    select '%Besiktningsprotokoll%' rubrik union
	    select  '%Beslut om%' rubrik union
	    select  N'%Bekräftelse%' rubrik union
	    select  '%Reviderad%' rubrik union
	    select  N'%Ansökan%' rubrik
    )
    ,textOfnotInterst as (

        select N'Ärendet skickat till Länsstyrelsen för bedömning om dispens gällande riksintresse Gotlands kusten.' [text] union
	select N'Remiss åter från LST. Ärendet kräver ingen dispens gällande naturreservat Gotlands kusten eller från strandskyddet.' [text]
    )

    SELECT
           Fastighet, Diarienummer, Rubrik, Händelsedatum, text
    into #händelserFiltered
		   FROM (select o.* from #Orginal_listFilter o
		       left outer join RubrikerNotInterested r on r.rubrik = o.rubrik
		       left outer join rubrikersNotInterestedInlike l on o.rubrik like l.rubrik
		       left outer join textOfnotInterst t on o.text = t.text
		   	where coalesce(l.rubrik,o.rubrik,t.text) is null

		   ) x

            WHERE
		    [Text] is not null
			AND x.[Riktning] <> 'utgående'

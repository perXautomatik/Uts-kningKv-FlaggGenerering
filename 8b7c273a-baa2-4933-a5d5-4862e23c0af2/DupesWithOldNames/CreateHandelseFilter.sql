
	--filter out rubriker that's irrelevant
    SELECT
           Fastighet,
           Diarienummer,
		   Rubrik,
           Händelsedatum,
		   text
    into #händelserFiltered
		   FROM #Orginal_listFilter as x
            WHERE

			rubrik <> 'Uppföljning utförandeintyg'
            AND rubrik <> 'Mottagningskvitto'
            AND rubrik <> 'Påminnelse om åtgärd - 18 månader'
            AND rubrik <> 'Fakturering av avloppsärende'
            AND Rubrik <> 'Bekräftelsekort'
			AND Rubrik <> 'Klart vatten - information om avlopp'
			and not(Rubrik like '%Besiktningsprotokoll%')
			and not(Rubrik like '%Beslut om%')
			and not(Rubrik like '%Bekräftelse%')
			and not(Rubrik like '%Reviderad%')
			and not(Rubrik like '%Ansökan%')
			AND Rubrik <> 'Provgropsprotokoll'
			AND ([Text] <> 'Ärendet skickat till Länsstyrelsen för bedömning om dispens gällande riksintresse Gotlands kusten.'
			AND [Text] <> 'Remiss åter från LST. Ärendet kräver ingen dispens gällande naturreservat Gotlands kusten eller från strandskyddet.'
			AND not([Text] is null)
			AND x.[Riktning] <> 'utgående'

			)

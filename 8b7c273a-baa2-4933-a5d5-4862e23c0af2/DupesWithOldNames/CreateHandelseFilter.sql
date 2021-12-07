
	--filter out rubriker that's irrelevant
    SELECT
           Fastighet,
           Diarienummer,
		   Rubrik,
           H�ndelsedatum,
		   text
    into #h�ndelserFiltered
		   FROM #Orginal_listFilter as x
            WHERE

			rubrik <> 'Uppf�ljning utf�randeintyg'
            AND rubrik <> 'Mottagningskvitto'
            AND rubrik <> 'P�minnelse om �tg�rd - 18 m�nader'
            AND rubrik <> 'Fakturering av avlopps�rende'
            AND Rubrik <> 'Bekr�ftelsekort'
			AND Rubrik <> 'Klart vatten - information om avlopp'
			and not(Rubrik like '%Besiktningsprotokoll%')
			and not(Rubrik like '%Beslut om%')
			and not(Rubrik like '%Bekr�ftelse%')
			and not(Rubrik like '%Reviderad%')
			and not(Rubrik like '%Ans�kan%')
			AND Rubrik <> 'Provgropsprotokoll'
			AND ([Text] <> '�rendet skickat till L�nsstyrelsen f�r bed�mning om dispens g�llande riksintresse Gotlands kusten.'
			AND [Text] <> 'Remiss �ter fr�n LST. �rendet kr�ver ingen dispens g�llande naturreservat Gotlands kusten eller fr�n strandskyddet.'
			AND not([Text] is null)
			AND x.[Riktning] <> 'utg�ende'

			)

utf�randintygellerej as (
	--filter out h�ndelser that does not have utf�randitnyg
    SELECT
	Fastighet,
	ISNULL(MAX(CASE WHEN [Rubrik] = 'Avlopp - utf�randeintyg' THEN 'T' END),
	    MAX(CASE WHEN [Rubrik] <> 'Avlopp - utf�randeintyg' THEN 'F' END)) AS Uj
	FROM #Orginal_listFilter
    GROUP BY [Fastighet], [Rubrik], [Diarienummer]
)
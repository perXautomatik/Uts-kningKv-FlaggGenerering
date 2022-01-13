utförandintygellerej as (
	--filter out händelser that does not have utföranditnyg
    SELECT
	Fastighet,
	ISNULL(MAX(CASE WHEN [Rubrik] = 'Avlopp - utförandeintyg' THEN 'T' END),
	    MAX(CASE WHEN [Rubrik] <> 'Avlopp - utförandeintyg' THEN 'F' END)) AS Uj
	FROM #Orginal_listFilter
    GROUP BY [Fastighet], [Rubrik], [Diarienummer]
)
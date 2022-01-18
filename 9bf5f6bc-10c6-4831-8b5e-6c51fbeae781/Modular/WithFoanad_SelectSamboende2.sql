WITH
    SAMMBOENDE AS (SELECT DIARIENUMMER, FNR, NAMN, ADRESS, POSTORT, POSTNR
			, count(*) OVER ( PARTITION BY DIARIENUMMER) UTSKICKPERDIA
		   FROM (SELECT DIARIENUMMER
			      , FNR
			      , NAMN = stuff((SELECT ',' + NAMN
					      FROM FOANAD Q
					      WHERE Q.ADRESS = R.ADRESS
					      GROUP BY NAMN
					      FOR XML PATH ('')), 1, 1, '')
			      , ADRESS, POSTORT, POSTNR
			 FROM FOANAD R) AS R2
		   GROUP BY DIARIENUMMER, FNR, NAMN, ADRESS, POSTORT, POSTNR)
SELECT *
FROM SAMMBOENDE
ORDER BY ADRESS



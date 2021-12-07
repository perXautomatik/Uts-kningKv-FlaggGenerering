with
    unx2 as (SELECT DIARIENUMMER FROM @TP1 UNION SELECT DIARIENUMMER FROM @TP2)
    ,sa2 as (SELECT Z.DIARIENUMMER, HARNAMN
			      FROM  UNX2
				  LEFT OUTER JOIN @TP1 Z ON UNX.DIARIENUMMER = Z.DIARIENUMMER)
    ,unx as (
			SELECT DIARIENUMMER
			FROM SA2
			WHERE HARNAMN = 0
		    )
   ,sa as (SELECT Z.*
		    FROM  UNX
			LEFT OUTER JOIN @TP2 Z ON UNX.DIARIENUMMER = Z.DIARIENUMMER)
    ,we as (
	      SELECT *
	      FROM (SELECT Z.*
		    FROM (SELECT DIARIENUMMER FROM @TP1 UNION SELECT DIARIENUMMER FROM @TP2) UNX
			LEFT OUTER JOIN @TP1 Z ON UNX.DIARIENUMMER = Z.DIARIENUMMER) AS SA
	      WHERE HARNAMN = 1
	      UNION
	      SELECT *
	      FROM  SA
	      WHERE HARNAMN = 1)
    ,W
    AS  (
	  SELECT DIARIENUMMER
	       , max(FNR)                                                                              FNR
	       , max(HÄNDELSEDATUM)                                                                    DATUM
	       , NAMN
	       , POSTNUMMER
	       , POSTORT
	       , GATUADRESS
	       , PERSONNR
	       , HARNAMN
	       , row_number() OVER (PARTITION BY DIARIENUMMER ORDER BY max(HÄNDELSEDATUM)) * max(PRIO) PRIOX
	  FROM  WE
	  GROUP BY DIARIENUMMER, NAMN, POSTNUMMER, POSTORT, GATUADRESS, PERSONNR, HARNAMN)


SELECT *
FROM  AD
WHERE DQWEQ = 1




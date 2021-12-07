:r FnrToAdress/Samboende.sql

SELECT *
FROM (SELECT FASTIGHET
      FROM tempExcel.dbo.[20201108ChristofferRäknarExcel]
      GROUP BY FASTIGHET
      UNION
      SELECT FASTIGHETSBETECKNING
      FROM tempExcel.dbo.[20201112Flaggor ägaruppgifter-nyutskick]
      GROUP BY FASTIGHETSBETECKNING) AS CREF20201112F
WHERE NOT (FASTIGHET IN (SELECT FNR FROM SAMMBOENDE))
SELECT KIR
FROM (SELECT Z.DIA, Z.KIR, X.FNR
      FROM (SELECT INTDIARIENUMMERLOEPNUMMER DIA, STRFASTIGHETSBETECKNING KIR, STRFNRID FNR
	    FROM [admsql04].[EDPVisionRegionGotland].DBO.VWAEHAERENDE
	    WHERE STRAERENDEMENING = 'Klart vatten - information om avlopp' AND INTDIARIEAAR = 2020) AS Z
	  LEFT OUTER JOIN [gisdata].[sde_geofir_gotland].[gng].FA_FASTIGHET X ON Z.KIR = X.BETECKNING
      WHERE NOT (DIA IN (SELECT DIARIENUMMER FROM SAMMBOENDE GROUP BY DIARIENUMMER))) Q
    LEFT OUTER JOIN tempExcel.dbo.[20201112Flaggor ägaruppgifter-nyutskick] Y ON Y.FASTIGHETSNYCKEL = Q.FNR
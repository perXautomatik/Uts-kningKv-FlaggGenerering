DECLARE @TIME AS SMALLDATETIME
SET @TIME = getdate();

BEGIN
    DECLARE @TIME AS SMALLDATETIME SET @TIME = getdate();
    WITH
	Q                  AS (SELECT FNR
				    , INSKDATUM
				    , ANDEL
				    , PERSORGNR
				    , FAL_CO
				    , FAL_UTADR1
				    , FAL_UTADR2
				    , FAL_POSTNR
				    , FAL_POSTORT
				    , SAL_CO
				    , SAL_UTADR1
				    , SAL_UTADR2
				    , SAL_POSTNR
				    , SAL_POSTORT
				    , UA_UTADR1
				    , UA_UTADR2
				    , UA_UTADR3
				    , UA_UTADR4
				    , UA_LAND
				    , KORTNAMN NAMN
			       FROM [GISDATA].SDE_GEOFIR_GOTLAND.GNG.FA_LAGFART_V2
			       WHERE FNR IN (SELECT FNR FROM #FNRZ))
      , Z                  AS (SELECT FNR
				    , NAMN
				    , INSKDATUM
				    , ANDEL
				    , PERSORGNR
				    , FAL_CO
				    , FAL_UTADR1
				    , FAL_UTADR2
				    , FAL_POSTNR
				    , FAL_POSTORT
			       FROM Q
			       UNION
			       SELECT FNR
				    , NAMN
				    , INSKDATUM
				    , ANDEL
				    , PERSORGNR
				    , SAL_CO
				    , SAL_UTADR1
				    , SAL_UTADR2
				    , SAL_POSTNR
				    , SAL_POSTORT
			       FROM Q
			       UNION
			       SELECT FNR
				    , NAMN
				    , INSKDATUM
				    , ANDEL
				    , PERSORGNR
				    , UA_UTADR1
				    , UA_UTADR2
				    , UA_UTADR3
				    , UA_UTADR4
				    , UA_LAND
			       FROM Q)
      , FA_LAGFART         AS (SELECT FNR
				    , NAMN
				    , INSKDATUM
				    , ANDEL
				    , PERSORGNR
				    , FAL_CO
				    , FAL_UTADR1
				    , FAL_UTADR2
				    , FAL_POSTNR
				    , FAL_POSTORT
			       FROM Z
			       WHERE coalesce(FAL_CO, FAL_UTADR1, FAL_UTADR2, FAL_POSTNR, FAL_POSTORT) IS NOT NULL)
      , Q2                 AS (SELECT FNR
				    , PERSORGNR
				    , ANDEL
				    , KORTNAMN NAMN
				    , FAL_CO
				    , FAL_UTADR1
				    , FAL_UTADR2
				    , FAL_POSTNR
				    , FAL_POSTORT
				    , SAL_CO
				    , SAL_UTADR1
				    , SAL_UTADR2
				    , SAL_POSTNR
				    , SAL_POSTORT
				    , UA_UTADR1
				    , UA_UTADR2
				    , UA_UTADR3
				    , UA_UTADR4
				    , UA_LAND
			       FROM [GISDATA].SDE_GEOFIR_GOTLAND.GNG.FA_TAXERINGAGARE_V2
			       WHERE FNR IN (SELECT FNR FROM #FNRZ))

      , Z2                 AS (SELECT FNR
				    , PERSORGNR
				    , ANDEL
				    , NAMN
				    , FAL_CO
				    , FAL_UTADR1
				    , FAL_UTADR2
				    , FAL_POSTNR
				    , FAL_POSTORT
			       FROM Q2
			       UNION
			       SELECT FNR
				    , PERSORGNR
				    , ANDEL
				    , NAMN
				    , SAL_CO
				    , SAL_UTADR1
				    , SAL_UTADR2
				    , SAL_POSTNR
				    , SAL_POSTORT
			       FROM Q2
			       UNION
			       SELECT FNR, PERSORGNR, ANDEL, NAMN, UA_UTADR1, UA_UTADR2, UA_UTADR3, UA_UTADR4, UA_LAND
			       FROM Q2)
      , FA_TAXERINGAGARE   AS (SELECT FNR
				    , PERSORGNR
				    , ANDEL
				    , NAMN
				    , nullif(FAL_CO, '')      FAL_CO
				    , nullif(FAL_UTADR1, '')  FAL_UTADR1
				    , nullif(FAL_UTADR2, '')  FAL_UTADR2
				    , nullif(FAL_POSTNR, '')  FAL_POSTNR
				    , nullif(FAL_POSTORT, '') FAL_POSTORT
			       FROM Z2
			       WHERE coalesce(nullif(FAL_CO, ''), nullif(FAL_UTADR1, ''), nullif(FAL_UTADR2, ''),
					      nullif(FAL_POSTNR, ''), nullif(FAL_POSTORT, '')) IS NOT NULL)
      , COMBINED           AS (SELECT FNR
				    , PERSORGNR
				    , ANDEL
				    , NAMN
				    , INSKDATUM
				    , FAL_CO
				    , FAL_UTADR1
				    , FAL_UTADR2
				    , FAL_POSTNR
				    , FAL_POSTORT
			       FROM FA_LAGFART
			       UNION
			       SELECT FNR
				    , PERSORGNR
				    , ANDEL
				    , NAMN
				    , @TIME
				    , FAL_CO
				    , FAL_UTADR1
				    , FAL_UTADR2
				    , FAL_POSTNR
				    , FAL_POSTORT
			       FROM FA_TAXERINGAGARE)
      , ANDELAD            AS (SELECT CASE WHEN charindex('/', ANDEL, 1) > 0 THEN
						   try_cast(left(ANDEL, charindex('/', ANDEL, 1) - 1) AS FLOAT) /
						   try_cast(
							   right(ANDEL, len(ANDEL) - charindex('/', ANDEL, 1)) AS FLOAT)
				      END AS ANDEL
				    , FNR
				    , PERSORGNR
				    , NAMN
				    , INSKDATUM
				    , FAL_CO
				    , FAL_UTADR1
				    , FAL_UTADR2
				    , FAL_POSTNR
				    , FAL_POSTORT
			       FROM COMBINED)
      , GROUPED            AS (SELECT FNR
				    , PERSORGNR
				    , min(ANDEL)     ANDELMIN
				    , NAMN
				    , min(INSKDATUM) INSKSDATMIN
				    , FAL_CO
				    , FAL_UTADR1
				    , FAL_UTADR2
				    , FAL_POSTNR
				    , FAL_POSTORT
			       FROM ANDELAD
			       GROUP BY FNR, PERSORGNR, NAMN, FAL_CO, FAL_UTADR1, FAL_UTADR2, FAL_POSTNR, FAL_POSTORT)
      , MEDFASTIGHETSAGARE AS (
	SELECT FNR
	     , PERSORGNR
	     , format(ANDELMIN, '0.00')                                                          ANDELMIN
	     , NAMN
	     , nullif(INSKSDATMIN, @TIME)                                                        INSKSDATMIN
	     , ltrim(CONCAT(CASE WHEN FAL_POSTNR IS NULL THEN FAL_CO ELSE nullif('c/o ' + FAL_CO + ', ', 'c/o , ') END,
			    FAL_UTADR1 + ' ', FAL_UTADR2 + ', ', FAL_POSTNR, ' ' + FAL_POSTORT)) ADRESS
	     , FAL_POSTORT                                                                       POSTORT
	     , FAL_POSTNR                                                                        POSTNR
	     , CASE WHEN INSKSDATMIN = @TIME THEN 'FA_TAXERINGAGARE' ELSE 'FA_LAGFART' END AS    SOURCE
	FROM GROUPED
	UNION
	SELECT REALESTATEKEY
	     , PERSONORGANISATIONNR
	     , format(CASE WHEN charindex('/', SHAREPART, 1) > 0 THEN
				   try_cast(left(SHAREPART, charindex('/', SHAREPART, 1) - 1) AS FLOAT) /
				   try_cast(right(SHAREPART, len(SHAREPART) - charindex('/', SHAREPART, 1)) AS FLOAT)
		      END, '0.00') ANDEL
	     , NAME                NAMN
	     , REGDT
	     , ADDRESS
	     , NULL                POSTORT
	     , NULL                POSTNR
	     , 'info_CurrentOwner'
	FROM [GISDATA].SDE_GEOFIR_GOTLAND.GNG.INFO_CURRENTOWNER --sde_geofir_gotland.gng.FASTIGHETSÄGARE
	WHERE REALESTATEKEY IN (SELECT FNR FROM #FNRZ) AND ADDRESS IS NOT NULL
    )
      , FARDIG             AS (
	SELECT FNR
	     , PERSORGNR
	     , min(ANDELMIN)                                        ANDEL
	     , NAMN
	     , format(nullif(min(INSKSDATMIN), @TIME), 'yyyy MMdd') INSKDATUM
	     , replace(replace(replace(ADRESS, '  ', ' '), isnull(' ' + max(POSTNR), ''), ''),
		       isnull(', ' + max(POSTORT), ''), '')         ADRESS
	     , max(POSTORT)                                         POSTORT
	     , max(POSTNR)                                          POSTNR
	     , CASE WHEN max(POSTORT) IS NULL
			THEN 'info_currentOwner'
			ELSE CASE WHEN min(INSKSDATMIN) IS NULL THEN 'FA_TAXERINGAGARE' ELSE 'FA_LAGFART' END
	       END
	    AS                                                      SOURCE

	FROM MEDFASTIGHETSAGARE
	GROUP BY FNR, PERSORGNR, NAMN, ADRESS)
    SELECT FN.BETECKNING, FARDIG.*
    FROM FARDIG
	FULL OUTER JOIN #FNRZ FN
	ON FARDIG.FNR = FN.FNR

    ORDER BY FNR, PERSORGNR, SOURCE
END
:r FnrToAdress/todo

CREATE FUNCTION sp_FirKomplete(@INPUT AS KONTAKTUPGTABLETYPE READONLY) RETURNS KONTAKTUPGTABLETYPE AS
BEGIN
    WITH
        FIRCORRECTION AS (SELECT *, NAMN, FNR, ANDEL FROM sp_xFirMinimized(@INPUT))
       ,BAD           AS (SELECT *FROM @INPUT WHERE NOT (PERSONNR IS NOT NULL AND FNR IS NOT NULL AND GATUADRESS IS NOT NULL AND POSTORT IS NOT NULL AND POSTNUMMER IS NOT NULL))
      , GOOD          AS (SELECT *FROM @INPUT WHERE PERSONNR IS NOT NULL AND FNR IS NOT NULL AND GATUADRESS IS NOT NULL AND POSTORT IS NOT NULL AND POSTNUMMER IS NOT NULL)
      ,
        TORETURN AS (SELECT *
	  FROM GOOD
	  UNION
	  SELECT *
	  FROM (SELECT FIR.FNR
		FROM GOOD
		    INNER JOIN FIRCORRECTION FIR
		    ON GOOD.FNR = FIR.FNR AND GOOD.PERSONNR = FIR.PERSORGNR) MATCHING
	      INNER JOIN FIRCORRECTION ON MATCHING.FNR = FIRCORRECTION.FNR
	  WHERE FIRCORRECTION.ANDEL >= 1 / 3
	  UNION
	  SELECT DIARIENUMMER
	       , FNR
	       , FASTIGHET
	       , HÄNDELSEDATUM
	       , NAMN
	       , sp_pickByDivider(MYADDRESS, ',', 1) AS ADRESS
	       , sp_pickByDivider(MYADDRESS, ',', 2) AS POSTNUMMER
	       , sp_pickByDivider(MYADDRESS, ',', 3) AS POSTORT
	  FROM (SELECT DIARIENUMMER
		     , POSSIBLYNULL.FNR
		     , POSSIBLYNULL.FASTIGHET
		     , HÄNDELSEDATUM
		     , POSSIBLYNULL.NAMN
		     , (CASE WHEN NOT (
		      isnull(FIRCORRECTION.ADRESS, '') IS NOT NULL AND
		      isnull(POSSIBLYNULL.POSTNUMMER, 0) IS NOT NULL AND
		      isnull(POSSIBLYNULL.POSTORT, '') IS NOT NULL)
				 THEN concat(
			  POSSIBLYNULL.GATUADRESS,
			  ',',
			  POSSIBLYNULL.POSTNUMMER,
			  ',',
			  POSSIBLYNULL.POSTORT)
				 ELSE concat(
					 FIRCORRECTION.ADRESS,
					 ',',
					 FIRCORRECTION.POSTNR,
					 ',',
					 FIRCORRECTION.FAL_POSTORT)
			END) MYADDRESS
		FROM BAD POSSIBLYNULL
		    INNER JOIN FIRCORRECTION
		    ON (FIRCORRECTION.NAMN = POSSIBLYNULL.NAMN OR
			FIRCORRECTION.NAMN LIKE '%' & POSSIBLYNULL.NAMN & '%') AND
		       FIRCORRECTION.FNR = POSSIBLYNULL.FNR) ASFASD)
    SELECT *
    FROM TORETURN

END
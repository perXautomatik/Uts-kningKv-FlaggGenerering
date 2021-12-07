DROP FUNCTION sp_xKonUpgToAdr
GO
-- legacy method? does this incorperate the ultimate fir?

--CAST(CASE WHEN isnull([ANDEL],'') = '' THEN '1/1' ELSE [ANDEL] END AS varchar) as Händelsedatum,
CREATE FUNCTION DBO.sp_xKonUpgToAdr(@INPUTFNR KONTAKTUPGTABLETYPE READONLY)
    RETURNS
	TABLE AS
	    RETURN
	    with inputX as (
	        select fir.*,input.fastighet ifast,input.fnr ifnr from GISDATA.SDE_GEOFIR_GOTLAND.GNG.FA_LAGFART_V2 FIR
				  INNER JOIN @INPUTFNR INPUT ON FIR.FNR = INPUT.FNR
			      WHERE INPUT.HARNAMN = 0
	    )
	    SELECT *
	    FROM (SELECT DIARIENUMMER, FNR, FASTIGHET, HÄNDELSEDATUM, NAMN, POSTNUMMER, POSTORT, GATUADRESS, PERSONNR
		  FROM (
		      SELECT DIARIENUMMER, FNR, FASTIGHET
			   , getdate()                                                                             HÄNDELSEDATUM
			   , CAST(
			      CASE WHEN [NAMN] IS NULL OR [NAMN] = '' THEN KORTNAMN ELSE [NAMN] END AS VARCHAR) AS NAMN
			   , try_CAST(CASE SALUTFALUP WHEN 6 * 35 THEN UA_UTADR2
						      WHEN 6      THEN SAL_POSTNR
								  ELSE [FAL_POSTNR]
				      END AS INT)                                                               AS POSTNUMMER
			   , CAST(CASE SALUTFALPOSALPOST WHEN 6 * 35 THEN UA_LAND
							 WHEN 6      THEN SAL_POSTORT
								     ELSE [FAL_POSTORT]
				  END AS VARCHAR)                                                               AS POSTORT
			   , CAST(CASE SALUTFALUP WHEN 6 * 35 THEN UA_UTADR1
						  WHEN 6      THEN SAL_UTADR1
							      ELSE [FAL_UTADR2]
				  END AS VARCHAR)                                                               AS GATUADRESS
			   , [PERSORGNR]                                                                           PERSONNR
		      FROM (
			  SELECT FASTIGHET
			       , (CASE WHEN isnull([FAL_POSTORT], '') = '' THEN 2 ELSE 1 END) *
				 (CASE WHEN isnull(SAL_POSTNR, '') = '' THEN 3 ELSE 1 END) *
				 SALUTASALPOS                                                               SALUTFALPOSALPOST
			       , (CASE WHEN isnull([FAL_UTADR2], '') = '' THEN 2 ELSE 1 END) *
				 (CASE WHEN isnull([FAL_POSTNR], '') = '' THEN 3 ELSE 1 END) * SALUTASALPOS SALUTFALUP
			       , DIARIENUMMER, FNR, [UA_UTADR2], [UA_UTADR1], [UA_LAND], [SAL_POSTORT], [SAL_POSTNR], [NAMN], [KORTNAMN], [FAL_UTADR2], [FAL_POSTORT], [FAL_POSTNR], [SAL_UTADR1], [PERSORGNR]
			  FROM (
			      SELECT IFASTIGHET
				   , (CASE WHEN isnull(SAL_UTADR1, '') = '' THEN 5 ELSE 1 END) *
				     (CASE WHEN isnull(SAL_POSTNR, '') = '' THEN 7 ELSE 1 END) SALUTASALPOS
				   , DIARIENUMMER, IFNR, [UA_UTADR2], [UA_UTADR1], [UA_LAND], [SAL_POSTORT], [SAL_POSTNR], FIR.[NAMN], [KORTNAMN], [FAL_UTADR2], [FAL_POSTORT], [FAL_POSTNR], [SAL_UTADR1], [PERSORGNR]
			      FROM inputX) ASDAGA) INPUTPLUSFIR
		  ) PT1
		  UNION
		  SELECT DIARIENUMMER, FNR, FASTIGHET, HÄNDELSEDATUM, NAMN, POSTNUMMER, POSTORT, GATUADRESS, PERSONNR
		  FROM (SELECT DIARIENUMMER, FNR, FASTIGHET, HÄNDELSEDATUM, NAMN, POSTNUMMER, POSTORT, GATUADRESS, PERSONNR, HARNAMN
			FROM @INPUTFNR X
			WHERE X.HARNAMN = 1
		  ) PT2) SAD
GO


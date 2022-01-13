DROP FUNCTION FnrToAdress;
GO
CREATE FUNCTION dbo.FnrToAdress(@inputFnr KontaktUpgTableType READONLY)
    RETURNS
        table as
            return
            select 
*
            from (
                     select 
	    		Diarienummer, Fnr, FASTIGHET, Händelsedatum, Namn, Postnummer, Postort, Gatuadress, personnr
		from (
			select diarienummer, Fnr, FASTIGHET
			   , getdate() HÄNDELSEDATUM
			   , CAST(CASE WHEN isnull([NAMN], '') = '' THEN KORTNAMN ELSE [NAMN] END AS VARCHAR) AS NAMN
			   , try_CAST(CASE SALUTFALUP WHEN 6 
			    then UA_UTADR2 when
			     2 
			    THEN SAL_POSTNR ELSE [FAL_POSTNR] END AS INT)                                                               AS POSTNUMMER
			   , CAST(CASE SALUTFALPOSALPOST WHEN 6 
			     then UA_LAND when
			      2 
			    THEN SAL_POSTORT ELSE [FAL_POSTORT] END AS VARCHAR)                                                               AS POSTORT
			   , CAST(CASE SALUTFALUP WHEN 6 
			     then UA_UTADR1 when 
			     2 
			      THEN SAL_UTADR1 ELSE [FAL_UTADR2] END AS VARCHAR)                                                               AS GATUADRESS
			   , [PERSORGNR]                                                                           PERSONNR
                            
                     FROM (
			      SELECT
			       FASTIGHET ,DIARIENUMMER,  [UA_UTADR2], [UA_UTADR1], [UA_LAND], [SAL_POSTORT], [SAL_POSTNR], [KORTNAMN], [FAL_UTADR2], [FAL_POSTORT], [FAL_POSTNR], [SAL_UTADR1], [PERSORGNR],
			      [NAMN], 
                              Fnr, 
			      [ANDEL], 
			       
			       
			       , try_cast(isNull(nullif(1, isnull(nullif(isnull([FAL_UTADR2], ''), q), 1)), 2) as int) * y SALUTFALUP ,
                                  try_cast(isNull(nullif(1, isnull(nullif(isnull(FAL_POSTORT, ''), q), 1)), 2) as int) * y SALUTFALPOSALPOST ,

			      FROM GISDATA.SDE_GEOFIR_GOTLAND.GNG.FA_LAGFART_V2 FIR
				  INNER JOIN @INPUTFNR INPUT
				      ON FIR.FNR = INPUT.FNR
			     		 WHERE INPUT.HARNAMN = 0) as F ) INPUTPLUSFIR
			)



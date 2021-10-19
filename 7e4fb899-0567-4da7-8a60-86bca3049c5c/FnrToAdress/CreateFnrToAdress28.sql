DROP FUNCTION FnrToAdress;
GO
CREATE FUNCTION dbo.FnrToAdress(@inputFnr KontaktUpgTableType READONLY)
    RETURNS
        table as
            return
            select 
	    		Diarienummer, Fnr, Händelsedatum, Namn, Postnummer, Postort, Gatuadress, personnr
            from (
                     select 
		     	    GETDATE() Händelsedatum,
                            CAST(CASE WHEN isnull([NAMN], '') = '' THEN KORTNAMN ELSE [NAMN] END AS varchar) as Namn,
                            CAST(CASE z when 6 then UA_UTADR1 when 2 then SAL_UTADR1 ELSE FAL_UTADR2 END AS varchar)                                         as Gatuadress,
                            try_CAST(CASE z when 6 then UA_UTADR2 when 2 then SAL_POSTNR ELSE [FAL_POSTNR] END AS int)                                       as POSTNUMMER,
                            CAST(CASE r when 6 then UA_LAND when 2 then SAL_POSTORT ELSE [FAL_POSTORT] END AS varchar)                                      as postOrt,
                            [PERSORGNR]                                                                      as personnr,
                            diarienummer,
                            Fnr
                     FROM (
                              SELECT Fnr, [UA_UTADR2], [UA_UTADR1], [UA_LAND], [SAL_POSTORT], [SAL_POSTNR], [NAMN], [KORTNAMN], [FAL_UTADR2], [FAL_POSTORT], [FAL_POSTNR], [ANDEL], [SAL_UTADR1], [PERSORGNR],
                                     try_cast(isNull(nullif(1, isnull(nullif(isnull([FAL_UTADR2], ''), q), 1)),
                                                     2) as int) * y z,
                                     try_cast(isNull(nullif(1, isnull(nullif(isnull(FAL_POSTORT, ''), q), 1)),
                                                     2) as int) * y r
                                      ,
                                     Diarienummer
			      FROM GISDATA.SDE_GEOFIR_GOTLAND.GNG.FA_LAGFART_V2 FIR
				  INNER JOIN @INPUTFNR INPUT
				      ON FIR.FNR = INPUT.FNR
			     		 WHERE INPUT.HARNAMN = 0) as F ) as FI




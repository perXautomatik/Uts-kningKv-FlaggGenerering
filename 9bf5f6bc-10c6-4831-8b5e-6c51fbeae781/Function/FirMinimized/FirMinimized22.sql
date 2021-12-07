DROP FUNCTION sp_xFirMinimized
GO
CREATE FUNCTION sp_xFirMinimized(@DIAKIR AS HANDELSETABLETYPE READONLY)
    RETURNS TABLE AS
	RETURN
	WITH
	    FIRRAW AS
		(SELECT PERSORGNR, FAL_CO, FAL_UTADR1, FAL_UTADR2, FAL_POSTNR, FAL_POSTORT, SAL_CO, SAL_UTADR1, SAL_UTADR2, SAL_POSTNR, SAL_POSTORT, UA_UTADR1, UA_UTADR2, UA_UTADR3, UA_UTADR4, UA_LAND
		      --,input.fastighet
		 FROM GISDATA.SDE_GEOFIR_GOTLAND.GNG.FA_LAGFART_V2 Q
		     INNER JOIN sp_xKirToFnr(@DIAKIR) INPUT ON Q.FNR = INPUT.FNR)
	SELECT PERSORGNR
	     , concat(CASE WHEN FAL_CO <> '' THEN concat(FAL_CO, ',') ELSE '' END,
		      CASE WHEN FAL_UTADR1 <> '' THEN concat(FAL_UTADR1, ',') ELSE '' END,
		      FAL_UTADR2)                        ADRESS
	     , TEMPEXCEL.DBO.udf_xGetNumeric(FAL_POSTNR) POSTNR
	     , FAL_POSTORT
	     , FASTIGHET
	FROM (SELECT PERSORGNR, FAL_CO, FAL_UTADR1, FAL_UTADR2, FAL_POSTNR, FAL_POSTORT, FASTIGHET
	      FROM FIRRAW
	      WHERE NOT (nullif(FAL_CO, '') IS NULL AND nullif(FAL_UTADR1, '') IS NULL AND
			 nullif(FAL_UTADR2, '') IS NULL) AND nullif(FAL_POSTNR, 0) IS NOT NULL AND
		    nullif(FAL_POSTORT, '') IS NOT NULL
	      UNION
	      SELECT PERSORGNR, SAL_CO, SAL_UTADR1, SAL_UTADR2, SAL_POSTNR, SAL_POSTORT, FASTIGHET
	      FROM FIRRAW
	      WHERE NOT (nullif(SAL_CO, '') IS NULL AND nullif(SAL_UTADR1, '') IS NULL AND
			 nullif(SAL_UTADR2, '') IS NULL) AND nullif(SAL_POSTNR, 0) IS NOT NULL AND
		    nullif(SAL_POSTORT, '') IS NOT NULL
	      UNION
	      SELECT PERSORGNR, UA_UTADR1, UA_UTADR2, UA_UTADR3, UA_UTADR4, UA_LAND, FASTIGHET
	      FROM FIRRAW
	      WHERE NOT (nullif(UA_UTADR1, '') IS NULL AND nullif(UA_UTADR2, '') IS NULL AND
			 nullif(UA_UTADR3, '') IS NULL) AND nullif(UA_UTADR4, '') IS NOT NULL AND
		    nullif(UA_LAND, '') IS NOT NULL) ENADRESSTYP

GO
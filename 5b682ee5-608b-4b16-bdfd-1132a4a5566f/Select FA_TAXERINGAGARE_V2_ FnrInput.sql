with
    fnrInput as (select *
		 from sde_geofir_gotland.gng.FA_TAXERINGAGARE_V2
		 where fnr in
		       (90035318, 90000487, 90028363,
		        90000807, 90042089, 90000849,
		        90061888, 90035635, 90028359))


SELECT CAST(CASE WHEN [ANDEL] is null OR [ANDEL] = '' THEN '1/1' ELSE [ANDEL] END AS varchar) as andel
     , CAST(CASE WHEN [NAMN] is null OR [NAMN] = '' THEN KORTNAMN ELSE [NAMN] END AS varchar) as Namn
     , CAST(CASE WHEN ([FAL_UTADR2] is null OR [FAL_UTADR2] = '') AND ([FAL_POSTNR] is null OR [FAL_POSTNR] = '')
		     then CASE WHEN (SAL_UTADR1 is null OR SAL_UTADR1 = '') AND (SAL_POSTNR is null OR SAL_POSTNR = '')
				   THEN UA_UTADR1
				   ELSE SAL_UTADR1
			  END
		     ELSE FAL_UTADR2
	    END AS varchar)                                                                   as Adress
     , CAST(CASE WHEN ([FAL_UTADR2] is null OR [FAL_UTADR2] = '') AND ([FAL_POSTNR] is null OR [FAL_POSTNR] = '')
		     then CASE WHEN (SAL_UTADR1 is null OR SAL_UTADR1 = '') AND (SAL_POSTNR is null OR SAL_POSTNR = '')
				   THEN UA_UTADR2
				   ELSE SAL_POSTNR
			  END
		     ELSE [FAL_POSTNR]
	    END AS varchar)                                                                   as Postnr
     , CAST(CASE WHEN ([FAL_POSTORT] is null OR [FAL_POSTORT] = '') AND ([FAL_POSTNR] is null OR [FAL_POSTNR] = '')
		     then CASE WHEN (SAL_UTADR1 is null OR SAL_UTADR1 = '') AND (SAL_POSTNR is null OR SAL_POSTNR = '')
				   THEN UA_LAND
				   ELSE SAL_POSTORT
			  END
		     ELSE [FAL_POSTORT]
	    END AS varchar)                                                                   as postOrt
FROM (SELECT [UA_UTADR2]
	   , [UA_UTADR1]
	   , [UA_LAND]
	   , [SAL_POSTORT]
	   , [SAL_POSTNR]
	   , [NAMN]
	   , [KORTNAMN]
	   , [FAL_UTADR2]
	   , [FAL_POSTORT]
	   , [FAL_POSTNR]
	   , [ANDEL]
	   , /*--[AGTYP],*/ [SAL_UTADR1] /*--,[UA_UTADR4],--[UA_UTADR3],--[TNMARK],--[SAL_UTADR2],--[SAL_CO],--[NAMN_OMV],--[MNAMN],--[KORTNAMN_OMV],--[FNAMN],--[FAL_UTADR1],--[FAL_CO],--[ENAMN]*/
      FROM fnrInput) da
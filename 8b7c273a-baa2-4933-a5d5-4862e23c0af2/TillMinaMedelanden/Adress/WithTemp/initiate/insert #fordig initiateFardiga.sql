
--drop table  tempdb.dbo.##fordig
if object_id(' tempdb..##fordig') is null begin
    BEGIN TRANSACTION;
WITH
    SRC1LAGFARa as (SELECT * from  tempdb.dbo.##KALLA where src is not null)
    ,rest as (SELECT fnr from  tempdb.dbo.##KALLA WHERE src is null)

    , s1 as (select z.FNR,	PERSORGNR, z.andel,z.NAMN, FAL_CO, 		FAL_UTADR1, FAL_UTADR2, FAL_POSTNR, FAL_POSTORT , 	'lagfart' SRC FROM  [GISDATA].SDE_GEOFIR_GOTLAND.GNG.FA_LAGFART_V2 Z INNER JOIN REST IP ON IP.FNR = Z.FNR 	WHERE coalesce(nullif(FAL_CO,''), nullif(FAL_UTADR1,''), nullif(FAL_UTADR2,''), nullif(FAL_POSTNR,''), nullif(FAL_POSTORT,'')) IS NOT NULL)
    , s2 as (SELECT z.FNR,	PERSORGNR, z.andel,z.NAMN, SAL_CO, 		SAL_UTADR1, SAL_UTADR2, SAL_POSTNR, SAL_POSTORT , 	'lagfart' SRC  FROM [GISDATA].SDE_GEOFIR_GOTLAND.GNG.FA_LAGFART_V2 Z INNER JOIN REST IP ON IP.FNR = Z.FNR	WHERE coalesce(nullif(SAL_CO,''), nullif(SAL_UTADR1,''), nullif(SAL_UTADR2,''), nullif(SAL_POSTNR,''), nullif(SAL_POSTORT,'')) IS NOT NULL)
    , s3 as (SELECT z.FNR,	PERSORGNR, z.andel,z.NAMN, UA_UTADR1, 		UA_UTADR2,  UA_UTADR3, 	UA_UTADR4,  UA_LAND , 		'lagfart' SRC  FROM [GISDATA].SDE_GEOFIR_GOTLAND.GNG.FA_LAGFART_V2 Z INNER JOIN REST IP ON IP.FNR = Z.FNR 	WHERE coalesce(nullif(UA_UTADR1,''), nullif(UA_UTADR2,''), nullif(UA_UTADR3,''), nullif(UA_UTADR4,''), nullif(UA_LAND,'')) IS NOT NULL)

    , [3toOneUnion] AS (SELECT * FROM S1 UNION ALL select * FROM S2 UNION all SELECT * FROM S3 UNION ALL SELECT * FROM SRC1LAGFARA Z)

    , T1 AS (SELECT q.FNR, PERSORGNR, ANDEL, NAMN, FAL_CO, 		FAL_UTADR1, FAL_UTADR2, FAL_POSTNR, FAL_POSTORT,'TAXERINGAGARE' src  	FROM [GISDATA].SDE_GEOFIR_GOTLAND.GNG.FA_TAXERINGAGARE_V2 Q INNER JOIN (SELECT FNR FROM rest EXCEPT SELECT FNR FROM [3toOneUnion])x ON X.FNR = Q.FNR WHERE coalesce(nullif(FAL_CO,''), nullif(FAL_UTADR1,''), nullif(FAL_UTADR2,''), nullif(FAL_POSTNR,''), nullif(FAL_POSTORT,'')) IS NOT NULL)
    , T2 AS (SELECT q.FNR, PERSORGNR, ANDEL, NAMN, SAL_CO, 		SAL_UTADR1, SAL_UTADR2, SAL_POSTNR, SAL_POSTORT,'TAXERINGAGARE' src  	FROM [GISDATA].SDE_GEOFIR_GOTLAND.GNG.FA_TAXERINGAGARE_V2 Q INNER JOIN (SELECT FNR FROM rest EXCEPT SELECT FNR FROM [3toOneUnion])x ON X.FNR = Q.FNR WHERE coalesce(nullif(SAL_CO,''), nullif(SAL_UTADR1,''), nullif(SAL_UTADR2,''), nullif(SAL_POSTNR,''), nullif(SAL_POSTORT,'')) IS NOT NULL)
    , T3 AS (SELECT q.FNR, PERSORGNR, ANDEL, NAMN, UA_UTADR1, 		UA_UTADR2,  UA_UTADR3,  UA_UTADR4,  UA_LAND,    'TAXERINGAGARE' src  	FROM [GISDATA].SDE_GEOFIR_GOTLAND.GNG.FA_TAXERINGAGARE_V2 Q INNER JOIN (SELECT FNR FROM rest EXCEPT SELECT FNR FROM [3toOneUnion])x ON X.FNR = Q.FNR WHERE coalesce(nullif(UA_UTADR1,''), nullif(UA_UTADR2,''), nullif(UA_UTADR3,''), nullif(UA_UTADR4,''), nullif(UA_LAND,'')) IS NOT NULL)

    , [3toOneUnion2] as (select * from t1 union all SELECT * from t2 union all SELECT * from t3 UNION ALL SELECT FNR, PERSORGNR, ANDEL, NAMN,  FAL_CO, FAL_UTADR1, FAL_UTADR2, FAL_POSTNR, FAL_POSTORT, SRC from [3toOneUnion])

, FARDIG
    AS (SELECT FNR, PERSORGNR
	     , format(try_cast(CASE WHEN charindex('/', ANDEL, 1) > 0 THEN try_cast(left(ANDEL, charindex('/', ANDEL, 1) - 1) AS FLOAT) / try_cast(right(ANDEL, len(ANDEL) - charindex('/', ANDEL, 1)) AS FLOAT)END AS FLOAT), '0.00') ANDELMIN
	     , NAMN
	     , ltrim(replace(replace(ltrim(CONCAT(CASE WHEN FAL_POSTNR IS NULL THEN FAL_CO
			     ELSE nullif('c/o ' + FAL_CO + ', ', 'c/o , ')END, FAL_UTADR1, ' ', FAL_UTADR2, ', ', FAL_POSTNR, ' ', FAL_POSTORT)), '  ', ' '), ' , ', ', ')) ADRESS
	 , FAL_POSTORT   POSTORT, FAL_POSTNR POSTNR, SRC SOURCE FROM  [3toOneUnion2])
SELECT * into  tempdb.dbo.##fordig from FARDIG
        end ;
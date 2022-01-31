use [tempExcel]
insert into dbo.resultatRunConf (dnr) values (concat(cast(sysdatetime() as varchar),'correctAdress6'))

	begin try
	    drop table tempExcel.dbo.fromKFetchLagFartAndTaxeringar
	    end try
	begin catch
	    print ERROR_line()
	end catch

begin try

    create table tempExcel.dbo.fromKFetchLagFartAndTaxeringar
    (
	    FNR int  not null,
	    org varchar(130)  not null,
	    ANDEL varchar(100),
	    NAMN nvarchar(300),
	    co nvarchar(350),
	    adress nvarchar(350),
	    ad2 nvarchar(350),
	    postnr nvarchar(350),
	    postort nvarchar(350),
	    src varchar(13) not null
	    unique clustered (org,namn,co,adress,ad2,postnr,postort)
	    with (ignore_dup_key = ON)
    )
    end try
    begin catch
	print ERROR_line()
    end catch
;
WITH
    rest as (select fnr from addressesToBeCorrected)
    , s1 as (select z.FNR,	PERSORGNR , andel,NAMN, FAL_CO , FAL_UTADR1 , FAL_UTADR2, FAL_POSTNR , FAL_POSTORT , 	'lagfart' SRC FROM  [GISDATA].SDE_GEOFIR_GOTLAND.GNG.FA_LAGFART_V2 Z
        INNER JOIN REST IP ON IP.FNR = Z.FNR
    WHERE coalesce(nullif(FAL_CO,''), nullif(FAL_UTADR1,''), nullif(FAL_UTADR2,''), nullif(FAL_POSTNR,''), nullif(FAL_POSTORT,'')) IS NOT NULL)
    , s2 as (SELECT z.FNR,	PERSORGNR, andel,NAMN, SAL_CO, 	SAL_UTADR1, SAL_UTADR2, SAL_POSTNR, SAL_POSTORT , 	'lagfart' SRC  FROM [GISDATA].SDE_GEOFIR_GOTLAND.GNG.FA_LAGFART_V2 Z
        INNER JOIN REST IP ON IP.FNR = Z.FNR
    WHERE coalesce(nullif(SAL_CO,''), nullif(SAL_UTADR1,''), nullif(SAL_UTADR2,''), nullif(SAL_POSTNR,''), nullif(SAL_POSTORT,'')) IS NOT NULL)
    , s3 as (SELECT z.FNR,	PERSORGNR, andel,NAMN, UA_UTADR1, UA_UTADR2,  UA_UTADR3, 	UA_UTADR4,  UA_LAND , 	'lagfart' SRC  FROM [GISDATA].SDE_GEOFIR_GOTLAND.GNG.FA_LAGFART_V2 Z
        INNER JOIN REST IP ON IP.FNR = Z.FNR
    WHERE coalesce(nullif(UA_UTADR1,''), nullif(UA_UTADR2,''), nullif(UA_UTADR3,''), nullif(UA_UTADR4,''), nullif(UA_LAND,'')) IS NOT NULL)

, s3toOneUnion2 as (select FNR,	PERSORGNR org, andel,NAMN, FAL_CO co, FAL_UTADR1 adress, FAL_UTADR2 ad2, FAL_POSTNR POSTNR, FAL_POSTORT POSTORT, src from s1 union all SELECT * from s2 union all SELECT * from s3 )

    , T1 AS (SELECT q.FNR, PERSORGNR, ANDEL, NAMN, FAL_CO, FAL_UTADR1, FAL_UTADR2, FAL_POSTNR, FAL_POSTORT ,'TAXERINGAGARE' src  	FROM [GISDATA].SDE_GEOFIR_GOTLAND.GNG.FA_TAXERINGAGARE_V2 Q
        INNER JOIN rest x ON X.FNR = Q.FNR
        where
        coalesce(nullif(FAL_CO,''), nullif(FAL_UTADR1,''), nullif(FAL_UTADR2,''), nullif(FAL_POSTNR,''), nullif(FAL_POSTORT,''))is not null
        )
    , T2 AS (SELECT q.FNR, PERSORGNR, ANDEL, NAMN, SAL_CO, 	SAL_UTADR1, SAL_UTADR2, SAL_POSTNR, SAL_POSTORT,'TAXERINGAGARE' src  	FROM [GISDATA].SDE_GEOFIR_GOTLAND.GNG.FA_TAXERINGAGARE_V2 Q
        INNER JOIN rest x ON X.FNR = Q.FNR
         where
        coalesce(nullif(SAL_CO,''), nullif(SAL_UTADR1,''), nullif(SAL_UTADR2,''), nullif(SAL_POSTNR,''), nullif(SAL_POSTORT,'')) is not null
        )
    , T3 AS (SELECT q.FNR, PERSORGNR, ANDEL, NAMN, UA_UTADR1,	UA_UTADR2,  UA_UTADR3,  UA_UTADR4,  UA_LAND,    'TAXERINGAGARE' src  	FROM [GISDATA].SDE_GEOFIR_GOTLAND.GNG.FA_TAXERINGAGARE_V2 Q
        INNER JOIN rest x ON X.FNR = Q.FNR
         where
        coalesce(nullif(UA_UTADR1,''), nullif(UA_UTADR2,''), nullif(UA_UTADR3,''), nullif(UA_UTADR4,''), nullif(UA_LAND,'')) is not null

        )

    , [3toOneUnion2] as (select FNR, PERSORGNR org, ANDEL, NAMN, FAL_CO co, FAL_UTADR1 adress, FAL_UTADR2 ad2, FAL_POSTNR postnr, FAL_POSTORT postort, src   from t1 union all SELECT * from t2 union all SELECT * from t3 union all select * from s3toOneUnion2)

insert into  fromKFetchLagFartAndTaxeringar
  select * from [3toOneUnion2]


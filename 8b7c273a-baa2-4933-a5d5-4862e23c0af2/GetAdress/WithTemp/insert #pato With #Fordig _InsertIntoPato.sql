with
    FoRDIG                 as (SELECT FNR
				    , PERSORGNR org
				    , ANDELMIN  andel
				    , NAMN, ADRESS, POSTORT, POSTNR, SOURCE
				    , 0         INSKDATUM
			       from  tempdb.dbo.##FORDIG)

  , FULAADRESSER           as (select * from fordig WHERE ADRESS is null)

  , GROUPBYFNRORG          AS (SELECT FNR, org, min(andel) ANDEL FROM FoRDIG GROUP BY FNR, org)

   , orgAdressPOSTORTPOSTNR as (select org, adress, POSTORT, POSTNR from FoRDIG)

   , orgNamn                as (select org, namn from FoRDIG)

   ,FOAWITHOUTSOURCE2GC as (select *, IIF(ORG IS NULL, count(*) OVER ( PARTITION BY FNR), 0) C FROM GROUPBYFNRORG)

   ,FOAWITHOUTSOURCE2 as (SELECT *from FOAWITHOUTSOURCE2GC WHERE C < 2)

   , FOAWITHOUTSOURCE       AS (SELECT FNR, ORG, ANDEL, count(*) OVER ( PARTITION BY FNR) CV FROM FOAWITHOUTSOURCE2)

   ,Qfaqa as (SELECT FOAWITHOUTSOURCE.*, FORDIG.SOURCE FROM FOAWITHOUTSOURCE
					       LEFT OUTER JOIN FORDIG
					       ON FORDIG.ORG = FOAWITHOUTSOURCE.ORG AND
						  FORDIG.FNR = FOAWITHOUTSOURCE.FNR AND
						  FORDIG.ANDEL = FOAWITHOUTSOURCE.ANDEL
					   WHERE SOURCE IS NULL)

   ,FAQA as (SELECT 			    FOAWITHOUTSOURCE.FNR, FOAWITHOUTSOURCE.ORG, CV
					  , try_cast(FOAWITHOUTSOURCE.ANDEL AS FLOAT) ANDEL
					  , FORDIG.INSKDATUM, FORDIG.SOURCE
				     FROM FOAWITHOUTSOURCE
					 LEFT OUTER JOIN
				     FORDIG
					 ON FORDIG.ORG = FOAWITHOUTSOURCE.ORG
					AND FORDIG.FNR = FOAWITHOUTSOURCE.FNR
					AND FORDIG.ANDEL = FOAWITHOUTSOURCE.ANDEL
				     WHERE SOURCE IS NOT NULL
				     UNION
				     SELECT Q.FNR, Q.ORG, Q.CV
					  , try_cast(FORDIG.ANDEL AS FLOAT) ANDEL
					  , FORDIG.INSKDATUM, FORDIG.SOURCE
				     FROM  Qfaqa
					 LEFT OUTER JOIN
				     FORDIG
				         ON FORDIG.ORG = Q.ORG
				        AND FORDIG.FNR = Q.FNR
       )
   ,FOA                    AS (SELECT FNR, ORG
				    , CV AS                               ANTALAGARETOTALT
				    , ANDEL
				    , isNull(SOURCE, 'gis')               SOURCE
				    , try_cast(left(INSKDATUM, 4) AS INT) INSKDATUM
			       FROM  FAQA)

   ,oaFG as (SELECT				 ORG, ADRESS, POSTORT, POSTNR
					   FROM ORGADRESSPOSTORTPOSTNR
					   UNION
					   SELECT org            ORGX
						, isnull(replace(replace(ADRESS, ' ' + POSTORT, ''), ', ' + POSTNR, ''),
							 ADRESS) ADRESS
						, POSTORT
						, POSTNR         POSTNUMMER
					   FROM FORDIG)

  ,OAINNERX as (SELECT 			FG.ORG, FG.ADRESS, max(FG.POSTORT) POSTORT, max(FG.POSTNR) POSTNR
				     FROM oaFG
				     GROUP BY ORG, ADRESS)
   , OA                     AS (SELECT INNERX.*,
          			count(*) OVER ( PARTITION BY INNERX.ORG) C
			       FROM  OAINNERX
				  , FULAADRESSER EXCLUDINGY
			       WHERE EXCLUDINGY.ADRESS IS NULL)
    --SELECT * FROM FOA --prata med erik om---select * from FOAWITHSOURCE ORDER BY ANTALAGARETOTALT desc,fnr,INSKDATUM desc

   , GF2 AS (SELECT * FROM GISON UNION SELECT * FROM orgNamn)

  , xOn                    as (SELECT *, count(*) OVER ( PARTITION BY ORG) C
			       FROM  GF2
			       WHERE NAMN is not null)
--prata med erik om-
  , OAN                    as (SELECT 	OA.ORG, ADRESS, POSTORT, POSTNR, NAMN,
         				count(*) OVER ( PARTITION BY oa.org ) count
			       from oa
				   inner join
			        xon on oa.org = xon.org)

  ,FO 			   AS (SELECT OAN.ORG, ADRESS, POSTORT, POSTNR, NAMN, FNR
					  , min(ANDEL)                                                 andel
					  , IIF(OAN.ORG IS NULL, count(*) OVER ( PARTITION BY FNR), 0) count
				     from Foa
					 LEFT OUTER JOIN
				    Oan on oan.org = foa.org
				     GROUP BY OAN.ORG, ADRESS, POSTORT, POSTNR, NAMN, FNR)

   , FOANA                  as (select *
			       from FO
			       where count < 2 and FNR is not null)
select *
into  tempdb.dbo.##pato
from FOANA

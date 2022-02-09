with
    FoRDIG                 as (SELECT FNR
				    , PERSORGNR org
				    , ANDELMIN  andel
				    , NAMN
				    , ADRESS
				    , POSTORT
				    , POSTNR
				    , SOURCE
				    , 0         INSKDATUM
			       from  tempdb.dbo.##FORDIG)
  , FULAADRESSER           as (select * from fordig WHERE ADRESS is null)
  , GROUPBYFNRORG          AS (SELECT FNR, org, min(andel) ANDEL FROM FoRDIG GROUP BY FNR, org)
  , orgAdressPOSTORTPOSTNR as (select org, adress, POSTORT, POSTNR from FoRDIG)
  , orgNamn                as (select org, namn from FoRDIG)
  , FOAWITHOUTSOURCE       AS (SELECT FNR, ORG, ANDEL, count(*) OVER ( PARTITION BY FNR) CV
			       FROM (SELECT *
				     FROM (SELECT *
					   from (select *, IIF(ORG IS NULL, count(*) OVER ( PARTITION BY FNR), 0) C
						 FROM GROUPBYFNRORG) as GC
					   WHERE C < 2) AS [*2*]) as [*2**])
  , FOA                    AS (SELECT FNR
				    , ORG
				    , CV AS                               ANTALAGARETOTALT
				    , ANDEL
				    , isNull(SOURCE, 'gis')               SOURCE
				    , try_cast(left(INSKDATUM, 4) AS INT) INSKDATUM
			       FROM (SELECT FOAWITHOUTSOURCE.FNR
					  , FOAWITHOUTSOURCE.ORG
					  , CV
					  , try_cast(FOAWITHOUTSOURCE.ANDEL AS FLOAT) ANDEL
					  , FORDIG.INSKDATUM
					  , FORDIG.SOURCE
				     FROM FOAWITHOUTSOURCE
					 LEFT OUTER JOIN
				     FORDIG
					 ON FORDIG.ORG = FOAWITHOUTSOURCE.ORG AND FORDIG.FNR = FOAWITHOUTSOURCE.FNR AND
					    FORDIG.ANDEL = FOAWITHOUTSOURCE.ANDEL
				     WHERE SOURCE IS NOT NULL
				     UNION
				     SELECT Q.FNR
					  , Q.ORG
					  , Q.CV
					  , try_cast(FORDIG.ANDEL AS FLOAT) ANDEL
					  , FORDIG.INSKDATUM
					  , FORDIG.SOURCE
				     FROM (SELECT FOAWITHOUTSOURCE.*, FORDIG.SOURCE
					   FROM FOAWITHOUTSOURCE
					       LEFT OUTER JOIN FORDIG
					       ON FORDIG.ORG = FOAWITHOUTSOURCE.ORG AND
						  FORDIG.FNR = FOAWITHOUTSOURCE.FNR AND
						  FORDIG.ANDEL = FOAWITHOUTSOURCE.ANDEL
					   WHERE SOURCE IS NULL) Q
					 LEFT OUTER JOIN FORDIG ON FORDIG.ORG = Q.ORG AND FORDIG.FNR = Q.FNR) AS F#AQ#A)
  , OA                     AS (SELECT INNERX.*, count(*) OVER ( PARTITION BY INNERX.ORG) C
			       FROM (SELECT FG.ORG, FG.ADRESS, max(FG.POSTORT) POSTORT, max(FG.POSTNR) POSTNR
				     FROM (SELECT ORG, ADRESS, POSTORT, POSTNR
					   FROM ORGADRESSPOSTORTPOSTNR
					   UNION
					   SELECT org            ORGX
						, isnull(replace(replace(ADRESS, ' ' + POSTORT, ''), ', ' + POSTNR, ''),
							 ADRESS) ADRESS
						, POSTORT
						, POSTNR         POSTNUMMER
					   FROM FORDIG) AS FG
				     GROUP BY ORG, ADRESS) AS INNERX
				  , FULAADRESSER EXCLUDINGY
			       WHERE EXCLUDINGY.ADRESS IS NULL)
    --SELECT * FROM FOA --prata med erik om---select * from FOAWITHSOURCE ORDER BY ANTALAGARETOTALT desc,fnr,INSKDATUM desc

  , xOn                    as (SELECT *, count(*) OVER ( PARTITION BY ORG) C
			       FROM (SELECT * FROM GISON UNION SELECT * FROM orgNamn) as [G*F*2]
			       WHERE NAMN is not null)
--prata med erik om-
  , OAN                    as (SELECT OA.ORG, ADRESS, POSTORT, POSTNR, NAMN, count(*) OVER ( PARTITION BY oa.org ) count
			       from oa
				   inner join xon on oa.org = xon.org)
  , FOANA                  as (select *
			       from (SELECT OAN.ORG
					  , ADRESS
					  , POSTORT
					  , POSTNR
					  , NAMN
					  , FNR
					  , min(ANDEL)                                                 andel
					  , IIF(OAN.ORG IS NULL, count(*) OVER ( PARTITION BY FNR), 0) count
				     from Foa
					 LEFT OUTER JOIN Oan on oan.org = foa.org
				     GROUP BY OAN.ORG, ADRESS, POSTORT, POSTNR, NAMN, FNR) as FO
			       where count < 2 and FNR is not null)
select *
into  tempdb.dbo.##pato
from FOANA

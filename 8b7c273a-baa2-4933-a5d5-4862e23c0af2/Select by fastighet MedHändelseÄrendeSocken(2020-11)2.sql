--hämta ärendenr från vision--drop TABLE #ALIAS--drop table #PATO
IF object_id('tempdb..#DF') IS NOT NULL
    DROP TABLE #DF

BEGIN TRANSACTION --B4
DECLARE @EXTERNALQUERY NVARCHAR(MAX), @EXTERNALPARAM NVARCHAR(255), @BJORKE NVARCHAR(255),@DALHEM VARCHAR(255),@FROJEL NVARCHAR(255),@GANTHEM VARCHAR(255),@HALLA VARCHAR(255),@KLINTE VARCHAR(255),@ROMA VARCHAR(255)
SET @BJORKE = N'björke'SET @DALHEM = 'Dalhem'SET @FROJEL = N'Fröjel'SET @GANTHEM = 'Ganthem'SET @HALLA = 'Halla'
SET @KLINTE = 'Klinte'SET @ROMA = 'Roma';
SET @EXTERNALPARAM =
	N'@bjorke nvarchar(255) , @dalhem varchar(255) , @frojel nvarchar(255) , @ganthem varchar(255) , @Halla varchar(255) , @Klinte varchar(255) ,  @Roma varchar(255)'
SET @EXTERNALQUERY = 'with fastighetsfilter as (Select  @bjorke  "socken" Union Select @dalhem  "a" Union Select @frojel  "a" Union Select  @ganthem "a" Union Select   @Halla "a" Union Select  @Klinte  "a" Union Select  @Roma   "a" )' +
		     'SELECT DIA, KIR, status
	 FROM (SELECT Arendenummer DIA, FASTIGHET KIR, status
	       FROM [sde_miljo_halsoskydd].gng.Flaggskiktet_p_evw fs inner join fastighetsfilter on left(fs.fastighet,len(socken)) = fastighetsfilter.socken ) AS Aws'

CREATE TABLE #DF (DIA NVARCHAR(250), KIR NVARCHAR(100), STATUS NVARCHAR(100))
INSERT
INTO #DF (DIA, KIR, STATUS) EXEC
	    GISDB01.MASTER.DBO.sp_executesql @EXTERNALQUERY, @EXTERNALPARAM, @BJORKE=@BJORKE, @DALHEM=@DALHEM,
	    @FROJEL=@FROJEL, @GANTHEM= @GANTHEM, @HALLA=@HALLA, @KLINTE= @KLINTE, @ROMA=@ROMA
COMMIT TRANSACTION --C4

DECLARE @INPUTFNR DBO.KONTAKTUPGTABLETYPE;
BEGIN
    BEGIN TRANSACTION;
    WITH
	KIR   AS (SELECT NULL DIA, FASTIGHET KIR, FSTATUS STATUS FROM [20201108ChristofferRäknarExcel])
      , DFFNR AS (
	SELECT isNull(DIA, '') DIA, KIR, X.FNR
	FROM (SELECT * FROM #DF UNION SELECT * FROM KIR) Z
	    LEFT OUTER JOIN [gisdata].[sde_geofir_gotland].[gng].FA_FASTIGHET X ON Z.KIR = X.BETECKNING

	WHERE Z.STATUS = 'Egenkontroll'
    )

    INSERT
    INTO @INPUTFNR (ID, DIARIENUMMER, FNR, FASTIGHET, HÄNDELSEDATUM)
    SELECT row_number() OVER (ORDER BY DIA), DIA, FNR, KIR, getdate()
    FROM DFFNR DF
    COMMIT TRANSACTION
END;
IF object_id('tempdb..#ALIAS') IS NULL BEGIN
    BEGIN TRANSACTION ;SELECT* INTO #ALIAS FROM FNRTOADRESS(@INPUTFNR) COMMIT TRANSACTION
END
SELECT * FROM #ALIAS;
IF object_id('tempdb..#pato') IS NULL BEGIN
    BEGIN TRANSACTION
	;
	WITH
	    FIR              AS (SELECT FNR
				      , isnull(PERSORGNR, row_number() OVER (ORDER BY NAMN)) ORG
				      , ANDEL, NAMN, INSKDATUM
				      , nullif(ADRESS, '')                                   ADRESS
				      , POSTORT, POSTNR, SOURCE
				      , (CASE WHEN NAMN IS NULL THEN 1 ELSE 0 END) +
					(CASE WHEN POSTNR IS NULL THEN 1 ELSE 0 END) +
					(CASE WHEN POSTORT IS NULL THEN 1 ELSE 0 END) +
					(CASE WHEN ADRESS IS NULL THEN 1 ELSE 0 END) +
					(CASE WHEN PERSORGNR IS NULL THEN 1 ELSE 0 END)      BADNESS
				 FROM #ALIAS)
	  , FIRFOA           AS (SELECT FNR, ORG, min(try_cast(replace(ANDEL, '.', ',') AS FLOAT)) AS ANDEL
				 FROM FIR
				 GROUP BY FNR, ORG)
	  , FIROA            AS (SELECT ORG, ADRESS, POSTORT, POSTNR FROM FIR)
	  , FIRON            AS (SELECT ORG, NAMN FROM FIR)
	  , GIS              AS (SELECT FASTIGHETSNYCKEL                                       FNR
				      , NAMN
				      , nullif(nullif(ADRESS, '<Null>'), '')                   ADRESS
				      , nullif(POSTNUMMER, '<Null>')                           POSTNUMMER
				      , nullif(POSTORT, '<Null>')                              POSTORT
				      , isnull(nullif(PERSONORGANISATIONNR, '<Null>'),
					       row_number() OVER (ORDER BY NAMN))              ORGX
				      , FASTIGHETSBETECKNING
				      , 1 / try_cast(
		    count(PERSONORGANISATIONNR) OVER (PARTITION BY FASTIGHETSNYCKEL) AS FLOAT) ANDEL
				 FROM TEMPEXCEL.DBO.[20201112Flaggor ägaruppgifter-nyutskick])
	  , GISFOA           AS (SELECT FNR, ORGX, min(ANDEL) ANDEL FROM GIS GROUP BY FNR, ORGX)
	  , GISOA            AS (SELECT ORGX, ADRESS, POSTNUMMER, POSTORT FROM GIS)
	  , GISON            AS (SELECT [ORGX] AS ORG, NAMN FROM GIS)
	  , FOAWITHOUTSOURCE AS (SELECT FNR, ORG, ANDEL, count(*) OVER ( PARTITION BY FNR) CV
				 FROM (SELECT *
				       FROM (SELECT *, IIF(ORG IS NULL, count(*) OVER ( PARTITION BY FNR), 0) C
					     FROM (SELECT FNR, ORG, min(try_cast(isnull(ANDEL, 1) AS FLOAT)) ANDEL
						   FROM (SELECT FNR, ORG, ANDEL
							 FROM FIRFOA
							 UNION
							 SELECT FNR, ORGX, ANDEL
							 FROM GISFOA) AS [gF*f*]
						   GROUP BY FNR, ORG) AS F) AS [*2]
				       WHERE C < 2) AS [*2*])
	  , FOA              AS (SELECT FNR, ORG
				      , CV AS                               ANTALAGARETOTALT
				      , ANDEL
				      , isNull(SOURCE, 'gis')               SOURCE
				      , try_cast(left(INSKDATUM, 4) AS INT) INSKDATUM
				 FROM (SELECT FOAWITHOUTSOURCE.FNR
					    , ORG, CV
					    , try_cast(FOAWITHOUTSOURCE.ANDEL AS FLOAT) ANDEL
					    , #ALIAS.INSKDATUM
					    , #ALIAS.SOURCE
				       FROM FOAWITHOUTSOURCE
					   LEFT OUTER JOIN #ALIAS ON #ALIAS.PERSORGNR = FOAWITHOUTSOURCE.ORG AND
								     #ALIAS.FNR = FOAWITHOUTSOURCE.FNR AND
								     #ALIAS.ANDEL = FOAWITHOUTSOURCE.ANDEL
				       WHERE SOURCE IS NOT NULL
				       UNION
				       SELECT Q.FNR, Q.ORG, Q.CV
					    , try_cast(#ALIAS.ANDEL AS FLOAT) ANDEL
					    , #ALIAS.INSKDATUM
					    , #ALIAS.SOURCE
				       FROM (SELECT FOAWITHOUTSOURCE.*, #ALIAS.SOURCE
					     FROM FOAWITHOUTSOURCE
						 LEFT OUTER JOIN #ALIAS ON #ALIAS.PERSORGNR = FOAWITHOUTSOURCE.ORG AND
									   #ALIAS.FNR = FOAWITHOUTSOURCE.FNR AND
									   #ALIAS.ANDEL = FOAWITHOUTSOURCE.ANDEL
					     WHERE SOURCE IS NULL) Q
					   LEFT OUTER JOIN #ALIAS ON #ALIAS.PERSORGNR = Q.ORG AND #ALIAS.FNR = Q.FNR) AS F#AQ#A)
	  , OA               AS (SELECT *, count(*) OVER ( PARTITION BY ORG) C
				 FROM (SELECT ORG, ADRESS, max(POSTORT) POSTORT, max(POSTNR) POSTNR
				       FROM (SELECT ORG, ADRESS, POSTORT, POSTNR
					     FROM FIROA
					     UNION
					     SELECT ORGX
						  , isnull(
						     replace(replace(ADRESS, ' ' + POSTORT, ''), ', ' + POSTNUMMER, ''),
						     ADRESS) ADRESS
						  , POSTORT, POSTNUMMER
					     FROM GISOA) AS FG
				       GROUP BY ORG, ADRESS) AS [g*f*]
				 WHERE NOT (ADRESS IN
					    ('ENEBY 161, ENBACKEN, 19592 MÄRSTA', 'ENEBY 161, ENBACKEN, 19592 MÄRSTA',
					     'DALHEM GRANSKOGS 966', 'GRANSKOGS DALHEM 966',
					     'GAMLA NORRBYVÄGEN 15, ÖSTRA TÄCKERÅKER, 13674 NORRBY',
					     'ÖSTRA TÄCKERÅKER GAMLA NORRBYVÄGEN 15',
					     'ALVA GUDINGS 328 VÅN 2, GAMLA SKOLAN, 62346 HEMSE',
					     'DALHEM KAUNGS 538, DUNBODI, 62256 DALHEM',
					     'HERTZBERGSGATE 3 A0360 OSLO NORGE', 'DALHEM HALLVIDE 119, HALFVEDE',
					     'OLAV M. TROVIKS VEI 500864 OSLO NORGE',
					     'LORNSENSTR. 30DE-24105 KIEL TYSKLAND',
					     'FRÜLINGSSTRASSE 3882110 GERMENING TYSKLAND',
					     'c/o FÖRENINGEN GOTLANDSTÅGET HÄSSELBY 166',
					     'c/o TRYGGVE PETTERSSON KAUNGS 524', 'c/o L. ANDERSSON DJURSTRÖMS VÄG 11',
					     'PRÄSTBACKEN 8', 'HALLA BROE 105', 'GAMLA SKOLAN ALVA GUDINGS 328 VÅN 2')))
--prata med erik om---select * from FOAWITHSOURCE ORDER BY ANTALAGARETOTALT desc,fnr,INSKDATUM desc
	  , XON              AS (SELECT *, count(*) OVER ( PARTITION BY ORG) C
				 FROM (SELECT * FROM GISON UNION SELECT * FROM FIRON) AS [G*F*2]
				 WHERE NAMN IS NOT NULL)
--prata med erik om-
	  , OAN              AS (SELECT OA.ORG, ADRESS, POSTORT, POSTNR, NAMN
				      , count(*) OVER ( PARTITION BY OA.ORG ) COUNT
				 FROM OA
				     INNER JOIN XON ON OA.ORG = XON.ORG)
	  , FOANA            AS (SELECT *
				 FROM (SELECT OAN.ORG, ADRESS, POSTORT, POSTNR, NAMN, FNR
					    , min(ANDEL)                                                 ANDEL
					    , IIF(OAN.ORG IS NULL, count(*) OVER ( PARTITION BY FNR), 0) COUNT
				       FROM FOA
					   LEFT OUTER JOIN OAN ON OAN.ORG = FOA.ORG
				       GROUP BY OAN.ORG, ADRESS, POSTORT, POSTNR, NAMN, FNR) AS FO
				 WHERE COUNT < 2 AND FNR IS NOT NULL)

	SELECT *INTO #PATO FROM FOANA
    COMMIT TRANSACTION;
END;
WITH
    FOANAD AS (SELECT DISTINCT concat('MBNV-2020-', FD.DIARIENUMMER) DIARIENUMMER
			     , FD.FASTIGHET                          FNR
			     , FOANA.NAMN, ADRESS, FOANA.POSTORT, POSTNR
	       FROM #PATO FOANA
		   RIGHT OUTER JOIN @INPUTFNR FD ON FD.FNR = FOANA.FNR)

SELECT *
FROM FOANAD

--  , sammboende as(select DIARIENUMMER, FNR, NAMN, ADRESS, POSTORT, POSTNR, count(*) OVER ( PARTITION BY DIARIENUMMER) UtskickperDia from (select DIARIENUMMER,fnr,namn = stuff((select ','+namn from FOANAD q where q.adress = r.adress group by namn for xml path ('')), 1, 1, ''),adress,POSTORT,postnr from FOANAD r)  as R2 GROUP BY DIARIENUMMER, FNR, NAMN, ADRESS, POSTORT, POSTNR)SELECT *FROM SAMMBOENDE ORDER BY ADRESS
--select * from     (SELECT FASTIGHET FROM [20201108ChristofferRäknarExcel]GROUP BY FASTIGHET UNION SELECT FASTIGHETSBETECKNING FROM [20201112Flaggor ägaruppgifter-nyutskick]GROUP BY FASTIGHETSBETECKNING) as [20201108CREF20201112F ä-nF]where not (FASTIGHET IN(SELECT FNR FROM SAMMBOENDE))
-- select kir from (select z.dia,z.kir,x.fnr from (select INTDIARIENUMMERLOEPNUMMER dia, STRFASTIGHETSBETECKNING kir,STRFNRID fnr from [admsql04].[EDPVisionRegionGotland].dbo.vwAehAerende where  STRAERENDEMENING = 'Klart vatten - information om avlopp' and INTDIARIEAAR = 2020) as z LEFT OUTER JOIN [gisdata].[sde_geofir_gotland].[gng].Fa_Fastighet x on z.kir = x.beteckning where not(dia in (select diarienummer from SAMMBOENDE GROUP BY diarienummer))) q left outer join tempExcel.dbo.[20201112Flaggor ägaruppgifter-nyutskick] y on y.FASTIGHETSNYCKEL = q.fnr


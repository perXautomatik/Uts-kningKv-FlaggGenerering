--input table that might be sentr from other method
USE GISDATA.SDE_GEOFIR_GOTLAND;

ALTER TABLE HÄNDELSERFÖRBUD12020
    ADD CONSTRAINT HÄNDELSERFÖRBUD12020_PK
	PRIMARY KEY NONCLUSTERED (DIARIENUMMER)
GO
;

UPDATE SOL19_4KOL
SET ROWNR = (SELECT row_number() OVER (PARTITION BY OBJEKTID ORDER BY FNR))
WHERE 1 = 1;

SELECT * FROM BOK12 WHERE FLIKEN_ÄRENDEN IS NOT NULL;
SELECT * FROM DBO.kirToFnr(.) X;
SELECT * FROM DBO.kirToFnr(SELECT * FROM [påminnelse-12-mån-2020_1]) X;
SELECT *
FROM SOL19_4KOL
    RIGHT OUTER JOIN SOL19_ÄRENDENRATTJOINA S19ÄAJ ON SOL19_4KOL.FNR = S19ÄAJ.FNR
ORDER BY [order];
SELECT SOL19_4KOL.FNR, PUNKTTYPAB, FLIKEN_KOORDINATER, DIARIENUMMER, OBJEKTID
FROM SOL19_4KOL
    LEFT OUTER JOIN SOL19_ÄRENDENRATTJOINA S19ÄAJ ON SOL19_4KOL.FNR = S19ÄAJ.FNR

SELECT FNR
     , BETECKNING
     , ÄRNDENR
     , CAST(CASE WHEN [ANDEL] IS NULL OR [ANDEL] = '' THEN '1/1' ELSE [ANDEL] END AS VARCHAR) AS ANDEL
     , CAST(CASE WHEN [NAMN] IS NULL OR [NAMN] = '' THEN KORTNAMN ELSE [NAMN] END AS VARCHAR) AS NAMN
     , CAST(CASE WHEN ([FAL_UTADR2] IS NULL OR [FAL_UTADR2] = '') AND ([FAL_POSTNR] IS NULL OR [FAL_POSTNR] = '')
		     THEN CASE WHEN (SAL_UTADR1 IS NULL OR SAL_UTADR1 = '') AND (SAL_POSTNR IS NULL OR SAL_POSTNR = '')
				   THEN UA_UTADR1
				   ELSE SAL_UTADR1
			  END
		     ELSE FAL_UTADR2
	    END AS VARCHAR)                                                                   AS ADRESS
     , CAST(CASE WHEN ([FAL_UTADR2] IS NULL OR [FAL_UTADR2] = '') AND ([FAL_POSTNR] IS NULL OR [FAL_POSTNR] = '')
		     THEN CASE WHEN (SAL_UTADR1 IS NULL OR SAL_UTADR1 = '') AND (SAL_POSTNR IS NULL OR SAL_POSTNR = '')
				   THEN UA_UTADR2
				   ELSE SAL_POSTNR
			  END
		     ELSE [FAL_POSTNR]
	    END AS VARCHAR)                                                                   AS POSTNUMMER
     , CAST(CASE WHEN ([FAL_POSTORT] IS NULL OR [FAL_POSTORT] = '') AND ([FAL_POSTNR] IS NULL OR [FAL_POSTNR] = '')
		     THEN CASE WHEN (SAL_UTADR1 IS NULL OR SAL_UTADR1 = '') AND (SAL_POSTNR IS NULL OR SAL_POSTNR = '')
				   THEN UA_LAND
				   ELSE SAL_POSTORT
			  END
		     ELSE [FAL_POSTORT]
	    END AS VARCHAR)                                                                   AS POSTORT
     , [PERSORGNR]

FROM (SELECT INPUT.FNR
	   , INPUT.BETECKNING
	   , INPUT.DIARIENR AS ÄRNDENR
	   , [UA_UTADR2]
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
	   , [SAL_UTADR1]
	   , [PERSORGNR]
	   --,[UA_UTADR4],--[UA_UTADR3],--[TNMARK],--[SAL_UTADR2],--[SAL_CO],--[NAMN_OMV],--[MNAMN],--[KORTNAMN_OMV],--[FNAMN],--[FAL_UTADR1],--[FAL_CO],--[ENAMN]
      FROM (
	  SELECT FNR
	       , [UA_UTADR2]
	       , [UA_UTADR1]
	       , [UA_LAND]
	       , [SAL_POSTORT]
	       , [SAL_POSTNR]
	       , [NAMN]
	       , [KORTNAMN]
	       , [FAL_UTADR2]
	       , [FAL_POSTORT]
	       , [FAL_POSTNR]
	       , min(ANDEL) 'andel'
	       , [SAL_UTADR1]
	       , [PERSORGNR] --ifall att ägarbyte skett och gammla ägande inte updaterats, välj den minsta ägande
	  FROM [GISDATA].SDE_GEOFIR_GOTLAND.GNG.FA_TAXERINGAGARE_V2
	  GROUP BY FNR, [UA_UTADR2], [UA_UTADR1], [UA_LAND], [SAL_POSTORT], [SAL_POSTNR], [NAMN], [KORTNAMN]
		 , [FAL_UTADR2], [FAL_POSTORT], [FAL_POSTNR], [SAL_UTADR1], [PERSORGNR]
      ) AS TAX
	  RIGHT OUTER JOIN
      (
	  SELECT *
	  FROM INPUT
	  WHERE INPUT.BETECKNING IS NOT NULL) AS ORGINALANDGEOFIR) AS TOAG

SELECT Z.FASTIGHETSBETECKNING KIR, X.FNR, Z.DIARIENUMMER AS DIARIENR
FROM [tempExcel].DBO.[påminnelse-12-mån-2020_1] Z
    LEFT OUTER JOIN GISDATA.[sde_geofir_gotland].[gng].FA_FASTIGHET X ON Z.FASTIGHETSBETECKNING = X.BETECKNING

SELECT TEMPEXCEL.DBO.up_xSplitStringByDelim(X.FLIKEN_ÄRENDEN, 2, '-')                                             YEAR
     , right(right(X.FLIKEN_ÄRENDEN, (len(X.FLIKEN_ÄRENDEN) - charindex('-', X.FLIKEN_ÄRENDEN))),
	     len(right(X.FLIKEN_ÄRENDEN, (len(X.FLIKEN_ÄRENDEN) - charindex('-', X.FLIKEN_ÄRENDEN)))) -
	     charindex('-', right(X.FLIKEN_ÄRENDEN, (len(X.FLIKEN_ÄRENDEN) - charindex('-', X.FLIKEN_ÄRENDEN))))) NR
FROM (SELECT FLIKEN_ÄRENDEN FROM TEMPEXCEL.DBO.SOL19_4KOL GROUP BY FLIKEN_ÄRENDEN) X
    LEFT OUTER JOIN TEMPEXCEL.DBO.SOL19_ÄRENDENRATTJOINA ON FLIKEN_ÄRENDEN = SOL19_ÄRENDENRATTJOINA.DIARIENUMMER
WHERE DIARIENUMMER IS NULL AND FLIKEN_ÄRENDEN <> '0' AND FLIKEN_ÄRENDEN <> 'anteckning'

SELECT MAX(NRX) I, MAX(ANDEL) ANDEL, POSTORT, POSTNUMMER, ADRESS, NAMN, BETECKNING, ARENDENR
FROM (SELECT row_number() OVER (ORDER BY newid()) NRX
	   , cast(BETECKNING AS VARCHAR(100))     BETECKNING
	   , cast(ÄRNDENR AS VARCHAR(100))        ARENDENR
	   , cast(ANDEL AS VARCHAR(100))          ANDEL
	   , cast(NAMN AS VARCHAR(100))           NAMN
	   , cast(ADRESS AS VARCHAR(100))         ADRESS
	   , cast(POSTNUMMER AS VARCHAR(100))     POSTNUMMER
	   , cast(POSTORT AS VARCHAR(100))        POSTORT
      FROM TEMPEXCEL.DBO.GENERATOR_INPUTPLUSGEOFIR) Z
GROUP BY POSTORT, POSTNUMMER, ADRESS, NAMN, BETECKNING, ARENDENR

DECLARE @HANDELSER AS HANDELSETABLETYPE;
INSERT
INTO @HANDELSER (DIARIENUMMER, HUVUDFASTIGHET, ÄRENDEMENING, TEXT, RUBRIK, RIKTNING, DATUM, ARENDEKOMMENTAR)
SELECT DIARIENUMMER
     , [Ärendets huvudfastighet]
     , ÄRENDEMENING
     , TEXT
     , RUBRIK
     , RIKTNING
     , cast(HÄNDELSEDATUM AS DATETIME)
     , KOMMENTAR
FROM HÄNDELSERFÖRBUD12020;

DECLARE @TABLE2 AS DBO.HANDELSETABLETYPE
INSERT
INTO @TABLE2 (DIARIENUMMER, HUVUDFASTIGHET, ÄRENDEMENING, TEXT, RUBRIK, RIKTNING, DATUM, ARENDEKOMMENTAR)
SELECT Z.DIARIENUMMER
     , Z.HUVUDFASTIGHET
     , Z.ÄRENDEMENING
     , Z.TEXT
     , Z.RUBRIK
     , Z.RIKTNING
     , Z.DATUM
     , Z.ARENDEKOMMENTAR
FROM [tempExcel].[dbo].sp_xCheckThatItsNotBadHadelseNa(@HANDELSER) Z
    INNER JOIN
usp_xFilterByHasArende(@HANDELSER) Q ON Q.ID = Z.ID
    INNER JOIN DBO.sp_xFilterSenasteMedKon(@HANDELSER) Y ON Z.ID = Y.ID

DECLARE @TABLE3 AS DBO.HANDELSETABLETYPEFNR
INSERT
INTO @TABLE3 (DIARIENUMMER, HUVUDFASTIGHET, ÄRENDEMENING, TEXT, RUBRIK, RIKTNING, DATUM, ARENDEKOMMENTAR)
SELECT DIARIENUMMER, HUVUDFASTIGHET, ÄRENDEMENING, TEXT, RUBRIK, RIKTNING, DATUM, ARENDEKOMMENTAR
FROM DBO.sp_xKirToFnr(@TABLE2)

--DECLARE @Table4 AS dbo.HandelseTableTypeAdress INSERT INTO @Table4 (Diarienummer,huvudfastighet,Ärendemening,Text,Rubrik,Riktning,Datum,ArendeKommentar,fnr) select Diarienummer,huvudfastighet,Ärendemening,Text,Rubrik,Riktning,Datum,ArendeKommentar,fnr

--select * from dbo.FnrToAdress(@Table4)

DECLARE @TP2 AS KONTAKTUPGTABLETYPE;
INSERT
INTO @TP2 (DIARIENUMMER, FNR, HÄNDELSEDATUM, NAMN, POSTNUMMER, GATUADRESS, POSTORT)
SELECT DIARIENUMMER
     , max(LÖPNUMMER)
     , max(HÄNDELSEDATUM)
     , ÄRENDEKONTAKTER.HUVUDKONTAKT
     , POSTNUMMER
     , GATUADRESS
     , ÄRENDEKONTAKTER.POSTORT
FROM ÄRENDEKONTAKTER
GROUP BY DIARIENUMMER, POSTNUMMER, GATUADRESS, ÄRENDEKONTAKTER.HUVUDKONTAKT, ÄRENDEKONTAKTER.POSTORT

SELECT *
FROM (SELECT *, row_number() OVER (PARTITION BY DIARIENUMMER ORDER BY PRIOX DESC) DQWEQ
      FROM (
	  SELECT DIARIENUMMER
	       , max(FNR)                                                                              FNR
	       , max(HÄNDELSEDATUM)                                                                    DATUM
	       , NAMN
	       , POSTNUMMER
	       , POSTORT
	       , GATUADRESS
	       , PERSONNR
	       , HARNAMN
	       , row_number() OVER (PARTITION BY DIARIENUMMER ORDER BY max(HÄNDELSEDATUM)) * max(PRIO) PRIOX
	  FROM (
	      SELECT *
	      FROM (SELECT Z.*
		    FROM (SELECT DIARIENUMMER FROM @TP1 UNION SELECT DIARIENUMMER FROM @TP2) UNX
			LEFT OUTER JOIN @TP1 Z ON UNX.DIARIENUMMER = Z.DIARIENUMMER) AS SA
	      WHERE HARNAMN = 1
	      UNION
	      SELECT *
	      FROM (SELECT Z.*
		    FROM (
			SELECT DIARIENUMMER
			FROM (SELECT Z.DIARIENUMMER, HARNAMN
			      FROM (SELECT DIARIENUMMER FROM @TP1 UNION SELECT DIARIENUMMER FROM @TP2) UNX
				  LEFT OUTER JOIN @TP1 Z ON UNX.DIARIENUMMER = Z.DIARIENUMMER) AS SA
			WHERE HARNAMN = 0
		    ) UNX
			LEFT OUTER JOIN @TP2 Z ON UNX.DIARIENUMMER = Z.DIARIENUMMER) AS SA
	      WHERE HARNAMN = 1) WE
	  GROUP BY DIARIENUMMER, NAMN, POSTNUMMER, POSTORT, GATUADRESS, PERSONNR, HARNAMN) AS W) AS AD
WHERE DQWEQ = 1



-- ifall att ägarbyte skett och gammla ägande inte updaterats, välj den minsta ägande

-- insert tabbles from händelser and ärenden, in that order,
-- we are given äendenr. is not null
-- we return a table with eather null or or adress joined
-- better not return null values, rathre a smaller table.
-- the returntype should be of adress table type
-- insert, tb1, tb2
-- if tbl 1 has adress, then ignore tvbl2 else table 2.
-- the tables should both contain same ärendenrs.
-- so in theory we could just
-- diarienummer as (select ärendenr from tbl1 union select ärende from table 2 )
-- then we select from tbl1 where.. could we use isnull? basicly isnull(table1,table2) we can't of
-- course becase isnull takes columns, but we could use a id and join on that.
-- give them a computed column, replacing there ärendenr, then give them order so we can do rownr =1
-- computeed column, gotta be, null or not, table1 or table 2.
-- we also only want the latest non null adress from händelse tabellen.
--(select *, row_number() over (partiotion by diarienummer sort by händelsedatum)*100*(isnull(adr)+isnull(postnr)+isnull(postort)+isnull(name)) prio from table1), harNamn ressult

-- becasue we want the least faulty, and latest.
-- we pick the highest number by
-- select top 1 from ressult order by prio desc where diarienummer.diarienummer = ressult.diarienummer
-- we do a
-- ressultJOin as select * from diarienummer cross join
-- then we make a
-- tbl2 left iouter join on ressultjoin where adress is null, and tbl2 adress is not null on ressultjoin.diarienummer = tbl2.diarienummer

-- then union both ressults.
-- due to the complexity of the method, it cant be inline.

-- the nwe insert it in the  ressult table.
-- declare @ab as adresstableType
-- insert into @ab select * from

-- then we make another fuction reciving this table
-- function (tbl1 as adresstabletype) return as table
-- the table insert table has diarienummer not null but null on every personnr.
-- might have some adresses, does that doesn't have adresses, fetch from my fir method
-- fetch personnr for does that have adress but not personnr by reverse lookup.

-- select col1,col2,col3 from x join y using c? <- if youre writing the columns you want?
-- inupt left outer join where input adress is null using fnr
-- we have to make sure our fnrToFir return the correct tabletype, does it work

--select fastighet,sum(andel),min(dataÅR) from (select distinct z.fastighet,namn "Utskick har gått till:",adress till ,name "Lagfaren ägare",cast(x.NUMERATOR as float)  / cast(x.DENOMINATOR as float) andel,cast(x.REGDT as date) dataÅR,coalesce(x.ADDRESS1,x.ADDRESS2) adress from dbo.[AAA to print] z left outer join dbo.BestFir x on z.fastighet = x.kir) asdafw group by fastighet

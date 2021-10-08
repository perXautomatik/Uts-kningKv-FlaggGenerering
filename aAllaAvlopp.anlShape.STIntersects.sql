declare @sokDat smalldatetime = '2006-10-08';
declare @sockenStrang varchar = N'Källunge,Vallstena,Hörsne,Bara,Norrlanda,Stenkyrka';
WITH
    FastighetsYtorOfInterest AS (SELECT SOCKEN SOCKENX, concat(TRAKT, ' ', BLOCKENHET) FASTIGHET, SHAPE
		       FROM SDE_GSD.GNG.AY_0980 X
			   INNER JOIN (SELECT VALUE "socken"
   FROM STRING_SPLIT(N'Källunge,Vallstena,Hörsne,Bara,Norrlanda,Stenkyrka', ',')) AS SOCKNAROFINTRESSE
			   ON X.TRAKT LIKE SOCKNAROFINTRESSE.SOCKEN + '%')



  , ASO            AS (SELECT left(FASTIGHET_TILLSTAND,
		    CASE WHEN charindex(' ', FASTIGHET_TILLSTAND) = 0 THEN len(FASTIGHET_TILLSTAND) + 1
		    ELSE charindex(' ', FASTIGHET_TILLSTAND) END - 1)       SOCKEN
			    , DIARIENUMMER , BESLUT_DATUM, UTFORD_DATUM, ANTECKNING
			    , FASTIGHET_TILLSTAND Z
			    , SHAPE               ANLSHAPE
		       FROM SDE_MILJO_HALSOSKYDD.GNG.ENSKILT_AVLOPP_SODRA_P)
  , ANO              AS (SELECT left(FASTIGHET_TILLSTAND,
		    CASE WHEN charindex(' ', FASTIGHET_TILLSTAND) = 0 THEN len(FASTIGHET_TILLSTAND) + 1
		    ELSE charindex(' ', FASTIGHET_TILLSTAND) END - 1)       SOCKEN
			    , DIARIENUMMER , BESLUT_DATUM, UTFORD_DATUM, ANTECKNING
			    , FASTIGHET_TILLSTAND Z
			    , SHAPE               ANLSHAPE
		       FROM SDE_MILJO_HALSOSKYDD.GNG.ENSKILT_AVLOPP_NORRA_P)
  , AMO             AS (SELECT left(Fastighet_tilstand,
		    CASE WHEN charindex(' ', Fastighet_tilstand) = 0 THEN len(Fastighet_tilstand) + 1
		    ELSE charindex(' ', Fastighet_tilstand) END - 1)       SOCKEN
			    , DIARIENUMMER , BESLUT_DATUM, UTFORD_DATUM, ANTECKNING
			    , Fastighet_tilstand Z
			    , SHAPE               ANLSHAPE
		       FROM SDE_MILJO_HALSOSKYDD.GNG.ENSKILT_AVLOPP_MELLERSTA_P)


  , SODRA_P        AS (SELECT DIARIENUMMER, Z Q, BESLUT_DATUM, UTFORD_DATUM, ANTECKNING, ALLAAVLOPP.ANLSHAPE, FASTIGHET,SOCKENX socken
		       FROM ASO ALLAAVLOPP
			   INNER JOIN
(SELECT FastighetsYtorOfInterest.* FROM FastighetsYtorOfInterest INNER JOIN (SELECT SOCKEN FROM ASO GROUP BY SOCKEN) Q ON SOCKEN = SOCKENX) FFAST
			   ON ALLAAVLOPP.SOCKEN = FFAST.SOCKENX AND ALLAAVLOPP.ANLSHAPE.STIntersects(FFAST.SHAPE) = 1)
  , NORRA_P        AS (SELECT DIARIENUMMER, Z Q, BESLUT_DATUM, UTFORD_DATUM, ANTECKNING, ALLAAVLOPP.ANLSHAPE, FASTIGHET,SOCKENX socken
		       FROM ANO ALLAAVLOPP
			   INNER JOIN
(SELECT FastighetsYtorOfInterest.* FROM FastighetsYtorOfInterest INNER JOIN (SELECT SOCKEN FROM ANO GROUP BY SOCKEN) Q ON SOCKEN = SOCKENX) FFAST
			   ON ALLAAVLOPP.SOCKEN = FFAST.SOCKENX AND ALLAAVLOPP.ANLSHAPE.STIntersects(FFAST.SHAPE) = 1)
  , MELLERSTA_P    AS (SELECT DIARIENUMMER, Z Q, BESLUT_DATUM, UTFORD_DATUM, ANTECKNING, ALLAAVLOPP.ANLSHAPE, FASTIGHET,SOCKENX socken
		       FROM AMO ALLAAVLOPP
		       INNER JOIN
(SELECT FastighetsYtorOfInterest.*  FROM FastighetsYtorOfInterest INNER JOIN (SELECT SOCKEN FROM AMO GROUP BY SOCKEN) Q ON SOCKEN = SOCKENX) FFAST
		       ON ALLAAVLOPP.SOCKEN = FFAST.SOCKENX AND ALLAAVLOPP.ANLSHAPE.STIntersects(FFAST.SHAPE) = 1)

,avloppPaSocknarna as (SELECT socken, FASTIGHET , DIARIENUMMER , Q            "Fastighet_til" , BESLUT_DATUM , UTFORD_DATUM "utförddatum" , ANTECKNING , ANLSHAPE     ANLAGGNINGSPUNKT FROM (SELECT * FROM SODRA_P UNION ALL SELECT * FROM NORRA_P UNION ALL SELECT * FROM MELLERSTA_P) Z)

,filtreradeAnlaggningar as (select * from avloppPaSocknarna where (Beslut_datum < cast(@sokDat as datetime2)  AND utförddatum is null ) OR ( utförddatum < cast(@sokDat as datetime2) ) OR (utförddatum is null AND Beslut_datum is null))

,periodsStatestik as (select socken,count(*) c,left(Beslut_datum,2) bd
     ,left(utförddatum,2) ud
from avloppPaSocknarna group by socken, left(Beslut_datum,2)
       , left(utförddatum,2)
    --   order by socken, bd
    )



select socken, count(*) c from filtreradeAnlaggningar group by socken


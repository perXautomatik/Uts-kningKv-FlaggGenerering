:r TillMinaMedelanden/CreateTempWithIdentity.sql

INSERT INTO dbo.#TempWithIdentity( i, ANDEL, POSTORT, POSTNUMMER, adress, NAMN, BETECKNING, arndenr )
	   SELECT MAX(nrx) i, MAX(ANDEL) ANDEL, POSTORT, POSTNUMMER, adress, NAMN, BETECKNING,arendenr
FROM (select
	row_number() over (order by newid()) nrx,
	cast(BETECKNING as varchar(100)) BETECKNING,
	cast(�rndenr as varchar(100)) arendenr,
	cast(andel as varchar(100)) andel,
	cast(Namn as varchar(100)) Namn,
	cast(Adress as varchar(100)) Adress,
	cast(POSTNUMMER as varchar(100)) POSTNUMMER,
	cast(postOrt as varchar(100)) postOrt
	from dbo.Generator_InputPlusGeofir) z group by POSTORT, POSTNUMMER, adress, NAMN, BETECKNING,arendenr
SET IDENTITY_INSERT  tempdb.dbo.##TempWithIdentity OFF;

IF OBJECT_ID(' tempdb..##del1') IS NOT NULL DROP TABLE  tempdb.dbo.##del1 CREATE TABLE dbo.#del1
(
	i int NOT NULL IDENTITY(1, 1) PRIMARY KEY, NAMN varchar(255), andel varchar(255), BETECKNING varchar(255), arndenr varchar(255)
);

SET IDENTITY_INSERT  tempdb.dbo.##del1 ON;

INSERT INTO dbo.#del1( i, NAMN, andel, BETECKNING, arndenr )
	   SELECT i, NAMN, andel, BETECKNING, arndenr
	   FROM  tempdb.dbo.##tempWithIdentity;

SET IDENTITY_INSERT  tempdb.dbo.##del1 OFF;



IF OBJECT_ID(' tempdb..##del2') IS NOT NULL DROP TABLE  tempdb.dbo.##del2 CREATE TABLE dbo.#del2
(
    i int NOT NULL IDENTITY(1, 1) PRIMARY KEY, POSTORT varchar(255), POSTNUMMER varchar(255), ADRESS varchar(255)
);

SET IDENTITY_INSERT  tempdb.dbo.##del2 ON;

INSERT INTO dbo.#del2( POSTORT, POSTNUMMER, adress, i )
	   SELECT POSTORT, POSTNUMMER, adress, i
	   FROM  tempdb.dbo.##tempWithIdentity;

SET IDENTITY_INSERT  tempdb.dbo.##del2 OFF;

IF OBJECT_ID(' tempdb..##splitAdressCTE') IS NOT NULL DROP TABLE  tempdb.dbo.##splitAdressCTE CREATE TABLE dbo.#splitAdressCTE
(
    i int , ADRESS varchar(255), Rn varchar(255), ExtractedValuesFromNames varchar(255)
);


--populate the temporary table

--adress, i FROM  tempdb.dbo.##del2 as x
--
INSERT INTO dbo.#splitAdressCTE( i, Rn, adress, ExtractedValuesFromNames )
	   SELECT Del2s.i, f.Rn, f.adress, f.ExtractedValuesFromNames
	   FROM ( SELECT adress, i FROM  tempdb.dbo.##del2 ) AS Del2s
                CROSS APPLY
                    --lite os�ker p� vad detta g�r, tror att kan vara ett s�tt att anv�nda
                    --row_number() och Value from s� att man kan itterera �ver ressultatet i splitt
	                (SELECT Rn = ROW_NUMBER() OVER (PARTITION BY Del2s.adress ORDER BY Del2s.adress),
                                Del2s.adress,
                                ExtractedValuesFromNames = value FROM STRING_SPLIT(Del2s.adress, ',') AS D
                    ) AS f;

IF OBJECT_ID(' tempdb..##d3AdressSplitt') IS NOT NULL DROP TABLE  tempdb.dbo.##d3AdressSplitt CREATE TABLE dbo.#d3AdressSplitt
  (
      i                        int,
      ADRESS                   varchar(255),
      C_O                      varchar(255),
      Adress2                  varchar(255),
      PostOrt                  varchar(255),
      postnr                   varchar(255)
  );
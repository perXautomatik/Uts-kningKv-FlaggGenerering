DECLARE @Table4 AS dbo.HandelseTableTypeAdress
INSERT INTO @Table4 (Diarienummer,huvudfastighet,�rendemening,Text,Rubrik,Riktning,Datum,ArendeKommentar,fnr)
select Diarienummer,huvudfastighet,�rendemening,Text,Rubrik,Riktning,Datum,ArendeKommentar,fnr

select * from dbo.FnrToAdress(@Table4)

DECLARE @TP2 AS KONTAKTUPGTABLETYPE;
INSERT
INTO @TP2 (DIARIENUMMER, FNR, H�NDELSEDATUM, NAMN, POSTNUMMER, GATUADRESS, POSTORT)
SELECT DIARIENUMMER
     , max(L�PNUMMER)
     , max(H�NDELSEDATUM)
     , �RENDEKONTAKTER.HUVUDKONTAKT
     , POSTNUMMER
     , GATUADRESS
     , �RENDEKONTAKTER.POSTORT
FROM �RENDEKONTAKTER
GROUP BY DIARIENUMMER, POSTNUMMER, GATUADRESS, �RENDEKONTAKTER.HUVUDKONTAKT, �RENDEKONTAKTER.POSTORT

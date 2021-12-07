DECLARE @Table4 AS dbo.HandelseTableTypeAdress
INSERT INTO @Table4 (Diarienummer,huvudfastighet,Ärendemening,Text,Rubrik,Riktning,Datum,ArendeKommentar,fnr)
select Diarienummer,huvudfastighet,Ärendemening,Text,Rubrik,Riktning,Datum,ArendeKommentar,fnr

select * from dbo.FnrToAdress(@Table4)

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

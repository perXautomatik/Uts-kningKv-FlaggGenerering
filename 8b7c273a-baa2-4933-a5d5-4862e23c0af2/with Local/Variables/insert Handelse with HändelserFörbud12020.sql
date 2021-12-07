DECLARE @handelser AS HandelseTableType;
INSERT INTO @handelser (Diarienummer, huvudfastighet, Ärendemening, Text, Rubrik, Riktning, Datum, ArendeKommentar)
   SELECT Diarienummer,
          [Ärendets huvudfastighet],
          Ärendemening,
          Text,
          Rubrik,
          Riktning,
          cast(Händelsedatum as datetime),
          Kommentar
FROM HändelserFörbud12020;

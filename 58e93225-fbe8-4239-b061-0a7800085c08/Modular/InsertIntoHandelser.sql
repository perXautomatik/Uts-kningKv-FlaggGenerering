
DECLARE @handelser AS HandelseTableType;--DATEFROMPARTS(cast(left(Händelsedatum,4) as int),cast(right(left(Händelsedatum,7),2) as int), cast(right(Händelsedatum,2) as int))
INSERT INTO @handelser(Diarienummer, huvudfastighet, Ärendemening, Text, Rubrik, Riktning, Datum, ArendeKommentar)
SELECT Diarienummer, [Ärendets huvudfastighet], Ärendemening, Text, Rubrik, Riktning, Händelsedatum, Kommentar FROM HändelserFörbud12020;

DECLARE @handelser AS HandelseTableType;--DATEFROMPARTS(cast(left(H�ndelsedatum,4) as int),cast(right(left(H�ndelsedatum,7),2) as int), cast(right(H�ndelsedatum,2) as int))
INSERT INTO @handelser(Diarienummer, huvudfastighet, �rendemening, Text, Rubrik, Riktning, Datum, ArendeKommentar)
SELECT Diarienummer, [�rendets huvudfastighet], �rendemening, Text, Rubrik, Riktning, H�ndelsedatum, Kommentar FROM H�ndelserF�rbud12020;
:r TillMinaMedelanden/CreateFilterByHasArende

--Select * from H�ndelserF�rbud12020,H�ndelseKontakter,�rendeKontakter

--select * from H�ndelserF�rbud12020 cross Apply FiltreraBortArendenMedAnsokan(

DECLARE @handelser AS HandelseTableType;
INSERT INTO @handelser (Diarienummer, huvudfastighet, �rendemening, Text, Rubrik, Riktning, Datum, ArendeKommentar)
   SELECT Diarienummer,
          [�rendets huvudfastighet],
          �rendemening,
          Text,
          Rubrik,
          Riktning,
          cast(H�ndelsedatum as datetime),
          Kommentar
FROM H�ndelserF�rbud12020;


select * from dbo.usp_FilterByHasArende(@handelser)
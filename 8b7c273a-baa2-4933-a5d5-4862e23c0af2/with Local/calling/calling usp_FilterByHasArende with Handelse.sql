:r TillMinaMedelanden/CreateFilterByHasArende

--Select * from H�ndelserF�rbud12020,H�ndelseKontakter,�rendeKontakter

--select * from H�ndelserF�rbud12020 cross Apply FiltreraBortArendenMedAnsokan(



select * from dbo.usp_FilterByHasArende(@handelser)
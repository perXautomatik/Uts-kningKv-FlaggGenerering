:r TillMinaMedelanden/CreateFilterByHasArende

--Select * from HändelserFörbud12020,HändelseKontakter,ÄrendeKontakter

--select * from HändelserFörbud12020 cross Apply FiltreraBortArendenMedAnsokan(



select * from dbo.usp_FilterByHasArende(@handelser)
select
           Fastighet,
           Diarienummer,
		   Rubrik,
           H�ndelsedatum,
		   text,
		   [Riktning]
into #Orginal_listFilter
		   FROM tempExcel.[dbo].H�ndelseTexter as x

			where NOT EXISTS (select * from [tempExcel].[dbo].[FastighetEller�rendeToExclude] where fastighet is not null and x.Fastighet = Fastighet)


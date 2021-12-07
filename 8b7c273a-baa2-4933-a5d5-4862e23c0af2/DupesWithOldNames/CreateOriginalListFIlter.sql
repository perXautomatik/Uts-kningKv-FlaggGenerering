select
           Fastighet,
           Diarienummer,
		   Rubrik,
           Händelsedatum,
		   text,
		   [Riktning]
into #Orginal_listFilter
		   FROM tempExcel.[dbo].HändelseTexter as x

			where NOT EXISTS (select * from [tempExcel].[dbo].[FastighetEllerÄrendeToExclude] where fastighet is not null and x.Fastighet = Fastighet)


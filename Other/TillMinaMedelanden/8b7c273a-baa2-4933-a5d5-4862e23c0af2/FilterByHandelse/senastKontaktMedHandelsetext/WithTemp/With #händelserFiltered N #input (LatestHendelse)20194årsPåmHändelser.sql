/****** Script for SelectTopNRows command from SSMS  ******/
:r LatestHendelse/CreateOriginalListFIlter.sql
	--filter out bannaded fastigheter
:r LatestHendelse/CreateHandelseFilter.sql
:r LatestHendelse/input.sql

-- sort list if it has händelse or not, then by fastighet

     --Diarienummer <> 'MBNV-2019-3007'
     -- AND Diarienummer <> 'MBNV-2019-3030'
     -- AND Diarienummer <> 'MBNV-2019-3041'
     --And
     --  Uj <> 'T'

--select * from filtered

with
    input as (SELECT [Anteckning],status,[Fastighet],Diarienummer,* from #input)
    ,handelseFiltered as (SELECT Händelsedatum,Rubrik,Text,Diarienummer,Fastighet,* from #händelserFiltered)
    ,inputo as (select Diarienummer,Fastighet from #Orginal_listFilter group by Diarienummer,Fastighet)

   ,OneFromEachHandelseGenerateNull as
	(SELECT DISTINCT
		input.Diarienummer,
		input.Fastighet,
		handelseFiltered.Händelsedatum,
		handelseFiltered.Rubrik,
		handelseFiltered.Text
                from inputo
                left outer join handelseFiltered on
				handelseFiltered.Diarienummer = inputo.Diarienummer
				and handelseFiltered.rubrik = (select top (1) rubrik from handelseFiltered where handelseFiltered.Fastighet = inputo.Fastighet order by händelsedatum desc)
				and handelseFiltered.Händelsedatum = (select top (1) Händelsedatum from handelseFiltered where handelseFiltered.Fastighet = inputo.Fastighet order by händelsedatum desc)
	  )

	    ,actuallNull as (select Diarienummer,Fastighet,Händelsedatum,* from OneFromEachHandelseGenerateNull where Rubrik is null)
	    , nonNull as (select * from OneFromEachHandelseGenerateNull where Rubrik is not null)
	    ,replaceNull as (select ActuallNull.Diarienummer, ActuallNull.Fastighet, Händelsedatum, input.status as Rubrik, [Anteckning]  as text from ActuallNull left outer join input on ActuallNull.fastighet = input.[Fastighet])
   	    ,unionX as (select *from  nonNull union select *from replaceNull)
								   ,
select * from unionX ORDER BY (case when händelseDatum is null then 1 else 2 end) desc, Fastighet DESC

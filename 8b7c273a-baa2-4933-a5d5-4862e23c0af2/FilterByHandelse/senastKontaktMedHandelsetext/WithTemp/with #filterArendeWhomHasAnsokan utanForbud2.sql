/****** Script for SelectTopNRows command from SSMS  ******/
--:r FilterByHendelse/insertIntoFilterArendeWhomHasAnsokan_2.sql
if exist('tempExcel.dbo.resultat') drop table resultat
;
with senastKontaktMedHandelsetext as (select dianr,
	(select top 1 HandelseText from
	 (select handelsetext,N'Kontakt i ärende' ka,'Information om' io,rub,dianr,dat from #filterArendeWhomHasAnsokan) as Tinner
	where HandelseText is not null
	AND (left(rub, len(ka)) = ka OR left(rub, len(io)) = io)
	and Tinner.dianr = Touter.dianr
	order by dat) as senastKontakt
	  from #filterArendeWhomHasAnsokan as Touter)

, senasteHandelseIfallIntoKontakt as 	(select * from senastKontaktMedHandelsetext where senastKontakt is null)
, ingenKontaktTextArenden as 		(select q.dianr, rub, dat from #filterArendeWhomHasAnsokan q
    						right join senasteHandelseIfallIntoKontakt t
						on q.dianr = t.dianr)

   ,senasteHendelseOmInteText as (select dianr,
				  	(select top 1 rub from ingenKontaktTextArenden as Tinner where Tinner.dianr = Touter.dianr order by dat) as senastRub
				  	from #filterArendeWhomHasAnsokan as Touter)

   ,AnsUtg as (select dianr,rub from #filterArendeWhomHasAnsokan where rikt = N'Utgående')
   ,harBeslut as (select distinct dianr, 'beslut' as hasBes from AnsUtg where rub like '%eslut%' group by dianr)

    ,AnsUtg2 as ( select * from #filterArendeWhomHasAnsokan)
   ,harForbud as (select distinct dianr, N'förbud' as hasForb from AnsUtg2 where rub = N'Beslut om förbud avlopp' group by dianr)

   ,SenastInkommande as (select dianr, max(rub) rub, max(dat) maxDat, status, has
                          from #filterArendeWhomHasAnsokan where rikt = 'inkommande'
   			group by dianr, status, has)

   , deMedBeslutsHandelser as (select distinct t.* from #filterArendeWhomHasAnsokan t
                                        inner join (select harforbud.dianr from harforbud) q on q.dianr = t.dianr)

   , utanForbud as (select dianr, kir from #filterArendeWhomHasAnsokan t
                    left outer join (select harforbud.dianr from harforbud) q
                        on t.dianr = q.dianr where q.dianr is null)

   , gis as (select fnr,beteckning from [GISDATA].[sde_geofir_gotland].gng.FA_FASTIGHET)

select distinct dianr, kir, gis.fnr into resultat
from utanForbud
         left outer join gis on kir = gis.BETECKNING
select * from resultat

--where senastKontaktMedHandelsetext.senastKontakt is not null
-- order by dianr


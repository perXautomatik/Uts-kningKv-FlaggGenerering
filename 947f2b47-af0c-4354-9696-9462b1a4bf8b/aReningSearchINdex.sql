with reningarUNion      as (
select 'M' f ,*
from sde_miljo_halsoskydd.gng.RENING_MELLERSTA_P union all
select 'N' f ,*
from sde_miljo_halsoskydd.gng.RENING_NORRA_P union all
select 'S' f ,*
from sde_miljo_halsoskydd.gng.RENING_SODRA_P)

,fObjAnslutFast as (
	select f,OBJECTID, nullif(Fastighet_rening,'') fastighetsKoppling from reningarUNion
--union 	select OBJECTID, nullif(Kommentarer,'') from reningarUNion
union 	select f,OBJECTID, nullif(Anslutna_fastigheter_1,'') from reningarUNion
union 	select f,OBJECTID, nullif(Anslutna_fastigheter_2,'') from reningarUNion
union 	select f,OBJECTID, nullif(Anslutna_fastigheter_3,'') from reningarUNion
union 	select f,OBJECTID, nullif(Anslutna_fastigheter_4,'') from reningarUNion
union 	select f,OBJECTID, nullif(Anslutna_fastigheter_5,'') from reningarUNion
union 	select f,OBJECTID, nullif(Anslutna_fastigheter_6,'') from reningarUNion
union 	select f,OBJECTID, nullif(Anslutna_fastigheter_7,'') from reningarUNion
union 	select f,OBJECTID, nullif(Anslutna_fastigheter_8,'') from reningarUNion
union 	select f,OBJECTID, nullif(Anslutna_fastigheter_9,'') from reningarUNion
union 	select f,OBJECTID, nullif(Anslutna_fastigheter_10,'') from reningarUNion
)
--, mOstKopplad as (
--select count(objectid) c, fastighetsKoppling from fkopl where fastighetsKoppling is not null group by fastighetsKoppling order by c desc
--)
,badFastighetsbeteckningar as (select ('-') q union select ( '.')union select ('0'))

select * from reningarUNion inner join fObjAnslutFast on fObjAnslutFast.f=reningarUNion.f AND fObjAnslutFast.OBJECTID = reningarUNion.OBJECTID  inner join badFastighetsbeteckningar t on t.q = fObjAnslutFast.fastighetsKoppling


--,bad as (select top 100 * from fkopl where len(fastighetsKoppling) > 1 and fastighetsKoppling is not null
--order by fastighetsKoppling)

--select * from bad



--where objectid in (
--2802,
--3380
--)
--;

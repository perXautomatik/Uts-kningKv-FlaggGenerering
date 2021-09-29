with reningarUNion      as (
select 'M' f ,OBJECTID, Fastighet_rening, Antal_hushall_rening, reningstyp, Storlek_m2, Beslut_datum, Utford_datum, Kommentarer, Anslutna_fastigheter_1, Anslutna_fastigheter_2, Anslutna_fastigheter_3, Anslutna_fastigheter_4, Anslutna_fastigheter_5, Anslutna_fastigheter_6, Anslutna_fastigheter_7, Anslutna_fastigheter_8, Anslutna_fastigheter_9, Anslutna_fastigheter_10
from sde_miljo_halsoskydd.gng.RENING_MELLERSTA_P union
select 'N' f ,OBJECTID, Fastighet_rening, Antal_hushall_rening, reningstyp, Storlek_m2, Beslut_datum, Utford_datum, Kommentarer, Anslutna_fastigheter_1, Anslutna_fastigheter_2, Anslutna_fastigheter_3, Anslutna_fastigheter_4, Anslutna_fastigheter_5, Anslutna_fastigheter_6, Anslutna_fastigheter_7, Anslutna_fastigheter_8, Anslutna_fastigheter_9, Anslutna_fastigheter_10
from sde_miljo_halsoskydd.gng.RENING_NORRA_P union
select 'S' f ,OBJECTID, Fastighet_rening, Antal_hushall_rening, reningstyp, Storlek_m2, Beslut_datum, Utford_datum, Kommentarer, Anslutna_fastigheter_1, Anslutna_fastigheter_2, Anslutna_fastigheter_3, Anslutna_fastigheter_4, Anslutna_fastigheter_5, Anslutna_fastigheter_6, Anslutna_fastigheter_7, Anslutna_fastigheter_8, Anslutna_fastigheter_9, Anslutna_fastigheter_10
from sde_miljo_halsoskydd.gng.RENING_SODRA_P)

,fkopl as (
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

,bad as (select top 100 * from fkopl where len(fastighetsKoppling) > 1 and fastighetsKoppling is not null
order by fastighetsKoppling)

--select * from bad

select * from
(
--    select * from sde_miljo_halsoskydd.gng.RENING_SODRA_P
--union all
--select * from sde_miljo_halsoskydd.gng.RENING_NORRA_P
--union all
select * from sde_miljo_halsoskydd.gng.RENING_MELLERSTA_P
) as q

where objectid in (
2802,
3380
)
;

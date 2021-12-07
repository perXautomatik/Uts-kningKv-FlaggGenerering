with
    Vilkenbetekning as (select 'alskog rommunds 1:15' betekning)
    ,q as ( select fnr from sde_geofir_gotland.gng.FA_FASTIGHET where BETECKNING in (select t.betekning from Vilkenbetekning t))
select z.*
from  q
    join sde_geofir_gotland.gng.FA_TAXERINGAGARE z
    on q.FNR = z.FNR

UPDATE sde_miljo_halsoskydd.gng.FLAGGSKIKTET_P
SET ARENDENUMMER = concat('mbnv 2020/', x.INTDIARIENUMMERLOEPNUMMER)
from sde_miljo_halsoskydd.gng.FLAGGSKIKTET_P q
    inner join #tempTable x on FASTIGHET = x.STRFASTIGHETSBETECKNING
WHERE (left(fastighet, len('Bj�rke')) = 'Bj�rke' OR
       left(fastighet, len('Dalhem')) = 'Dalhem' OR
       left(fastighet, len('Fr�jel')) = 'Fr�jel' OR
       left(fastighet, len('Ganthem')) = 'Ganthem' OR
       left(fastighet, len('Halla')) = 'Halla' OR
       left(fastighet, len('Halla')) = 'Halla' OR
       left(fastighet, len('Roma')) = 'Roma')
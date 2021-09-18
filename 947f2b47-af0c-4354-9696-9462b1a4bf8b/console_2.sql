with fastighetsfilter as (Select 'bj�rke' "socken"
                          Union
                          Select 'dalhem' "a"
                          Union
                          Select 'fr�jel' "a"
                          Union
                          Select 'ganthem' "a"
                          Union
                          Select 'Halla' "a"
                          Union
                          Select 'Klinte' "a"
                          Union
                          Select 'Roma' "a"),
     socknarOfIntresse as (SELECT fastighetsFilter.socken SockenX, concat(Trakt, SPACE(1), Blockenhet) FAStighet, Shape from sde_gsd.gng.AY_0980 x inner join fastighetsFilter on left(x.TRAKT, len(fastighetsFilter.socken)) = fastighetsFilter.socken),

     byggnad_yta as (select andamal_1T Byggnadstyp, Shape from sde_gsd.gng.BY_0980),
     q as (Select Byggnadstyp, socknarOfIntresse.fastighet Fastighetsbeteckning, byggnad_yta.SHAPE
           from byggnad_yta
                    inner join socknarOfIntresse on byggnad_yta.Shape.STIntersects(socknarOfIntresse.shape) = 1)
select Fastighetsbeteckning, Byggnadstyp, shape ByggShape

from (select *, row_number() over (partition by Fastighetsbeteckning order by Byggnadstyp ) orderz from q) z
where
      --orderz = 1 and
       --socken =     'Fr�jel' and
Fastighetsbeteckning like 'fr�jel ansarve%' or
Fastighetsbeteckning in (           'Fr�jel Hallg�rds 1:2',

'Fr�jel G�stavs 5:1',

'Fr�jel Ansarve 1:16'
)
with fastighetsfilter as (Select 'björke' "socken"
                          Union
                          Select 'dalhem' "a"
                          Union
                          Select 'fröjel' "a"
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
       --socken =     'Fröjel' and
Fastighetsbeteckning like 'fröjel ansarve%' or
Fastighetsbeteckning in (           'Fröjel Hallgårds 1:2',

'Fröjel Göstavs 5:1',

'Fröjel Ansarve 1:16'
)
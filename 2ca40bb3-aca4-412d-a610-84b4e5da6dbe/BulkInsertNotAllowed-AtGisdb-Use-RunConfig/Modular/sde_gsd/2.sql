with
    fastighetsfilter  as (select * FROM #fastighetsfilter)
  , socknarOfIntresse as (SELECT fastighetsFilter.socken SockenX, concat(Trakt, SPACE(1), Blockenhet) FAStighet, Shape
			  from sde_gsd.gng.AY_0980 x
			      inner join fastighetsFilter
			      on left(x.TRAKT, len(fastighetsFilter.socken)) = fastighetsFilter.socken)
  , byggnad_yta       as (select andamal_1T Byggnadstyp, Shape from sde_gsd.gng.BY_0980), q as (Select Byggnadstyp
												     , socknarOfIntresse.fastighet Fastighetsbeteckning
												     , byggnad_yta.SHAPE
												from byggnad_yta
												    inner join socknarOfIntresse
												    on byggnad_yta.Shape.STIntersects(socknarOfIntresse.shape) = 1)
select Fastighetsbeteckning, Byggnadstyp, shape ByggShape
from (select *, row_number() over (partition by Fastighetsbeteckning order by Byggnadstyp ) orderz from q) z
where orderz = 1
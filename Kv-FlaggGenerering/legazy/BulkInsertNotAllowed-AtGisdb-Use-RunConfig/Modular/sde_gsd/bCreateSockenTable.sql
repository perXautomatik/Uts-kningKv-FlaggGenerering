with

    socknarOfIntresse as (SELECT #fastighetsFilter.socken SockenX, concat(Trakt, SPACE(1), Blockenhet) FAStighet, Shape
			  from sde_gsd.gng.AY_0980 x
			      inner join #fastighetsFilter
			      on left(x.TRAKT, len(#fastighetsFilter.socken)) = #fastighetsFilter.socken)
select *
from socknarOfIntresse
with socknarOfIntresse as (SELECT value "socken"
                           from STRING_SPLIT(N'Björke,Dalhem,Fröjel,Ganthem,Halla,Klinte,Roma', ','))
SELECT concat(Trakt, ' ', Blockenhet) FAStighet, OBJECTID, Fnr_FDS, Shape
from sde_gsd.gng.AY_0980 x
         inner join socknarOfIntresse on left(x.TRAKT, len(socknarOfIntresse.socken)) = socknarOfIntresse.socken
-- create view sockenOfInterest
-- we're not allowed to create temp tables in the db, we'll have to call from local db with external query

with
    sockenVal         as (Select 'björke' "socken"
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
			  Select 'Roma' "a")
  ,

    -- create view fastighetsytor of interest

    socknarOfIntresse as (SELECT sockenVal.socken SockenX, concat(Trakt, SPACE(1), Blockenhet) FAStighet, Shape
			  from sde_gsd.gng.AY_0980 x
			      inner join sockenVal on left(x.TRAKT, len(sockenVal.socken)) = sockenVal.socken)
  ,

    -- create view byggnader innom socken.

    byggnad_yta       as (select andamal_1T Byggnadstyp, Shape from sde_gsd.gng.BY_0980), byggnaderInomSocken
		      as (Select Byggnadstyp, socknarOfIntresse.fastighet Fastighetsbeteckning, byggnad_yta.SHAPE
			  from byggnad_yta
			      inner join socknarOfIntresse
			      on byggnad_yta.Shape.STIntersects(socknarOfIntresse.shape) = 1)

  , selectOnlyOne     as (select *
			       , row_number() over (partition by Fastighetsbeteckning order by Byggnadstyp ) orderz
			       , count(all Byggnadstyp) over ( partition by Fastighetsbeteckning)            countz

			  from byggnaderInomSocken)

select Fastighetsbeteckning, countz, Byggnadstyp, shape ByggShape
from selectOnlyOne

where orderz = 1
--and
--socken =     'Fröjel' and
--where Fastighetsbeteckning like 'fröjel ansarve%' or Fastighetsbeteckning in (           'Fröjel Hallgårds 1:2', 'Fröjel Göstavs 5:1', 'Fröjel Ansarve 1:16' )
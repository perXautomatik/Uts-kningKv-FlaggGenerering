with
    fastighetsfilter  as (select * FROM #fastighetsfilter)
  , socknarOfIntresse as (SELECT fastighetsFilter.socken SockenX, concat(Trakt, SPACE(1), Blockenhet) FAStighet, Shape
			  from sde_gsd.gng.AY_0980 x
			      inner join fastighetsFilter
			      on left(x.TRAKT, len(fastighetsFilter.socken)) = fastighetsFilter.socken)
  , LOKALT_SLAM_P     as (select Diarienr, Fastighet_, Fastighe00, Eget_omhän, Lokalt_omh, Anteckning, Beslutsdat, shape
			  from sde_miljo_halsoskydd.gng.MoH_Slam_Lokalt_p_evw)
  , Fas2              as (select *
			       , concat(nullif(LOKALT_SLAM_P.Lokalt_omh + space(1), space(1)),
					nullif(LOKALT_SLAM_P.Fastighet_ + space(1), space(1)),
					nullif(LOKALT_SLAM_P.Fastighe00 + space(1), space(1))) fas
			  from sde_miljo_halsoskydd.gng.MoH_Slam_Lokalt_p_evw LOKALT_SLAM_P)
  , Med_fastighet     as (select Fastighet_, Fastighets, Eget_omhän, Lokalt_omh, Fastighe00, Beslutsdat, Diarienr, Anteckning
			       , shape LocaltOmH
			       , fas
			  from Fas2
			  where fas is not null and charindex(char(58), fas) > 0)
  , utan_fastighet    as (select Fastighet_, Fastighets, Eget_omhän, Lokalt_omh, Fastighe00, Beslutsdat, Diarienr, Anteckning
			       , utan_fastighet.shape LocaltOmH
			       , FAStighet            fas
			  from (select * from Fas2 where fas is null OR charindex(char(58), fas) = 0) utan_fastighet
			      inner join socknarOfIntresse sYt on sYt.shape.STIntersects(utan_fastighet.Shape) = 1)
select Fastighet_, Fastighets, Eget_omhän, Lokalt_omh, Fastighe00, Beslutsdat, Diarienr, Anteckning, LocaltOmH, FAStighet
from socknarOfIntresse sYt
    left outer join Med_fastighet on fas like char(37) + sYt.Fastighet + char(37)
where fas is not null
union all
select *
from utan_fastighet
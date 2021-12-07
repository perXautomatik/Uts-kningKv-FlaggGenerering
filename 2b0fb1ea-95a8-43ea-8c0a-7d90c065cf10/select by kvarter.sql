with
    fas as (select fa.FNR, fa.BETECKNING, fa.TRAKT, yt.Shape
        from sde_geofir_gotland.gng.FA_FASTIGHET fa
            inner join sde_gsd.gng.REGISTERENHET_YTA yt on fa.FNR = yt.FNR_FDS)

select * from sde_geografi.gng.KVARTER_Y b
	left outer join fas
			on fas.Shape.STIntersects(b.shape) = 1



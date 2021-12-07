with
    rq as ( select _FASTIGHET_,_�rendenr_ from Hideviken )

    ,f as (
    SELECT fa.FNR
	   , fa.BETECKNING
	   , rq._�rendenr_
	FROM rq left JOIN
	[GISDATA].sde_geofir_gotland.gng.FA_FASTIGHET
	AS fa
      ON rq._FASTIGHET_ = fa.BETECKNING
      where fa.BETECKNING is not null
    )

select * into #input from  f
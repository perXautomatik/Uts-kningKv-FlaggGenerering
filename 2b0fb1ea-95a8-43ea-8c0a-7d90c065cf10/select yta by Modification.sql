with
    fas as (select FNR, BETECKNING, TRAKT
        from sde_geofir_gotland.gng.FA_FASTIGHET)


select * from sde_geofir_gotland.gng.REAREA b
	left outer join fas
			on realEstateKey = fnr

 where modificationDate > datefromparts(2021,9,30)
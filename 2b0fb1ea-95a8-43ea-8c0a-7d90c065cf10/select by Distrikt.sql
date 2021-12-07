select * from sde_geofir_gotland.gng.RE_DISTRICTRE
		left outer join sde_geofir_gotland.gng.FA_FASTIGHET on FNR = realestatekey
			where trakt not like districtName + '%'
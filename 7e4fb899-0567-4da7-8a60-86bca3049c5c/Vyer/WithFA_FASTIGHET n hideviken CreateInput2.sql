select * into #input from (SELECT input.FNR, input.BETECKNING, Hideviken._�rendenr_
      FROM Hideviken
               left JOIN [GISDATA].sde_geofir_gotland.gng.FA_FASTIGHET AS input ON _FASTIGHET_ = input.BETECKNING
      where input.BETECKNING is not null) as FB�
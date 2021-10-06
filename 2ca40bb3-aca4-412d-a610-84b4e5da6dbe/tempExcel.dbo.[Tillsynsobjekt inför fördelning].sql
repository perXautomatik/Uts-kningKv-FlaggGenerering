select tempExcel.dbo.[Tillsynsobjekt inför fördelning].*,
       gng.sde_geofir_gotland.FA_FASTIGHET.*
from tempExcel.dbo.[Tillsynsobjekt inför fördelning] left outer join
    gng.sde_geofir_gotland.FA_FASTIGHET on
        tempExcel.dbo.[Tillsynsobjekt inför fördelning].Huvudfastighet = beteckning
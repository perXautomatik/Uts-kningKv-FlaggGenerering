declare @personNr nvarchar(13);
@personNr = '19520627-1016'

select x.*, q.BETECKNING
from
 sde_geofir_gotland.gng.FA_FASTIGHET q
join EDPVisionRegionGotlandAvlopp.dbo.vwAehAerendetsHuvudfastighet w on q.FNR = w.FNR
    join
     (
	SELECT t.FNR
	    FROM sde_geofir_gotland.gng.FA_TAXERINGAGARE t
	    where t.PERSORGNR = @personNr
	    union
	SELECT t.FNR
	    FROM sde_geofir_gotland.gng.FA_TAXERINGAGARE_v2 t
	    where t.PERSORGNR = @personNr
	    union
	SELECT y.FNR
	    FROM sde_geofir_gotland.gng.FA_TAXERINGAGARE_V2 y
	    where y.PERSORGNR = @personNr
	    union
	SELECT y.FNR
	    FROM sde_geofir_gotland.gng.FA_TAXERINGAGARE y
	    where y.PERSORGNR = @personNr
	    union
	SELECT q.FASTIGHETSNYCKEL
	    FROM sde_geofir_gotland.gng.Fastighetsägare q
	    where q.PERSONORGANISATIONNR = @personNr
	    union
	SELECT q.FNR
	    FROM sde_geofir_gotland.gng.FA_LAGFART q
	    where q.PERSORGNR = @personNr
	    union
	SELECT q.FNR
	    FROM sde_geofir_gotland.gng.FA_LAGFART_V2 q
	    where q.PERSORGNR = @personNr
	    union
	SELECT q.FNR
	    FROM sde_geofir_gotland.gng.FA_TAXERINGAGARE_V2 q
	    where q.PERSORGNR = @personNr
	    union
	SELECT q.FNR
	    FROM sde_geofir_gotland.gng.FA_TAXERINGAGARE q
	    where q.PERSORGNR = @personNr
	    union
	SELECT q.RealEstateKey
	    FROM sde_geofir_gotland.gng.info_OwnerShipChange q
	    where q.IdNumber = @personNr
    ) x on x.FNR = q.FNR


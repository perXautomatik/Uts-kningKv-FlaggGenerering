
select x.*,q.BETECKNING from
(
SELECT t.FNR
FROM sde_geofir_gotland.gng.FA_TAXERINGAGARE t
where t.PERSORGNR = '19520627-1016'
union
SELECT t.FNR
FROM sde_geofir_gotland.gng.FA_TAXERINGAGARE_v2 t
where t.PERSORGNR = '19520627-1016'
union
SELECT y.FNR
FROM sde_geofir_gotland.gng.FA_TAXERINGAGARE_V2 y
where y.PERSORGNR = '19520627-1016'
union
SELECT y.FNR FROM sde_geofir_gotland.gng.FA_TAXERINGAGARE y
where y.PERSORGNR = '19520627-1016'
union
SELECT q.FASTIGHETSNYCKEL
FROM sde_geofir_gotland.gng.Fastighetsägare q
where q.PERSONORGANISATIONNR = '19520627-1016'
union
SELECT q.FNR
FROM sde_geofir_gotland.gng.FA_LAGFART q
where q.PERSORGNR = '19520627-1016'
union
SELECT q.FNR
FROM sde_geofir_gotland.gng.FA_LAGFART_V2 q
where q.PERSORGNR = '19520627-1016'
union
SELECT q.FNR
FROM sde_geofir_gotland.gng.FA_TAXERINGAGARE_V2 q
where q.PERSORGNR = '19520627-1016'
union
SELECT q.FNR
FROM sde_geofir_gotland.gng.FA_TAXERINGAGARE q
where q.PERSORGNR = '19520627-1016'
union
SELECT q.RealEstateKey
FROM sde_geofir_gotland.gng.info_OwnerShipChange q
where q.IdNumber = '19520627-1016'
    ) x join sde_geofir_gotland.gng.FA_FASTIGHET q on x.FNR = q.FNR

join [LocalTempAndEdpCopy].EDPVisionRegionGotlandAvlopp.dbo.vwAehAerendetsHuvudfastighet w on q.FNR = w.fnr


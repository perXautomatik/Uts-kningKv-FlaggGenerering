
select w.recAerendeID,x.*,q.BETECKNING from
(
SELECT t.FNR
FROM [Gisdata].sde_geofir_gotland.gng.FA_TAXERINGAGARE t
where t.PERSORGNR = '19520627-1016'
union
SELECT t.FNR
FROM [Gisdata].sde_geofir_gotland.gng.FA_TAXERINGAGARE_v2 t
where t.PERSORGNR = '19520627-1016'
union
SELECT y.FNR
FROM [Gisdata].sde_geofir_gotland.gng.FA_TAXERINGAGARE_V2 y
where y.PERSORGNR = '19520627-1016'
union
SELECT y.FNR FROM [Gisdata].sde_geofir_gotland.gng.FA_TAXERINGAGARE y
where y.PERSORGNR = '19520627-1016'
union
SELECT q.FASTIGHETSNYCKEL
FROM [Gisdata].sde_geofir_gotland.gng.Fastighetsägare q
where q.PERSONORGANISATIONNR = '19520627-1016'
union
SELECT q.FNR
FROM [Gisdata].sde_geofir_gotland.gng.FA_LAGFART q
where q.PERSORGNR = '19520627-1016'
union
SELECT q.FNR
FROM [Gisdata].sde_geofir_gotland.gng.FA_LAGFART_V2 q
where q.PERSORGNR = '19520627-1016'
union
SELECT q.FNR
FROM [Gisdata].sde_geofir_gotland.gng.FA_TAXERINGAGARE_V2 q
where q.PERSORGNR = '19520627-1016'
union
SELECT q.FNR
FROM [Gisdata].sde_geofir_gotland.gng.FA_TAXERINGAGARE q
where q.PERSORGNR = '19520627-1016'
union
SELECT q.RealEstateKey
FROM [Gisdata].sde_geofir_gotland.gng.info_OwnerShipChange q
where q.IdNumber = '19520627-1016'
    ) x join [Gisdata].sde_geofir_gotland.gng.FA_FASTIGHET q on x.FNR = q.FNR

left outer join (select

                        recAerendeID,

                        strFnrID
                 from EDPVisionRegionGotlandAvlopp.dbo.tbAehAerendeEnstakaFastighet join EDPVisionRegionGotlandAvlopp.dbo.tbVisEnstakaFastighet on tbAehAerendeEnstakaFastighet.recFastighetID = tbVisEnstakaFastighet.recFastighetID)

    w on x.FNR = w.strFnrID


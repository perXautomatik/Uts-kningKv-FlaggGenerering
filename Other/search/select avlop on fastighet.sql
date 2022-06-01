with
    fasWithShape as (select fa.FNR,fa.BETECKNING , fa.TRAKT, yt.Shape from sde_geofir_gotland.gng.FA_FASTIGHET fa inner join sde_gsd.gng.REGISTERENHET_YTA yt on fa.FNR = yt.FNR_FDS)

select * from sde_miljo_halsoskydd.gng.ENSKILT_AVLOPP_MELLERSTA_P eamp inner join fasWithShape
on fasWithShape.Shape.STContains(eamp.Shape) = 1
where BETECKNING like  'sanda bjästavs 1:36'


SELECT * FROM sde_miljo_halsoskydd.gng.ENSKILT_AVLOPP_MELLERSTA_P WHERE OBJECTID IN (1228, 2525)
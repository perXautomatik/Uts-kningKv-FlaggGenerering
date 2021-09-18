create procedure
select z.* from (select fnr from sde_geofir_gotland.gng.FA_FASTIGHET where BETECKNING = 'alskog rommunds 1:15') q
join sde_geofir_gotland.gng.FA_TAXERINGAGARE z on q.FNR = z.FNR

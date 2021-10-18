declare @sokfras varchar(40) ;
    set @sokfras = 'VISBY STORA HÄSTNÄS 1:19';

select BETECKNING,UBETECKNING,BETECKNING x from sde_geofir_gotland.gng.FA_URSPRUNG
where UBETECKNING = @sokfras
union
select BETECKNING,UBETECKNING,UBETECKNING from sde_geofir_gotland.gng.FA_URSPRUNG
where BETECKNING = @sokfras
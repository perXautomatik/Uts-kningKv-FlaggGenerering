IF object_id('tempdb..#fnrz') is null
begin    ;
WITH

,fastigheter as (select max(selection.SOCKENX) socken, max(selection .STATUS) status,coalesce( FASTIGHET,evwFASTIGHET,FASTIGHET_TILLSTAND) f from selection GROUP BY  coalesce( FASTIGHET,evwFASTIGHET,FASTIGHET_TILLSTAND)) ,
fnrz as (select fnr,beteckning,socken,fastigheter.status from sde_geofir_gotland.gng.FA_FASTIGHET q inner join fastigheter on FASTIGHETER.F = beteckning)
    select * into #Fnrz from FNRZ
; end ELSE begin drop table #fnrz goto startz end go
;
with selected as (some selection with shape column, and beteckningscolumn, and ort kolumn)

,Geofastigheted as (select
         	fnr geofas
         	,fastighets
         	,id,ort,LAGE
		from  selected b
		    left outer join fas
			on fas.Shape.STIntersects(b.shape) = 1
        )

,fastighetedx as (select coalesce(geofas,fnr) geofas,fastighets,id,
       ort
     ,	LAGE from geoFastigheted
		    left outer join sde_geofir_gotland.gng.FA_FASTIGHET fas
			on fas.beteckning = fastighets)

,fastighetedq as (select coalesce(geofas,fnr) geofas,fastighets,id,
       ort
     ,	LAGE from fastighetedx
		    left outer join sde_geofir_gotland.gng.FA_FASTIGHET fas
			on fas.beteckning = ort + ' ' + fastighets)

,FasWithSockenAndBetUtanSocken as (SELECT
       iif(charindex(' ',trakt) > 0, left(trakt,charindex(' ',trakt)),trakt) socken,
       right(beteckning,len(beteckning)-len(iif(charindex(' ',trakt) > 0, left(trakt,charindex(' ',trakt)),trakt))-1) betUtanSocken
       ,* FROM sde_geofir_gotland.gng.FA_FASTIGHET)

,FasWithSockenAndBetUtanSockenX as (
    select coalesce(geofas, fnr) geofas
	 , fastighets
	 , id
	 , ort
	 , LAGE
    from fastighetedq
	left outer join fasWithSockenAndBetUtanSocken
	on betUtanSocken =
	   iif(len(fastighets) < 6, ort + ' ' + fastighets, fastighets)
	       AND
	   (geofas is null and fastighets != '' and charindex(':', fastighets) > 0 and len(fastighets) > 4)
)

,FasUtanSockenX as (
    select coalesce(geofas, fnr) geofas
	 , fastighets
	 , id
	 , ort
	 , LAGE
    from FasWithSockenAndBetUtanSockenX
	left outer join fasWithSockenAndBetUtanSocken
	on betUtanSocken = isnull(case when charindex(' ',fastighets,1+isnull(nullif(charindex(' ',fastighets),0),len(fastighets))) > 0 then
	       		right(fastighets,isnull(nullif(len(fastighets)-charindex(' ',fastighets),0),1) ) end,'')
       AND
	   (geofas is null AND fastighets != ' ' ))


    ,fastighetsy as (select distinct coalesce(geofas,fnr) geofas,fastighets,id,ort,LAGE from fastighetedx
		left outer join (
		    select fnr,districtname,beteckning from sde_geofir_gotland.gng.RE_DISTRICTRE
		inner join sde_geofir_gotland.gng.FA_FASTIGHET on FNR = realestatekey
		    where beteckning not like districtname + '%'
    				) fas

		on fas.districtname = ort AND beteckning like fastighets +'%' )





			--on fas.beteckning = fastighetsx)


,fastighetsxy as (select distinct coalesce(geofas,fnr) geofas,id from fastighetsx
		left outer join sde_geofir_gotland.gng.FA_URSPRUNG fas
			on fas.Ubeteckning = ort + ' ' + fastighets)



select * from FasUtanSockenX where geofas is null

select * from
     		sde_geofir_gotland.gng.FA_FASTIGHET
where beteckning like  '%kinner 1:8%'
select * from
		sde_geofir_gotland.gng.FA_URSPRUNG
where Ubeteckning like  '%kinner 1:8%' OR beteckning like  '%kinner 1:8%'


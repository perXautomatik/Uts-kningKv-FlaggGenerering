FasWithSockenAndBetUtanSocken as (SELECT
       iif(charindex(' ',trakt) > 0, left(trakt,charindex(' ',trakt)),trakt) socken,
       right(beteckning,len(beteckning)-len(iif(charindex(' ',trakt) > 0, left(trakt,charindex(' ',trakt)),trakt))-1) betUtanSocken
       ,* FROM sde_geofir_gotland.gng.FA_FASTIGHET)
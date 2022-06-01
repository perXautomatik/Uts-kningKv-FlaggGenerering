declare @sockenStrang Nvarchar(50)
set @sockenStrang = N'Björke,Dalhem,Fröjel,Ganthem,Halla,Klinte,Roma';

with
    socknarOfIntresse as (SELECT value "socken"
			  from STRING_SPLIT(@sockenStrang, ','))

SELECT BETECKNING FAStighet, fnr Fnr_FDS, Shape
INTO #SockenYtor
from (select fa.FNR, fa.BETECKNING, fa.TRAKT, yt.Shape
      from [gisdb01].[sde_geofir_gotland].[gng].FA_FASTIGHET fa
	  inner join [gisdb01].[sde_gsd].gng.REGISTERENHET_YTA yt on fa.FNR = yt.FNR_FDS) x
    inner join socknarOfIntresse on left(x.TRAKT, len(socknarOfIntresse.socken)) = socknarOfIntresse.socken
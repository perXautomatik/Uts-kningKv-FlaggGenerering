IF OBJECT_ID('tempdb..#FastighetsYtor') IS NULL
       OR (select top 1 RebuildStatus from #settingTable) = 1
    Begin BEGIN TRY DROP TABLE #FastighetsYtor END TRY BEGIN CATCH select 1 END CATCH;

    with 
       fasWithShape as (select fa.FNR,fa.BETECKNING , fa.TRAKT, yt.Shape from sde_geofir_gotland.gng.FA_FASTIGHET fa inner join sde_gsd.gng.REGISTERENHET_YTA yt on fa.FNR = yt.FNR_FDS)
     ,fasInnomSocken as (
    	    	SELECT BETECKNING FAStighet, x.Shape,so.socken, fnr Fnr_FDS
    		from  fasWithShape x
             inner join #socknarOfInterest so on x.Shape.STIntersects(so.shape) = 1
	)
    select * INTO #FastighetsYtor 
	from fasInnomSocken;

    INSERT INTO #statusTable select 'rebuilt#FastighetsYtor',CURRENT_TIMESTAMP,@@ROWCOUNT
    --set @rebuiltStatus1 = 1
        end
    else INSERT INTO #statusTable select 'preloading#FastighetsYtor',CURRENT_TIMESTAMP,@@ROWCOUNT
--goto TableInitiate;
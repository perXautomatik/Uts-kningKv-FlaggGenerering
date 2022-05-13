IF OBJECT_ID('tempdb..#FastighetsYtor') IS not null OR (select top 1 RebuildStatus from #settingTable) = 1
    BEGIN TRY DROP TABLE #FastighetsYtor END TRY BEGIN CATCH select 'could not drop FastighetsYtor' END CATCH;
go;
IF OBJECT_ID('tempdb..#FastighetsYtor') IS null
    Begin

    with 
       fasWithShape as (select fa.FNR,fa.BETECKNING , fa.TRAKT, yt.Shape from sde_geofir_gotland.gng.FA_FASTIGHET fa inner join sde_gsd.gng.REGISTERENHET_YTA yt on fa.FNR = yt.FNR_FDS)
      	,socknarOfinterest as (select socken,sokedSocken,shape sockenShape from #socknarOfInterest)


    select FNR fnr_fds, BETECKNING fastighet, Shape, coalesce(sokedSocken,socken) socken
	 INTO #FastighetsYtor
    from fasWithShape x
	inner join socknarOfinterest so
	on (left(x.BETECKNING, len(so.socken)) = so.socken
		OR
	    left(x.BETECKNING, len(so.sokedSocken)) = so.sokedSocken)

    INSERT INTO #statusTable select 'rebuilt#FastighetsYtor',CURRENT_TIMESTAMP,@@ROWCOUNT
    --set @rebuiltStatus1 = 1
        end
    else INSERT INTO #statusTable select 'preloading#FastighetsYtor',CURRENT_TIMESTAMP,@@ROWCOUNT
/*
exsists in fastighetsyta
källunge burs 1:44
källunge burs 1:47
*/
----goto TableInitiate;
 go

 IF OBJECT_ID(N'tempdb..#FiltreraMotFlaggskiktet') is not null OR (select top 1 RebuildStatus from #settingtable) = 1
        BEGIN TRY DROP TABLE #FiltreraMotFlaggskiktet END TRY BEGIN CATCH select 'failed to drop #FiltreraMotFlaggskiktet' END CATCH
go;
IF OBJECT_ID(N'tempdb..#FiltreraMotFlaggskiktet') is null
    begin
with
	-- fastighetsytor inclusive shiften
    	fs as (Select q.FAStighet, Status,flaggor.shape from sde_miljo_halsoskydd.gng.FLAGGSKIKTET_P flaggor inner join (select * from  #fastighetsYtor) q on flaggor.Shape.STWithin(q.shape) = 1 or q.fastighet = isnull(flaggor.FASTIGHET,'') )
    ,	FiltreraMotFlaggskiktet as(
	select
	    ttv.*,fs.Status, fs.shape
	    from
		 #enatSkikt ttv left outer join
		     fs on fs.FASTIGHET = ttv.fastighet
)
select * into #FiltreraMotFlaggskiktet
from FiltreraMotFlaggskiktet where Status is null

INSERT INTO #statusTable select N'rebuilt#FiltreraMotFlaggskiktet', CURRENT_TIMESTAMP, @@ROWCOUNT end
    else INSERT INTO #statusTable select N'preloading#FiltreraMotFlaggskiktet', CURRENT_TIMESTAMP, @@ROWCOUNT;

go
;

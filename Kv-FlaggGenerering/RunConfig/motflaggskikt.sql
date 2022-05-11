;
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
from FiltreraMotFlaggskiktet
go
;

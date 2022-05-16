;
with
fastigheter as (select fastighet, shape from #FastighetsYtor fastighetsytor  where fastighet like N'källunge burs 1:4%')
, byggnader as (select 'byggnad' typ, shape from #ByggnadPåFastighetISocken byggnaderX )
,anlagggningar as (select N'anläggning' typ,  AnlaggningsPunkt shape from #Socken_tillstånd anlaggningarx )
, flaggor as (select 'flagga' typ, shape from sde_miljo_halsoskydd.gng.FLAGGSKIKTET_P flaggorX)

select fastighet, typ, shape.STX x,shape.STY y
from (
select fastighet,typ,b.shape from fastigheter f
			left outer join
    				byggnader b
    				    on
					b.Shape.STWithin(f.shape) = 1
union all
select fastighet,typ,a.shape from fastigheter f
			left outer join
    				anlagggningar a on
    				    a.Shape.STWithin(f.shape) = 1
union all
select fastighet,typ,fl.shape from fastigheter f
			left outer join
    				flaggor fl
    				    on
    				        fl.Shape.STWithin(f.shape) = 1
    )q where typ is not null
order by fastighet



;
go
;
select * from
(select fastighet, x, y, deltax, deltay, len(cast(deltax as nvarchar)) lenX,len(cast(deltay as nvarchar)) lenY
 from
(select fastighet, x,y, cast(x as int)-x deltax, cast(y as int)-y deltay
from (
    select FASTIGHET, shape.STX x,shape.STY y from sde_miljo_halsoskydd.gng.FLAGGSKIKTET_P flaggorX
) q ) t ) u order by lenx+lenY
--where deltax <= -0.1 Or deltay <= -0.1  order by deltax desc, deltay desc


	  /* case when (fstatus = 'röd' OR (fstatus is null AND  harbyggtypInteIVa  = 'true' ))
	    then 'x' end IrodUtsokning,
	   case when (fs.fastighet not in(select fastighet from #enatSkikt toTeamVatten where fstatus = 'röd') and  harbyggtypInteIVa  = 'true' )
		then 'x' end IgronUtsokning
	    ,case when isnull(harbyggtypInteIVa,'nej') = 'true' then 'nej' else 'ja' end bla*/


--select *  -- fastighet, fstatus,Status, flagga --, concat('röd:',isnull(IrodUtsokning,'inteRöd'),',Va:',bla)
--from #FiltreraMotFlaggskiktet FiltreraMotFlaggskiktet -- fastighet, fstatus,Status, flagga --, concat('röd:',isnull(IrodUtsokning,'inteRöd'),',Va:',bla)
--	    where fs.Status is null and fstatus is not null

/*
select distinct count(*) over ( partition by IrodUtsokning,IgronUtsokning,bla) c,IrodUtsokning,IgronUtsokning,bla
from FiltreraMotFlaggskiktet
order by bla,IgronUtsokning,IrodUtsokning,fstatus,Byggnadstyp, coalesce(fstatus, Diarienummer, Fastighet_tillstand, try_cast(Beslut_datum as varchar), try_cast(utförddatum as varchar),
    Anteckning, egetOmhändertangandeInfo, VAantek, typ, Byggnadstyp, try_cast( bygTot as varchar)
)*/
--order by fstatus desc,fastighet,typ,egetOmhändertangandeInfo
--;
--select count(*) c, 'slam' a from @slamz union select count(*) c, 'egetomh' a  from @egetomh union select count(*) c, 'va' a  from @va union select count(*) c, 'byggs' a  from @byggs
--drop table #FiltreraMotFlaggskiktet
--select * from #FiltreraMotFlaggskiktet
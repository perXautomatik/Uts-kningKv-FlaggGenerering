	  /* case when (fstatus = 'röd' OR (fstatus is null AND  harbyggtypInteIVa  = 'true' ))
	    then 'x' end IrodUtsokning,
	   case when (fs.fastighet not in(select fastighet from #enatSkikt toTeamVatten where fstatus = 'röd') and  harbyggtypInteIVa  = 'true' )
		then 'x' end IgronUtsokning
	    ,case when isnull(harbyggtypInteIVa,'nej') = 'true' then 'nej' else 'ja' end bla*/

SELECT *,shape.STX flaggax,shape.STY flaggay,flagga.STX flaggax,flagga.STY flaggay FROM FiltreraMotFlaggskiktet where fastighet like 'källunge burs 1:4%'
select * into #FiltreraMotFlaggskiktet -- fastighet, fstatus,Status, flagga --, concat('röd:',isnull(IrodUtsokning,'inteRöd'),',Va:',bla)
from FiltreraMotFlaggskiktet -- fastighet, fstatus,Status, flagga --, concat('röd:',isnull(IrodUtsokning,'inteRöd'),',Va:',bla)
	    where fs.Status is null and fstatus is not null

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
select * from #FiltreraMotFlaggskiktet


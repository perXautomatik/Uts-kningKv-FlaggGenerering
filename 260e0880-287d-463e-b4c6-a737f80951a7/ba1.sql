




    --select * from (select cbid, case when (name = 'Cl' OR name = 'KLORID')  and poSeq in (select seq from nrIdentified ni where ni.cbid = bx.cbid  ) and (popoV = 'mg/L' OR popoV = 'MG/L.') then poV when (ppv = 'KLORIDHALT' OR ppv = 'KLORID') and pSeq in (select seq from nrIdentified ni where ni.cbid = bx.cbid  ) and name = 'MG/L'  then pv end ClMgL from betweexxest bx) zz where ClMgL is not null




cbid,
if saltref , 'på', nr then saltPåM



	    --(s.seq = sr.seq+1 OR s.seq = sr.seq-1 OR s.seq = sr.seq)





;


  ,betweenWords as (select distinct s.cbId, case when s.seq = sr.seq-2 And sr.seq-2 >= 1 then s.seq end PrePreSeq, case when s.seq = sr.seq-2 And sr.seq-2 >= 1 then splitValue end PrePre, case when s.seq = sr.seq-1 And sr.seq-1 >= 1 then s.seq end PreSeq, case when s.seq = sr.seq-1 And sr.seq-1 >= 1 then splitValue end Pre, case when s.seq = sr.seq then  s.seq end splitValueSeq, case when s.seq = sr.seq then  splitValue end splitValue, case when s.seq = sr.seq+1 then s.seq end PostSeq, case when s.seq = sr.seq+1 then splitValue end Post, case when s.seq = sr.seq+2 then s.seq end PostPostSeq, case when s.seq = sr.seq+2 then splitValue end PostPost from @splitInwords s inner join saltRef sr on s.cbId = sr.cbId where s.seq between sr.seq-2 and sr.seq+2)


,removeDupes as (SELECT * FROM (select*, row_number() over (partition by cbID order by len(saltAnmarkning) desc,geoFas) RNR from MedSaltAnmarkningar) QZ where rnr = 1)

select SaltAnmarkning,mgl, anm anmarkning,
           geofas,
           FASTIGHETS, ORT, LAGE,
           VATTENMANG, TN, GRUNDVATTE, NIVADATUM,
           BOTTENDIAM, TOTALDJUP, TJ, DJUP_TILL_, RORBORRNIN, STALFODERR, PLASTFODER, TATNING, ANVANDNING,
           BORRDATUM,cbID,
           OBJECTID_1, BRUNNS_ID, LAGESNOGGR, Shape, GDB_GEOMATTR_DATA from removeDupes
order by SaltAnmarkning desc,coalesce(anm,convert(varchar,geoFas),nullif(FASTIGHETS,''),nullif(ort,''),lage),mgl desc
,betweexxest as (select distinct * from  betweex where name is not null
      and coalesce(ppV,pv,poV,popoV) is not null
      --and ppv != pv ANd poV != popoV
      and (cast(ppSec+pseq+seq+poseq+poposec as float)/cast(seq as float)) = 5)
--case when  = nr.seq
--	aseq then a is val, b is post, c is postpost
--     	bseq then a is pre, b is val, c is post, d is postpost
--     	dseq then b is prepre, c is pre, d is val, e is post
--     	eseq then c is prepre, d is pre, e is val

,betweex as (
    select si.cbid
	 , pp.splitValue   ppv
	 , p.splitValue    pv
	 , si.name
	 , po.splitValue   poV
	 , poPo.splitValue popoV
	 , pp.seq          ppSec
	 , p.seq           pseq
	 , si.seq
	 , po.seq          poSeq
	 , poPo.seq        popoSec
    from SaltIdentified si
    		left outer join pre p on p.cbId = si.cbId And p.seq < si.seq
    		left outer join prePre pp on pp.cbId = si.cbId And pp.seq < si.seq
    		left outer join post po on po.cbId = si.cbId And po.seq > si.seq
    		left outer join postPost poPo on poPo.cbId = si.cbId And popo.seq > si.seq
    )
declare @stringSplitVar1 varchar(10) = '</x>'; declare @stringSplitVar2 varchar(10) = '<x>'; declare @stringSplitDelim varchar(10) = ','; declare @toSplit table (toSplit nvarchar(max)); declare @farligaTecken table (name nvarchar);
insert into @farligaTecken select '!' a union select '&' a union select '+' a union select ':' a union select ';' a union select '<' a union select '=' a union select '>' a union select '?' a
insert into @toSplit select N'ANING BRÄCKT, ANING SALTHALTIGT, ANINGEN SALT, ANINGENSALT, BRÄCKT VATTEN ( LÄTT ), BRÄCKT, BRÄCKTVATTEN, CL , ' +
                            N'DELVIS SALT, EN ANING SALT, ENANINGBRÄCKT, GANSKA SALT, KAN BLI BRÄCKT VID TRYCKNING, KLORID, KRAFTIG SALTSMAK, ' +
                            N'KRAFTIGT SALT, KRAFTIGT SALTHALTIGT, LITE BRÄCKT, LITE SALT, LITE SALTVATTEN, LITEN SMAK AV SALT, LITESALT, ' +
                            N'LITET SALT, LÄTT SMAK AV SALT, MYCKET SALT, NGT BRÄCKT, NGT SALT, NGT. SALT, NGTSALT, NÅGON FORM AV SALT, ' +
                            N'NÅGOT BRÄCKT, NÅGOTSALT, NÅGT SALT, OBETYDL. SALT, OBETYDLIGT SALT, RISK FÖR SALT I OMR, RISK FÖR SALT, ' +
                            N'RISK FÖR SALTVATTEN, SALT IBLAND, SALT NÄR YTVATTENBRUNN SINAR, SALT SMAK, SALT, SALT-SÖTTVATTEN-GRÄNS, SALT4, ' +
                            N'SALTARE ÄN HAVET, SALTARE ÄN ÖSTERSJÖN, SALTAREÄNÖSTERSJÖN, SALTHALTEN HAR ÖKA, SALTHALTEN LIKA HÖG SOM NR:30840, ' +
                            N'SALTHALTIGT, SALTINTRÄNGNING, SALTPROPP, SALTRISK, SALTSMAK, SALTVATTEN, SALTVATTENTILLRINNING, SMAK AV SALT, ' +
                            N'STARK SMAK AV SALT, STENSALT, SVAG SALTSMAK, SVAG SMAK AV SALT SVAGSMAKAVSALT, SVAGT SALT, UPPGIFT ANSÅGS ORIMLIG, ' +
                            N'VATTNETHARENSTARKSMAKAVSALT, VATTNETSMAKADENÅGOTSALT, VATTNETÄRSALT, VIDPROVPUMPNINGENSMAKADEVATTNETNÅGOTBRÄCKT, ' +
                            N'YTTERST LITE SALT, hög kloridhalt, lite bräckt, något salt, salt-propp monterad,MG/L,CL/MG,MG/L CL'
declare @saltiga table (name nvarchar(max))
insert into @saltiga
SELECT distinct ltrim(SplitValue) FROM (select toSplit from @toSplit) q
    Cross Apply (Select Seq        = Row_Number() over (Order By (Select null))
		      , SplitValue = v.value('(./text())[1]', 'varchar(max)')
		 From (values (convert(xml, @stringSplitVar2 +
					    replace(toSplit, @stringSplitDelim, @stringSplitVar1 + @stringSplitVar2) +
					    @stringSplitVar1))) x(n)
		     Cross Apply n.nodes('x') node(v)) B
					   where SplitValue is not null;
delete from @toSplit where toSplit is not null
insert into @toSplit select N'ej salt,' +
                            N'inget salt,' +
                            N'INGEN SMAK AV SALT,' +
                            N'INGEN SALT,' +
                            N'INGA FÖRHÖJDA KLORIDVÄRDEN UPPMÄTTA,' +
                            N'EJ BRÄCKT'
declare @NotSalted table (name nvarchar(max))insert into @NotSalted SELECT distinct ltrim(SplitValue) FROM (select toSplit from @toSplit) q Cross Apply (Select Seq        = Row_Number() over (Order By (Select null)) , SplitValue = v.value('(./text())[1]', 'varchar(max)') From (values (convert(xml, @stringSplitVar2 + replace(toSplit, @stringSplitDelim, @stringSplitVar1 + @stringSplitVar2) + @stringSplitVar1))) x(n) Cross Apply n.nodes('x') node(v)) B where SplitValue is not null;delete from @toSplit where toSplit is not null;
declare @saltigaCorrect table (name nvarchar(max),Correction nvarchar(max))

declare @saltigaMgConv table (name nvarchar(max),mgL float)
declare @geofas table (geofas int, id bigint)
declare @selected table (id bigint, lage nvarchar(254), TN nvarchar(254), TJ nvarchar(254), TATNING nvarchar(254), ANVANDNING nvarchar(254), GRUNDVATTE nvarchar(254), BOTTENDIAM numeric(38,8), TOTALDJUP nvarchar(254), NIVADATUM numeric(38,8), shape geometry, ORT nvarchar(254), VATTENMANG numeric(38,8), DJUP_TILL_ nvarchar(254), RORBORRNIN numeric(38,8), OBJECTID_1 int, BRUNNS_ID numeric(38,8), LAGESNOGGR numeric(38,8), STALFODERR nvarchar(254), PLASTFODER numeric(38,8), BORRDATUM numeric(38,8), GDB_GEOMATTR_DATA varbinary(8000), fastighets nvarchar(4000), anm nvarchar(254), gv float(24), tdjup float(24), djupTil float(24), slafoderr float(24))

insert into @selected select row_number() over (order by %%physloc%%) id, lage, TN, TJ, TATNING, ANVANDNING,GRUNDVATTE,BOTTENDIAM,TOTALDJUP, NIVADATUM,  shape,ORT,VATTENMANG,DJUP_TILL_, RORBORRNIN,OBJECTID_1, BRUNNS_ID, LAGESNOGGR,STALFODERR,PLASTFODER, BORRDATUM, GDB_GEOMATTR_DATA,iif(charindex(ort,fastighets,0) > 0,replace(fastighets,ort+' ',''),fastighets) fastighets,nullif(anmarkning, '')  anm, isNull(try_cast(GRUNDVATTE as float), nullif(GRUNDVATTE,'')) gv, isNull(try_cast(TOTALDJUP as float), nullif( TOTALDJUP,'')) tdjup, isNull(try_cast(DJUP_TILL_ as float), nullif( DJUP_TILL_,'')) djupTil, isNull(try_cast(STALFODERR as float), nullif( STALFODERR,'')) slafoderr from  sde_extern.gng.BRUNNSARKIV202106_P

; --fastighets korrigering, visst gissande
with
    fas as (select fa.FNR, fa.BETECKNING, fa.TRAKT, yt.Shape from sde_geofir_gotland.gng.FA_FASTIGHET fa inner join sde_gsd.gng.REGISTERENHET_YTA yt on fa.FNR = yt.FNR_FDS)
    ,selected  as (select * from @selected)
    ,Geofastigheted as (select fnr geofas,fastighets,id,ort,LAGE from  selected b left outer join fas on fas.Shape.STIntersects(b.shape) = 1)
    ,fastighetedx as (select coalesce(geofas,fnr) geofas,fastighets,id, ort,	LAGE from geoFastigheted left outer join sde_geofir_gotland.gng.FA_FASTIGHET fas on fas.beteckning = fastighets)
    ,fastighetedq as (select coalesce(geofas,fnr) geofas,fastighets,id, ort, LAGE from fastighetedx left outer join sde_geofir_gotland.gng.FA_FASTIGHET fas on fas.beteckning = ort + ' ' + fastighets)
    ,FasWithSockenAndBetUtanSocken as (SELECT iif(charindex(' ',trakt) > 0, left(trakt,charindex(' ',trakt)),trakt) socken, right(beteckning,len(beteckning)-len(iif(charindex(' ',trakt) > 0, left(trakt,charindex(' ',trakt)),trakt))-1) betUtanSocken,* FROM sde_geofir_gotland.gng.FA_FASTIGHET)
    ,FasWithSockenAndBetUtanSockenX as (select coalesce(geofas, fnr) geofas, fastighets, id, ort, LAGE from fastighetedq left outer join fasWithSockenAndBetUtanSocken on betUtanSocken = iif(len(fastighets) < 6, ort + ' ' + fastighets, fastighets) AND (geofas is null and fastighets != '' and charindex(':', fastighets) > 0 and len(fastighets) > 4))
    ,FasUtanSockenX as (select coalesce(geofas, fnr) geofas, fastighets, id, ort, LAGE from FasWithSockenAndBetUtanSockenX left outer join fasWithSockenAndBetUtanSocken on betUtanSocken = isnull(case when charindex(' ',fastighets,1+isnull(nullif(charindex(' ',fastighets),0),len(fastighets))) > 0 then right(fastighets,isnull(nullif(len(fastighets)-charindex(' ',fastighets),0),1) ) end,'') AND (geofas is null AND fastighets != ' ' ))

insert into @geoFas select geofas,id from FasUtanSockenX
declare @splitInwords table
(
	cbID bigint,
	Seq bigint,
	SplitValue varchar(max),
 	UNIQUE CLUSTERED (cbID,Seq)
 	 with (IGNORE_DUP_KEY = on)
)
;
 with
    selected as (select * from @selected)
    ,geoFas as (select geofas,id cbID from @geoFas)

    ,medSaltMgl as (select name SaltAnmarkning, 300 mgl from @saltiga)

	,medGeoFas as (select s.*, coalesce(f.cbID,s.id) cbID,geoFas from selected s left outer join geoFas f on f.cbID=s.id )

     ,MedSaltAnmarkningar as (select selected.*,s.saltAnmarkning,mgl
	    from medGeoFas selected
		left outer join medSaltMgl s on charindex(s.SaltAnmarkning,selected.anm) > 0
		left outer join @NotSalted ns on charindex(name,selected.anm ) > 0 where ns.name is null
			    )


    ,Ofarliga as (select cbID,replace(replace(anm,'<','+'),'>','-') toSplit from MedSaltAnmarkningar where saltAnmarkning is not null)
		--left outer join @farligaTecken ft on charindex(ft.name,qq.toSplit) >
    ,splitInwords as (select * FROM ofarliga q
       		Cross Apply (Select Seq        = Row_Number() over (Order By (Select null))
		      , SplitValue = v.value('(./text())[1]', 'varchar(max)')
		 From (values (convert(xml, @stringSplitVar2 +
					    replace(toSplit, ' ', @stringSplitVar1 + @stringSplitVar2) +
					    @stringSplitVar1))) x(n)
		     Cross Apply n.nodes('x') node(v)) B
					   where SplitValue is not null)

insert into @splitInwords (cbid,seq,splitvalue)
	select cbId,seq,splitvalue from splitInwords


;
declare @scope integer = 3;
with
    SaltIdentified as (select * from @splitInwords sw left outer join @saltiga s on sw.splitValue = s.name)

    ,saltRef as (select distinct cbID,seq from SaltIdentified where name is not null)
 	-- do we need any other words than does inside of the indentified?
    ,limitWordsRoundsalt as (
    		select s.cbid,s.seq,s.splitvalue from @splitInwords s inner join saltRef r on s.cbid = r.cbid
        		where s.seq between r.seq-@scope and  r.seq+@scope
    )
    ,nrIdentified as (select sw.cbID,sw.Seq,s.splitvalue from limitWordsRoundsalt sw inner join @splitInwords s on sw.cbid = s.cbid where try_cast(s.splitValue as float) is not null )

   ,filteredByContainingNrs as (select * from nrIdentified )

     ,prePrePre as 	(select distinct s.* from limitWordsRoundsalt s inner join saltRef sr on s.cbId = sr.cbId AND s.seq = sr.seq-3)
    ,prePre as 		(select distinct s.* from limitWordsRoundsalt s inner join saltRef sr on s.cbId = sr.cbId AND s.seq = sr.seq-2)
    ,pre as 		(select distinct s.* from limitWordsRoundsalt s inner join saltRef sr on s.cbId = sr.cbId AND s.seq = sr.seq-1)
    ,post as 		(select distinct s.* from limitWordsRoundsalt s inner join saltRef sr on s.cbId = sr.cbId AND s.seq = sr.seq+1)
    ,postPost as 	(select distinct s.* from limitWordsRoundsalt s inner join saltRef sr on s.cbId = sr.cbId AND s.seq = sr.seq+2)
    ,postPostPost as 	(select distinct s.* from limitWordsRoundsalt s inner join saltRef sr on s.cbId = sr.cbId AND s.seq = sr.seq+3)

   ,betweexy as (
    select si.cbid
	 , pp.splitValue   a
	 , p.splitValue    b
	 , si.name	   c
	 , po.splitValue   d
	 , poPo.splitValue e
	 , pp.seq          aSeq
	 , p.seq           bSeq
	 , si.seq	   cSeq
	 , po.seq          dSeq
	 , poPo.seq        eSeq
    from SaltIdentified si
    		left outer join pre p on p.cbId = si.cbId And p.seq < si.seq
    		left outer join prePre pp on pp.cbId = si.cbId And pp.seq < si.seq
    		left outer join post po on po.cbId = si.cbId And po.seq > si.seq
    		left outer join postPost poPo on poPo.cbId = si.cbId And popo.seq > si.seq
      where si.name is not null
      and coalesce(pp.splitValue,p.splitValue,po.splitValue,popo.splitValue) is not null
      and (cast(pp.Seq+p.seq+si.seq+po.seq+popo.seq as float)/cast(si.seq as float)) = 5
    )

,betweexxest as (select distinct * from  betweexy where c is not null
      and coalesce(a,b,d,e) is not null
      --and ppv != pv ANd poV != popoV
      and (cast(aSeq+bseq+cseq+dseq+eseq as float)/cast(cseq as float)) = 5)

,centeredRoundNumber as (select s.cbid
     , case nr.seq when eseq then c when dseq then b end                                   as prepre
     , case nr.seq when bseq then a when dseq then c when eseq then d end                  as pre
     , case nr.seq when aseq then a when bseq then b when dseq then d when eseq then e end as val
     , case nr.seq when aseq then b when bseq then c when dseq then e end                  as post
     , case nr.seq when aseq then c when bseq then d end                                   as postpost
from betweexy s
    inner
    join nrIdentified nr on s.cbID = nr.cbId AND nr.seq in (aseq, bseq, dSeq, eSeq))

select * from (select DISTINCT 
       case when (pre in('klorid','cl','salt','KLORIDHALT','KLORID,' )) and (post = 'mg/l' or post = 'mg/l.' or post = 'mg/l,') then val end clmgl,

       * from centeredRoundNumber) first where clmgl is null
	order by
	         ((case when prepre is null then 0 else 1 end)+(case when pre is null then 0 else 1 end)+
	          (case when post is null then 0 else 1 end)+(case when postpost is null then 0 else 1 end)) desc
	         ,prepre desc,pre desc,post desc,postpost desc


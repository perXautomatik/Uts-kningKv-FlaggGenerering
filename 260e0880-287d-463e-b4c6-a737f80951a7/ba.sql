--todo, split up into tempTables with run configuraiton.

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
                            N'STARK SMAK AV SALT, STENSALT, SVAG SALTSMAK, SVAG SMAK AV SALT, SVAGSMAKAVSALT, SVAGT SALT, UPPGIFT ANSÅGS ORIMLIG, ' +
                            N'VATTNETHARENSTARKSMAKAVSALT, VATTNETSMAKADENÅGOTSALT, VATTNETÄRSALT, VIDPROVPUMPNINGENSMAKADEVATTNETNÅGOTBRÄCKT, ' +
                            N'YTTERST LITE SALT, hög kloridhalt, lite bräckt, något salt, salt-propp monterad,MG/L,CL/MG,MG/L CL,NÅGOT SALT' +
                            N',LITE SALTVATTEN'
declare @saltiga table (name nvarchar(80) not null
,length integer
 UNIQUE CLUSTERED (name,length) with (IGNORE_DUP_KEY = on)
)
insert into @saltiga
SELECT ltrim(SplitValue),len(ltrim(SplitValue)) FROM (select toSplit from @toSplit) q
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

insert into @selected select row_number() over (order by %%physloc%%) id,
      lage, TN, TJ, TATNING, ANVANDNING,GRUNDVATTE,BOTTENDIAM,TOTALDJUP, NIVADATUM,  shape,ORT,VATTENMANG,DJUP_TILL_,
       RORBORRNIN,OBJECTID_1, BRUNNS_ID, LAGESNOGGR,STALFODERR,PLASTFODER, BORRDATUM, GDB_GEOMATTR_DATA,
       iif(charindex(ort,fastighets,0) > 0,
       replace(fastighets,ort+' ',''),fastighets) fastighets,
       nullif(anmarkning, '')  anm,
       isNull(try_cast(GRUNDVATTE as float), nullif(GRUNDVATTE,'')) gv, isNull(try_cast(TOTALDJUP as float), nullif( TOTALDJUP,'')) tdjup,
       isNull(try_cast(DJUP_TILL_ as float), nullif( DJUP_TILL_,'')) djupTil, isNull(try_cast(STALFODERR as float), nullif( STALFODERR,'')) slafoderr
from  sde_extern.gng.BRUNNSARKIV202106_P

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

insert into @geoFas select geofas,id from FasUtanSockenX declare @splitInwords table ( cbID bigint, Seq bigint, SplitValue varchar(max), UNIQUE CLUSTERED (cbID,Seq) with (IGNORE_DUP_KEY = on) )
; --preparingTosplitintoWords
 with
    selected as (select * from @selected)
    ,geoFas as (select geofas,id cbID from @geoFas)
    ,medSaltMgl as (select name SaltAnmarkning, 300 mgl from @saltiga)
    ,medGeoFas as (select s.*, coalesce(f.cbID,s.id) cbID,geoFas from selected s left outer join geoFas f on f.cbID=s.id )
    ,MedSaltAnmarkningar as (select selected.*,s.saltAnmarkning,mgl from medGeoFas selected
        left outer join medSaltMgl s
            on charindex(rtrim(ltrim(s.SaltAnmarkning)),selected.anm) > 0 left outer join @NotSalted ns on charindex(name,selected.anm ) > 0 where ns.name is null)
    ,Ofarliga as (select cbID,replace(replace(anm,'<','+'),'>','-') toSplit from MedSaltAnmarkningar where saltAnmarkning is not null)
    ,splitInwords as (select * FROM ofarliga q Cross Apply (Select Seq        = Row_Number() over (Order By (Select null)), SplitValue = v.value('(./text())[1]', 'varchar(max)')From (values (convert(xml, @stringSplitVar2 + replace(toSplit, ' ', @stringSplitVar1 + @stringSplitVar2) + @stringSplitVar1))) x(n)Cross Apply n.nodes('x') node(v)) B where SplitValue is not null)

insert into @splitInwords (cbid,seq,splitvalue)select cbId,seq,splitvalue from splitInwords;

declare @scope integer = 3;
declare @saltOkOrdOmkring table (cbid bigint, seq bigint, splitvalue varchar(400) UNIQUE CLUSTERED (cbID,Seq,splitvalue) with (IGNORE_DUP_KEY = on));
with
    SaltIdentified as (select * from @splitInwords sw left outer join @saltiga s on sw.splitValue = s.name)
    ,saltRef as (select distinct cbID,seq from SaltIdentified where name is not null)
 	-- do we need any other words than does inside of the indentified?
    ,limitWordsRoundsalt as (
    		select s.cbid,s.seq,s.splitvalue from @splitInwords s inner join saltRef r on s.cbid = r.cbid
        		where s.seq between r.seq-@scope and  r.seq+@scope
    )
insert into @saltOkOrdOmkring select * from limitWordsRoundsalt;

with
	 nrIdentified as (select distinct sw.cbid, sw.seq,
	                 try_cast(replace(sw.splitvalue,',','.') as float) splitvalue
			  from
			   (
			       select
			              IIF(isnumeric(sw.splitValue) = 0,

			                  iif( isnumeric(left(sw.splitValue, len(sw.splitvalue) - 1)) = 0,
					       IIF(isnumeric(replace(sw.splitValue, 'mg/l', '')) = 0,
						   replace(sw.splitValue, 'm', ''), replace(sw.splitValue, 'mg/l', '')),
			                      left(sw.splitValue, len(sw.splitvalue) - 1)),
					  sw.splitvalue) splitvalue
			              ,sw.cbid, sw.seq
			       from @saltOkOrdOmkring sw


			       where isnumeric(sw.splitValue)+
			             isnumeric(left(sw.splitValue,len(sw.splitvalue)-1))+
			             isnumeric(case when charindex(sw.splitValue, 'mg/l') > 1 then replace(sw.splitValue, 'mg/l','') end)+
				     isnumeric(case when charindex(sw.splitValue, 'm') > 1 then replace(sw.splitValue, 'm','') end)
			                 > 0

			       ) sw			  )
	,centeredRoundNumber as (
select nr.cbid,
       nr.nrPos seq,
       cast(a.splitvalue as nvarchar) preprepre,
       cast(b.splitvalue as nvarchar) prepre,
       cast(c.splitvalue as nvarchar) pre,
       cast(nr.nr as float) val,
       cast(e.splitvalue as nvarchar) post,
       cast(f.splitvalue as nvarchar) postpost,
       cast(g.splitvalue as nvarchar) postpostpost

    from (select cbid,seq nrPos,splitvalue nr from nrIdentified ) nr
	left outer join @saltOkOrdOmkring a on nr.cbid=a.cbid and a.seq = nr.NrPos-3
	    left outer join @saltOkOrdOmkring b on nr.cbid=b.cbid and b.seq = nr.NrPos-2
	    left outer join @saltOkOrdOmkring c on nr.cbid=c.cbid and c.seq = nr.NrPos-1
	left outer join @saltOkOrdOmkring e on nr.cbid=e.cbid and e.seq = nr.NrPos+1
	    left outer join @saltOkOrdOmkring f on nr.cbid=f.cbid and f.seq = nr.NrPos+2
	    left outer join @saltOkOrdOmkring g on nr.cbid=g.cbid and g.seq = nr.NrPos+3
    )
, centeredRoundNumbersWithShort as (select *, cast(IIF(	pre in ('salthalt', 'salt-ca', 'klorid', N'BRÄCKT', 'cl','klorid', 'salt', 'KLORIDHALT','cl=', 'KLORIDHALTEN',N'SALT.', N'SALT,', N'BRÄCKT,CA', N'BRÄCKT,'
                                                               															       ), 1, 0) as boolean)  preSalt
                                             ,cast(IIF(	left(post,4) in ('mg/l',N'järn')												, 1, 0) as boolean)  postMgl
					     ,cast(IIF( prepre in ('KLORIDHALT', 'KLORID', 'KLORIDHALTEN', 'cl',N'SALTHALT',N'CL.', N'SALT')								, 1, 0) as boolean)  prepreSalt
					     ,cast(IIF( postPost in ('cl', 'klorid', 'klorid.', 'cl.')											, 1, 0) as boolean)  postPostSalt
from centeredRoundNumber)

	, IdentifieraKlorid as (select DISTINCT *
				from (select case when (((preSalt Or (pre in ('CA', 'C:A') and (prepreSalt=1 OR right(prepre, 1) in ('.', ',') and postMgl = 1 and postPostSalt = 1))
				                              or
							(pre in (N'över', '=') And PrepreSalt=1))
				                             and
							 postMgl = 1) or (postMgl = 1 and ((preSalt = 1 or
											    (pre = '-' and prepre in (N'KLORID', N'CL')) and
											    coalesce(postpost, postpostpost) is null) or
											   postpostSalt=1 or
											   ((postPostSalt=1 and
											     right(pre, 1) in ('.', ',') or
											     seq = 1)) or
											   (postpost = 'klorid' and postpostpost is null)))

		    or (						prepre = '(troligen' 			and	pre = 'Ca' 									and coalesce(post,postpost,postpostpost) is null)
		    or (												preSalt = 1	and post = 'CA' 	and postpostpost = 'mg/l' )
		    or (												preSalt = 1	and post in ('under','u'))
		    or (						right(prepre, 1) in ('.', ',') 	     	and	preSalt = 1	)
		    or (												preSalt = 1	and postMgl=1)
		    or (						(prepre ='vatten' Or prepreSalt=1) 	and 	pre = 'ca' 						and postMgl=1)
                    or (						prepre = 'kloridhalten' 		and	pre=  N'högre' 						and postMgl=1)
                    or ( left(preprepre,len('klorid')) = 'klorid' and	prepre in( N'uppmätt',N'överstiger')	and	pre in('ej','till') 					and postMgl=1)
                    OR (						prepre = N'EFTER' 			and	pre = 'DET' 						and left(post,4)='mg/l')
                    or (												seq=1 							and post='cl/mg')

                    ) then val
			  end clmgl,cbid
			  from centeredRoundNumbersWithShort) a
    	where clmgl is not null
    )
   , identifieraDjup as (
       select * from (select case when
           ( 1=0
	       or	(													pre in ('vid', N'på', 'efter', 'cl','till',N'över')												and coalesce(post, postpost, postpostpost) is null)
               or  	(													pre in ('vid', N'på', 'efter', 'cl','till',N'över') 	and (left(post, 1) = 'm' and (substring(post, 2, 1) in ('.', ',') OR len(post) = 1)) 	and postpost in (N'NÅGOT','delvis','lite','sedan') OR postpost in ('salt', N'BRÄCKT.',N'BRÄCKT'))
               or 	(													pre in ('vid', N'på', 'efter', 'cl','till',N'över')												and 'salt' in (post,postpost))
	       or	(						prepre in ('vatten', N'ökning','tryckt')  and 		pre in ('vid', N'på', 'efter', 'cl','till',N'över')												and postpost in (N'NÅGOT','delvis','lite','sedan') OR postpost in ('salt', N'BRÄCKT.',N'BRÄCKT'))

               or  	(preprepre in ('klorid', 'cl', 'salt' )   and								pre = 'mg/l' 						and (left(post, 1) = 'm' and (substring(post, 2, 1) in ('.', ',') OR len(post) = 1)))
	       or	(left(preprepre,len('klorid')) = 'klorid' and								pre = 'mg/l' 						and (left(post, 1) = 'm' and (substring(post, 2, 1) in ('.', ',') OR len(post) = 1)))
               or	(preprepre = N'för' 		and		prepre in (N'SALTVATTEN', N'BRÄCKT', N'SALT') and	pre in ('vid', N'på', 'efter', 'cl','till',N'över') 	and (left(post, 1) = 'm' and (substring(post, 2, 1) in ('.', ',') OR len(post) = 1)))
               or  	(preprepre in ('klorid', 'cl', 'salt' )   and								pre = 'mg/l' 						and 											coalesce(post, postpost, postpostpost) is null)
               or 	(preprepre in ('klorid', 'cl', 'salt' )   and	prepre = N'på' 				and		pre = 'ca' )
               or 	(						prepre in (N'SALTVATTEN', N'BRÄCKT', N'SALT') and 	pre in ('vid', N'på', 'efter', 'cl','till',N'över') 	)
	       or 	(													pre= 'saltvatten' and  seq = 2)
	


               ) then val
					  end clVidM,cbid
			  from centeredRoundNumber) b
       	where clVidM is not null
	)

	,IdentifiedNumbers as (select distinct c.cbid,clmgl, clvidm from centeredRoundNumber c left outer join IdentifieraKlorid k on k.cbid = c.cbid left outer join identifieraDjup d on d.cbid = c.cbid)
       ,unidentifiedNumbers as (select c.*,case when val is null then
           (
               select top 1 splitvalue from
                    @saltOkOrdOmkring soo
               where c.cbid = soo.cbid and c.seq = soo.seq order by len(splitvalue) desc )
           end valN from centeredRoundNumber c left outer join(select cbid,clmgl, clvidm from IdentifiedNumbers where coalesce(clmgl, clvidm) is not null) inn on inn.cbid = c.cbid where inn.cbid is null)

	--select * from unidentifiedNumbers order by (case when val is null then 0 else 1 end) desc, pre desc, post desc, seq, ((case when preprepre is null then 0 else 1 end)+ (case when prepre is null then 0 else 1 end)+ (case when pre is null then 0 else 1 end) + (case when post is null then 0 else 1 end)+ (case when postpost is null then 0 else 1 end)+ (case when postpostpost is null then 0 else 1 end)) desc, right(pre, 1) desc,prepre desc, postpost desc
	,sa as (select clmgl, clvidm,
       (select top 1 splitvalue from
            (select salt.name splitvalue,cbid from @saltOkOrdOmkring inner join @saltiga salt on splitValue = salt.name) sa
       		    where sa.cbid=u.cbid ) saltAnm,
       cbid from identifiedNumbers u)

   select OBJECTID_1,clmgl, clvidm,saltAnm,anm,fastighets,GRUNDVATTE,TOTALDJUP,DJUP_TILL_,VATTENMANG,BOTTENDIAM,
          ANVANDNING,STALFODERR,NIVADATUM,lage,id, TN, TJ, TATNING, shape,ORT, RORBORRNIN,BRUNNS_ID, LAGESNOGGR,
          STALFODERR,PLASTFODER, BORRDATUM, GDB_GEOMATTR_DATA
from @selected s left outer join sa on sa.cbid=s.id
	order by IIF(OBJECTID_1 in (1308, 3269, 4727, 8028, 2791, 398, 1511, 5152, 4075, 1618, 71360, 2007, 2063, 2059, 8206, 6558,
		      6877, 6545, 6881), 1, 0)
	desc , IIF(saltAnm is not null, 1, 0) desc, IIF(coalesce(clmgl, clvidm) is not null, 1, 0)
		,saltAnm
		desc









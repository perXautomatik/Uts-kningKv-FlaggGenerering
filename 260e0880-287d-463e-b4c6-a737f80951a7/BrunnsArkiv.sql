declare @stringSplitVar1 varchar(10) = '</x>';
declare @stringSplitVar2 varchar(10) = '<x>';
declare @stringSplitDelim varchar(10) = ',';
declare @toSplit table (toSplit nvarchar(max));
declare @farligaTecken table (name nvarchar);
insert
into @farligaTecken
select '!' a union select '&' a union select '(' a union select ')' a
union select '+' a union select '/' a union select ':' a
union select ';' a union select '<' a union select '=' a
union select '>' a union select '?' a

insert into @toSplit select 'EJ SALT,INGEN SMAK AV SALTVATTEN,INGET SALTVATTEN,RIKLIGT MED GOTT VATTEN. EJ SALT,'


declare @vanliga table (name nvarchar(max));
insert
into @vanliga
SELECT distinct SplitValue
FROM (select toSplit from @toSplit) q
    Cross Apply (Select Seq        = Row_Number() over (Order By (Select null))
		      , SplitValue = v.value('(./text())[1]', 'varchar(max)')
		 From (values (convert(xml, @stringSplitVar2 +
					    replace(toSplit, @stringSplitDelim, @stringSplitVar1 + @stringSplitVar2) +
					    @stringSplitVar1))) x(n)
		     Cross Apply n.nodes('x') node(v)) B
;
delete from @toSplit where toSplit is not null;

insert into @toSplit select N'SALT,BRÄCKT,SALTVATTEN,SALTARE,SALTRISK,SALTSMAK,ANINGENSALT,BRÄCKTVATTEN,ENANINGBRÄCKT,KLORID,LITESALT,NGTSALT,NÅGOTSALT,SALT4,' +
                            N'SALTHALTIGT,SALTVATTENTILLRINNING,STENSALT,SVAGSMAKAVSALT,VATTNETHARENSTARKSMAKAVSALT,VATTNETSALTAREÄNÖSTERSJÖN,VATTNETSMAKADENÅGOTSALT,' +
                            N'VATTNETÄRSALT,VIDPROVPUMPNINGENSMAKADEVATTNETNÅGOTBRÄCKT,'

declare @saltiga table (name nvarchar(max));
insert
into @saltiga
SELECT distinct SplitValue
FROM (select toSplit from @toSplit) q
    Cross Apply (Select Seq        = Row_Number() over (Order By (Select null))
		      , SplitValue = v.value('(./text())[1]', 'varchar(max)')
		 From (values (convert(xml, @stringSplitVar2 +
					    replace(toSplit, @stringSplitDelim, @stringSplitVar1 + @stringSplitVar2) +
					    @stringSplitVar1))) x(n)
		     Cross Apply n.nodes('x') node(v)) B
;
delete from @toSplit where toSplit is not null
;
declare @numberSeries table (i integer)
;

WITH
        generate_series(value) AS
        ( SELECT 1
		UNION ALL
	 SELECT value + 1 FROM
	 generate_series WHERE value + 1 <= 100 )
insert into @numberSeries
    select * from generate_series
;
with

    --fromated as (select IIF(fas.beteckning like '%' + fastighets + '%', fas.beteckning, case when fas.beteckning is null then FASTIGHETS else fas.beteckning + ' (' + fastighets + ')' end) geofas, b.*from (select rtrim(nullif(isNull(IIF(fastighets like '%' + ORT + '%', FASTIGHETS, isnull(nullif(ort + ' ', ' '), '') + fastighets), ' '), '')) fastighets, lage, TN, isNull(try_cast(GRUNDVATTE as float), GRUNDVATTE) gv, isNull(try_cast(TOTALDJUP as float), TOTALDJUP) tdjup, TJ, isNull(try_cast(DJUP_TILL_ as float), DJUP_TILL_) djupTil, isNull(try_cast(STALFODERR as float), STALFODERR) slafoderr, TATNING, ANVANDNING, ANMARKNING, shape from sde_extern.gng.BRUNNSARKIV202106_P) b left outer join(select fa.FNR, fa.BETECKNING, fa.TRAKT, yt.Shape from sde_geofir_gotland.gng.FA_FASTIGHET fa inner join sde_gsd.gng.REGISTERENHET_YTA yt on fa.FNR = yt.FNR_FDS) fas on fas.Shape.STIntersects(b.shape) = 1)
    fromated  as (select * from sde_extern.gng.BRUNNSARKIV202106_P)
    ,selected  as (select nullif(anmarkning, '')  anm from  fromated)
   ,FilterVanliga as (select anm from selected left outer join (select * from @vanliga) q on selected.anm = q.name where anm is not null AND q.name is null)
    ,Tecken as (select charz,count(*) c from (select anm,substring(anm,i,1) charz from (select * from filterVanliga where len(anm) <= 100) q inner join @numberSeries N on n.i <= len(q.anm)) q group by charz)
   ,filterFarligaTecken as (select * from filterVanliga left outer join @farligaTecken on charIndex(name,anm) > 0 where name is null)
   ,endastOrd as (select * from
    (select anm toSplit from filterFarligaTecken) q
	Cross Apply (Select Seq = Row_Number() over (Order By (Select null))
			  , ord = v.value('(./text())[1]', 'varchar(max)')
		     From (values (convert(xml, @stringSplitVar2 +
						replace(replace(replace(toSplit, ',' ,'.'), '.' ,' '), ' ', @stringSplitVar1 + @stringSplitVar2) +
						@stringSplitVar1))) x(n)
			 Cross Apply n.nodes('x') node(v)) B)
    ,OnlySaltiga as (select * from endastOrd inner join @saltiga s on s.name = ord )
    ,filterSaltiga as (select fv.* from filterVanliga fv left outer join OnlySaltiga on anm = toSplit where toSplit is null)

   ,selected2 as  (select *,charindex(vs, anm) vv,charindex(ps, anm) vp,charindex(ps+' ca', anm) vpp from  (select anm,'vatten vid' vs,'vatten på' ps from  filterSaltiga) q)

   ,vattenvid as (select coalesce(rtrim(ltrim(case when vv > 0 then substring(anm, vv + len(vs), 5)end)),rtrim(ltrim(case when vp > 0 then substring(anm, vp + len(ps + IIF(vpp != 0, ' ca', '')), 5) end))) vatten_vid, * from selected2)
   , formated2 as (select isnull( replace( anm, concat( case when vv != 0 then vs else case when vp != 0 then ps end end ,' ', cast(vatten_vid as nvarchar(max))) ,''),anm ) anm,vatten_vid from vattenvid)
    ,nullIfAnmIsEmpty as (select nullif(ltrim(anm),'') anm, vatten_vid from formated2)
    ,WithChar1N2 as (select substring(anm,1,1) char1,substring(anm,2,1) char2,* from nullIfAnmIsEmpty)
    -- not quit right, seems to not handle substring(x,1,len(x))
   ,FirstTwoTrimmed as (select nullif(ltrim(substring(anm, (IIF(char1 in (',', '.', '-'), IIF(char2 = ' ', 2, 1), 0)), len(anm)+1)), '') anm,anm anm2,char1,vatten_vid, IIF(char2 = ' ', 2, 1) qx from WithChar1N2)
   ,FilterVanliga2 as (select anm from firstTwoTrimmed left outer join (select * from @vanliga union select * from @saltiga) q on firstTwoTrimmed.anm = q.name where anm is not null AND q.name is null)
   ,filterNumber as ( select anm from
         filterSaltiga left outer join
             (select convert(nvarchar,nr) nrz from  (select top 10 i nr from @numberSeries) qzs ) qz
                 on charIndex(nrz,anm) > 0 where nrz is null)
   ,WithNumber as ( select anm from filterSaltiga left outer join
             (select convert(nvarchar,nr) nrz from  (select top 10 i nr from @numberSeries) qzs ) qz
            on charIndex(nrz,anm) > 0 where nrz is not null)

,countz as (select anm,count(*) c from filterNumber

group by anm
--order by c desc,anm
    )
   select * from countz order by c desc




          --------------

,countOrd as ( select splitValue, avg(seq) AvgSeq,count(*) c from endastOrd where splitValue is not null group by splitValue)

select * from filterNumber where
anm like '%SALTVATTEN%' OR
anm like N'%BRÄCKT%'


   select * from countOrd order by c desc

,Meningar as (select * from
    (select replace(replace(anm, char(34) ,'|'), '/' ,'|') toSplit from withNumber) q
	Cross Apply (Select Seq        = Row_Number() over (Order By (Select null))
			  , SplitValue = v.value('(./text())[1]', 'varchar(max)')
		     From (values (convert(xml, @stringSplitVar2 +
						replace(replace(toSplit, ',' ,'.'), '.', @stringSplitVar1 + @stringSplitVar2) +
						@stringSplitVar1))) x(n)
			 Cross Apply n.nodes('x') node(v)) B)
---select * from filterNumber where anm like N'%BRÄCKT%'
,meningarz as (select toSplit anm, ltrim(splitValue) mening  from Meningar)

select mening,count(*) c from meningarz group by mening
order by c desc




select char(34)

select anm,count(*) c from withNumber group by anm
order by c desc
--where charindex(' ',anm) = 0
    --and charindex(N'br',anm) != 0


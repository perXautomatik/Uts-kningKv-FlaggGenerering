declare @rodDatum datetime = DATETIME2FROMPARTS(2006, 10, 1, 1, 1, 1, 1, 1);
declare @socknar table (socken nvarchar(70))

insert into @socknar select * from (Select N'Källunge' "socken"
     Union
     Select 'Vallstena' as alias2
     Union
     Select N'Hörsne' as alias234567
     Union
     Select 'Bara' as alias23
     Union
     Select 'Norrlanda' as alias234
     Union
     Select 'Stenkyrka' as alias2345
     )asdasd
;

declare @fastighetsYtor table (SockenX nvarchar(70), FAStighet nvarchar(100), Shape geometry);
declare @byggs table (Fastighetsbeteckning nvarchar(100), Byggnadstyp nvarchar(100), bygTot int,flagga geometry);

declare @slamz table (statusx nvarchar(30), FAStighet nvarchar(100), Diarienummer nvarchar(100), Fastighet_tillstand nvarchar(150), Beslut_datum datetime, utförddatum datetime, Anteckning nvarchar(254), AnlaggningsPunkt geometry);
declare @egetomh table (fastighet nvarchar(100), egetOmhändertangandeInfo nvarchar(4000));
declare @va table (fastighet nvarchar(100), typ nvarchar(273));

with
fasinnomSocken as (SELECT socken SockenX,BETECKNING FAStighet, Shape from (select fa.FNR,fa.BETECKNING , fa.TRAKT, yt.Shape from sde_geofir_gotland.gng.FA_FASTIGHET fa inner join sde_gsd.gng.REGISTERENHET_YTA yt on fa.FNR = yt.FNR_FDS) x inner join
     @socknar socknarOfIntresse  on left(x.TRAKT, len(socknarOfIntresse.socken)) = socknarOfIntresse.socken ) qtz

insert into @fastighetsYtor select * from fasInnomSocken
;
--byggs
with fastighetsYtor as (select * from  @fastighetsYtor)
 ,byggnad_yta as (select andamal1 Byggnadstyp, Shape from sde_gsd.gng.BYGGNAD),
        q as (Select Byggnadstyp, fastighetsYtor.fastighet Fastighetsbeteckning, byggnad_yta.SHAPE from byggnad_yta
            inner join fastighetsYtor on byggnad_yta.Shape.STWithin(fastighetsYtor.shape) = 1)
,withRownr as (select *, count(shape) over (partition by Fastighetsbeteckning) bygTot, row_number() over (partition by Fastighetsbeteckning order by Byggnadstyp ) orderz from q)
,byggs 
	as (        select Fastighetsbeteckning, Byggnadstyp,bygTot,shape from withRownr where orderz = 1 )
insert into @byggs select * from 
				byggs

;
with      fastighetsYtor    as (select * from  @fastighetsYtor)
	, socknarOfIntresse as (select * from @socknar)
        , AnSoMedSocken     as (select left(Fastighet_tillstand, IIF(charindex(' ', Fastighet_tillstand) = 0, len(Fastighet_tillstand) + 1, charindex(' ', Fastighet_tillstand)) - 1) socken,Diarienummer,Fastighet_tillstand z,Beslut_datum,Utford_datum,Anteckning,Shape anlShape from sde_miljo_halsoskydd.gng.ENSKILT_AVLOPP_sodra_P)
        , AnNoMedSocken     as (select left(Fastighet_tillstand, IIF(charindex(' ', Fastighet_tillstand) = 0, len(Fastighet_tillstand) + 1, charindex(' ', Fastighet_tillstand)) - 1) socken,Diarienummer,Fastighet_tillstand z,Beslut_datum,Utford_datum,Anteckning,Shape anlShape from sde_miljo_halsoskydd.gng.ENSKILT_AVLOPP_Norra_P)
        , AnMeMedSocken as (select left(Fastighet_tilstand, IIF(charindex(' ', Fastighet_tilstand) = 0, len(Fastighet_tilstand) + 1, charindex(' ', Fastighet_tilstand)) - 1) socken,Diarienummer,Fastighet_tilstand z,Beslut_datum,Utford_datum,Anteckning,Shape anlShape from sde_miljo_halsoskydd.gng.ENSKILT_AVLOPP_MELLERSTA_P)
   	, allaAv as (select socken, Diarienummer, z q, Beslut_datum, Utford_datum, Anteckning, anlShape from AnSoMedSocken union all select *from AnNoMedSocken union all select *from AnMeMedSocken)
	, geoAv as (select SockenX socken, Diarienummer, fastighetsYtor.FAStighet, Beslut_datum, Utford_datum, Anteckning, anlShape from (select *from allaAv where socken is null) UtanSocken inner join fastighetsYtor  on anlShape.STIntersects(fastighetsYtor.Shape) = 1)
       	, SammanSlagna as (select Diarienummer, q "Fastighet_tillstand",isnull(TRY_CONVERT(DateTime, Beslut_datum,102), DATETIME2FROMPARTS(1988, 1, 1, 1, 1, 1, 1, 1)) Beslut_datum, isnull(TRY_CONVERT(DateTime, Utford_datum,102), DATETIME2FROMPARTS(1988, 1, 1, 1, 1, 1, 1, 1)) Utford_datum, Anteckning, anlShape, z.q fastighet from (select * from allaAv union all select * from geoAv) z inner join socknarOfIntresse x on x.socken = z.socken)
	, slamz	as (select IIF(
       			(
       			  IIF(Beslut_datum < @rodDatum, 1, 0) +	IIF(Utford_datum < @rodDatum, 1, 0) +
			  IIF(Utford_datum is null, 1, 0)) > 0 , N'röd', 'ok') statusx,
	  FAStighet,Diarienummer,Fastighet_tillstand,Beslut_datum,Utford_datum "utförddatum",Anteckning,anlShape AnlaggningsPunkt from SammanSlagna)


insert into @slamz
 select *from slamz
;
--select * from @slamz where FAStighet = N'Hörsne nybjärs 1:20'
;

   with fastighetsYtor as (select * from  @fastighetsYtor)
      , LOKALT_SLAM_P as (select Diarienr, (case
	   when charindex(':', Fastighet_) <> 0 then Fastighet_
	   when charindex(':', Fastighe00) <> 0 then Fastighe00
	   when charindex(':', Lokalt_omh) <> 0 then Lokalt_omh end
   ) Fastighet
           ,Fastighet_,Fastighe00,Lokalt_omh, Anteckning,Beslutsdat,Eget_omhän, shape,
             concat(	nullif(sde_miljo_halsoskydd.gng.MoH_Slam_Lokalt_p_evw.Lokalt_omh,' '), ' ',
                 	nullif(sde_miljo_halsoskydd.gng.MoH_Slam_Lokalt_p_evw.Fastighet_,' '), ' ',
                 	nullif(sde_miljo_halsoskydd.gng.MoH_Slam_Lokalt_p_evw.Fastighe00,' ')) fases
                          from sde_miljo_halsoskydd.gng.MoH_Slam_Lokalt_p_evw)
      , utan_fastighet2 as (select *from LOKALT_SLAM_P where Fastighet is null)
      , Med_fastighet as (select Diarienr, fastighetsYtor.Fastighet, Fastighet_, Fastighe00, Lokalt_omh, Anteckning, Beslutsdat, Eget_omhän, LOKALT_SLAM_P.shape, fases
      from LOKALT_SLAM_P inner join fastighetsYtor on  LOKALT_SLAM_P.fases
   	like '%' + fastighetsYtor.FAStighet + '%'),

       geoFast as (
	   select Fastighet_,Eget_omhän,Lokalt_omh,Fastighe00,Beslutsdat,Diarienr,Anteckning,utan_fastighet2.Shape,sYt.FAStighet
	   from  utan_fastighet2 inner join
       fastighetsYtor sYt on sYt.shape.STIntersects(utan_fastighet2.Shape) = 1)
      ,MedOchUtanFas as (select 				Diarienr, Fastighet, Fastighet_, Fastighe00, Lokalt_omh, Anteckning, Beslutsdat, Eget_omhän, shape
			 from med_fastighet union all select 	Diarienr, FAStighet, Fastighet_, Fastighe00, Lokalt_omh, Anteckning, Beslutsdat, Eget_omhän, Shape
			 from geoFast)

  ,egetOmh as ( select distinct fastighet,concat(nullif(ltrim(Diarienr)+' - ',' - '), nullif(ltrim(Fastighe00)+' - ',' - '),
           nullif(ltrim(Fastighet_)+' - ',' - '), nullif(ltrim(Eget_omhän)+' - ',' - '), nullif(ltrim(Lokalt_omh)+' - ',' - '), nullif(ltrim(Anteckning)+' - ',' - '),
           FORMAT(Beslutsdat,' yyyy-MM-dd')) egetOmhändertangandeInfo from MedOchUtanFas sYMfuf)

         , egetOmhx as (select distinct * from egetOmh)
,egetOmhy as (
      select distinct fastighet
			      , STUFF((
    SELECT ', ' + CAST(egetOmhx.egetOmhändertangandeInfo AS VARCHAR(MAX))
    FROM egetOmhx
    WHERE (egetOmhx.FAStighet = r.FAStighet)
    FOR XML PATH(''),TYPE).value('(./text())[1]','VARCHAR(MAX)')
  ,1,2,'') AS vaTyp
			 from egetOmhx r)



   insert into @egetomh
select * from egetOmhy
--where FAStighet = 'DALHEM GANDARVE 1:2'
;
   with fastighetsYtor as (select * from  @fastighetsYtor)
    ,planOmr as   (select shape,dp_i_omr,planprog,planansokn from sde_VA.gng.Va_planomraden_171016),
    spillAvtalGemPlanAnsok as (
	select shape, concat(typkod,':',status,'(spill)') typ
	from sde_VA.gng.VO_Spillvatten VO_Spillvatten
    union all select shape, 'AVTALSABONNENT [Tabell_ObjID: ]' as c
	from sde_VA.gng.AVTALSABONNENTER AVTALSABONNENTER
    union all select shape, concat('GEMENSAMHETSANLAGGNING: ',GEMENSAMHETSANLAGGNINGAR.GA) as c2
	from sde_VA.gng.GEMENSAMHETSANLAGGNINGAR GEMENSAMHETSANLAGGNINGAR
    	union all select shape,isnull(coalesce(nullif(concat('dp_i_omr:',dp_i_omr) ,'dp_i_omr:'), nullif(concat('planprog:',planprog) ,'planprog:'), nullif(concat('planansokn:',planansokn) ,'planansokn:')),
    N'okändStatus') as i from planOmr)
      , vax as (select distinct sYt.fastighet, q.typ  from fastighetsYtor sYt inner join spillAvtalGemPlanAnsok q on sYt.shape.STIntersects(q.Shape) = 1)
,va as (
      select distinct fastighet
			      , STUFF((
    SELECT ', ' + CAST(vax.typ AS VARCHAR(MAX))
    FROM vax
    WHERE (vax.FAStighet = r.FAStighet)
    FOR XML PATH(''),TYPE).value('(./text())[1]','VARCHAR(MAX)')
  ,1,2,'') AS vaTyp
			 from vax r)

insert into @va
   select * from va
   --where FAStighet = 'DALHEM GANDARVE 1:2'
;

declare @grönaFörFlaggskikt  table (
				 FASTIGHET                                     nvarchar(150),
				 Fastighet_tillstand                           nvarchar(150),
				 Arendenummer                                  nvarchar(50),
				 Beslut_datum                                  datetime2,
				 Status                                        nvarchar(50),
				 Utskick_datum                                 datetime2,
				 Anteckning                                    nvarchar(254),
				 Utforddatum                                   datetime2,
				 Slamhamtning                                  nvarchar(100),
				 Antal_byggnader                               numeric(38, 8),
				 x						bigint		,
                                y						bigint
                                unique (FASTIGHET)
                                with (ignore_dup_key = on)
)
declare @rödaFörFlaggskikt  table (
				 FASTIGHET                                     nvarchar(150),
				 Fastighet_tillstand                           nvarchar(150),
				 Arendenummer                                  nvarchar(50),
				 Beslut_datum                                  datetime2,
				 Status                                        nvarchar(50),
				 Utskick_datum                                 datetime2,
				 Anteckning                                    nvarchar(254),
				 Utforddatum                                   datetime2,
				 Slamhamtning                                  nvarchar(100),
				 Antal_byggnader                               numeric(38, 8),
				 x						bigint		,
                                y						bigint
)

;--  case when  statusx = 'röd' OR (statusx is null AND Byggnadstyp is not null and typ <> 'Spillvatten:Antaget(spill)' AND typ <> 'Avlopp:Antaget(spill)') then 1 else 0 end included, case when Byggnadstyp is not null then 1 else 0 end Bytyp,case when (isnull(typ,'') <> 'Spillvatten:Antaget(spill)' AND isnull(typ,'') <> 'Avlopp:Antaget(spill)') then 1 else 0 end SpillStat,
with toTeamVatten as (
select
              --  case when  statusx = 'röd' OR (statusx is null AND Byggnadstyp is not null and typ <> 'Spillvatten:Antaget(spill)' AND typ <> 'Avlopp:Antaget(spill)') then 1 else 0 end included, case when Byggnadstyp is not null then 1 else 0 end Bytyp,case when (isnull(typ,'') <> 'Spillvatten:Antaget(spill)' AND isnull(typ,'') <> 'Avlopp:Antaget(spill)') then 1 else 0 end SpillStat,
              statusx,SockenX, coalesce(fastighetsYtor.FAStighet, egetOmh.fastighet, va.fastighet, Fastighetsbeteckning,slamz.FAStighet) fastighet,
       Diarienummer, Fastighet_tillstand, nullif(cast(Beslut_datum as date),'1988-01-01') Beslut_datum, nullif(cast(utförddatum as date),'1988-01-01') utförddatum, Anteckning
     , egetOmh.egetOmhändertangandeInfo
     , typ VAantek
     , Byggnadstyp, bygTot,flagga.STPointN(1)  flagga
from @fastighetsYtor fastighetsYtor
full outer join @slamz slamz on slamz.FAStighet = fastighetsYtor.FAStighet
full outer join @egetOmh egetOmh on fastighetsYtor.FAStighet = egetOmh.FAStighet
full outer join @va va on fastighetsYtor.FAStighet = va.FAStighet
full outer join @byggs byggs on fastighetsYtor.FAStighet = byggs.Fastighetsbeteckning
--where fastighetsYtor.FAStighet like '%ekeskogs 1:6' OR fastighetsYtor.FAStighet like '%ekeskogs 1:7'

      --
      --order by included desc, statusx, SpillStat,Bytyp
)
--order by statusx desc,fastighet,typ,egetOmhändertangandeInfo
--;
--select count(*) c, 'slam' a from @slamz union select count(*) c, 'egetomh' a  from @egetomh union select count(*) c, 'va' a  from @va union select count(*) c, 'byggs' a  from @byggs

insert into @rödaFörFlaggskikt (FASTIGHET, Fastighet_tillstand, Arendenummer, Beslut_datum, Status, Utskick_datum, Anteckning
, Utforddatum, Slamhamtning, Antal_byggnader,x,y)
select
    left(fastighet,150),
    left(Fastighet_tillstand,150),
    left(Diarienummer,50),
     Beslut_datum,
     left(iif(statusx='ok','grön',statusx),50), --SockenX,
       null,
       left(CASE WHEN len(Anteckning) != 1 THEN anteckning END, 254),
     utförddatum
     ,left(concat( egetOmhändertangandeInfo,nullif(concat(' va: ',VAantek),' va: '), nullif(concat(' bygtyp: ' , Byggnadstyp),' bygtyp: ')),100) VAantek
     , bygTot,flagga.STX flaggax,flagga.STY flaggay

from toTeamVatten
(statusx = 'röd' OR (statusx is null AND  Byggnadstyp is not null and (isnull(typ,'') <> 'Spillvatten:Antaget(spill)' AND isnull(typ,'') <> 'Avlopp:Antaget(spill)')))


insert into @grönaFörFlaggskikt (FASTIGHET, Fastighet_tillstand, Arendenummer, Beslut_datum, Status, Utskick_datum, Anteckning
, Utforddatum, Slamhamtning, Antal_byggnader,x,y)
select
    left(fastighet,150),
    left(Fastighet_tillstand,150),
    left(Diarienummer,50),
     Beslut_datum,
     left(iif(statusx='ok','grön',statusx),50), --SockenX,
       null,
       left(CASE WHEN len(Anteckning) != 1 THEN anteckning END, 254),
     utförddatum
     ,left(concat( egetOmhändertangandeInfo,nullif(concat(' va: ',VAantek),' va: '), nullif(concat(' bygtyp: ' , Byggnadstyp),' bygtyp: ')),100) VAantek
     , bygTot,flagga.STX flaggax,flagga.STY flaggay
from toTeamVatten
	where fastighet not in(select fastighet from toTeamVatten where statusx = 'röd') and  Byggnadstyp is not null
	      and (isnull(typ,'') <> 'Spillvatten:Antaget(spill)' AND isnull(typ,'') <> 'Avlopp:Antaget(spill)')
select * from @grönaFörFlaggskikt
/*Insert Databases names into SQL Temp Table*/
begin try
declare @statusTable table(one NVARCHAR(max),start datetime,rader integer);
TableInitiate:

-- dropTabels?

INSERT INTO @statusTable (one) select '#initiating#slam';
IF OBJECT_ID('tempdb..#slam') IS NULL RAISERROR ( 18,-1,-1,'taxekodTabell saknas, exekvera om slaminitate');  else begin if not                     (exists(select 1 from #slam)) begin drop table #slam;  RAISERROR ( 18,-1,-1,N'taxekod Var olämplig,tabell förstörd, exekvera-om slaminitiate') end end
INSERT INTO @statusTable select 'preloading#slam',CURRENT_TIMESTAMP,count(*) from #slam;

INSERT INTO @statusTable select '#TableInitiate',CURRENT_TIMESTAMP,@@ROWCOUNT;
INSERT INTO @statusTable (one) select '#initiating#sockenYtor',CURRENT_TIMESTAMP,@@ROWCOUNT;
IF OBJECT_ID('tempdb..#SockenYtor')                     IS NULL goto SockenYtor else begin if not                   (exists(select 1 from #SockenYtor)) begin drop table #SockenYtor;                                  goto SockenYtor; end end INSERT INTO @statusTable select 'preloading#SockenYtor',CURRENT_TIMESTAMP,count(*) from #SockenYtor;
INSERT INTO @statusTable (one) select '#initiating#Byggnader',CURRENT_TIMESTAMP,@@ROWCOUNT;
IF OBJECT_ID(N'tempdb..#ByggnadPåFastighetISocken')     IS NULL goto ByggnadPåFastighetISocken else begin if not    (exists(select 1 from #ByggnadPåFastighetISocken)) begin drop table #ByggnadPåFastighetISocken;    goto ByggnadPåFastighetISocken;end end INSERT INTO @statusTable select 'preloading#ByggnadPåFastighetISocken',CURRENT_TIMESTAMP,count(*) from #ByggnadPåFastighetISocken;
INSERT INTO @statusTable (one) select '#initiating#sockenTillstånd',CURRENT_TIMESTAMP,@@ROWCOUNT;
IF OBJECT_ID(N'tempdb..#Socken_tillstånd')              IS NULL goto Socken_tillstånd else begin if not             (exists(select 1 from #Socken_tillstånd)) begin drop table #Socken_tillstånd;                      goto Socken_tillstånd; end end INSERT INTO @statusTable select 'preloading#Socken_tillstånd',CURRENT_TIMESTAMP,count(*) from #Socken_tillstånd;
INSERT INTO @statusTable (one) select '#initiating#egetOmhändertagande',CURRENT_TIMESTAMP,@@ROWCOUNT;
IF OBJECT_ID(N'tempdb..#egetOmhändertagande')           IS NULL goto egetOmhändertagande  else begin if not         (exists(select 1 from #egetOmhändertagande)) begin drop table #egetOmhändertagande;                goto egetOmhändertagande; end end  INSERT INTO @statusTable select 'preloading#egetOmhändertagande',CURRENT_TIMESTAMP,count(*) from #egetOmhändertagande;
INSERT INTO @statusTable (one) select '#initiating#Spillvatten',CURRENT_TIMESTAMP,@@ROWCOUNT;
IF OBJECT_ID('tempdb..#spillvaten')                     IS NULL goto spillvaten  else begin if not                  (exists(select 1 from #spillvaten)) begin drop table #spillvaten;                                  goto spillvaten; end end  INSERT INTO @statusTable select 'preloading#spillvaten',CURRENT_TIMESTAMP,count(*) from #spillvaten;
INSERT INTO @statusTable (one) select '#initiating#röd',CURRENT_TIMESTAMP,@@ROWCOUNT;
IF OBJECT_ID(N'tempdb..#röd')                           IS NULL goto röd  else begin if not                         (exists(select 1 from #röd)) begin drop table #röd;                                                goto röd; end end  INSERT INTO @statusTable select 'preloading#röd',CURRENT_TIMESTAMP,count(*) from #röd
INSERT INTO @statusTable select '#goingToRepport',CURRENT_TIMESTAMP,@@ROWCOUNT;
goto repport


if (select 1) IS NULL
    BEGIN
        TRY
Drop table #SockenYtor
Drop table #ByggnadPåFastighetISocken
Drop table #Socken_tillstånd
Drop table #egetOmhändertagande
Drop table #spillvaten
Drop table #slam
Drop table #röd
    end try begin catch select 1 end catch
goto TableInitiate

SockenYtor:
    with socknarOfIntresse as (Select N'Björke' "socken"  Union Select 'Dalhem' as alias2 Union Select N'Fröjel' as alias234567 Union Select 'Ganthem' as alias23 Union Select 'Halla' as alias234 Union Select 'Klinte' as alias2345 Union Select 'Roma' as alias23456)
    SELECT socken SockenX,concat(Trakt,' ',Blockenhet) FAStighet, Shape INTO #SockenYtor from sde_gsd.gng.AY_0980 x inner join socknarOfIntresse on left(x.TRAKT, len(socknarOfIntresse.socken)) = socknarOfIntresse.socken

INSERT INTO @statusTable select 'rebuilt#SockenYtor',CURRENT_TIMESTAMP,@@ROWCOUNT

goto TableInitiate
ByggnadPåFastighetISocken:
    with byggnad_yta as (select andamal_1T Byggnadstyp, Shape from sde_gsd.gng.BY_0980),
        q as (Select Byggnadstyp, socknarOfIntresse.fastighet Fastighetsbeteckning, byggnad_yta.SHAPE from byggnad_yta inner join #SockenYtor socknarOfIntresse on byggnad_yta.Shape.STWithin(socknarOfIntresse.shape) = 1)
        select Fastighetsbeteckning, Byggnadstyp,shape ByggShape into #ByggnadPåFastighetISocken from (select *, row_number() over (partition by Fastighetsbeteckning order by Byggnadstyp ) orderz from q) z where orderz = 1; INSERT INTO @statusTable select  N'rebuilt#ByggnadPåFastighetISocken',CURRENT_TIMESTAMP,@@ROWCOUNT

goto TableInitiate
;Socken_tillstånd:
      with
       AnSoMedSocken as (select left(Fastighet_tillstand, case when charindex(' ', Fastighet_tillstand) = 0 then len(Fastighet_tillstand) + 1 else charindex(' ', Fastighet_tillstand) end - 1) socken,Diarienummer,Fastighet_tillstand                                                             z,Beslut_datum,Utford_datum,Anteckning,Shape                                                                           anlShape from sde_miljo_halsoskydd.gng.ENSKILT_AVLOPP_sodra_P),
       AnNoMedSocken as (select left(Fastighet_tillstand, case when charindex(' ', Fastighet_tillstand) = 0 then len(Fastighet_tillstand) + 1 else charindex(' ', Fastighet_tillstand) end - 1) socken,Diarienummer,Fastighet_tillstand                                                             z,Beslut_datum,Utford_datum,Anteckning,Shape                                                                           anlShape from sde_miljo_halsoskydd.gng.ENSKILT_AVLOPP_Norra_P),
       AnMeMedSocken as (select left(Fastighet_tilstand, case when charindex(' ', Fastighet_tilstand) = 0 then len(Fastighet_tilstand) + 1 else charindex(' ', Fastighet_tilstand) end - 1) socken,Diarienummer,Fastighet_tilstand                                                            z,Beslut_datum,Utford_datum,Anteckning,Shape                                                                         anlShape from sde_miljo_halsoskydd.gng.ENSKILT_AVLOPP_MELLERSTA_P),
       SodraFiltrerad as (select Diarienummer, z q, Beslut_datum, Utford_datum, Anteckning, AllaAvlopp.anlShape, FAStighet from AnSoMedSocken AllaAvlopp inner join(select FiltreradeFast.*from #sockenYtor FiltreradeFast inner join (select socken from AnSoMedSocken group by socken) q on socken = sockenX) FFast on AllaAvlopp.socken = ffast.SockenX and AllaAvlopp.anlShape.STIntersects(FFast.Shape) = 1),
       NorraFiltrerad as (select Diarienummer, z q, Beslut_datum, Utford_datum, Anteckning, AllaAvlopp.anlShape, FAStighet from AnNoMedSocken AllaAvlopp inner join(select FiltreradeFast.*from #sockenYtor FiltreradeFast inner join (select socken from AnNoMedSocken group by socken) q on socken = sockenX) FFast on AllaAvlopp.socken = ffast.SockenX and AllaAvlopp.anlShape.STIntersects(FFast.Shape) = 1),
       MellerstaFiltrerad as (select Diarienummer, z q, Beslut_datum, Utford_datum, Anteckning, AllaAvlopp.anlShape, FAStighet from AnMeMedSocken AllaAvlopp inner join(select FiltreradeFast.*from #sockenYtor FiltreradeFast inner join (select socken from AnMeMedSocken group by socken) q on socken = sockenX) FFast on AllaAvlopp.socken = ffast.SockenX and AllaAvlopp.anlShape.STIntersects(FFast.Shape) = 1),
       SammanSlagna as (select Diarienummer, q "Fastighet_tillstand",isnull(TRY_CONVERT(DateTime, Beslut_datum,102), DATETIME2FROMPARTS(1988, 1, 1, 1, 1, 1, 1, 1)) Beslut_datum, isnull(TRY_CONVERT(DateTime, Utford_datum,102), DATETIME2FROMPARTS(1988, 1, 1, 1, 1, 1, 1, 1)) Utford_datum, Anteckning, anlShape, FAStighet from (select * from SodraFiltrerad union all select * from NorraFiltrerad union all select * from MellerstaFiltrerad) z)

      select FAStighet,Diarienummer,Fastighet_tillstand,Beslut_datum,Utford_datum "utförddatum",Anteckning,anlShape     AnlaggningsPunkt into #Socken_tillstånd from SammanSlagna INSERT INTO @statusTable select N'rebuilt#Socken_tillstånd',CURRENT_TIMESTAMP,@@ROWCOUNT

goto TableInitiate
;egetOmhändertagande:
     with
        LOKALT_SLAM_P as ( select Diarienr,Fastighet_,Fastighe00,Eget_omhän,Lokalt_omh,Anteckning,Beslutsdat, shape from sde_miljo_halsoskydd.gng.MoH_Slam_Lokalt_p_evw)
        ,Med_fastighet as (select * from (select *,concat(nullif(LOKALT_SLAM_P.Lokalt_omh,''),' ',nullif(LOKALT_SLAM_P.Fastighet_,''),' ',nullif(LOKALT_SLAM_P.Fastighe00,'')) fas from sde_miljo_halsoskydd.gng.MoH_Slam_Lokalt_p_evw LOKALT_SLAM_P) q where fas is not null and charindex(':',fas) > 0),
        utan_fastighet as (select OBJECTID,Fastighet_,Fastighets,Eget_omhän,Lokalt_omh,Fastighe00,Beslutsdat,Diarienr,Anteckning,utan_fastighet.Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID,FAStighet from (select *from sde_miljo_halsoskydd.gng.MoH_Slam_Lokalt_p_evw LOKALT_SLAM_P where charindex(':', concat(nullif(LOKALT_SLAM_P.Lokalt_omh, ''), ' ', nullif(LOKALT_SLAM_P.Fastighet_, ''), ' ', nullif(LOKALT_SLAM_P.Fastighe00, ''))) = 0) utan_fastighet inner join #SockenYtor sYt on sYt.shape.STIntersects(utan_fastighet.Shape) = 1)
        select fastighet,concat(nullif(Diarienr+'-','-'), nullif(Fastighe00+'-',' -'), nullif(Fastighet_+'-',' -'), nullif(Eget_omhän+'-',' -'), nullif(Lokalt_omh+'-',' -'), nullif(Anteckning+'-',' -'),FORMAT(Beslutsdat,'yyyy-MM-dd')) egetOmhändertangandeInfo,Shape  LocaltOmH into #egetOmhändertagande from (select OBJECTID,Fastighet_,Fastighets,Eget_omhän,Lokalt_omh,Fastighe00,Beslutsdat,Diarienr,Anteckning,Med_fastighet.Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID,FAStighet from #SockenYtor sYt left outer join Med_fastighet on fas like '%' + sYt.Fastighet + '%' where fas is not null union all select * from utan_fastighet) as [sYMfuf*]
        INSERT INTO @statusTable select N'rebuilt#egetOmhändertagande',CURRENT_TIMESTAMP,@@ROWCOUNT

goto TableInitiate
;
spillvaten:
    with Va_planomraden_171016_evw as   (select shape,dp_i_omr,planprog,planansokn from sde_pipe.gng.Va_planomraden_171016_evw),q as (
            select shape, concat(typkod,':',status,'(spill)') typ from sde_pipe.gng.VO_Spillvatten_evw VO_Spillvatten_evw union all
            select shape, concat('AVTALSABONNENT [Tabell_ObjID: ',OBJECTID,']') as c
            from sde_pipe.gng.AVTALSABONNENTER AVTALSABONNENTER union all
            select shape, concat('GEMENSAMHETSANLAGGNING: ',GEMENSAMHETSANLAGGNINGAR.GA) as c2
            from sde_pipe.gng.GEMENSAMHETSANLAGGNINGAR GEMENSAMHETSANLAGGNINGAR union all
            select shape,isnull(coalesce(nullif(concat('dp_i_omr:',dp_i_omr) ,'dp_i_omr:'),
                                  nullif(concat('planprog:',planprog) ,'planprog:'),
                                  nullif(concat('planansokn:',planansokn) ,'planansokn:')),N'okändStatus') as i from Va_planomraden_171016_evw)
  select sYt.fastighet, q.typ  into #spillvaten from #SockenYtor sYt inner join q on sYt.shape.STIntersects(q.Shape) = 1 INSERT INTO @statusTable select 'rebuilt#spillvaten',CURRENT_TIMESTAMP,@@ROWCOUNT

goto TableInitiate
;
röd:
with         slamm as (select strFastBeteckningHel,strDelprodukt,z2 = STUFF((SELECT distinct ','+ concat(nullif(x.strTaxebenamning,''), nullif(concat(' Avbrutet:', FORMAT(nullif(x.q2z, smalldatetimefromparts(1900, 01, 01, 00, 00)), 'yyyy-MM-dd')), ' Avbrutet:')) as c3s FROM #slam x where q.strFastBeteckningHel = x.strFastBeteckningHel FOR XML PATH ('')), 1, 1, '')FROM #slam q group by strFastBeteckningHel,strDelprodukt)
            ,slam as (select strFastBeteckningHel,datStoppdatum =STUFF((SELECT distinct ','+nullif(strDelprodukt+'|','|')+z2 as nadas FROM slamm x where q.strFastBeteckningHel = x.strFastBeteckningHel FOR XML PATH ('')), 1, 1, '')from slamm q group by strFastBeteckningHel)
            ,socknarOfInteresse as (select distinct sockenX socken, fastighet from #SockenYtor )
            ,byggnader as (select Fastighetsbeteckning fastighet, Byggnadstyp,ByggShape from #ByggnadPåFastighetISocken)
            ,vaPlan as (select fastighet,typ  from #spillvaten)
            ,egetOmhandertagande as (select  fastighet,egetOmhändertangandeInfo,LocaltOmH from #egetOmhändertagande )
            ,anlaggningar as (select diarienummer,Fastighet,Fastighet_tillstand,Beslut_datum,utförddatum,Anteckning,(case when not (Beslut_datum > DATETIME2FROMPARTS(2003, 1, 1, 1, 1, 1, 1, 1) and utförddatum > DATETIME2FROMPARTS(2003, 1, 1, 1, 1, 1, 1, 1)) then N'röd' else N'grön' end) fstatus,anlaggningspunkt from #Socken_tillstånd)
            , attUtsokaFran as (select *, row_number() over (partition by q.fastighet order by q.Anteckning desc ) flaggnr from (select anlaggningar.diarienummer,(case when anlaggningar.anlaggningspunkt is not null then anlaggningar.fstatus else '?' end) fstatus, socknarOfInteresse.socken,socknarOfInteresse.fastighet,Byggnadstyp,Fastighet_tillstand,Beslut_datum,utförddatum,Anteckning,(case when anlaggningar.anlaggningspunkt is not null then anlaggningar.anlaggningspunkt else ByggShape end) flagga from socknarOfInteresse left outer join byggnader on socknarOfInteresse.fastighet = byggnader.fastighet left outer join anlaggningar on socknarOfInteresse.fastighet = anlaggningar.fastighet) q  where q.flagga is not null)
            ,q as (select attUtsokaFran.socken,attUtsokaFran.fastighet,attUtsokaFran.Fastighet_tillstand,attUtsokaFran.Diarienummer,attUtsokaFran.Byggnadstyp,Beslut_datum,utförddatum "utförddatum",attUtsokaFran.Anteckning,
                    VaPlan                   = (select top 1 typ from vaPlan where vaPlan.fastighet = attUtsokaFran.fastighet),fstatus,
                    egetOmhändertangandeInfo = (select top 1 egetOmhändertangandeInfo from egetOmhandertagande where attUtsokaFran.fastighet = egetOmhandertagande.fastighet),
                    slam                     = (select top 1 datStoppdatum from slam where attUtsokaFran.fastighet = slam.strFastBeteckningHel),flaggnr,flagga.STPointN(1) flagga from attUtsokaFran)
            ,röd as ( select socken,fastighet,Fastighet_tillstand,Byggnadstyp,Beslut_datum,utförddatum,Anteckning,VaPlan,egetOmhändertangandeInfo,slam,flaggnr,flagga, (case when fstatus = N'röd' then (case when (vaPlan is null and egetOmhändertangandeInfo is null) then N'röd' else (case when VaPlan is not null then 'KomV?' else (case when null is not null then 'gem' else '?' end) end) end) else fstatus end ) Fstatus from q)
            select *into #röd from röd INSERT INTO @statusTable select N'rebuilt#Röd',CURRENT_TIMESTAMP,@@ROWCOUNT

repport:
    --begin try
select * from @statusTable
end try begin catch
    insert into @statusTable select ERROR_MESSAGE(),CURRENT_TIMESTAMP,@@ROWCOUNT
    select * from @statusTable end catch
--
taxekod:

--Kopierade tabellföreteckning från gng.FLAGGSKIKTET_P
create table gng.Inventering_Bjorke
(
    OBJECTID            int not null
        constraint invBj_pk
            primary key,
    FASTIGHET           nvarchar(150),
    Fastighet_tillstand nvarchar(150),
    Arendenummer        nvarchar(50),
    Beslut_datum        datetime2,
    Status              nvarchar(50),
    Utskick_datum       datetime2,
    Anteckning          nvarchar(254),
    Utforddatum         datetime2,
    Slamhamtning        nvarchar(100),
    Antal_byggnader     numeric(38, 8),
    alltidsant          int,
    Shape               geometry,
    GDB_GEOMATTR_DATA   varbinary(max),
    skapad_datum        datetime2,
    andrad_datum        datetime2
)
go

create index invBj_idx
    on gng.Inventering_Bjorke (Shape)
go

BEGIN TRANSACTION
insert into gng.Inventering_Bjorke (OBJECTID,                                           FASTIGHET,Fastighet_tillstand,  Beslut_datum,   Status,     Anteckning,                                                                                                                                                                 Utforddatum,                Slamhamtning,                Antal_byggnader,    alltidsant,  Shape,  skapad_datum,   andrad_datum)
select                             (row_number() over (order by fastighet,flaggnr)),    fastighet,Fastighet_tillstand,  Beslut_datum,   Fstatus,    concat(Byggnadstyp,' ',Anteckning,' ',nullif(concat('vaPlan: ',VaPlan,' '),'vaPlan:  '),nullif(concat('egetOmh: ',egetOmhändertangandeInfo,' '),'egetOmh:  ')),             utförddatum,                slam,                        flaggnr,            1,           flagga, CURRENT_TIMESTAMP,CURRENT_TIMESTAMP
from #röd where Socken = N'Björke';
ROLLBACK TRANSACTION


create table gng.Inventering_Dalhem
(
    OBJECTID            int not null
        constraint invDahl_pk
            primary key,
    FASTIGHET           nvarchar(150),
    Fastighet_tillstand nvarchar(150),
    Arendenummer        nvarchar(50),
    Beslut_datum        datetime2,
    Status              nvarchar(50),
    Utskick_datum       datetime2,
    Anteckning          nvarchar(254),
    Utforddatum         datetime2,
    Slamhamtning        nvarchar(100),
    Antal_byggnader     numeric(38, 8),
    alltidsant          int,
    Shape               geometry,
    GDB_GEOMATTR_DATA   varbinary(max),
    skapad_datum        datetime2,
    andrad_datum        datetime2
)
go

create index invDahl_idx
    on gng.Inventering_Dalhem (Shape)
go
BEGIN TRANSACTION
insert into gng.Inventering_Dalhem (OBJECTID,                                           FASTIGHET,Fastighet_tillstand,  Beslut_datum,   Status,     Anteckning,                                                                                                                                                                 Utforddatum,                Slamhamtning,                Antal_byggnader,    alltidsant,  Shape,  skapad_datum,   andrad_datum)
select                             (row_number() over (order by fastighet,flaggnr)),    fastighet,Fastighet_tillstand,  Beslut_datum,   Fstatus,    concat(Byggnadstyp,' ',Anteckning,' ',nullif(concat('vaPlan: ',VaPlan,' '),'vaPlan:  '),nullif(concat('egetOmh: ',egetOmhändertangandeInfo,' '),'egetOmh:  ')),             utförddatum,                slam,                        flaggnr,            1,           flagga, CURRENT_TIMESTAMP,CURRENT_TIMESTAMP
from #röd where Socken = 'Dalhem';
ROLLBACK TRANSACTION

create table gng.Inventering_frojel
(
    OBJECTID            int not null
        constraint invfrojel_pk
            primary key,
    FASTIGHET           nvarchar(150),
    Fastighet_tillstand nvarchar(150),
    Arendenummer        nvarchar(50),
    Beslut_datum        datetime2,
    Status              nvarchar(50),
    Utskick_datum       datetime2,
    Anteckning          nvarchar(254),
    Utforddatum         datetime2,
    Slamhamtning        nvarchar(100),
    Antal_byggnader     numeric(38, 8),
    alltidsant          int,
    Shape               geometry,
    GDB_GEOMATTR_DATA   varbinary(max),
    skapad_datum        datetime2,
    andrad_datum        datetime2
)
go

create index invfrojel_idx
    on gng.Inventering_frojel (Shape)
go
BEGIN TRANSACTION
insert into gng.Inventering_frojel (OBJECTID,                                           FASTIGHET,Fastighet_tillstand,  Beslut_datum,   Status,     Anteckning,                                                                                                                                                                 Utforddatum,                Slamhamtning,                Antal_byggnader,    alltidsant,  Shape,  skapad_datum,   andrad_datum)
select                             (row_number() over (order by fastighet,flaggnr)),    fastighet,Fastighet_tillstand,  Beslut_datum,   Fstatus,    concat(Byggnadstyp,' ',Anteckning,' ',nullif(concat('vaPlan: ',VaPlan,' '),'vaPlan:  '),nullif(concat('egetOmh: ',egetOmhändertangandeInfo,' '),'egetOmh:  ')),             utförddatum,                slam,                        flaggnr,            1,           flagga, CURRENT_TIMESTAMP,CURRENT_TIMESTAMP
from #röd where Socken = 'fröjel';
ROLLBACK TRANSACTION




create table gng.Inventering_ganthem
(
    OBJECTID            int not null
        constraint invganthem_pk
            primary key,
    FASTIGHET           nvarchar(150),
    Fastighet_tillstand nvarchar(150),
    Arendenummer        nvarchar(50),
    Beslut_datum        datetime2,
    Status              nvarchar(50),
    Utskick_datum       datetime2,
    Anteckning          nvarchar(254),
    Utforddatum         datetime2,
    Slamhamtning        nvarchar(100),
    Antal_byggnader     numeric(38, 8),
    alltidsant          int,
    Shape               geometry,
    GDB_GEOMATTR_DATA   varbinary(max),
    skapad_datum        datetime2,
    andrad_datum        datetime2
)
go

create index invganthem_idx
    on gng.Inventering_ganthem (Shape)
go
BEGIN TRANSACTION
insert into gng.Inventering_ganthem (OBJECTID,                                           FASTIGHET,Fastighet_tillstand,  Beslut_datum,   Status,     Anteckning,                                                                                                                                                                 Utforddatum,                Slamhamtning,                Antal_byggnader,    alltidsant,  Shape,  skapad_datum,   andrad_datum)
select                             (row_number() over (order by fastighet,flaggnr)),    fastighet,Fastighet_tillstand,  Beslut_datum,   Fstatus,    concat(Byggnadstyp,' ',Anteckning,' ',nullif(concat('vaPlan: ',VaPlan,' '),'vaPlan:  '),nullif(concat('egetOmh: ',egetOmhändertangandeInfo,' '),'egetOmh:  ')),             utförddatum,                slam,                        flaggnr,            1,           flagga, CURRENT_TIMESTAMP,CURRENT_TIMESTAMP
from #röd where Socken = 'Ganthem';
ROLLBACK TRANSACTION


create table gng.Inventering_Halla
(
    OBJECTID            int not null
        constraint invHalla_pk
            primary key,
    FASTIGHET           nvarchar(150),
    Fastighet_tillstand nvarchar(150),
    Arendenummer        nvarchar(50),
    Beslut_datum        datetime2,
    Status              nvarchar(50),
    Utskick_datum       datetime2,
    Anteckning          nvarchar(254),
    Utforddatum         datetime2,
    Slamhamtning        nvarchar(100),
    Antal_byggnader     numeric(38, 8),
    alltidsant          int,
    Shape               geometry,
    GDB_GEOMATTR_DATA   varbinary(max),
    skapad_datum        datetime2,
    andrad_datum        datetime2
)
go

create index invHalla_idx
    on gng.Inventering_Halla (Shape)
go
BEGIN TRANSACTION
insert into gng.Inventering_Halla (OBJECTID,                                           FASTIGHET,Fastighet_tillstand,  Beslut_datum,   Status,     Anteckning,                                                                                                                                                                 Utforddatum,                Slamhamtning,                Antal_byggnader,    alltidsant,  Shape,  skapad_datum,   andrad_datum)
select                             (row_number() over (order by fastighet,flaggnr)),    fastighet,Fastighet_tillstand,  Beslut_datum,   Fstatus,    concat(Byggnadstyp,' ',Anteckning,' ',nullif(concat('vaPlan: ',VaPlan,' '),'vaPlan:  '),nullif(concat('egetOmh: ',egetOmhändertangandeInfo,' '),'egetOmh:  ')),             utförddatum,                slam,                        flaggnr,            1,           flagga, CURRENT_TIMESTAMP,CURRENT_TIMESTAMP
from #röd where Socken = 'Halla';
ROLLBACK TRANSACTION


create table gng.Inventering_klinte
(
    OBJECTID            int not null
        constraint invklinte_pk
            primary key,
    FASTIGHET           nvarchar(150),
    Fastighet_tillstand nvarchar(150),
    Arendenummer        nvarchar(50),
    Beslut_datum        datetime2,
    Status              nvarchar(50),
    Utskick_datum       datetime2,
    Anteckning          nvarchar(254),
    Utforddatum         datetime2,
    Slamhamtning        nvarchar(100),
    Antal_byggnader     numeric(38, 8),
    alltidsant          int,
    Shape               geometry,
    GDB_GEOMATTR_DATA   varbinary(max),
    skapad_datum        datetime2,
    andrad_datum        datetime2
)
go

create index invklinte_idx
    on gng.Inventering_klinte (Shape)
go
BEGIN TRANSACTION
insert into gng.Inventering_klinte (OBJECTID,                                           FASTIGHET,Fastighet_tillstand,  Beslut_datum,   Status,     Anteckning,                                                                                                                                                                 Utforddatum,                Slamhamtning,                Antal_byggnader,    alltidsant,  Shape,  skapad_datum,   andrad_datum)
select                             (row_number() over (order by fastighet,flaggnr)),    fastighet,Fastighet_tillstand,  Beslut_datum,   Fstatus,    concat(Byggnadstyp,' ',Anteckning,' ',nullif(concat('vaPlan: ',VaPlan,' '),'vaPlan:  '),nullif(concat('egetOmh: ',egetOmhändertangandeInfo,' '),'egetOmh:  ')),             utförddatum,                slam,                        flaggnr,            1,           flagga, CURRENT_TIMESTAMP,CURRENT_TIMESTAMP
from #röd where Socken = 'klinte';
ROLLBACK TRANSACTION

create table gng.Inventering_roma
(
    OBJECTID            int not null
        constraint invroma_pk
            primary key,
    FASTIGHET           nvarchar(150),
    Fastighet_tillstand nvarchar(150),
    Arendenummer        nvarchar(50),
    Beslut_datum        datetime2,
    Status              nvarchar(50),
    Utskick_datum       datetime2,
    Anteckning          nvarchar(254),
    Utforddatum         datetime2,
    Slamhamtning        nvarchar(100),
    Antal_byggnader     numeric(38, 8),
    alltidsant          int,
    Shape               geometry,
    GDB_GEOMATTR_DATA   varbinary(max),
    skapad_datum        datetime2,
    andrad_datum        datetime2
)
go

create index invroma_idx
    on gng.Inventering_roma (Shape)
go
BEGIN TRANSACTION
insert into gng.Inventering_roma (OBJECTID,                                           FASTIGHET,Fastighet_tillstand,  Beslut_datum,   Status,     Anteckning,                                                                                                                                                                 Utforddatum,                Slamhamtning,                Antal_byggnader,    alltidsant,  Shape,  skapad_datum,   andrad_datum)
select                             (row_number() over (order by fastighet,flaggnr)),    fastighet,Fastighet_tillstand,  Beslut_datum,   Fstatus,    concat(Byggnadstyp,' ',Anteckning,' ',nullif(concat('vaPlan: ',VaPlan,' '),'vaPlan:  '),nullif(concat('egetOmh: ',egetOmhändertangandeInfo,' '),'egetOmh:  ')),             utförddatum,                slam,                        flaggnr,            1,           flagga, CURRENT_TIMESTAMP,CURRENT_TIMESTAMP
from #röd where Socken = 'roma';
ROLLBACK TRANSACTION




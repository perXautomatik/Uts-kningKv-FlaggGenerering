/*Insert Databases names into SQL Temp Table*/

Begin Try
-- dropTabels?
declare @statusTable table(one NVARCHAR(max),start datetime,rader integer);
declare @rebuiltStatus1 as binary = 0;
declare @rebuiltStatus2 as binary = 0;

TableInitiate:

IF OBJECT_ID('tempdb..#SockenYtor') IS NULL
    goto SockenYtor
else
    begin
        if not (exists(select 1 from #SockenYtor))
            begin
                drop table #SockenYtor; goto SockenYtor
            end    end
INSERT INTO @statusTable select 'preloading#SockenYtor',CURRENT_TIMESTAMP,@@ROWCOUNT
 ;
IF OBJECT_ID(N'tempdb..#ByggnadPåFastighetISocken') IS NULL
    goto ByggnadPåFastighetISocken;
else
    begin
        if not (exists(select 1 from #ByggnadPåFastighetISocken))
            begin
                drop table #ByggnadPåFastighetISocken; goto ByggnadPåFastighetISocken;
            end
end

INSERT INTO @statusTable select 'preloading#ByggnadPåFastighetISocken',CURRENT_TIMESTAMP,@@ROWCOUNT
    ;
IF OBJECT_ID(N'tempdb..#Socken_tillstånd') IS NULL
    goto Socken_tillstånd
else
    if not (exists(select 1 from #Socken_tillstånd))
        begin
            drop table #Socken_tillstånd; goto Socken_tillstånd
        end

INSERT INTO @statusTable select 'preloading#Socken_tillstånd',CURRENT_TIMESTAMP,@@ROWCOUNT
;

IF OBJECT_ID(N'tempdb..#egetOmhändertagande') IS NULL
    goto egetOmhändertagande
else
    if not (exists(select 1 from #egetOmhändertagande))
        begin
            drop table #egetOmhändertagande; goto egetOmhändertagande;
        end
INSERT INTO @statusTable select 'preloading#egetOmhändertagande',CURRENT_TIMESTAMP,@@ROWCOUNT
;
IF OBJECT_ID('tempdb..#spillvaten') IS NULL
    goto spillvaten
else
    if not (exists(select 1 from #spillvaten))
        begin
            drop table #spillvaten; goto spillvaten;
        end
INSERT INTO @statusTable select 'preloading#spillvaten',CURRENT_TIMESTAMP,@@ROWCOUNT
;
IF OBJECT_ID('tempdb..#slam') IS NULL
    goto taxekod
else
    if not (exists(select 1 from #slam))
        begin
            drop table #slam; goto taxekod;
        end
INSERT INTO @statusTable select 'preloading#slam',CURRENT_TIMESTAMP,@@ROWCOUNT
        ;
IF OBJECT_ID(N'tempdb..#röd') IS NULL
    goto röd
else
    if not (exists(select 1 from #röd))
        begin
            drop table #röd; goto röd;
        end;
    INSERT INTO @statusTable select 'preloading#röd',CURRENT_TIMESTAMP,@@ROWCOUNT
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
        INSERT INTO @statusTable
        select '#Rebuilding',CURRENT_TIMESTAMP,@@ROWCOUNT END TRY BEGIN CATCH SELECT 1 END CATCH else INSERT INTO @statusTable select 'preloading#DidNotDiscard',CURRENT_TIMESTAMP,@@ROWCOUNT
Print '#Rebuilding' + CURRENT_TIMESTAMP + ' RowNR:' + @@ROWCOUNT;
;

SockenYtor:
    with socknarOfIntresse as (Select N'Björke' "socken"  Union Select 'Dalhem' as alias2 Union Select N'Fröjel' as alias234567 Union Select 'Ganthem' as alias23 Union Select 'Halla' as alias234 Union Select 'Klinte' as alias2345 Union Select 'Roma' as alias23456)
    SELECT socken SockenX,concat(Trakt,' ',Blockenhet) FAStighet, Shape INTO #SockenYtor
    from [sde_gsd].[gng].AY_0980 x inner join socknarOfIntresse on left(x.TRAKT, len(socknarOfIntresse.socken)) = socknarOfIntresse.socken
    INSERT INTO @statusTable select 'rebuilt#SockenYtor',CURRENT_TIMESTAMP,@@ROWCOUNT
    set @rebuiltStatus1 = 1
;Print 'preloading#SockenYtor' + CURRENT_TIMESTAMP + ' RowNR:' + @@ROWCOUNT;goto TableInitiate;

       --ByggBeslut as (select Ärendenummer,                         Byggnadstyp,                    Fastighetsbeteckning,  concat(Inkommande_datum,Registereringsdatum,År,Beslutsdatum,Status,Planbedömning,Beslutsnivå,Ärendetyp) rest,   GDB_GEOMATTR_DATA,  Shape, OBJECTID  from sde_bygglov.gng.BYGGLOVSPUNKTER union all select concat(DIARIENR,ANSÖKAN),   ÄNDAMÅL,                     Beteckning,               concat(DATUM,BESLUT,ANTAL,concat(URSPRUNG,id, Kod),AVSER,ANVÄNDNING),                                   GDB_GEOMATTR_DATA,  Shape, OBJECTID  from sde_bygglov.gng.BYGGLOVREG_ALDRE_P union all select concat(DIARIENR,ANSÖKAN),   concat(BYGGNADSTY,ÄNDAMÅL),     AVSER,                 concat(DATUM,BESLUT,År,ANTAL,ANMÄRKNIN,ANM,ANSÖKAN_A),                                            GDB_GEOMATTR_DATA,  Shape, OBJECTID  from sde_bygglov.gng.BYGGLOVSREG_2007_2019_P union all select DIARIENR,                   BYGGNADSTY,                     ANSÖKAN_AV,            concat(ANM,BESLUT),                                                                      GDB_GEOMATTR_DATA,  Shape, OBJECTID  from sde_bygglov.gng.BYGGLOVSREGISTRERING_CA_1999_2007_P),
ByggnadPåFastighetISocken:
    with byggnad_yta as (select andamal_1T Byggnadstyp, Shape from sde_gsd.gng.BY_0980),
        q as (Select Byggnadstyp, socknarOfIntresse.fastighet Fastighetsbeteckning, byggnad_yta.SHAPE from byggnad_yta inner join #SockenYtor socknarOfIntresse on byggnad_yta.Shape.STWithin(socknarOfIntresse.shape) = 1)
select Fastighetsbeteckning, Byggnadstyp,shape ByggShape into #ByggnadPåFastighetISocken from (select *, row_number() over (partition by Fastighetsbeteckning order by Byggnadstyp ) orderz from q) z where orderz = 1;

INSERT INTO @statusTable select  N'rebuilt#ByggnadPåFastighetISocken',CURRENT_TIMESTAMP,@@ROWCOUNT


Print N'rebuilt#ByggnadPåFastighetISocken' + CURRENT_TIMESTAMP + ' RowNR:' + @@ROWCOUNT;goto TableInitiate;

Socken_tillstånd:
      with
       aso as (select left(Fastighet_tillstand, case when charindex(' ', Fastighet_tillstand) = 0 then len(Fastighet_tillstand) + 1 else charindex(' ', Fastighet_tillstand) end - 1) socken,Diarienummer,Fastighet_tillstand                                                             z,Beslut_datum,Utford_datum,Anteckning,Shape                                                                           anlShape from sde_miljo_halsoskydd.gng.ENSKILT_AVLOPP_sodra_P),
       aNo as (select left(Fastighet_tillstand, case when charindex(' ', Fastighet_tillstand) = 0 then len(Fastighet_tillstand) + 1 else charindex(' ', Fastighet_tillstand) end - 1) socken,Diarienummer,Fastighet_tillstand                                                             z,Beslut_datum,Utford_datum,Anteckning,Shape                                                                           anlShape from sde_miljo_halsoskydd.gng.ENSKILT_AVLOPP_Norra_P),
       aMo as (select left(Fastighet_tilstand, case when charindex(' ', Fastighet_tilstand) = 0 then len(Fastighet_tilstand) + 1 else charindex(' ', Fastighet_tilstand) end - 1) socken,Diarienummer,Fastighet_tilstand                                                            z,Beslut_datum,Utford_datum,Anteckning,Shape                                                                         anlShape from sde_miljo_halsoskydd.gng.ENSKILT_AVLOPP_MELLERSTA_P),
       sodra_p as (select Diarienummer, z q, Beslut_datum, Utford_datum, Anteckning, AllaAvlopp.anlShape, FAStighet from aSo AllaAvlopp inner join(select FiltreradeFast.*from #sockenYtor FiltreradeFast inner join (select socken from aso group by socken) q on socken = sockenX) FFast on AllaAvlopp.socken = ffast.SockenX and AllaAvlopp.anlShape.STIntersects(FFast.Shape) = 1),
       Norra_p as (select Diarienummer, z q, Beslut_datum, Utford_datum, Anteckning, AllaAvlopp.anlShape, FAStighet from aNo AllaAvlopp inner join(select FiltreradeFast.*from #sockenYtor FiltreradeFast inner join (select socken from aNo group by socken) q on socken = sockenX) FFast on AllaAvlopp.socken = ffast.SockenX and AllaAvlopp.anlShape.STIntersects(FFast.Shape) = 1),
       Mellersta_p as (select Diarienummer, z q, Beslut_datum, Utford_datum, Anteckning, AllaAvlopp.anlShape, FAStighet from aMo AllaAvlopp inner join(select FiltreradeFast.*from #sockenYtor FiltreradeFast inner join (select socken from aMo group by socken) q on socken = sockenX) FFast on AllaAvlopp.socken = ffast.SockenX and AllaAvlopp.anlShape.STIntersects(FFast.Shape) = 1)
      select FAStighet,Diarienummer,q            "Fastighet_tillstand",Beslut_datum,Utford_datum "utförddatum",Anteckning,anlShape     AnlaggningsPunkt into #Socken_tillstånd from (select * from sodra_p union all select * from norra_p union all select * from mellersta_p) z INSERT INTO @statusTable select N'rebuilt#Socken_tillstånd',CURRENT_TIMESTAMP,@@ROWCOUNT Print 'rebuilt#Socken_tillstånd' + CURRENT_TIMESTAMP + ' RowNR:' + @@ROWCOUNT; goto TableInitiate;

egetOmhändertagande:
     with
        LOKALT_SLAM_P as ( select Diarienr,Fastighet_,Fastighe00,Eget_omhän,Lokalt_omh,Anteckning,Beslutsdat, shape from sde_miljo_halsoskydd.gng.MoH_Slam_Lokalt_p_evw)
        ,Med_fastighet as (select * from (select *,concat(nullif(LOKALT_SLAM_P.Lokalt_omh,''),' ',nullif(LOKALT_SLAM_P.Fastighet_,''),' ',nullif(LOKALT_SLAM_P.Fastighe00,'')) fas from sde_miljo_halsoskydd.gng.MoH_Slam_Lokalt_p_evw LOKALT_SLAM_P) q where fas is not null and charindex(':',fas) > 0),
        utan_fastighet as (select OBJECTID,Fastighet_,Fastighets,Eget_omhän,Lokalt_omh,Fastighe00,Beslutsdat,Diarienr,Anteckning,utan_fastighet.Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID,FAStighet from (select *from sde_miljo_halsoskydd.gng.MoH_Slam_Lokalt_p_evw LOKALT_SLAM_P where charindex(':', concat(nullif(LOKALT_SLAM_P.Lokalt_omh, ''), ' ', nullif(LOKALT_SLAM_P.Fastighet_, ''), ' ', nullif(LOKALT_SLAM_P.Fastighe00, ''))) = 0) utan_fastighet inner join #SockenYtor sYt on sYt.shape.STIntersects(utan_fastighet.Shape) = 1)

        select fastighet,concat(nullif(Diarienr+'-','-'), nullif(Fastighe00+'-',' -'), nullif(Fastighet_+'-',' -'), nullif(Eget_omhän+'-',' -'), nullif(Lokalt_omh+'-',' -'), nullif(Anteckning+'-',' -'),FORMAT(Beslutsdat,'yyyy-MM-dd')) egetOmhändertangandeInfo,Shape  LocaltOmH into #egetOmhändertagande from
              (select OBJECTID,Fastighet_,Fastighets,Eget_omhän,Lokalt_omh,Fastighe00,Beslutsdat,Diarienr,Anteckning,Med_fastighet.Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID,FAStighet from #SockenYtor sYt left outer join Med_fastighet
                  on fas like '%' + sYt.Fastighet + '%' where fas is not null
              union all
              select * from utan_fastighet) as [sYMfuf*]
    INSERT INTO @statusTable select N'rebuilt#egetOmhändertagande',CURRENT_TIMESTAMP,@@ROWCOUNT

Print 'rebuilt#egetOmhändertagande' + CURRENT_TIMESTAMP + ' RowNR:' + @@ROWCOUNT;
;goto TableInitiate;
spillvaten:
    with
        Va_planomraden_171016_evw as   (select shape,dp_i_omr,planprog,planansokn from sde_pipe.gng.Va_planomraden_171016_evw)
         ,q as (
            select shape, concat(typkod,':',status,'(spill)') typ from sde_pipe.gng.VO_Spillvatten_evw VO_Spillvatten_evw union all
            select shape, concat('AVTALSABONNENT [Tabell_ObjID: ',OBJECTID,']') as c
            from sde_pipe.gng.AVTALSABONNENTER AVTALSABONNENTER union all
            select shape, concat('GEMENSAMHETSANLAGGNING: ',GEMENSAMHETSANLAGGNINGAR.GA) as c2
            from sde_pipe.gng.GEMENSAMHETSANLAGGNINGAR GEMENSAMHETSANLAGGNINGAR union all
            select shape,
                   isnull(coalesce(
                                  nullif(concat('dp_i_omr:',dp_i_omr) ,'dp_i_omr:'),
                                  nullif(concat('planprog:',planprog) ,'planprog:'),
                                  nullif(concat('planansokn:',planansokn) ,'planansokn:')
                                                                        ),N'okändStatus') as i
            from
            Va_planomraden_171016_evw
         )
  select sYt.fastighet, q.typ  into #spillvaten
  from #SockenYtor sYt
           inner join q on sYt.shape.STIntersects(q.Shape) = 1
    INSERT INTO @statusTable select 'rebuilt#spillvaten',CURRENT_TIMESTAMP,@@ROWCOUNT
Print 'rebuilt#spillvaten'  + CURRENT_TIMESTAMP + ' RowNR:' + @@ROWCOUNT;goto TableInitiate;

röd:
    with     slamm as (select strFastBeteckningHel,strDelprodukt,z2 = STUFF((SELECT distinct ','+ concat( nullif(x.strTaxebenamning,''), nullif(concat(' Avbrutet:', FORMAT(nullif(x.q2z, smalldatetimefromparts(1900, 01, 01, 00, 00)),'yyyy-MM-dd')), ' Avbrutet:'))FROM #slam x  where q.strFastBeteckningHel = x.strFastBeteckningHel  FOR XML PATH ('')), 1, 1, '')FROM #slam q group by strFastBeteckningHel,strDelprodukt)
             ,slam as (select strFastBeteckningHel,datStoppdatum =STUFF((SELECT distinct ','+nullif(strDelprodukt+'|','|')+z2 FROM slamm x  where q.strFastBeteckningHel = x.strFastBeteckningHel  FOR XML PATH ('')), 1, 1, '')from slamm q group by strFastBeteckningHel)
             , socknarOfInteresse as (select distinct sockenX socken, fastighet from #SockenYtor )
           ,byggnader as (select Fastighetsbeteckning fastighet, Byggnadstyp,ByggShape from #ByggnadPåFastighetISocken)
            ,vaPlan as (select fastighet,typ  from #spillvaten)
            ,egetOmhandertagande as (select  fastighet,egetOmhändertangandeInfo,LocaltOmH from #egetOmhändertagande )
            ,anlaggningar as (select diarienummer,Fastighet,Fastighet_tillstand,Beslut_datum,utförddatum,Anteckning,(case when not( isnull(Beslut_datum, DATETIME2FROMPARTS(1988, 1, 1, 1, 1, 1, 1, 1)) > (select DATETIME2FROMPARTS(2003, 1, 1, 1, 1, 1, 1, 1) datum) and isnull(utförddatum, DATETIME2FROMPARTS(1988, 1, 1, 1, 1, 1, 1, 1)) > (select DATETIME2FROMPARTS(2003, 1, 1, 1, 1, 1, 1, 1) datum)) then N'röd' else N'grön' end) fstatus,anlaggningspunkt from #Socken_tillstånd)
            , attUtsokaFran as (select *, row_number() over (partition by q.fastighet order by q.Anteckning desc ) flaggnr from (select anlaggningar.diarienummer,(case when anlaggningar.anlaggningspunkt is not null then anlaggningar.fstatus else '?' end) fstatus, socknarOfInteresse.socken,socknarOfInteresse.fastighet,Byggnadstyp,Fastighet_tillstand,Beslut_datum,utförddatum,Anteckning,(case when anlaggningar.anlaggningspunkt is not null then anlaggningar.anlaggningspunkt else ByggShape end) flagga from socknarOfInteresse left outer join byggnader on socknarOfInteresse.fastighet = byggnader.fastighet left outer join anlaggningar on socknarOfInteresse.fastighet = anlaggningar.fastighet) q  where q.flagga is not null)
            ,gul as (select null "fstat" ) -- from fastighets_Anslutningar_Gemensamhetanläggningar)

            select socken,fastighet,Fastighet_tillstand,Byggnadstyp,Beslut_datum,utförddatum,Anteckning,VaPlan,egetOmhändertangandeInfo,slam,flaggnr,flagga, (case when fstatus = N'röd' then (case when (vaPlan is null and egetOmhändertangandeInfo is null) then N'röd' else (case when VaPlan is not null then 'KomV?' else (case when null is not null then 'gem' else '?' end) end) end) else fstatus end ) Fstatus
            into #röd from (select attUtsokaFran.socken,
                                   attUtsokaFran.fastighet,
                                                           attUtsokaFran.Fastighet_tillstand,attUtsokaFran.Diarienummer,
                                                           attUtsokaFran.Byggnadstyp,
                                                           FORMAT(nullif(attUtsokaFran.Beslut_datum, smalldatetimefromparts(1900, 01, 01, 00, 00)),'yyyy-MM-dd') Beslut_datum,
                                                           FORMAT(nullif(attUtsokaFran.utförddatum, smalldatetimefromparts(1900, 01, 01, 00, 00)),'yyyy-MM-dd') utförddatum,
                                                           attUtsokaFran.Anteckning,
                                VaPlan                   = (select top 1 typ
                                                            from vaPlan
                                                            where vaPlan.fastighet = attUtsokaFran.fastighet),
                                                           fstatus,
                                egetOmhändertangandeInfo = (select top 1 egetOmhändertangandeInfo
                                                            from egetOmhandertagande
                                                            where attUtsokaFran.fastighet = egetOmhandertagande.fastighet),
                                slam                     = (select top 1 datStoppdatum
                                                            from slam
                                                            where attUtsokaFran.fastighet = slam.strFastBeteckningHel),
                                                           flaggnr,
                                                           flagga.STPointN(1) flagga

                            from attUtsokaFran) q

            INSERT INTO @statusTable select N'rebuilt#Röd',CURRENT_TIMESTAMP,@@ROWCOUNT

Print 'rebuilt#Röd' + CURRENT_TIMESTAMP + ' RowNR:' + @@ROWCOUNT;


repport:

--select * from #röd where left(fastighet, len(N'Björke')) = N'Björke';
--select * from #röd where left(fastighet, len('Dalhem')) = 'Dalhem';
--select * from #röd where left(fastighet, len(N'Fröjel')) = N'Fröjel';
--select * from #röd where left(fastighet, len('Ganthem')) = 'Ganthem';
--select * from #röd where left(fastighet, len('Halla')) = 'Halla';
--select * from #röd where left(fastighet, len('Klinte')) = 'Klinte';
--select * from #röd where left(fastighet, len('Roma')) = 'Roma';
select * from @statusTable

select * from (select socken,fastighet,(case when fstatus = '?' then 'röd' else fstatus end) "Status",Fastighet_tillstand,Byggnadstyp,Beslut_datum,utförddatum,Anteckning,VaPlan,egetOmhändertangandeInfo,slam,flaggnr from #röd) as r2 order by socken,Status,fastighet

taxekod:
end try begin catch select * from @statusTable end catch
;
--end try begin catch select 1 end catch;




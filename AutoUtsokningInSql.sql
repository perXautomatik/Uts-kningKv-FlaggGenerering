/*Insert Databases names into SQL Temp Table*/
begin try
    declare @statusTable table (medelande NVARCHAR(max), start     smalldatetime, rader     integer);
TableInitiate:

-- dropTabels?

    INSERT INTO @statusTable (medelande) select '#initiating#slam'; IF OBJECT_ID('tempdb..#slam') IS NULL RAISERROR ( 18,-1,-1,'taxekodTabell saknas, exekvera om slaminitate');ELSE BEGIN IF NOT (exists(SELECT 1 FROM #SLAM)) BEGIN DROP TABLE #SLAM; RAISERROR ( 18,-1,-1,N'taxekod Var olämplig,tabell förstörd, exekvera-om slaminitiate')END END INSERT INTO @statusTable select 'preloading#slam', CURRENT_TIMESTAMP, count(*) from #slam;
    INSERT INTO @statusTable (medelande) select '#initiating#sockenYtor'; IF OBJECT_ID('tempdb..#SockenYtor') IS NULL goto SockenYtor ELSE BEGIN IF NOT (exists(SELECT 1 FROM #SOCKENYTOR)) BEGIN DROP TABLE #SOCKENYTOR; GOTO SOCKENYTOR;END END INSERT INTO @statusTable select 'preloading#SockenYtor', CURRENT_TIMESTAMP, count(*) from #SockenYtor;
    INSERT INTO @statusTable (medelande) select '#initiating#Byggnader'; IF OBJECT_ID(N'tempdb..#ByggnadPåFastighetISocken') IS NULL goto ByggnadPåFastighetISocken ELSE BEGIN IF NOT (exists(SELECT 1 FROM #BYGGNADPÅFASTIGHETISOCKEN)) BEGIN DROP TABLE #BYGGNADPÅFASTIGHETISOCKEN; GOTO BYGGNADPÅFASTIGHETISOCKEN;END END INSERT INTO @statusTable select 'preloading#ByggnadPåFastighetISocken', CURRENT_TIMESTAMP, count(*)from #ByggnadPåFastighetISocken;
    INSERT INTO @statusTable (medelande) select '#initiating#sockenTillstånd'; IF OBJECT_ID(N'tempdb..#Socken_tillstånd') IS NULL goto Socken_tillstånd ELSE BEGIN IF NOT (exists(SELECT 1 FROM #SOCKEN_TILLSTÅND)) BEGIN DROP TABLE #SOCKEN_TILLSTÅND; GOTO SOCKEN_TILLSTÅND;END END INSERT INTO @statusTable select 'preloading#Socken_tillstånd', CURRENT_TIMESTAMP, count(*) from #Socken_tillstånd;
    INSERT INTO @statusTable (medelande) select '#initiating#egetOmhändertagande'; IF OBJECT_ID(N'tempdb..#egetOmhändertagande') IS NULL goto egetOmhändertagande ELSE BEGIN IF NOT (exists(SELECT 1 FROM #EGETOMHÄNDERTAGANDE)) BEGIN DROP TABLE #EGETOMHÄNDERTAGANDE; GOTO EGETOMHÄNDERTAGANDE;END END INSERT INTO @statusTable select 'preloading#egetOmhändertagande', CURRENT_TIMESTAMP, count(*) from #egetOmhändertagande;
    INSERT INTO @statusTable (medelande) select '#initiating#Spillvatten'; IF OBJECT_ID('tempdb..#spillvaten') IS NULL goto spillvaten ELSE BEGIN IF NOT (exists(SELECT 1 FROM #SPILLVATEN)) BEGIN DROP TABLE #SPILLVATEN; GOTO SPILLVATEN;END END INSERT INTO @statusTable select 'preloading#spillvaten', CURRENT_TIMESTAMP, count(*) from #spillvaten;
    INSERT INTO @statusTable (medelande) select '#initiating#röd'; IF OBJECT_ID(N'tempdb..#röd') IS NULL goto röd ELSE BEGIN IF NOT (exists(SELECT 1 FROM #RÖD)) BEGIN DROP TABLE #RÖD; GOTO RÖD;END END INSERT INTO @statusTable select 'preloading#röd', CURRENT_TIMESTAMP, count(*) from #röd INSERT INTO @statusTable (medelande) select '#goingToRepport';goto repport


    if (select 1) IS NULL
        BEGIN TRY
            BEGIN TRANSACTION
                Drop table #SockenYtor
                Drop table #ByggnadPåFastighetISocken
                Drop table #Socken_tillstånd
                Drop table #egetOmhändertagande
                Drop table #spillvaten
                Drop table #slam
                Drop table #röd
            Commit Transaction
        end try begin catch ROLLBACK Transaction end catch goto TableInitiate --koden skall inte exekveras i läsordning, alla initiate test moste först slutföras, sedan går programmet till repportblocket.

SockenYtor:
    declare @tid smalldatetime set @tid = CURRENT_TIMESTAMP INSERT INTO @statusTable (medelande) select 'Starting#SockenYtor' BEGIN TRY BEGIN TRANSACTION
	    WITH
		SOCKNAROFINTRESSE AS (SELECT N'Björke' "socken" UNION SELECT 'Dalhem' AS ALIAS2 UNION SELECT N'Fröjel' AS ALIAS234567 UNION SELECT 'Ganthem' AS ALIAS23 UNION SELECT 'Halla' AS ALIAS234 UNION SELECT 'Klinte' AS ALIAS2345 UNION SELECT 'Roma' AS ALIAS23456)
	    	SELECT SOCKEN SOCKENX, concat(TRAKT, ' ', BLOCKENHET) FASTIGHET, SHAPE INTO #SOCKENYTOR FROM SDE_GSD.GNG.AY_0980 X INNER JOIN SOCKNAROFINTRESSE ON left(X.TRAKT, len(SOCKNAROFINTRESSE.SOCKEN)) = SOCKNAROFINTRESSE.SOCKEN
        Commit Transaction
    end try begin catch ROLLBACK TRANSACTION insert into @statusTable select ERROR_MESSAGE(), CURRENT_TIMESTAMP, @@ROWCOUNTprint 'failed to build' throw end catch set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO @statusTable select 'rebuilt#', @tid, @@ROWCOUNT goto TableInitiate

ByggnadPåFastighetISocken:
	set @tid = CURRENT_TIMESTAMP INSERT INTO @statusTable (medelande) select 'Starting#Byggnadsyta' BEGIN TRY BEGIN TRANSACTION
	    WITH
		BYGGNAD_YTA AS (SELECT ANDAMAL_1T BYGGNADSTYP, SHAPE FROM SDE_GSD.GNG.BY_0980),
	        Q AS (SELECT BYGGNADSTYP, SOCKNAROFINTRESSE.FASTIGHET FASTIGHETSBETECKNING, BYGGNAD_YTA.SHAPE FROM BYGGNAD_YTA INNER JOIN #SOCKENYTOR SOCKNAROFINTRESSE ON BYGGNAD_YTA.SHAPE.STWithin(SOCKNAROFINTRESSE.SHAPE) = 1)
	    SELECT FASTIGHETSBETECKNING, BYGGNADSTYP, SHAPE BYGGSHAPE INTO #BYGGNADPÅFASTIGHETISOCKEN FROM (SELECT *, row_number() OVER (PARTITION BY FASTIGHETSBETECKNING ORDER BY BYGGNADSTYP ) ORDERZ FROM Q) Z WHERE ORDERZ = 1;
	COMMIT TRANSACTION
    END TRY BEGIN CATCH ROLLBACK TRANSACTION INSERT INTO @STATUSTABLE SELECT ERROR_MESSAGE(), CURRENT_TIMESTAMP, @@ROWCOUNTPRINT 'failed to build' THROW END CATCH SET @TID = CURRENT_TIMESTAMP - @TID INSERT INTO @STATUSTABLE SELECT 'rebuilt#', @TID, @@ROWCOUNT GOTO TABLEINITIATE;

SOCKEN_TILLSTÅND:
    SET @TID = CURRENT_TIMESTAMP INSERT INTO @STATUSTABLE (MEDELANDE) SELECT 'Starting#Socken_tillstånd' BEGIN TRY BEGIN TRANSACTION
	    WITH
		ANSOMEDSOCKEN      AS (SELECT left(FASTIGHET_TILLSTAND, CASE WHEN charindex(' ', FASTIGHET_TILLSTAND) = 0 THEN len(FASTIGHET_TILLSTAND) + 1 ELSE charindex(' ', FASTIGHET_TILLSTAND)END - 1)       SOCKEN, DIARIENUMMER, FASTIGHET_TILLSTAND Z, BESLUT_DATUM, UTFORD_DATUM, ANTECKNING, SHAPE               ANLSHAPE FROM SDE_MILJO_HALSOSKYDD.GNG.ENSKILT_AVLOPP_SODRA_P)
	      , ANNOMEDSOCKEN      AS (SELECT left(FASTIGHET_TILLSTAND, CASE WHEN charindex(' ', FASTIGHET_TILLSTAND) = 0 THEN len(FASTIGHET_TILLSTAND) + 1 ELSE charindex(' ', FASTIGHET_TILLSTAND)END - 1)       SOCKEN, DIARIENUMMER, FASTIGHET_TILLSTAND Z, BESLUT_DATUM, UTFORD_DATUM, ANTECKNING, SHAPE               ANLSHAPE FROM SDE_MILJO_HALSOSKYDD.GNG.ENSKILT_AVLOPP_NORRA_P)
	      , ANMEMEDSOCKEN      AS (SELECT left(FASTIGHET_TILSTAND, CASE WHEN charindex(' ', FASTIGHET_TILSTAND) = 0 THEN len(FASTIGHET_TILSTAND) + 1 ELSE charindex(' ', FASTIGHET_TILSTAND)END - 1) SOCKEN, DIARIENUMMER, FASTIGHET_TILSTAND                Z, BESLUT_DATUM, UTFORD_DATUM, ANTECKNING, SHAPE                             ANLSHAPE FROM SDE_MILJO_HALSOSKYDD.GNG.ENSKILT_AVLOPP_MELLERSTA_P)
	      , SODRAFILTRERAD     AS (SELECT DIARIENUMMER, Z Q, BESLUT_DATUM, UTFORD_DATUM, ANTECKNING, ALLAAVLOPP.ANLSHAPE, FASTIGHET FROM ANSOMEDSOCKEN ALLAAVLOPP INNER JOIN(SELECT FILTRERADEFAST.*FROM #SOCKENYTOR FILTRERADEFAST INNER JOIN (SELECT SOCKEN FROM ANSOMEDSOCKEN GROUP BY SOCKEN) Q ON SOCKEN = SOCKENX) FFAST ON ALLAAVLOPP.SOCKEN = FFAST.SOCKENX AND ALLAAVLOPP.ANLSHAPE.STIntersects(FFAST.SHAPE) = 1)
	      , NORRAFILTRERAD     AS (SELECT DIARIENUMMER, Z Q, BESLUT_DATUM, UTFORD_DATUM, ANTECKNING, ALLAAVLOPP.ANLSHAPE, FASTIGHET FROM ANNOMEDSOCKEN ALLAAVLOPP INNER JOIN(SELECT FILTRERADEFAST.*FROM #SOCKENYTOR FILTRERADEFAST INNER JOIN (SELECT SOCKEN FROM ANNOMEDSOCKEN GROUP BY SOCKEN) Q ON SOCKEN = SOCKENX) FFAST ON ALLAAVLOPP.SOCKEN = FFAST.SOCKENX AND ALLAAVLOPP.ANLSHAPE.STIntersects(FFAST.SHAPE) = 1)
	      , MELLERSTAFILTRERAD AS (SELECT DIARIENUMMER, Z Q, BESLUT_DATUM, UTFORD_DATUM, ANTECKNING, ALLAAVLOPP.ANLSHAPE, FASTIGHET FROM ANMEMEDSOCKEN ALLAAVLOPP INNER JOIN(SELECT FILTRERADEFAST.*FROM #SOCKENYTOR FILTRERADEFAST INNER JOIN (SELECT SOCKEN FROM ANMEMEDSOCKEN GROUP BY SOCKEN) Q ON SOCKEN = SOCKENX) FFAST ON ALLAAVLOPP.SOCKEN = FFAST.SOCKENX AND ALLAAVLOPP.ANLSHAPE.STIntersects(FFAST.SHAPE) = 1)
	      , SAMMANSLAGNA       AS (SELECT DIARIENUMMER, Q                                                     "Fastighet_tillstand", isnull(TRY_CONVERT(DATETIME, BESLUT_DATUM, 102), DATETIME2FROMPARTS(1988, 1, 1, 1, 1, 1, 1, 1)) BESLUT_DATUM, isnull(TRY_CONVERT(DATETIME, UTFORD_DATUM, 102), DATETIME2FROMPARTS(1988, 1, 1, 1, 1, 1, 1, 1)) UTFORD_DATUM, ANTECKNING, ANLSHAPE, FASTIGHET FROM (SELECT * FROM SODRAFILTRERAD UNION ALL SELECT * FROM NORRAFILTRERAD UNION ALL SELECT * FROM MELLERSTAFILTRERAD) Z)
	    SELECT FASTIGHET, DIARIENUMMER, FASTIGHET_TILLSTAND, BESLUT_DATUM, UTFORD_DATUM "utförddatum", ANTECKNING, ANLSHAPE     ANLAGGNINGSPUNKT INTO #SOCKEN_TILLSTÅND FROM SAMMANSLAGNA
	COMMIT TRANSACTION
    END TRY BEGIN CATCH ROLLBACK TRANSACTION INSERT INTO @STATUSTABLE SELECT ERROR_MESSAGE(), CURRENT_TIMESTAMP, @@ROWCOUNTPRINT 'failed to build' THROW END CATCH set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO @statusTable select 'rebuilt#', @tid, @@ROWCOUNT goto TableInitiate;

egetOmhändertagande:
    set @tid = CURRENT_TIMESTAMP INSERT INTO @statusTable (medelande) select 'Starting#egetOmhändertagande' BEGIN TRY BEGIN TRANSACTION
	    WITH
		LOKALT_SLAM_P  AS (SELECT DIARIENR, FASTIGHET_, FASTIGHE00, EGET_OMHÄN, LOKALT_OMH, ANTECKNING, BESLUTSDAT, SHAPE FROM SDE_MILJO_HALSOSKYDD.GNG.MOH_SLAM_LOKALT_P_EVW)
	      , MED_FASTIGHET  AS (SELECT *FROM (SELECT *, concat(nullif(LOKALT_SLAM_P.LOKALT_OMH, ''), ' ', nullif(LOKALT_SLAM_P.FASTIGHET_, ''), ' ', nullif(LOKALT_SLAM_P.FASTIGHE00, '')) FAS FROM SDE_MILJO_HALSOSKYDD.GNG.MOH_SLAM_LOKALT_P_EVW LOKALT_SLAM_P) Q WHERE FAS IS NOT NULL AND charindex(':', FAS) > 0)
	      , UTAN_FASTIGHET AS (SELECT OBJECTID, FASTIGHET_, FASTIGHETS, EGET_OMHÄN, LOKALT_OMH, FASTIGHE00, BESLUTSDAT, DIARIENR, ANTECKNING, UTAN_FASTIGHET.SHAPE, GDB_GEOMATTR_DATA, SDE_STATE_ID, FASTIGHET FROM (SELECT *FROM SDE_MILJO_HALSOSKYDD.GNG.MOH_SLAM_LOKALT_P_EVW LOKALT_SLAM_P WHERE charindex(':', concat(nullif(LOKALT_SLAM_P.LOKALT_OMH, ''), ' ', nullif(LOKALT_SLAM_P.FASTIGHET_, ''), ' ', nullif(LOKALT_SLAM_P.FASTIGHE00, ''))) = 0) UTAN_FASTIGHET INNER JOIN #SOCKENYTOR SYT ON SYT.SHAPE.STIntersects(UTAN_FASTIGHET.SHAPE) = 1)
	    SELECT FASTIGHET, concat(nullif(DIARIENR + '-', '-'), nullif(FASTIGHE00 + '-', ' -'), nullif(FASTIGHET_ + '-', ' -'), nullif(EGET_OMHÄN + '-', ' -'), nullif(LOKALT_OMH + '-', ' -'), nullif(ANTECKNING + '-', ' -'), FORMAT(BESLUTSDAT, 'yyyy-MM-dd')) EGETOMHÄNDERTANGANDEINFO, SHAPE                                                                    LOCALTOMH INTO #EGETOMHÄNDERTAGANDE FROM (SELECT OBJECTID, FASTIGHET_, FASTIGHETS, EGET_OMHÄN, Lokalt_omh, Fastighe00, Beslutsdat, Diarienr, Anteckning, Med_fastighet.Shape, GDB_GEOMATTR_DATA, SDE_STATE_ID, FAStighet from #SockenYtor sYt left outer join Med_fastighet on fas like '%' + sYt.Fastighet + '%' where fas is not null union all select *from utan_fastighet) as [sYMfuf*]
        Commit Transaction
    end try begin catch ROLLBACK TRANSACTION insert into @statusTable select ERROR_MESSAGE(), CURRENT_TIMESTAMP, @@ROWCOUNTprint 'failed to build' throw end catch set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO @statusTable select 'rebuilt#', @tid, @@ROWCOUNT goto TableInitiate

spillvaten:
    set @tid = CURRENT_TIMESTAMP INSERT INTO @statusTable (medelande) select 'Starting#spillvaten' BEGIN TRY BEGIN TRANSACTION
            with
                Va_planomraden_171016_evw as (select shape, dp_i_omr, planprog, planansokn from sde_pipe.gng.Va_planomraden_171016_evw),
                 q as (select shape, concat(typkod, ':', status, '(spill)') typ from sde_pipe.gng.VO_Spillvatten_evw VO_Spillvatten_evw union all select shape, concat('AVTALSABONNENT [Tabell_ObjID: ', OBJECTID, ']') as c from sde_pipe.gng.AVTALSABONNENTER AVTALSABONNENTER union all select shape, concat('GEMENSAMHETSANLAGGNING: ', GEMENSAMHETSANLAGGNINGAR.GA) as c2 from sde_pipe.gng.GEMENSAMHETSANLAGGNINGAR GEMENSAMHETSANLAGGNINGAR union all select shape, isnull(coalesce(nullif(concat('dp_i_omr:', dp_i_omr), 'dp_i_omr:'), nullif(concat('planprog:', planprog), 'planprog:'), nullif(concat('planansokn:', planansokn), 'planansokn:')), N'okändStatus') as i from Va_planomraden_171016_evw)
            select sYt.fastighet, q.typ into #spillvaten from #SockenYtor sYt inner join q on sYt.shape.STIntersects(q.Shape) = 1
            Commit Transaction
        end try begin catch ROLLBACK TRANSACTION insert into @statusTable select ERROR_MESSAGE(), CURRENT_TIMESTAMP, @@ROWCOUNTprint 'failed to build' throw end catch set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO @statusTable select 'rebuilt#', @tid, @@ROWCOUNT goto TableInitiate

    röd:
    set @tid = CURRENT_TIMESTAMP INSERT INTO @statusTable (medelande) select 'Starting#Röd' BEGIN TRY BEGIN TRANSACTION
            with
                slamm as (select strFastBeteckningHel, strDelprodukt, z2 = STUFF((SELECT distinct ',' + concat(nullif(x.strTaxebenamning, ''), nullif(concat(' Avbrutet:', FORMAT(nullif(x.q2z, smalldatetimefromparts(1900, 01, 01, 00, 00)), 'yyyy-MM-dd')), ' Avbrutet:')) as c3s FROM #slam x where q.strFastBeteckningHel = x.strFastBeteckningHel FOR XML PATH ('')), 1, 1, '')FROM #slam q group by strFastBeteckningHel, strDelprodukt)
               , slam as (select strFastBeteckningHel, datStoppdatum =STUFF((SELECT distinct ',' + nullif(strDelprodukt + '|', '|') + z2 as nadas FROM slamm x where q.strFastBeteckningHel = x.strFastBeteckningHel FOR XML PATH ('')), 1, 1, '')from slamm q group by strFastBeteckningHel)
               , socknarOfInteresse as (select distinct sockenX socken, fastighet from #SockenYtor)
               , byggnader as (select Fastighetsbeteckning fastighet, Byggnadstyp, ByggShape from #ByggnadPåFastighetISocken)
               , vaPlan as (select fastighet, typ from #spillvaten)
               , egetOmhandertagande as (select fastighet, egetOmhändertangandeInfo, LocaltOmH from #egetOmhändertagande)
               , anlaggningar as (select diarienummer, Fastighet, Fastighet_tillstand, Beslut_datum, utförddatum, Anteckning, (case when not (Beslut_datum > DATETIME2FROMPARTS(2003, 1, 1, 1, 1, 1, 1, 1) and utförddatum > DATETIME2FROMPARTS(2003, 1, 1, 1, 1, 1, 1, 1)) then N'röd' else N'grön' end) fstatus, anlaggningspunkt from #Socken_tillstånd)
               , attUtsokaFran as (select *, row_number() over (partition by q.fastighet order by q.Anteckning desc ) flaggnr from (select anlaggningar.diarienummer, (case when anlaggningar.anlaggningspunkt is not null then anlaggningar.fstatus else '?' end)       fstatus, socknarOfInteresse.socken, socknarOfInteresse.fastighet, Byggnadstyp, Fastighet_tillstand, Beslut_datum, utförddatum, Anteckning, (case when anlaggningar.anlaggningspunkt is not null then anlaggningar.anlaggningspunkt else ByggShape end) flagga from socknarOfInteresse left outer join byggnader on socknarOfInteresse.fastighet = byggnader.fastighet left outer join anlaggningar on socknarOfInteresse.fastighet = anlaggningar.fastighet) q where q.flagga is not null)
               , q as (select                         attUtsokaFran.socken, attUtsokaFran.fastighet, attUtsokaFran.Fastighet_tillstand, attUtsokaFran.Diarienummer, attUtsokaFran.Byggnadstyp, Beslut_datum, utförddatum        "utförddatum", attUtsokaFran.Anteckning, VaPlan                   = (select top 1 typ from vaPlan where vaPlan.fastighet = attUtsokaFran.fastighet), fstatus, egetOmhändertangandeInfo = (select top 1 egetOmhändertangandeInfo from egetOmhandertagande where attUtsokaFran.fastighet = egetOmhandertagande.fastighet), slam                     = (select top 1 datStoppdatum from slam where attUtsokaFran.fastighet = slam.strFastBeteckningHel), flaggnr, flagga.STPointN(1) flagga from attUtsokaFran)
               , röd as (select socken, fastighet, Fastighet_tillstand, Byggnadstyp, Beslut_datum, utförddatum, Anteckning, VaPlan, egetOmhändertangandeInfo, slam, flaggnr, flagga, (case when fstatus = N'röd' then (case when (vaPlan is null and egetOmhändertangandeInfo is null) then N'röd' else (case when VaPlan is not null then 'KomV?' else (case when null is not null then 'gem' else '?' end) end) end)else fstatus end) Fstatus from q)
            select *into #röd from röd
	Commit Transaction
    end try begin catch ROLLBACK TRANSACTION insert into @statusTable select ERROR_MESSAGE(), CURRENT_TIMESTAMP, @@ROWCOUNTprint 'failed to build' throw end catch set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO @statusTable select 'rebuilt#', @tid, @@ROWCOUNT goto TableInitiate



repport:
    select * from @statusTable end try begin catch insert into @statusTable select ERROR_MESSAGE(), CURRENT_TIMESTAMP, @@ROWCOUNT select * from @statusTable end catch



--Kopierade tabellföreteckning från gng.FLAGGSKIKTET_P
set @tid = CURRENT_TIMESTAMP INSERT INTO @statusTable (medelande)select 'tableCreate#Inventering_Bjorke' BEGIN TRY BEGIN TRANSACTION
        create table gng.Inventering_Bjorke (OBJECTID            int not null constraint invBj_pk primary key, FASTIGHET           nvarchar(150), Fastighet_tillstand nvarchar(150), Arendenummer        nvarchar(50), Beslut_datum        datetime2, Status              nvarchar(50), Utskick_datum       datetime2, Anteckning          nvarchar(254), Utforddatum         datetime2, Slamhamtning        nvarchar(100), Antal_byggnader     numeric(38, 8), alltidsant          int, Shape               geometry, GDB_GEOMATTR_DATA   varbinary(max), skapad_datum        datetime2, andrad_datum        datetime2)
end try begin catch ROLLBACK TRANSACTION insert into @statusTable select ERROR_MESSAGE(), CURRENT_TIMESTAMP, @@ROWCOUNTprint 'failed to build' throw end catch set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO @statusTable select 'built#', @tid, @@ROWCOUNT

go set @tid = CURRENT_TIMESTAMP INSERT INTO @statusTable (medelande)select 'createIndex#Inventering_Bjorke' BEGIN TRY
    create index invBj_idx on gng.Inventering_Bjorke (Shape)
end try begin catch ROLLBACK TRANSACTION insert into @statusTable select ERROR_MESSAGE(), CURRENT_TIMESTAMP, @@ROWCOUNTprint 'failed to build' throw end catch set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO @statusTable select 'built#', @tid, @@ROWCOUNT Commit Transaction

go
BEGIN TRANSACTION
    insert into gng.Inventering_Bjorke (OBJECTID, FASTIGHET, Fastighet_tillstand, Beslut_datum, Status, Anteckning, Utforddatum, Slamhamtning, Antal_byggnader, alltidsant, Shape, skapad_datum, andrad_datum)select (row_number() over (order by fastighet,flaggnr)), fastighet, Fastighet_tillstand, Beslut_datum, Fstatus, concat(Byggnadstyp, ' ', Anteckning, ' ', nullif(concat('vaPlan: ', VaPlan, ' '), 'vaPlan:  '), nullif(concat('egetOmh: ', egetOmhändertangandeInfo, ' '), 'egetOmh:  ')), utförddatum, slam, flaggnr, 1, flagga, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP from #röd where Socken = N'Björke';
Commit Transaction

set @tid = CURRENT_TIMESTAMP INSERT INTO @statusTable (medelande)select 'tableCreate#Inventering_dalhem' BEGIN TRY BEGIN TRANSACTION
        create table gng.Inventering_dalhem (OBJECTID            int not null constraint invdalhem_pk primary key, FASTIGHET           nvarchar(150), Fastighet_tillstand nvarchar(150), Arendenummer        nvarchar(50), Beslut_datum        datetime2, Status              nvarchar(50), Utskick_datum       datetime2, Anteckning          nvarchar(254), Utforddatum         datetime2, Slamhamtning        nvarchar(100), Antal_byggnader     numeric(38, 8), alltidsant          int, Shape               geometry, GDB_GEOMATTR_DATA   varbinary(max), skapad_datum        datetime2, andrad_datum        datetime2)
end try begin catch ROLLBACK TRANSACTION insert into @statusTable select ERROR_MESSAGE(), CURRENT_TIMESTAMP, @@ROWCOUNTprint 'failed to build' throw end catch set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO @statusTable select 'built#', @tid, @@ROWCOUNT

go
set @tid = CURRENT_TIMESTAMP INSERT INTO @statusTable (medelande)select 'createIndex#Inventering_dalhem' BEGIN TRY
    create index invdalhem_idx on gng.Inventering_dalhem (Shape)
end try begin catch ROLLBACK TRANSACTION insert into @statusTable select ERROR_MESSAGE(), CURRENT_TIMESTAMP, @@ROWCOUNTprint 'failed to build' throw end catch set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO @statusTable select 'built#', @tid, @@ROWCOUNT Commit Transaction

go
BEGIN TRANSACTION
    insert into gng.Inventering_Dalhem (OBJECTID, FASTIGHET, Fastighet_tillstand, Beslut_datum, Status, Anteckning, Utforddatum, Slamhamtning, Antal_byggnader, alltidsant, Shape, skapad_datum, andrad_datum)select (row_number() over (order by fastighet,flaggnr)), fastighet, Fastighet_tillstand, Beslut_datum, Fstatus, concat(Byggnadstyp, ' ', Anteckning, ' ', nullif(concat('vaPlan: ', VaPlan, ' '), 'vaPlan:  '), nullif(concat('egetOmh: ', egetOmhändertangandeInfo, ' '), 'egetOmh:  ')), utförddatum, slam, flaggnr, 1, flagga, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP from #röd where Socken = 'Dalhem';
Commit Transaction


set @tid = CURRENT_TIMESTAMP INSERT INTO @statusTable (medelande)select 'tableCreate#Inventering_frojel' BEGIN TRY BEGIN TRANSACTION
        create table gng.Inventering_frojel (OBJECTID            int not null constraint invfrojel_pk primary key, FASTIGHET           nvarchar(150), Fastighet_tillstand nvarchar(150), Arendenummer        nvarchar(50), Beslut_datum        datetime2, Status              nvarchar(50), Utskick_datum       datetime2, Anteckning          nvarchar(254), Utforddatum         datetime2, Slamhamtning        nvarchar(100), Antal_byggnader     numeric(38, 8), alltidsant          int, Shape               geometry, GDB_GEOMATTR_DATA   varbinary(max), skapad_datum        datetime2, andrad_datum        datetime2)
end try begin catch ROLLBACK TRANSACTION insert into @statusTable select ERROR_MESSAGE(), CURRENT_TIMESTAMP, @@ROWCOUNTprint 'failed to build' throw end catch set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO @statusTable select 'built#', @tid, @@ROWCOUNT

go
set @tid = CURRENT_TIMESTAMP INSERT INTO @statusTable (medelande)select 'createIndex#Inventering_frojel' BEGIN TRY
    create index invfrojel_idx on gng.Inventering_frojel (Shape)
end try begin catch ROLLBACK TRANSACTION insert into @statusTable select ERROR_MESSAGE(), CURRENT_TIMESTAMP, @@ROWCOUNTprint 'failed to build' throw end catch set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO @statusTable select 'built#', @tid, @@ROWCOUNT Commit Transaction

go
BEGIN TRANSACTION
    insert into gng.Inventering_frojel (OBJECTID, FASTIGHET, Fastighet_tillstand, Beslut_datum, Status, Anteckning, Utforddatum, Slamhamtning, Antal_byggnader, alltidsant, Shape, skapad_datum, andrad_datum)select (row_number() over (order by fastighet,flaggnr)), fastighet, Fastighet_tillstand, Beslut_datum, Fstatus, concat(Byggnadstyp, ' ', Anteckning, ' ', nullif(concat('vaPlan: ', VaPlan, ' '), 'vaPlan:  '), nullif(concat('egetOmh: ', egetOmhändertangandeInfo, ' '), 'egetOmh:  ')), utförddatum, slam, flaggnr, 1, flagga, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP from #röd where Socken = 'fröjel';
COMMIT TRANSACTION

set @tid = CURRENT_TIMESTAMP INSERT INTO @statusTable (medelande)select 'tableCreate#Inventering_ganthem' BEGIN TRY BEGIN TRANSACTION
        create table gng.Inventering_ganthem (OBJECTID            int not null constraint invganthem_pk primary key, FASTIGHET           nvarchar(150), Fastighet_tillstand nvarchar(150), Arendenummer        nvarchar(50), Beslut_datum        datetime2, Status              nvarchar(50), Utskick_datum       datetime2, Anteckning          nvarchar(254), Utforddatum         datetime2, Slamhamtning        nvarchar(100), Antal_byggnader     numeric(38, 8), alltidsant          int, Shape               geometry, GDB_GEOMATTR_DATA   varbinary(max), skapad_datum        datetime2, andrad_datum        datetime2)
end try begin catch ROLLBACK TRANSACTION insert into @statusTable select ERROR_MESSAGE(), CURRENT_TIMESTAMP, @@ROWCOUNTprint 'failed to build' throw end catch set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO @statusTable select 'built#', @tid, @@ROWCOUNT

go
set @tid = CURRENT_TIMESTAMP INSERT INTO @statusTable (medelande)select 'createIndex#Inventering_ganthem' BEGIN TRY
    create index invganthem_idx on gng.Inventering_ganthem (Shape)
end try begin catch ROLLBACK TRANSACTION insert into @statusTable select ERROR_MESSAGE(), CURRENT_TIMESTAMP, @@ROWCOUNTprint 'failed to build' throw end catch set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO @statusTable select 'built#', @tid, @@ROWCOUNT Commit Transaction

go
BEGIN TRANSACTION
    insert into gng.Inventering_ganthem (OBJECTID, FASTIGHET, Fastighet_tillstand, Beslut_datum, Status, Anteckning, Utforddatum, Slamhamtning, Antal_byggnader, alltidsant, Shape, skapad_datum, andrad_datum)select (row_number() over (order by fastighet,flaggnr)), fastighet, Fastighet_tillstand, Beslut_datum, Fstatus, concat(Byggnadstyp, ' ', Anteckning, ' ', nullif(concat('vaPlan: ', VaPlan, ' '), 'vaPlan:  '), nullif(concat('egetOmh: ', egetOmhändertangandeInfo, ' '), 'egetOmh:  ')), utförddatum, slam, flaggnr, 1, flagga, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP from #röd where Socken = 'ganthem';
Commit Transaction


set @tid = CURRENT_TIMESTAMP INSERT INTO @statusTable (medelande)select 'tableCreate#Inventering_halla' BEGIN TRY BEGIN TRANSACTION
        create table gng.Inventering_halla (OBJECTID            int not null constraint invhalla_pk primary key, FASTIGHET           nvarchar(150), Fastighet_tillstand nvarchar(150), Arendenummer        nvarchar(50), Beslut_datum        datetime2, Status              nvarchar(50), Utskick_datum       datetime2, Anteckning          nvarchar(254), Utforddatum         datetime2, Slamhamtning        nvarchar(100), Antal_byggnader     numeric(38, 8), alltidsant          int, Shape               geometry, GDB_GEOMATTR_DATA   varbinary(max), skapad_datum        datetime2, andrad_datum        datetime2)
end try begin catch ROLLBACK TRANSACTION insert into @statusTable select ERROR_MESSAGE(), CURRENT_TIMESTAMP, @@ROWCOUNTprint 'failed to build' throw end catch set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO @statusTable select 'built#', @tid, @@ROWCOUNT

go
set @tid = CURRENT_TIMESTAMP INSERT INTO @statusTable (medelande)select 'createIndex#Inventering_halla' BEGIN TRY
    create index invhalla_idx on gng.Inventering_halla (Shape)
end try begin catch ROLLBACK TRANSACTION insert into @statusTable select ERROR_MESSAGE(), CURRENT_TIMESTAMP, @@ROWCOUNTprint 'failed to build' throw end catch set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO @statusTable select 'built#', @tid, @@ROWCOUNT Commit Transaction

go
BEGIN TRANSACTION
    insert into gng.Inventering_halla (OBJECTID, FASTIGHET, Fastighet_tillstand, Beslut_datum, Status, Anteckning, Utforddatum, Slamhamtning, Antal_byggnader, alltidsant, Shape, skapad_datum, andrad_datum)select (row_number() over (order by fastighet,flaggnr)), fastighet, Fastighet_tillstand, Beslut_datum, Fstatus, concat(Byggnadstyp, ' ', Anteckning, ' ', nullif(concat('vaPlan: ', VaPlan, ' '), 'vaPlan:  '), nullif(concat('egetOmh: ', egetOmhändertangandeInfo, ' '), 'egetOmh:  ')), utförddatum, slam, flaggnr, 1, flagga, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP from #röd where Socken = 'halla';
Commit Transaction

set @tid = CURRENT_TIMESTAMP INSERT INTO @statusTable (medelande)select 'tableCreate#Inventering_klinte' BEGIN TRY BEGIN TRANSACTION
        create table gng.Inventering_klinte (OBJECTID            int not null constraint invklinte_pk primary key, FASTIGHET           nvarchar(150), Fastighet_tillstand nvarchar(150), Arendenummer        nvarchar(50), Beslut_datum        datetime2, Status              nvarchar(50), Utskick_datum       datetime2, Anteckning          nvarchar(254), Utforddatum         datetime2, Slamhamtning        nvarchar(100), Antal_byggnader     numeric(38, 8), alltidsant          int, Shape               geometry, GDB_GEOMATTR_DATA   varbinary(max), skapad_datum        datetime2, andrad_datum        datetime2)
end try begin catch ROLLBACK TRANSACTION insert into @statusTable select ERROR_MESSAGE(), CURRENT_TIMESTAMP, @@ROWCOUNTprint 'failed to build' throw end catch set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO @statusTable select 'built#', @tid, @@ROWCOUNT

go
set @tid = CURRENT_TIMESTAMP INSERT INTO @statusTable (medelande)select 'createIndex#Inventering_klinte' BEGIN TRY
    create index invklinte_idx on gng.Inventering_klinte (Shape)
end try begin catch ROLLBACK TRANSACTION insert into @statusTable select ERROR_MESSAGE(), CURRENT_TIMESTAMP, @@ROWCOUNTprint 'failed to build' throw end catch set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO @statusTable select 'built#', @tid, @@ROWCOUNT Commit Transaction

go
BEGIN TRANSACTION
    insert into gng.Inventering_klinte (OBJECTID, FASTIGHET, Fastighet_tillstand, Beslut_datum, Status, Anteckning, Utforddatum, Slamhamtning, Antal_byggnader, alltidsant, Shape, skapad_datum, andrad_datum)select (row_number() over (order by fastighet,flaggnr)), fastighet, Fastighet_tillstand, Beslut_datum, Fstatus, concat(Byggnadstyp, ' ', Anteckning, ' ', nullif(concat('vaPlan: ', VaPlan, ' '), 'vaPlan:  '), nullif(concat('egetOmh: ', egetOmhändertangandeInfo, ' '), 'egetOmh:  ')), utförddatum, slam, flaggnr, 1, flagga, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP from #röd where Socken = 'klinte';
Commit Transaction

set @tid = CURRENT_TIMESTAMP INSERT INTO @statusTable (medelande)select 'tableCreate#Inventering_Roma' BEGIN TRY BEGIN TRANSACTION
        create table gng.Inventering_Roma (OBJECTID            int not null constraint invRoma_pk primary key, FASTIGHET           nvarchar(150), Fastighet_tillstand nvarchar(150), Arendenummer        nvarchar(50), Beslut_datum        datetime2, Status              nvarchar(50), Utskick_datum       datetime2, Anteckning          nvarchar(254), Utforddatum         datetime2, Slamhamtning        nvarchar(100), Antal_byggnader     numeric(38, 8), alltidsant          int, Shape               geometry, GDB_GEOMATTR_DATA   varbinary(max), skapad_datum        datetime2, andrad_datum        datetime2)
end try begin catch ROLLBACK TRANSACTION insert into @statusTable select ERROR_MESSAGE(), CURRENT_TIMESTAMP, @@ROWCOUNTprint 'failed to build' throw end catch set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO @statusTable select 'built#', @tid, @@ROWCOUNT

go
set @tid = CURRENT_TIMESTAMP INSERT INTO @statusTable (medelande)select 'createIndex#Inventering_Roma' BEGIN TRY
    create index invRoma_idx on gng.Inventering_Roma (Shape)
end try begin catch ROLLBACK TRANSACTION insert into @statusTable select ERROR_MESSAGE(), CURRENT_TIMESTAMP, @@ROWCOUNTprint 'failed to build' throw end catch set @tid = CURRENT_TIMESTAMP - @tid INSERT INTO @statusTable select 'built#', @tid, @@ROWCOUNT Commit Transaction

go
BEGIN TRANSACTION
    insert into gng.Inventering_Roma (OBJECTID, FASTIGHET, Fastighet_tillstand, Beslut_datum, Status, Anteckning, Utforddatum, Slamhamtning, Antal_byggnader, alltidsant, Shape, skapad_datum, andrad_datum)select (row_number() over (order by fastighet,flaggnr)), fastighet, Fastighet_tillstand, Beslut_datum, Fstatus, concat(Byggnadstyp, ' ', Anteckning, ' ', nullif(concat('vaPlan: ', VaPlan, ' '), 'vaPlan:  '), nullif(concat('egetOmh: ', egetOmhändertangandeInfo, ' '), 'egetOmh:  ')), utförddatum, slam, flaggnr, 1, flagga, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP from #röd where Socken = 'Roma';
Commit Transaction




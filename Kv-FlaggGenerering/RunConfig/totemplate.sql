 IF OBJECT_ID(N'tempdb..#rodaForFlaggskikt') is not null OR (select top 1 RebuildStatus from #settingtable) = 1
        BEGIN TRY DROP TABLE #rodaForFlaggskikt END TRY BEGIN CATCH select 'failed to drop #rodaForFlaggskikt' END CATCH
go;
IF OBJECT_ID(N'tempdb..#rodaForFlaggskikt') is null
    begin
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
				 Antal_byggnader                               int,
				 x						float		,
                                y						float
                                unique (FASTIGHET)
                                with (ignore_dup_key = on)
)

;
with alias as (select * from #FiltreraMotFlaggskiktet where
    (fstatus = 'röd' OR (fstatus is null AND  Byggnadstyp is not null and (isnull(VaPlan,'') <> 'Spillvatten:Antaget(spill)' AND isnull(VaPlan,'') <> 'Avlopp:Antaget(spill)'))))
insert into @rödaFörFlaggskikt (FASTIGHET, Fastighet_tillstand, Arendenummer, Beslut_datum, Status, Utskick_datum, Anteckning
, Utforddatum, Slamhamtning, Antal_byggnader,x,y)
select
    left(fastighet,150),
    left(Fastighet_tillstand,150),
    left(Diarienummer,50),
    Beslut_datum,
    left(iif(fstatus='ok','grön',fstatus),50), --SockenX,
    null,
    left(CASE WHEN len(Anteckning) != 1 THEN anteckning END, 254),
    utförddatum
    ,left(concat( LocaltOmH,nullif(concat(' va: ',VaPlan),' va: '), nullif(concat(' bygtyp: ' , Byggnadstyp),' bygtyp: ')),100) VAantek
    , bygTot,flagga.STX flaggax,flagga.STY flaggay
from alias
select * into #rodaForFlaggskikt from @rödaFörFlaggskikt

INSERT INTO #statusTable select N'rebuilt#rodaForFlaggskikt', CURRENT_TIMESTAMP, @@ROWCOUNT end
    else INSERT INTO #statusTable select N'preloading#rodaForFlaggskikt', CURRENT_TIMESTAMP, @@ROWCOUNT;

go

;
 IF OBJECT_ID(N'tempdb..#gronaForFlaggskikt') is not null OR (select top 1 RebuildStatus from #settingtable) = 1
        BEGIN TRY DROP TABLE #gronaForFlaggskikt END TRY BEGIN CATCH select 'failed to drop #gronaForFlaggskikt' END CATCH
go;
IF OBJECT_ID(N'tempdb..#gronaForFlaggskikt') is null
    begin
;declare @grönaFörFlaggskikt  table (
				 FASTIGHET                                     nvarchar(150),
				 Fastighet_tillstand                           nvarchar(150),
				 Arendenummer                                  nvarchar(50),
				 Beslut_datum                                  datetime2,
				 Status                                        nvarchar(50),
				 Utskick_datum                                 datetime2,
				 Anteckning                                    nvarchar(254),
				 Utforddatum                                   datetime2,
				 Slamhamtning                                  nvarchar(100),
				Antal_byggnader                               	int,
				x						float,
                                y						float
                                unique (FASTIGHET)
                                with (ignore_dup_key = on)
)
;
with alias as (select * from #FiltreraMotFlaggskiktet)
insert into @grönaFörFlaggskikt (FASTIGHET, Fastighet_tillstand, Arendenummer, Beslut_datum, Status, Utskick_datum, Anteckning
, Utforddatum, Slamhamtning, Antal_byggnader,x,y)
select
    left(fastighet,150),
    left(Fastighet_tillstand,150),
    left(Diarienummer,50),
     Beslut_datum,
     left(iif(fstatus='ok','grön',fstatus),50), --SockenX,
       null,
       left(CASE WHEN len(Anteckning) != 1 THEN anteckning END, 254),
     utförddatum
     ,left(concat( LocaltOmH,nullif(concat(' va: ',VaPlan),' va: '), nullif(concat(' bygtyp: ' , Byggnadstyp),' bygtyp: ')),100) VAantek
     , bygTot,
       flagga.STX flaggax,flagga.STY flaggay
from alias
	where fastighet not in(select fastighet from alias where fstatus = 'röd') and  Byggnadstyp is not null
	      and (isnull(VaPlan,'') <> 'Spillvatten:Antaget(spill)' AND isnull(VaPlan,'') <> 'Avlopp:Antaget(spill)')
select * into #gronaForFlaggskikt from @grönaFörFlaggskikt

INSERT INTO #statusTable select N'rebuilt#gronaForFlaggskikt', CURRENT_TIMESTAMP, @@ROWCOUNT end
    else INSERT INTO #statusTable select N'preloading#gronaForFlaggskikt', CURRENT_TIMESTAMP, @@ROWCOUNT;

go
;
select * from #rodaForFlaggskikt
;
select * from #gronaForFlaggskikt
;
select * from #statusTable

;

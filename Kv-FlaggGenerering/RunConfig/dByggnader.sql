IF OBJECT_ID(N'tempdb..#ByggnadPåFastighetISocken') is not null OR (select top 1 RebuildStatus from #SettingTable) = 1
     BEGIN TRY DROP TABLE #ByggnadPåFastighetISocken END TRY BEGIN CATCH select 'error DROP TABLE #ByggnadPåFastighetISocken' END CATCH
          --BEGIN TRY DROP TABLE #temp_byggnad_yta END TRY BEGIN CATCH select 1 END CATCH
       --ByggBeslut as (select Ärendenummer,                         Byggnadstyp,                    Fastighetsbeteckning,  concat(Inkommande_datum,Registereringsdatum,År,Beslutsdatum,Status,Planbedömning,Beslutsnivå,Ärendetyp) rest,   GDB_GEOMATTR_DATA,  Shape, OBJECTID  from sde_bygglov.gng.BYGGLOVSPUNKTER union all select concat(DIARIENR,ANSÖKAN),   ÄNDAMÅL,                     Beteckning,               concat(DATUM,BESLUT,ANTAL,concat(URSPRUNG,id, Kod),AVSER,ANVÄNDNING),                                   GDB_GEOMATTR_DATA,  Shape, OBJECTID  from sde_bygglov.gng.BYGGLOVREG_ALDRE_P union all select concat(DIARIENR,ANSÖKAN),   concat(BYGGNADSTY,ÄNDAMÅL),     AVSER,                 concat(DATUM,BESLUT,År,ANTAL,ANMÄRKNIN,ANM,ANSÖKAN_A),                                            GDB_GEOMATTR_DATA,  Shape, OBJECTID  from sde_bygglov.gng.BYGGLOVSREG_2007_2019_P union all select DIARIENR,                   BYGGNADSTY,                     ANSÖKAN_AV,            concat(ANM,BESLUT),                                                                      GDB_GEOMATTR_DATA,  Shape, OBJECTID  from sde_bygglov.gng.BYGGLOVSREGISTRERING_CA_1999_2007_P),
go;
IF OBJECT_ID(N'tempdb..#ByggnadPåFastighetISocken') is null
   begin
      ;
    with
     fastighetsYtor      as (select * from  #fastighetsYtor)
 ,   byggnad_yta         as (select andamal1 Byggnadstyp, Shape from sde_gsd.gng.BYGGNAD),
  	byggnaderISocken as 
			     (Select Byggnadstyp, so.socken, byggnad_yta.SHAPE
			     from byggnad_yta
					inner join #socknarOfInterest so on
				    so.
					shape.STContains(
				    byggnad_yta.shape) = 1)
   ,ByggnadPaFastighetISocken as (  select  sy.FAStighet,sy.Fnr_FDS, bis.*  from fastighetsYtor sy
       inner join byggnaderISocken bIS on bis.Shape.STIntersects(sy.Shape) = 1)

,    withRownr           as (
	select *, 
	count(shape) over (partition by FAStighet) bygTot,
	   row_number() over (partition by FAStighet order by Byggnadstyp ) orderz
	  from ByggnadPaFastighetISocken )
	, OnlyOnePerFastighet 	as (  select FAStighet, Byggnadstyp,bygTot,shape from  withRownr     where orderz = 1 )
    select FAStighet, Byggnadstyp, bygTot, shape
    into #ByggnadPåFastighetISocken
				      from OnlyOnePerFastighet

    ;
         INSERT INTO #statusTable select  N'rebuilt#ByggnadPåFastighetISocken',CURRENT_TIMESTAMP,@@ROWCOUNT
        END
    else INSERT INTO #statusTable select  N'preloading#ByggnadPåFastighetISocken',CURRENT_TIMESTAMP,@@ROWCOUNT

----goto TableInitiate
go

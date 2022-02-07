IF OBJECT_ID(N'tempdb..#ByggnadP�FastighetISocken') is null
       OR (select top 1 RebuildStatus from #SettingTable) = 1
       --ByggBeslut as (select �rendenummer,                         Byggnadstyp,                    Fastighetsbeteckning,  concat(Inkommande_datum,Registereringsdatum,�r,Beslutsdatum,Status,Planbed�mning,Beslutsniv�,�rendetyp) rest,   GDB_GEOMATTR_DATA,  Shape, OBJECTID  from sde_bygglov.gng.BYGGLOVSPUNKTER union all select concat(DIARIENR,ANS�KAN),   �NDAM�L,                     Beteckning,               concat(DATUM,BESLUT,ANTAL,concat(URSPRUNG,id, Kod),AVSER,ANV�NDNING),                                   GDB_GEOMATTR_DATA,  Shape, OBJECTID  from sde_bygglov.gng.BYGGLOVREG_ALDRE_P union all select concat(DIARIENR,ANS�KAN),   concat(BYGGNADSTY,�NDAM�L),     AVSER,                 concat(DATUM,BESLUT,�r,ANTAL,ANM�RKNIN,ANM,ANS�KAN_A),                                            GDB_GEOMATTR_DATA,  Shape, OBJECTID  from sde_bygglov.gng.BYGGLOVSREG_2007_2019_P union all select DIARIENR,                   BYGGNADSTY,                     ANS�KAN_AV,            concat(ANM,BESLUT),                                                                      GDB_GEOMATTR_DATA,  Shape, OBJECTID  from sde_bygglov.gng.BYGGLOVSREGISTRERING_CA_1999_2007_P),

    begin BEGIN TRY DROP TABLE #ByggnadP�FastighetISocken END TRY BEGIN CATCH select 1 END CATCH
          --BEGIN TRY DROP TABLE #temp_byggnad_yta END TRY BEGIN CATCH select 1 END CATCH
      ;
    with
     fastighetsYtor      as (select * from  #fastighetsYtor)
 ,   byggnad_yta         as (select andamal1 Byggnadstyp, Shape from sde_gsd.gng.BYGGNAD),
  	byggnaderISocken as 
			     (Select Byggnadstyp, so.socken, byggnad_yta.SHAPE
			     from byggnad_yta
					inner join #socknarOfInterest so on
				    byggnad_yta.
					shape.STIntersects(
				    so.shape) = 1)
   ,ByggnadPaFastighetISocken as (  select  sy.FAStighet,sy.Fnr_FDS, bis.*  from fastighetsYtor sy
       inner join byggnaderISocken bIS on bis.Shape.STIntersects(sy.Shape) = 1)

,    withRownr           as (
	select *, 
	count(shape) over (partition by FAStighet) bygTot,
	   row_number() over (partition by FAStighet order by Byggnadstyp ) orderz
	  from ByggnadPaFastighetISocken )
   , OnlyOnePerFastighet as (        select FAStighet, Byggnadstyp,bygTot,shape
	from  withRownr     where orderz = 1 )
select * into #ByggnadP�FastighetISocken
 from OnlyOnePerFastighet

    ;
         INSERT INTO #statusTable select  N'rebuilt#ByggnadP�FastighetISocken',CURRENT_TIMESTAMP,@@ROWCOUNT
        END
    else INSERT INTO #statusTable select  N'preloading#ByggnadP�FastighetISocken',CURRENT_TIMESTAMP,@@ROWCOUNT


--goto TableInitiate
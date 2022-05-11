IF OBJECT_ID(N'tempdb..#ByggnadP�FastighetISocken') is null OR @rebuiltStatus1 = 1
       --ByggBeslut as (select �rendenummer,                         Byggnadstyp,                    Fastighetsbeteckning,  concat(Inkommande_datum,Registereringsdatum,�r,Beslutsdatum,Status,Planbed�mning,Beslutsniv�,�rendetyp) rest,   GDB_GEOMATTR_DATA,  Shape, OBJECTID  from sde_bygglov.gng.BYGGLOVSPUNKTER union all select concat(DIARIENR,ANS�KAN),   �NDAM�L,                     Beteckning,               concat(DATUM,BESLUT,ANTAL,concat(URSPRUNG,id, Kod),AVSER,ANV�NDNING),                                   GDB_GEOMATTR_DATA,  Shape, OBJECTID  from sde_bygglov.gng.BYGGLOVREG_ALDRE_P union all select concat(DIARIENR,ANS�KAN),   concat(BYGGNADSTY,�NDAM�L),     AVSER,                 concat(DATUM,BESLUT,�r,ANTAL,ANM�RKNIN,ANM,ANS�KAN_A),                                            GDB_GEOMATTR_DATA,  Shape, OBJECTID  from sde_bygglov.gng.BYGGLOVSREG_2007_2019_P union all select DIARIENR,                   BYGGNADSTY,                     ANS�KAN_AV,            concat(ANM,BESLUT),                                                                      GDB_GEOMATTR_DATA,  Shape, OBJECTID  from sde_bygglov.gng.BYGGLOVSREGISTRERING_CA_1999_2007_P),

    begin BEGIN TRY DROP TABLE #ByggnadP�FastighetISocken END TRY BEGIN CATCH select 1 END CATCH
          BEGIN TRY DROP TABLE #temp_byggnad_yta END TRY BEGIN CATCH select 1 END CATCH
      ;

    with
      socknarOfIntresse as (select socken SockenX,concat(Trakt,' ',Blockenhet) FAStighet, Shape  from sde_gsd.gng.AY_0980 x inner join (SELECT value "socken"
      from STRING_SPLIT(N'Bj�rke,Dalhem,Fr�jel,Ganthem,Halla,Klinte,Roma', ',')) as socknarOfIntresse on x.TRAKT like socknarOfIntresse.socken + '%')
    select Fastighetsbeteckning, Byggnadstyp,shape ByggShape
into #ByggnadP�FastighetISocken
      from (
               select *, row_number() over (partition by Fastighetsbeteckning order by Byggnadstyp ) orderz
               from ( Select Byggnadstyp,socknarOfIntresse.fastighet Fastighetsbeteckning,byggnad_yta.SHAPE
                from (select andamal_1T Byggnadstyp,Shape from sde_gsd.gng.BY_0980) byggnad_yta inner join socknarOfIntresse on byggnad_yta.Shape.STWithin(socknarOfIntresse.shape) = 1) q
           ) z where orderz = 1

         INSERT INTO @statusTable select  N'rebuilt#ByggnadP�FastighetISocken',CURRENT_TIMESTAMP,@@ROWCOUNT
        END
    else INSERT INTO @statusTable select  N'preloading#ByggnadP�FastighetISocken',CURRENT_TIMESTAMP,@@ROWCOUNT
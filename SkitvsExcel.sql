IF object_id('tempdb..#fastigheter') is not null
    drop table #FASTIGHETER



    BEGIN TRANSACTION --B4
    declare @externalQuery nvarchar(max), @externalparam nvarchar(255), @bjorke nvarchar(255),@dalhem varchar(255),@frojel nvarchar(255),@ganthem varchar(255),@Halla varchar(255),@Klinte varchar(255),@Roma varchar(255) set @bjorke=N'björke'set @dalhem = 'Dalhem'set @frojel = N'Fröjel'set @ganthem = 'Ganthem'set @Halla = 'Halla'set @Klinte = 'Klinte'set @Roma = 'Roma'; set @externalparam = N'@bjorke nvarchar(255) , @dalhem varchar(255) , @frojel nvarchar(255) , @ganthem varchar(255) , @Halla varchar(255) , @Klinte varchar(255) ,  @Roma varchar(255)'
	set @externalQuery =  '
		    with
		          fastighetsfilter as (Select  @bjorke  "socken" Union Select @dalhem  "a" Union Select @frojel  "a" Union Select  @ganthem "a" Union Select   @Halla "a" Union Select  @Klinte  "a" Union Select  @Roma   "a" )'+
                        ',FILTRERADEFAST as (SELECT fastighetsFilter.socken SockenX,concat(Trakt,SPACE(1),Blockenhet) FAStighet, Shape from sde_gsd.gng.AY_0980 x inner join fastighetsFilter on left(x.TRAKT, len(fastighetsFilter.socken)) = fastighetsFilter.socken )' +
		       N',
  SELECTION      AS (SELECT OBJECTID, FLAGGSKIKTET_P_EVW.FASTIGHET AS EVWFASTIGHET, FASTIGHET_TILLSTAND, ARENDENUMMER, BESLUT_DATUM, FLAGGSKIKTET_P_EVW.STATUS, UTSKICK_DATUM, ANTECKNING, UTFORDDATUM, SLAMHAMTNING, ANTAL_BYGGNADER, ALLTIDSANT, FLAGGSKIKTET_P_EVW.SHAPE, GDB_GEOMATTR_DATA, SDE_STATE_ID, SKAPAD_DATUM, ANDRAD_DATUM, SOCKENX, FILTRERADEFAST.FASTIGHET FROM SDE_MILJO_HALSOSKYDD.GNG.FLAGGSKIKTET_P_EVW LEFT OUTER JOIN FILTRERADEFAST ON FILTRERADEFAST.FASTIGHET = FLAGGSKIKTET_P_EVW.FASTIGHET WHERE coalesce(FILTRERADEFAST.FASTIGHET, FLAGGSKIKTET_P_EVW.FASTIGHET, FLAGGSKIKTET_P_EVW.FASTIGHET_TILLSTAND) IS NOT NULL AND SOCKENX IS NOT NULL)
,fastigheterSol as (select max(selection.SOCKENX) socken, max(selection .STATUS) status,coalesce( FASTIGHET,evwFASTIGHET,FASTIGHET_TILLSTAND) f from selection GROUP BY  coalesce( FASTIGHET,evwFASTIGHET,FASTIGHET_TILLSTAND)) ' +
	                      N'select * from fastigheterSol'

    CREATE TABLE #Fastigheter (FASTIGHET        NVARCHAR(250),
                                socken nvarchar (100),
                               status nvarchar (100)
                                    )
    INSERT
    INTO #Fastigheter (socken,STATUS,FASTIGHET) EXEC
		GISDB01.MASTER.DBO.sp_executesql @EXTERNALQUERY, @EXTERNALPARAM, @BJORKE=@BJORKE, @DALHEM=@DALHEM,
		@FROJEL=@FROJEL, @GANTHEM= @GANTHEM, @HALLA=@HALLA, @KLINTE= @KLINTE, @ROMA=@ROMA
    Commit Transaction --C4

;
WITH

fastigheterSol as (select * from #FASTIGHETER)
,fastigheterq as (select SOCKEN, FASTIGHET F, FSTATUS status from tempExcel.dbo.[20201108ChristofferRäknarExcel])
   --, fnrz as (select fnr,beteckning,socken,fastigheter.status from [GISDATA].sde_geofir_gotland.gng.FA_FASTIGHET q inner join fastigheter on FASTIGHETER.F = beteckning)

select coalesce(FASTIGHETERQ.SOCKEN,FASTIGHETERSOL.SOCKEN) socken ,coalesce(FASTIGHET,F) Fastighet , isnull(FASTIGHETERSOL.STATUS,'Saknas')  SkiktFlagga, isnull(FASTIGHETERQ.STATUS,'saknas')  ExcelFlagga
from fastigheterSol full OUTER join fastigheterq on fastigheterSol.fastighet = fastigheterq.f
where (fastighet is null or f is NULL and coalesce(FASTIGHETERQ.STATUS,FASTIGHETERSOL.STATUS) = 'röd')
or (FASTIGHETERQ.STATUS != FASTIGHETERSOL.STATUS and f is not null)





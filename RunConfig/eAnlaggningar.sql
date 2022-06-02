IF (OBJECT_ID(N'tempdb..#Socken_tillstånd') IS NULL)
       OR (select top 1 RebuildStatus from #SettingTable) = 1
    begin
          BEGIN TRY DROP TABLE #Socken_tillstånd  END TRY BEGIN CATCH select 1 END CATCH;
          with
    socknarOfinterest as (select socken from #socknarOfInterest)

    , fastighetsYtor
	      as (select socken SockenX, FAStighet, Shape 
	      from #FastighetsYtor)

        , AnSoMedSocken     as (select left(fastighet, IIF(charindex(' ', fastighet) = 0, len(fastighet) + 1, charindex(' ', fastighet)) - 1) socken,*
               from (select (case when charindex(':', Fastighet_tillstand) > 0 then Fastighet_tillstand
               else case when charindex(':', fastighet_rening) > 0 then fastighet_rening
               else case when charindex(':', Anteckning) > 0 then Anteckning
               end end end) as fastighet,    Diarienummer,Fastighet_tillstand z,Beslut_datum,Utford_datum,Anteckning,Shape anlShape from  sde_miljo_halsoskydd.gng.ENSKILT_AVLOPP_sodra_P) q)
        , AnNoMedSocken   as (select left(fastighet, IIF(charindex(' ', fastighet) = 0, len(fastighet) + 1, charindex(' ', fastighet)) - 1) socken,*
               from (select (case when charindex(':', Fastighet_tillstand) > 0 then Fastighet_tillstand
               else case when charindex(':', fastighet_rening) > 0 then fastighet_rening
               else case when charindex(':', Anteckning) > 0 then Anteckning
               end end end) as fastighet,    Diarienummer,Fastighet_tillstand z,Beslut_datum,Utford_datum,Anteckning,Shape anlShape from  sde_miljo_halsoskydd.gng.ENSKILT_AVLOPP_Norra_P) q)
        , AnMeMedSocken as (select left(fastighet, IIF(charindex(' ', fastighet) = 0, len(fastighet) + 1, charindex(' ', fastighet)) - 1) socken,*
               from (select (case when charindex(':', Fastighet_tilstand) > 0 then Fastighet_tilstand
               else case when charindex(':', fastighet_rening) > 0 then fastighet_rening
               else case when charindex(':', Anteckning) > 0 then Anteckning
               end end end) as fastighet,    Diarienummer,Fastighet_tilstand z,Beslut_datum,Utford_datum,Anteckning,Shape anlShape from  sde_miljo_halsoskydd.gng.ENSKILT_AVLOPP_MELLERSTA_P) q)

       , sodra_p as (select Diarienummer, z q, Beslut_datum, Utford_datum, Anteckning, AllaAvlopp.anlShape, FFast.FAStighet,FFast.sockenX from AnSoMedSocken AllaAvlopp inner join
	   fastighetsytor FFast on AllaAvlopp.socken = ffast.SockenX and AllaAvlopp.anlShape.STIntersects(FFast.Shape) = 1)
	, Norra_p as (select Diarienummer, z q, Beslut_datum, Utford_datum, Anteckning, AllaAvlopp.anlShape, FFast.FAStighet,FFast.sockenX from AnNoMedSocken AllaAvlopp inner join
	   fastighetsytor FFast on AllaAvlopp.socken = ffast.SockenX and AllaAvlopp.anlShape.STIntersects(FFast.Shape) = 1)
	, Mellersta_p as (select Diarienummer, z q, Beslut_datum, Utford_datum, Anteckning, AllaAvlopp.anlShape, FFast.FAStighet,FFast.sockenX from AnMeMedSocken AllaAvlopp inner join
	   fastighetsytor FFast on AllaAvlopp.socken = ffast.SockenX and AllaAvlopp.anlShape.STIntersects(FFast.Shape) = 1)

             	, allaAv as (select sockenX socken, Diarienummer, q, Beslut_datum, Utford_datum, Anteckning, anlShape from  (select * from sodra_p union all select *from norra_p union all select *from mellersta_p) a)
		, utanSocken as (select *from allaAv where socken is null)

             , geoAv as (select SockenX socken, Diarienummer, fy.FAStighet, Beslut_datum, Utford_datum, Anteckning, anlShape from
	      	UtanSocken inner join
	         fastighetsYtor fY on anlShape.STIntersects(fy.Shape) = 1)



          , z as (select * from allaAv union all select * from geoAv)
       	, SammanSlagna as (select Diarienummer, q "Fastighet_tillstand",
       	       isnull(TRY_CONVERT(DateTime, Beslut_datum,102), DATETIME2FROMPARTS(1988, 1, 1, 1, 1, 1, 1, 1)) Beslut_datum,
       	       isnull(TRY_CONVERT(DateTime, Utford_datum,102), DATETIME2FROMPARTS(1988, 1, 1, 1, 1, 1, 1, 1)) Utford_datum,
       	       Anteckning, anlShape, z.q fastighet from
       	      z inner join socknarOfinterest x on x.socken = z.socken)

             , slamz	as (select IIF(
       			(
       			  IIF(Beslut_datum < rodDatum, 1, 0) +	IIF(Utford_datum < rodDatum, 1, 0) +
			  IIF(Utford_datum is null, 1, 0)) > 0 , N'röd', 'ok') statusx,
			      FAStighet,Diarienummer,Fastighet_tillstand,Beslut_datum,Utford_datum "utförddatum",
				Anteckning,anlShape AnlaggningsPunkt
             from
                  SammanSlagna,#settingTable


                 )

	,withRownr as (select *, row_number() over (partition by fastighet order  by coalesce(utförddatum,Beslut_datum) desc) as x from slamz)

        ,OnePerFastighet as (select statusx, FAStighet, Diarienummer, Fastighet_tillstand q, Beslut_datum, utförddatum Utford_datum, Anteckning, AnlaggningsPunkt anlShape
			     from withRownr where x = 1)

          select FAStighet,
                 Diarienummer,
                 q            "Fastighet_tillstand",
                 FORMAT(nullif(Beslut_datum, smalldatetimefromparts(1900, 01, 01, 00, 00)),
			  'yyyy-MM-dd')                                                       Beslut_datum,
                 FORMAT(nullif(Utford_datum, smalldatetimefromparts(1900, 01, 01, 00, 00)),
			  'yyyy-MM-dd')                                                        "utförddatum",
                 Anteckning,
                 anlShape     AnlaggningsPunkt
           , (case when not (
			isnull(Beslut_datum, DATETIME2FROMPARTS(1988, 1, 1, 1, 1, 1, 1, 1)) >
			(select DATETIME2FROMPARTS(2003, 1, 1, 1, 1, 1, 1, 1) datum) and
			isnull(Utford_datum, DATETIME2FROMPARTS(1988, 1, 1, 1, 1, 1, 1, 1)) >
			(select DATETIME2FROMPARTS(2003, 1, 1, 1, 1, 1, 1, 1) datum)) then N'röd'
										      else N'grön'
					    end) fstatus
          into #Socken_tillstånd
from OnePerFastighet 

    INSERT INTO #statusTable select N'rebuilt#Socken_tillstånd',CURRENT_TIMESTAMP,@@ROWCOUNT end else
        INSERT INTO #statusTable select N'preloading#Socken_tillstånd',CURRENT_TIMESTAMP,@@ROWCOUNT
--goto TableInitiate
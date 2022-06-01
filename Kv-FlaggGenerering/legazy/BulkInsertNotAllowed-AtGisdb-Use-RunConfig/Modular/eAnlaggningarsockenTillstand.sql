IF (OBJECT_ID(N'tempdb..#Socken_tillstånd') IS NULL) OR @rebuiltStatus1 = 1
    begin
	BEGIN TRY
	    DROP TABLE #Socken_tillstånd
	END TRY BEGIN CATCH
	    select 1
	END CATCH;
	with
	    FiltreradeFast as (select socken SockenX, concat(Trakt, ' ', Blockenhet) FAStighet, Shape
			       from sde_gsd.gng.AY_0980 x
				   inner join (SELECT value "socken"
					       from STRING_SPLIT(N'Björke,Dalhem,Fröjel,Ganthem,Halla,Klinte,Roma', ',')) as socknarOfIntresse
				   on x.TRAKT like socknarOfIntresse.socken + '%')
	  , aso            as (select left(Fastighet_tillstand, case when charindex(' ', Fastighet_tillstand) = 0
									 then len(Fastighet_tillstand) + 1
									 else charindex(' ', Fastighet_tillstand)
								end - 1) socken
				    , Diarienummer
				    , Fastighet_tillstand                z
				    , Beslut_datum
				    , Utford_datum
				    , Anteckning
				    , Shape                              anlShape
			       from sde_miljo_halsoskydd.gng.ENSKILT_AVLOPP_sodra_P)
	  , aNo            as (select left(Fastighet_tillstand, case when charindex(' ', Fastighet_tillstand) = 0
									 then len(Fastighet_tillstand) + 1
									 else charindex(' ', Fastighet_tillstand)
								end - 1) socken
				    , Diarienummer
				    , Fastighet_tillstand                z
				    , Beslut_datum
				    , Utford_datum
				    , Anteckning
				    , Shape                              anlShape
			       from sde_miljo_halsoskydd.gng.ENSKILT_AVLOPP_Norra_P)
	  , aMo            as (select left(Fastighet_tilstand, case when charindex(' ', Fastighet_tilstand) = 0
									then len(Fastighet_tilstand) + 1
									else charindex(' ', Fastighet_tilstand)
							       end - 1) socken
				    , Diarienummer
				    , Fastighet_tilstand                z
				    , Beslut_datum
				    , Utford_datum
				    , Anteckning
				    , Shape                             anlShape
			       from sde_miljo_halsoskydd.gng.ENSKILT_AVLOPP_MELLERSTA_P)
	  , sodra_p        as (select Diarienummer
				    , z q
				    , Beslut_datum
				    , Utford_datum
				    , Anteckning
				    , AllaAvlopp.anlShape
				    , FAStighet
			       from aSo AllaAvlopp
				   inner join(select FiltreradeFast.*
					      from FiltreradeFast
						  inner join (select socken from aso group by socken) q on socken = sockenX) FFast
				   on AllaAvlopp.socken = ffast.SockenX and
				      AllaAvlopp.anlShape.STIntersects(FFast.Shape) = 1)
	  , Norra_p        as (select Diarienummer
				    , z q
				    , Beslut_datum
				    , Utford_datum
				    , Anteckning
				    , AllaAvlopp.anlShape
				    , FAStighet
			       from aNo AllaAvlopp
				   inner join(select FiltreradeFast.*
					      from FiltreradeFast
						  inner join (select socken from aNo group by socken) q on socken = sockenX) FFast
				   on AllaAvlopp.socken = ffast.SockenX and
				      AllaAvlopp.anlShape.STIntersects(FFast.Shape) = 1)
	  , Mellersta_p    as (select Diarienummer
				    , z q
				    , Beslut_datum
				    , Utford_datum
				    , Anteckning
				    , AllaAvlopp.anlShape
				    , FAStighet
			       from aMo AllaAvlopp
				   inner join(select FiltreradeFast.*
					      from FiltreradeFast
						  inner join (select socken from aMo group by socken) q on socken = sockenX) FFast
				   on AllaAvlopp.socken = ffast.SockenX and
				      AllaAvlopp.anlShape.STIntersects(FFast.Shape) = 1)

	select FAStighet
	     , Diarienummer
	     , q            "Fastighet_tillstand"
	     , Beslut_datum
	     , Utford_datum "utförddatum"
	     , Anteckning
	     , anlShape     AnlaggningsPunkt
	into #Socken_tillstånd
	from (select * from sodra_p union all select * from norra_p union all select * from mellersta_p) z

	INSERT INTO @statusTable select N'rebuilt#Socken_tillstånd', CURRENT_TIMESTAMP, @@ROWCOUNT
    end else
    INSERT INTO @statusTable select N'preloading#Socken_tillstånd', CURRENT_TIMESTAMP, @@ROWCOUNT
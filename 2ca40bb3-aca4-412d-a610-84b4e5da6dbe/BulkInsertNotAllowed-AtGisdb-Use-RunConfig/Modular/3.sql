with
    fastighetsfilter  as (select * FROM #fastighetsfilter)
  , socknarOfIntresse  as (SELECT fastighetsFilter.socken SockenX, concat(Trakt, SPACE(1), Blockenhet) FAStighet, Shape
			   from sde_gsd.gng.AY_0980 x
			       inner join fastighetsFilter
			       on left(x.TRAKT, len(fastighetsFilter.socken)) = fastighetsFilter.socken)
  , AnSoMedSocken      as (select left(Fastighet_tillstand, case when charindex(SPACE(1), Fastighet_tillstand) = 0
								     then len(Fastighet_tillstand) + 1
								     else charindex(SPACE(1), Fastighet_tillstand)
							    end - 1) socken
				, Diarienummer
				, Fastighet_tillstand                z
				, Beslut_datum, Utford_datum, Anteckning
				, Shape                              anlShape
			   from sde_miljo_halsoskydd.gng.ENSKILT_AVLOPP_sodra_P)
  , AnNoMedSocken      as (select left(Fastighet_tillstand, case when charindex(SPACE(1), Fastighet_tillstand) = 0
								     then len(Fastighet_tillstand) + 1
								     else charindex(SPACE(1), Fastighet_tillstand)
							    end - 1) socken
				, Diarienummer
				, Fastighet_tillstand                z
				, Beslut_datum, Utford_datum, Anteckning
				, Shape                              anlShape
			   from sde_miljo_halsoskydd.gng.ENSKILT_AVLOPP_Norra_P)
  , AnMeMedSocken      as (select left(Fastighet_tilstand, case when charindex(SPACE(1), Fastighet_tilstand) = 0
								    then len(Fastighet_tilstand) + 1
								    else charindex(SPACE(1), Fastighet_tilstand)
							   end - 1) socken
				, Diarienummer
				, Fastighet_tilstand                z
				, Beslut_datum, Utford_datum, Anteckning
				, Shape                             anlShape
			   from sde_miljo_halsoskydd.gng.ENSKILT_AVLOPP_MELLERSTA_P)
  , SodraFiltrerad     as (select Diarienummer
				, z q
				, Beslut_datum, Utford_datum, Anteckning, AllaAvlopp.anlShape, FAStighet
			   from AnSoMedSocken AllaAvlopp
			       inner join(select FiltreradeFast.*
					  from socknarOfIntresse FiltreradeFast
					      inner join (select socken from AnSoMedSocken group by socken) q on socken = sockenX) FFast
			       on AllaAvlopp.socken = ffast.SockenX and
				  AllaAvlopp.anlShape.STIntersects(FFast.Shape) = 1)
  , NorraFiltrerad     as (select Diarienummer
				, z q
				, Beslut_datum, Utford_datum, Anteckning, AllaAvlopp.anlShape, FAStighet
			   from AnNoMedSocken AllaAvlopp
			       inner join(select FiltreradeFast.*
					  from socknarOfIntresse FiltreradeFast
					      inner join (select socken from AnNoMedSocken group by socken) q on socken = sockenX) FFast
			       on AllaAvlopp.socken = ffast.SockenX and
				  AllaAvlopp.anlShape.STIntersects(FFast.Shape) = 1)
  , MellerstaFiltrerad as (select Diarienummer
				, z q
				, Beslut_datum, Utford_datum, Anteckning, AllaAvlopp.anlShape, FAStighet
			   from AnMeMedSocken AllaAvlopp
			       inner join(select FiltreradeFast.*
					  from socknarOfIntresse FiltreradeFast
					      inner join (select socken from AnMeMedSocken group by socken) q on socken = sockenX) FFast
			       on AllaAvlopp.socken = ffast.SockenX and
				  AllaAvlopp.anlShape.STIntersects(FFast.Shape) = 1)
  , SammanSlagna       as (select Diarienummer
				, q                                                     "Fastighet_tillstand"
				, isnull(TRY_CONVERT(DateTime, Beslut_datum, 102),
					 DATETIME2FROMPARTS(1988, 1, 1, 1, 1, 1, 1, 1)) Beslut_datum
				, isnull(TRY_CONVERT(DateTime, Utford_datum, 102),
					 DATETIME2FROMPARTS(1988, 1, 1, 1, 1, 1, 1, 1)) Utford_datum
				, Anteckning
				, anlShape
				, FAStighet
			   from (select *
				 from SodraFiltrerad
				 union all
				 select *
				 from NorraFiltrerad
				 union all
				 select *
				 from MellerstaFiltrerad) z)
select FAStighet
     , Diarienummer
     , Fastighet_tillstand
     , Beslut_datum
     , Utford_datum "utförddatum"
     , Anteckning
     , anlShape     AnlaggningsPunkt
from SammanSlagna
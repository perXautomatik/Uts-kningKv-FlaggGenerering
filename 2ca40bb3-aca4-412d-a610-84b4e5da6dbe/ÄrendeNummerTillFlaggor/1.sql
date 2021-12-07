with
    fastighetsfilter as (Select @bjorke "socken" Union Select @dalhem "a" Union Select @frojel "a" Union Select @ganthem "a" Union Select @Halla "a" Union Select @Klinte "a" Union Select @Roma "a")
  , FILTRERADEFAST   as (SELECT fastighetsFilter.socken SockenX, concat(Trakt, SPACE(1), Blockenhet) FAStighet, Shape
			 from sde_gsd.gng.AY_0980 x
			     inner join fastighetsFilter
			     on left(x.TRAKT, len(fastighetsFilter.socken)) = fastighetsFilter.socken)
  , SELECTION        AS (SELECT OBJECTID
			      , FLAGGSKIKTET_P_EVW.FASTIGHET AS EVWFASTIGHET
			      , FASTIGHET_TILLSTAND
			      , ARENDENUMMER
			      , BESLUT_DATUM
			      , FLAGGSKIKTET_P_EVW.STATUS
			      , UTSKICK_DATUM
			      , ANTECKNING
			      , UTFORDDATUM
			      , SLAMHAMTNING
			      , ANTAL_BYGGNADER
			      , ALLTIDSANT
			      , FLAGGSKIKTET_P_EVW.SHAPE
			      , GDB_GEOMATTR_DATA
			      , SDE_STATE_ID
			      , SKAPAD_DATUM
			      , ANDRAD_DATUM
			      , SOCKENX
			      , FILTRERADEFAST.FASTIGHET
			 FROM SDE_MILJO_HALSOSKYDD.GNG.FLAGGSKIKTET_P_EVW
			     LEFT OUTER JOIN FILTRERADEFAST ON FILTRERADEFAST.FASTIGHET = FLAGGSKIKTET_P_EVW.FASTIGHET
			 WHERE coalesce(FILTRERADEFAST.FASTIGHET, FLAGGSKIKTET_P_EVW.FASTIGHET,
					FLAGGSKIKTET_P_EVW.FASTIGHET_TILLSTAND) IS NOT NULL AND SOCKENX IS NOT NULL)
  , fastigheterSol   as (select max(selection.SOCKENX)                                 socken
			      , max(selection.STATUS)                                  status
			      , coalesce(FASTIGHET, evwFASTIGHET, FASTIGHET_TILLSTAND) f
			 from selection
			 GROUP BY coalesce(FASTIGHET, evwFASTIGHET, FASTIGHET_TILLSTAND))
    ' +
	'
select * from fastigheterSol
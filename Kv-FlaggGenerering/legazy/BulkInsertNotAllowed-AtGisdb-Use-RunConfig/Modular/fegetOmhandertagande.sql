IF OBJECT_ID(N'tempdb..#egetOmhändertagande') is null OR @rebuiltStatus1 = 1
    begin
	BEGIN TRY
	    DROP TABLE #egetOmhändertagande
	END TRY BEGIN CATCH
	    select 1
	END CATCH;
	with
	    sYt            as (select socken SockenX, concat(Trakt, ' ', Blockenhet) FAStighet, Shape
			       from sde_gsd.gng.AY_0980 x
				   inner join
			       (SELECT value "socken"
				from STRING_SPLIT(N'Björke,Dalhem,Fröjel,Ganthem,Halla,Klinte,Roma', ',')) as socknarOfIntresse
				   on x.TRAKT
				       like socknarOfIntresse.socken + '%')

	  , LOKALT_SLAM_P  as (select Diarienr
				    , Fastighet_
				    , Fastighe00
				    , Eget_omhän
				    , Lokalt_omh
				    , Anteckning
				    , Beslutsdat
				    , shape
			       from sde_miljo_halsoskydd.gng.MoH_Slam_Lokalt_p_evw)

	  , Med_fastighet  as (select *
			       from (select *
					  , concat(nullif(LOKALT_SLAM_P.Lokalt_omh, ''), ' ',
						   nullif(LOKALT_SLAM_P.Fastighet_, ''), ' ',
						   nullif(LOKALT_SLAM_P.Fastighe00, '')) fas
				     from sde_miljo_halsoskydd.gng.MoH_Slam_Lokalt_p_evw LOKALT_SLAM_P) q
			       where fas is not null and charindex(':', fas) > 0)
	  , utan_fastighet as (select OBJECTID
				    , Fastighet_
				    , Fastighets
				    , Eget_omhän
				    , Lokalt_omh
				    , Fastighe00
				    , Beslutsdat
				    , Diarienr
				    , Anteckning
				    , utan_fastighet.Shape
				    , GDB_GEOMATTR_DATA
				    , SDE_STATE_ID
				    , FAStighet
			       from (select *
				     from sde_miljo_halsoskydd.gng.MoH_Slam_Lokalt_p_evw LOKALT_SLAM_P
				     where charindex(':', concat(nullif(LOKALT_SLAM_P.Lokalt_omh, ''), ' ',
								 nullif(LOKALT_SLAM_P.Fastighet_, ''), ' ',
								 nullif(LOKALT_SLAM_P.Fastighe00, ''))) =
					   0) utan_fastighet
				   inner join sYt on sYt.shape.STIntersects(utan_fastighet.Shape) = 1)
	    sYMfuf as (
	    select OBJECTID, Fastighet_, Fastighets, Eget_omhän, Lokalt_omh, Fastighe00, Beslutsdat, Diarienr
	  , Anteckning, Med_fastighet.Shape, GDB_GEOMATTR_DATA, SDE_STATE_ID
	  , FAStighet from sYt left outer join Med_fastighet on fas like '%' + sYt.Fastighet + '%' where fas is not null union all select * from utan_fastighet)

	select fastighet
	     , concat(nullif(Diarienr + '-', '-'), nullif(Fastighe00 + '-', ' -'), nullif(Fastighet_ + '-', ' -'),
		      nullif(Eget_omhän + '-', ' -'), nullif(Lokalt_omh + '-', ' -'), nullif(Anteckning + '-', ' -'),
		      FORMAT(Beslutsdat, 'yyyy-MM-dd')) egetOmhändertangandeInfo
	     , Shape                                    LocaltOmH
	into #egetOmhändertagande
	from sYMfuf

	INSERT INTO @statusTable select N'rebuilt#egetOmhändertagande', CURRENT_TIMESTAMP, @@ROWCOUNT
    END else
    INSERT INTO @statusTable select N'preloading#egetOmhändertagande', CURRENT_TIMESTAMP, @@ROWCOUNT
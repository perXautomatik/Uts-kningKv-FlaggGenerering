IF OBJECT_ID(N'tempdb..#egetOmhändertagande') is not null OR (select top 1 RebuildStatus from #SettingTable) = 1
     BEGIN TRY DROP TABLE #egetOmhändertagande END TRY BEGIN CATCH select 'error DROP TABLE #egetOmhändertagande' END CATCH
go;
IF OBJECT_ID(N'tempdb..#egetOmhändertagande') is null
 begin
    ; with
fastighetsYtor as (select *
	  from #FastighetsYtor)

          ,LOKALT_SLAM_P as ( select Diarienr,
	   (case
	       when charindex(':', Fastighet_) <> 0 then Fastighet_
	       when charindex(':', Fastighe00) <> 0 then Fastighe00
	       when charindex(':', Lokalt_omh) <> 0 then Lokalt_omh end
	    ) Fastighet

	    ,nullif(rtrim(concat( nullif(LOKALT_SLAM_P.Lokalt_omh,''),' ',
	    	nullif(LOKALT_SLAM_P.Fastighet_,''),' ',
		nullif(LOKALT_SLAM_P.Fastighe00,''))),'') fas

           ,Fastighet_,Fastighe00,Lokalt_omh, Anteckning,Beslutsdat,Eget_omhän, shape
		from sde_miljo_halsoskydd.gng.MoH_Slam_Lokalt_p_evw LOKALT_SLAM_P
              )

           ,noShapeLikeMatch as (select Diarienr, fy.Fastighet, Fastighet_, Fastighe00, Lokalt_omh, Anteckning, Beslutsdat, Eget_omhän, fy.shape
			      from LOKALT_SLAM_P wf
				  left outer join fastighetsYtor fY
				  on wf.Fastighet like '%' + fy.FAStighet + '%')
  ,egetOmh as (
	      select row_number() over (partition by Fastighet order by Beslutsdat) Nr,
	             fastighet,shape,
	      concat(nullif(ltrim(Diarienr)+' - ',' - '), nullif(ltrim(Fastighe00)+' - ',' - '),
		       nullif(ltrim(Fastighet_)+' - ',' - '), nullif(ltrim(Eget_omhän)+' - ',' - '),
			nullif(ltrim(Lokalt_omh)+' - ',' - '), nullif(ltrim(Anteckning)+' - ',' - '),
		       FORMAT(Beslutsdat,' yyyy-MM-dd')) egetOmhändertangandeInfo
		       from noShapeLikeMatch  sYMfuf)
       ,egetOmhy as (
	      select fastighet,shape, nr
				      , STUFF((
	    SELECT ', ' + CAST(egetOmh.egetOmhändertangandeInfo AS VARCHAR(MAX))
	    FROM egetOmh
	    WHERE (egetOmh.FAStighet = r.FAStighet)
	    FOR XML PATH(''),TYPE).value('(./text())[1]','VARCHAR(MAX)')
	  ,1,2,'') AS  LocaltOmH from egetOmh r)

      select fastighet, shape, LocaltOmH
      into #egetOmhändertagande from egetOmhy where nr = 1  ;

    INSERT INTO #statusTable select N'rebuilt#egetOmhändertagande',CURRENT_TIMESTAMP,@@ROWCOUNT END else
        INSERT INTO #statusTable select N'preloading#egetOmhändertagande',CURRENT_TIMESTAMP,@@ROWCOUNT
----goto TableInitiate */
go

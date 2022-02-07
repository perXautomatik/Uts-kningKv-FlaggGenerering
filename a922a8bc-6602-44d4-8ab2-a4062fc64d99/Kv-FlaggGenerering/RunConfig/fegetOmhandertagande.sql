IF OBJECT_ID(N'tempdb..#egetOmhändertagande') is null --OR (select top 1 RebuildStatus from #SettingTable) = 1
    begin BEGIN TRY DROP TABLE #egetOmhändertagande END TRY BEGIN CATCH select 1 END CATCH
    ;with
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

     select * into #indexeratLokalt from LOKALT_SLAM_P
end
;
go
    -- drop PK constraint if it exists
IF EXISTS (SELECT * FROM sys.key_constraints WHERE type = 'PK' AND parent_object_id = OBJECT_ID('tempDb..#indexeratLokalt') AND Name = 'PK_YourTable')
   ALTER TABLE #indexeratLokalt
   DROP CONSTRAINT PK_YourTable
GO

-- drop column if it already exists
IF EXISTS (SELECT * FROM sys.columns WHERE Name = 'RowId' AND object_id = OBJECT_ID('tempDb..#indexeratLokalt'))
    ALTER TABLE #indexeratLokalt DROP COLUMN RowId
GO

-- add new "RowId" column, make it IDENTITY (= auto-incrementing)
ALTER TABLE #indexeratLokalt
ADD RowId INT IDENTITY(1,1)
GO

-- add new primary key constraint on new column
ALTER TABLE #indexeratLokalt
ADD CONSTRAINT PK_YourTable
PRIMARY KEY CLUSTERED (RowId)
GO
    ;
    CREATE SPATIAL INDEX si_tbSpatialTable__geometry_col
	   ON #indexeratLokalt(shape)
	   WITH
	   (
	         BOUNDING_BOX= (xmin=-20, ymin=50, xmax=-19, ymax=51),
	         GRIDS= ( LEVEL_3= HIGH, LEVEL_2 = HIGH )
	   );


with 
		fasWithShape as (select fa.FNR,fa.BETECKNING fastighet , fa.TRAKT, yt.Shape from sde_geofir_gotland.gng.FA_FASTIGHET fa inner join sde_gsd.gng.REGISTERENHET_YTA yt on fa.FNR = yt.FNR_FDS)

              ,geoFast as (
	   select Fastighet_,Eget_omhän,Lokalt_omh,Fastighe00,Beslutsdat,Diarienr,Anteckning,uf2.Shape,coalesce(sYt.FAStighet,uf2.Fastighet) fastighet,syt.shape FaShape
	   from  #indexeratLokalt uf2
	    inner join
       		fasWithShape sYt on sYt.shape.STIntersects(uf2.Shape) = 1)

    select * into ##temp2 from geoFast
;
    declare @outString as nvarchar(max) = (Select top 1 count(*) from #temp2)
;
THROW 51000, @outString, 1;
/*
       ,utan_fastighet2 as (select * from geoFast where FaShape is null)

       ,noShapeLikeMatch as (select Diarienr
				   , fy.Fastighet
				   , Fastighet_
				   , Fastighe00
				   , Lokalt_omh
				   , Anteckning
				   , Beslutsdat
				   , Eget_omhän
				   , fy.shape
			      from utan_fastighet2 wf
				  left outer join fastighetsYtor fY
				  on wf.Fastighet like '%' + fy.FAStighet + '%')


       ,Med_fastighet2 as (select * from noShapeLikeMatch where Fastighet is not null)

      ,MedOchUtanFas as (select 				Diarienr, Fastighet, Fastighet_, Fastighe00, Lokalt_omh, Anteckning, Beslutsdat, Eget_omhän, shape
			 from Med_fastighet2 union all select 	Diarienr, FAStighet, Fastighet_, Fastighe00, Lokalt_omh, Anteckning, Beslutsdat, Eget_omhän, Shape
			 from geoFast )




	,FiltreraPerSocken as (
	    select uf2.* from MedOchUtanFas uf2  inner join
       		fastighetsYtor syt
       		 on sYt.shape.STIntersects(uf2.Shape) = 1

	    )

  ,egetOmh as (
	      select row_number() over (partition by Fastighet order by Beslutsdat) Nr,
	             fastighet,shape,
	      concat(nullif(ltrim(Diarienr)+' - ',' - '), nullif(ltrim(Fastighe00)+' - ',' - '),
		       nullif(ltrim(Fastighet_)+' - ',' - '), nullif(ltrim(Eget_omhän)+' - ',' - '),
			nullif(ltrim(Lokalt_omh)+' - ',' - '), nullif(ltrim(Anteckning)+' - ',' - '),
		       FORMAT(Beslutsdat,' yyyy-MM-dd')) egetOmhändertangandeInfo
		       from FiltreraPerSocken  sYMfuf)

       ,egetOmhy as (
	      select fastighet,shape, nr
				      , STUFF((
	    SELECT ', ' + CAST(egetOmh.egetOmhändertangandeInfo AS VARCHAR(MAX))
	    FROM egetOmh
	    WHERE (egetOmh.FAStighet = r.FAStighet)
	    FOR XML PATH(''),TYPE).value('(./text())[1]','VARCHAR(MAX)')
	  ,1,2,'') AS vaTyp from egetOmh r)

select * into #egetOmhändertagande from egetOmhy where nr = 1  ;

    INSERT INTO #statusTable select N'rebuilt#egetOmhändertagande',CURRENT_TIMESTAMP,@@ROWCOUNT END else
        INSERT INTO #statusTable select N'preloading#egetOmhändertagande',CURRENT_TIMESTAMP,@@ROWCOUNT
--goto TableInitiate */
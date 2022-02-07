IF OBJECT_ID('tempdb..#spillvatten')is null OR (select top 1 RebuildStatus from #settingtable) = 1-- OR @rebuiltStatus1 = 1
    begin BEGIN TRY DROP TABLE #spillvatten END TRY BEGIN CATCH select 1 END CATCH

     ;with
        fastighetsYtor as (select socken SockenX, FAStighet, Shape
		 from
	    --(select fa.FNR,fa.BETECKNING , fa.TRAKT, yt.Shape from sde_geofir_gotland.gng.FA_FASTIGHET fa inner join sde_gsd.gng.REGISTERENHET_YTA yt on fa.FNR = yt.FNR_FDS) x inner join(SELECT value "socken" from STRING_SPLIT(N'Björke,Dalhem,Fröjel,Ganthem,Halla,Klinte,Roma', ',')) as socknarOfIntresse on x.TRAKT like socknarOfIntresse.socken + '%')
	#FastighetsYtor
            )
    ,planOmr as   (select shape,dp_i_omr,planprog,planansokn from sde_VA.gng.Va_planomraden_171016),

    spillAvtalGemPlanAnsok as (
	select shape, concat(typkod,':',status,'(spill)') typ
	from sde_VA.gng.VO_Spillvatten VO_Spillvatten
    union all 
    select shape, 'AVTALSABONNENT [Tabell_ObjID: ]' as c
	from sde_VA.gng.AVTALSABONNENTER AVTALSABONNENTER
    union all 
    select shape, concat('GEMENSAMHETSANLAGGNING: ',GEMENSAMHETSANLAGGNINGAR.GA) as c2
	from sde_VA.gng.GEMENSAMHETSANLAGGNINGAR GEMENSAMHETSANLAGGNINGAR
    	union all 
	select shape,
	isnull(coalesce(
	nullif(concat('dp_i_omr:',dp_i_omr) ,'dp_i_omr:'), 
	nullif(concat('planprog:',planprog) ,'planprog:'), 
	nullif(concat('planansokn:',planansokn) ,'planansokn:')),
    N'okändStatus') as i 
    from planOmr)
      , vax as (select distinct syt.fastighet, q.typ  from fastighetsYtor sYt inner join spillAvtalGemPlanAnsok q on sYt.shape.STIntersects(q.Shape) = 1)
,va as (

      select row_number() over (partition by FAStighet order by typ) nr,
             fastighet
			      , STUFF((
    SELECT ', ' + CAST(vax.typ AS VARCHAR(MAX))
    FROM vax
    WHERE (vax.FAStighet = r.FAStighet)
    FOR XML PATH(''),TYPE).value('(./text())[1]','VARCHAR(MAX)')
  ,1,2,'') AS vaTyp			 from vax r)

     select left(fastighet,100) fastighet, left(vaTyp,273) vaTyp
   	into #spillvatten
      from va where nr = 1

    INSERT INTO #statusTable select 'rebuilt#spillvatten',CURRENT_TIMESTAMP,@@ROWCOUNT END
    else INSERT INTO #statusTable select 'preloading#spillvatten',
           CURRENT_TIMESTAMP,@@ROWCOUNT
--goto TableInitiate
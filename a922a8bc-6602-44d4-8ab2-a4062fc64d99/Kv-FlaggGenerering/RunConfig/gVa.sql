 IF OBJECT_ID('tempdb..#spillvatten') is not null OR (select top 1 RebuildStatus from #settingtable) = 1-- OR @rebuiltStatus1 = 1
     BEGIN TRY DROP TABLE #spillvatten END TRY BEGIN CATCH select 'error DROP TABLE #spillvatten' END CATCH
go;
IF OBJECT_ID('tempdb..#spillvatten') is null
    begin
     ;with
        fastighetsYtor as (select socken SockenX, FAStighet, Shape from #FastighetsYtor)
    	,planOmr as   (select shape,dp_i_omr,planprog,planansokn from sde_VA.gng.Va_planomraden_171016),

    spillAvtalGemPlanAnsok as (
				    select shape, concat(typkod,':',status,'(spill)') typ
					from sde_VA.gng.VO_Spillvatten					union all
					select shape, 'AVTALSABONNENT [Tabell_ObjID: ]' as c
					    from sde_VA.gng.AVTALSABONNENTER					union all
					select shape, concat('GEMENSAMHETSANLAGGNING: ',GEMENSAMHETSANLAGGNINGAR.GA) as c2
					    from sde_VA.gng.GEMENSAMHETSANLAGGNINGAR					    union all
					    select shape,
					    isnull(coalesce(
					    nullif(concat('dp_i_omr:',dp_i_omr) ,'dp_i_omr:'),
					    nullif(concat('planprog:',planprog) ,'planprog:'),
					    nullif(concat('planansokn:',planansokn) ,'planansokn:')),
					N'okändStatus') as i
					from planOmr)
      , vax as (select distinct syt.fastighet, q.typ 
       from fastighetsYtor sYt
        inner join spillAvtalGemPlanAnsok q on sYt.shape.STIntersects(q.Shape) = 1)
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
    -- döoom vaPlan till komVa
-- dela upp till separat column om gemensam anläggning, gemensamhetsanläggning
    INSERT INTO #statusTable select 'rebuilt#spillvatten',CURRENT_TIMESTAMP,@@ROWCOUNT END
    else INSERT INTO #statusTable select 'preloading#spillvatten',
           CURRENT_TIMESTAMP,@@ROWCOUNT
----goto TableInitiate
go

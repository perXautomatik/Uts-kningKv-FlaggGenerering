IF OBJECT_ID('tempdb..#spillvaten') is null OR @rebuiltStatus1 = 1
    begin
	BEGIN TRY
	    DROP TABLE #spillvaten
	END TRY BEGIN CATCH
	    select 1
	END CATCH;
	with
	    Va_planomraden_171016_evw as (select shape, dp_i_omr, planprog, planansokn
					  from sde_pipe.gng.Va_planomraden_171016_evw)
	  , sYt                       as (select socken SockenX, concat(Trakt, ' ', Blockenhet) FAStighet, Shape
					  from sde_gsd.gng.AY_0980 x
					      inner join
					  (SELECT value "socken"
					   from STRING_SPLIT(N'Björke,Dalhem,Fröjel,Ganthem,Halla,Klinte,Roma', ',')) as socknarOfIntresse
					      on x.TRAKT like socknarOfIntresse.socken + '%')
	  , q                         as (
	    select shape, concat(typkod, ':', status, '(spill)') typ
	    from sde_pipe.gng.VO_Spillvatten_evw VO_Spillvatten_evw
	    union all
	    select shape, concat('AVTALSABONNENT [Tabell_ObjID: ', OBJECTID, ']') as c
	    from sde_pipe.gng.AVTALSABONNENTER AVTALSABONNENTER
	    union all
	    select shape, concat('GEMENSAMHETSANLAGGNING: ', GEMENSAMHETSANLAGGNINGAR.GA) as c2
	    from sde_pipe.gng.GEMENSAMHETSANLAGGNINGAR GEMENSAMHETSANLAGGNINGAR
	    union all
	    select shape
		 , isnull(coalesce(
				  nullif(concat('dp_i_omr:', dp_i_omr), 'dp_i_omr:'),
				  nullif(concat('planprog:', planprog), 'planprog:'),
				  nullif(concat('planansokn:', planansokn), 'planansokn:')
			      ), N'okändStatus') as i
	    from Va_planomraden_171016_evw
	)
	select sYt.fastighet, q.typ
	into #spillvaten
	from sYt
	    inner join q on sYt.shape.STIntersects(q.Shape) = 1

	INSERT INTO @statusTable select 'rebuilt#spillvaten', CURRENT_TIMESTAMP, @@ROWCOUNT
    END else INSERT
	     INTO @statusTable
	     select 'preloading#spillvaten'
		  , CURRENT_TIMESTAMP
		  , @@ROWCOUNT
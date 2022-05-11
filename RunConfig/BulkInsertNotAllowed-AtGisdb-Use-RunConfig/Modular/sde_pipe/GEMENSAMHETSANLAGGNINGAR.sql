 ;with
        Va_planomraden_171016_evw as   (select shape,dp_i_omr,planprog,planansokn from sde_pipe.gng.Va_planomraden_171016_evw)
        ,sYt as (select socken SockenX,concat(Trakt,' ',Blockenhet) FAStighet, Shape  from sde_gsd.gng.AY_0980 x inner join (SELECT value "socken" from STRING_SPLIT(N'Roma,Björke,Dalhem,Halla,Ganthem,Hörsne,Bara,Källunge,Vallstena,Norrlanda,Klinte,Fröjel,Eksta', ',')) as socknarOfIntresse on x.TRAKT like socknarOfIntresse.socken + '%')
         ,q as (
               select shape, concat(typkod,':',status,'(spill)') typ from sde_pipe.gng.VO_Spillvatten_evw VO_Spillvatten_evw union all
               select shape, concat('AVTALSABONNENT [Tabell_ObjID: ',OBJECTID,']') from sde_pipe.gng.AVTALSABONNENTER AVTALSABONNENTER union all
               select shape, concat('GEMENSAMHETSANLAGGNING: ',GEMENSAMHETSANLAGGNINGAR.GA) from sde_pipe.gng.GEMENSAMHETSANLAGGNINGAR GEMENSAMHETSANLAGGNINGAR union all
               select shape,
               isnull(coalesce(
               nullif(concat('dp_i_omr:',dp_i_omr) ,'dp_i_omr:'),
               nullif(concat('planprog:',planprog) ,'planprog:'),
               nullif(concat('planansokn:',planansokn) ,'planansokn:')
                                                     ),N'okändStatus')  from
            Va_planomraden_171016_evw
         )
  select sYt.fastighet, q.typ
  from sYt
           inner join q on sYt.shape.STIntersects(q.Shape) = 1



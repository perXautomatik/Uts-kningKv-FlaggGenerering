









with socknarOfIntresse as (SELECT socken SockenX,concat(Trakt,SPACE(0),Blockenhet) FAStighet, Shape from sde_gsd.gng.AY_0980 x inner join (Select N'Björke' "socken"  Union Select 'Dalhem' as alias2 Union Select N'Fröjel' as alias234567 Union Select 'Ganthem' as alias23 Union Select 'Halla' as alias234 Union Select 'Klinte' as alias2345 Union Select 'Roma' as alias23456) socknarOfIntresse on left(x.TRAKT, len(socknarOfIntresse.socken)) = socknarOfIntresse.socken )
    select * from socknarOfIntresse
;
    
    with socknarOfIntresse as (SELECT socken SockenX,concat(Trakt,SPACE(0),Blockenhet) FAStighet, Shape from sde_gsd.gng.AY_0980 x inner join (Select N'Björke' "socken"  Union Select 'Dalhem' as alias2 Union Select N'Fröjel' as alias234567 Union Select 'Ganthem' as alias23 Union Select 'Halla' as alias234 Union Select 'Klinte' as alias2345 Union Select 'Roma' as alias23456) socknarOfIntresse on left(x.TRAKT, len(socknarOfIntresse.socken)) = socknarOfIntresse.socken )

 ,byggnad_yta as (select andamal_1T Byggnadstyp, Shape from sde_gsd.gng.BY_0980),
        q as (Select Byggnadstyp, socknarOfIntresse.fastighet Fastighetsbeteckning, byggnad_yta.SHAPE from byggnad_yta inner join socknarOfIntresse on byggnad_yta.Shape.STWithin(socknarOfIntresse.shape) = 1)
        select Fastighetsbeteckning, Byggnadstyp,shape ByggShape from (select *, row_number() over (partition by Fastighetsbeteckning order by Byggnadstyp ) orderz from q) z where orderz = 1

;


      with socknarOfIntresse as (SELECT socken SockenX,concat(Trakt,SPACE(0),Blockenhet) FAStighet, Shape from sde_gsd.gng.AY_0980 x inner join (Select N'Björke' "socken"  Union Select 'Dalhem' as alias2 Union Select N'Fröjel' as alias234567 Union Select 'Ganthem' as alias23 Union Select 'Halla' as alias234 Union Select 'Klinte' as alias2345 Union Select 'Roma' as alias23456) socknarOfIntresse on left(x.TRAKT, len(socknarOfIntresse.socken)) = socknarOfIntresse.socken )

       ,AnSoMedSocken as (select left(Fastighet_tillstand, case when charindex(SPACE(0), Fastighet_tillstand) = 0 then len(Fastighet_tillstand) + 1 else charindex(SPACE(0), Fastighet_tillstand) end - 1) socken,Diarienummer,Fastighet_tillstand                                                             z,Beslut_datum,Utford_datum,Anteckning,Shape                                                                           anlShape from sde_miljo_halsoskydd.gng.ENSKILT_AVLOPP_sodra_P),
       AnNoMedSocken as (select left(Fastighet_tillstand, case when charindex(SPACE(0), Fastighet_tillstand) = 0 then len(Fastighet_tillstand) + 1 else charindex(SPACE(0), Fastighet_tillstand) end - 1) socken,Diarienummer,Fastighet_tillstand                                                             z,Beslut_datum,Utford_datum,Anteckning,Shape                                                                           anlShape from sde_miljo_halsoskydd.gng.ENSKILT_AVLOPP_Norra_P),
       AnMeMedSocken as (select left(Fastighet_tilstand, case when charindex(SPACE(0), Fastighet_tilstand) = 0 then len(Fastighet_tilstand) + 1 else charindex(SPACE(0), Fastighet_tilstand) end - 1) socken,Diarienummer,Fastighet_tilstand                                                            z,Beslut_datum,Utford_datum,Anteckning,Shape                                                                         anlShape from sde_miljo_halsoskydd.gng.ENSKILT_AVLOPP_MELLERSTA_P),
       SodraFiltrerad as (select Diarienummer, z q, Beslut_datum, Utford_datum, Anteckning, AllaAvlopp.anlShape, FAStighet from AnSoMedSocken AllaAvlopp inner join(select FiltreradeFast.*from socknarOfIntresse FiltreradeFast inner join (select socken from AnSoMedSocken group by socken) q on socken = sockenX) FFast on AllaAvlopp.socken = ffast.SockenX and AllaAvlopp.anlShape.STIntersects(FFast.Shape) = 1),
       NorraFiltrerad as (select Diarienummer, z q, Beslut_datum, Utford_datum, Anteckning, AllaAvlopp.anlShape, FAStighet from AnNoMedSocken AllaAvlopp inner join(select FiltreradeFast.*from socknarOfIntresse FiltreradeFast inner join (select socken from AnNoMedSocken group by socken) q on socken = sockenX) FFast on AllaAvlopp.socken = ffast.SockenX and AllaAvlopp.anlShape.STIntersects(FFast.Shape) = 1),
       MellerstaFiltrerad as (select Diarienummer, z q, Beslut_datum, Utford_datum, Anteckning, AllaAvlopp.anlShape, FAStighet from AnMeMedSocken AllaAvlopp inner join(select FiltreradeFast.*from socknarOfIntresse FiltreradeFast inner join (select socken from AnMeMedSocken group by socken) q on socken = sockenX) FFast on AllaAvlopp.socken = ffast.SockenX and AllaAvlopp.anlShape.STIntersects(FFast.Shape) = 1),
       SammanSlagna as (select Diarienummer, q "Fastighet_tillstand",isnull(TRY_CONVERT(DateTime, Beslut_datum,102), DATETIME2FROMPARTS(1988, 1, 1, 1, 1, 1, 1, 1)) Beslut_datum, isnull(TRY_CONVERT(DateTime, Utford_datum,102), DATETIME2FROMPARTS(1988, 1, 1, 1, 1, 1, 1, 1)) Utford_datum, Anteckning, anlShape, FAStighet from (select * from SodraFiltrerad union all select * from NorraFiltrerad union all select * from MellerstaFiltrerad) z)
      select FAStighet,Diarienummer,Fastighet_tillstand,Beslut_datum,Utford_datum "utförddatum",Anteckning,anlShape     AnlaggningsPunkt from SammanSlagna
;

   with socknarOfIntresse as (SELECT socken SockenX,concat(Trakt,SPACE(0),Blockenhet) FAStighet, Shape from sde_gsd.gng.AY_0980 x inner join (Select N'Björke' "socken"  Union Select 'Dalhem' as alias2 Union Select N'Fröjel' as alias234567 Union Select 'Ganthem' as alias23 Union Select 'Halla' as alias234 Union Select 'Klinte' as alias2345 Union Select 'Roma' as alias23456) socknarOfIntresse on left(x.TRAKT, len(socknarOfIntresse.socken)) = socknarOfIntresse.socken )

      , LOKALT_SLAM_P as (select Diarienr,Fastighet_,Fastighe00,Eget_omhän,Lokalt_omh,Anteckning,Beslutsdat,shape
                          from sde_miljo_halsoskydd.gng.MoH_Slam_Lokalt_p_evw)
      , Med_fastighet as ( select * from (select *,
                                       concat(nullif(LOKALT_SLAM_P.Lokalt_omh,SPACE(0)),
                                                     nullif(LOKALT_SLAM_P.Fastighet_,SPACE(0)),
                                                            nullif(LOKALT_SLAM_P.Fastighe00,SPACE(0))) fas from
                                              sde_miljo_halsoskydd.gng.MoH_Slam_Lokalt_p_evw LOKALT_SLAM_P) as [*2]
                                where fas is not null
                                  and charindex(' :', fas) > 0),
                               utan_fastighet as (
   select OBJECTID,Fastighet_,Fastighets,Eget_omhän,Lokalt_omh,Fastighe00,Beslutsdat,Diarienr,Anteckning,utan_fastighet.Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID,FAStighet
   from (select *
         from sde_miljo_halsoskydd.gng.MoH_Slam_Lokalt_p_evw LOKALT_SLAM_P
         where charindex(':', concat(nullif(LOKALT_SLAM_P.Lokalt_omh,SPACE(0)), SPACE(0), nullif(LOKALT_SLAM_P.Fastighet_,SPACE(0)), SPACE(0),
                                     nullif(LOKALT_SLAM_P.Fastighe00,SPACE(0)))) = 0) utan_fastighet inner join socknarOfIntresse sYt on sYt.shape.STIntersects(utan_fastighet.Shape) = 1) select fastighet,concat(nullif(Diarienr+' -',' - '), nullif(Fastighe00+' - ',' - '), nullif(Fastighet_+' - ',' -'), nullif(Eget_omhän+' - ',' - '), nullif(Lokalt_omh+' - ',' -'), nullif(Anteckning+' - ',' - '),FORMAT(Beslutsdat,' yyyy - MM - dd')) egetOmhändertangandeInfo,Shape  LocaltOmH from (select OBJECTID,Fastighet_,Fastighets,Eget_omhän,Lokalt_omh,Fastighe00,Beslutsdat,Diarienr,Anteckning,Med_fastighet.Shape,GDB_GEOMATTR_DATA,SDE_STATE_ID,FAStighet from socknarOfIntresse sYt left outer join Med_fastighet on fas like ' %' + sYt.Fastighet + ' %' where fas is not null union all select * from utan_fastighet) as [sYMfuf*]

;
with socknarOfIntresse as (SELECT socken SockenX,concat(Trakt,SPACE(0),Blockenhet) FAStighet, Shape from sde_gsd.gng.AY_0980 x inner join (Select N'Björke' "socken"  Union Select 'Dalhem' as alias2 Union Select N'Fröjel' as alias234567 Union Select 'Ganthem' as alias23 Union Select 'Halla' as alias234 Union Select 'Klinte' as alias2345 Union Select 'Roma' as alias23456) socknarOfIntresse on left(x.TRAKT, len(socknarOfIntresse.socken)) = socknarOfIntresse.socken )

       ,Va_planomraden_171016_evw as   (select shape,dp_i_omr,planprog,planansokn from sde_pipe.gng.Va_planomraden_171016_evw),q as ( select shape, concat(typkod,':',status,'(spill)') typ from sde_pipe.gng.VO_Spillvatten_evw VO_Spillvatten_evw union all select shape, concat('AVTALSABONNENT [Tabell_ObjID: ',OBJECTID,']') as c from sde_pipe.gng.AVTALSABONNENTER AVTALSABONNENTER union all select shape, concat('GEMENSAMHETSANLAGGNING: ',GEMENSAMHETSANLAGGNINGAR.GA) as c2 from sde_pipe.gng.GEMENSAMHETSANLAGGNINGAR GEMENSAMHETSANLAGGNINGAR union all select shape,isnull(coalesce(nullif(concat('dp_i_omr:',dp_i_omr) ,'dp_i_omr:'), nullif(concat('planprog:',planprog) ,'planprog:'), nullif(concat('planansokn:',planansokn) ,'planansokn:')),N'okändStatus') as i from Va_planomraden_171016_evw) select sYt.fastighet, q.typ  from socknarOfIntresse sYt inner join q on sYt.shape.STIntersects(q.Shape) = 1
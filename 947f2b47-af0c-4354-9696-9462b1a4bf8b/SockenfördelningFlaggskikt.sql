startz:
IF object_id('tempdb..#fnrz') is null
begin    ;
WITH
    FILTRERADEFAST AS (SELECT SOCKEN SOCKENX, concat(TRAKT, ' ', BLOCKENHET) FASTIGHET, SHAPE FROM SDE_GSD.GNG.AY_0980 X INNER JOIN (SELECT VALUE "socken" FROM STRING_SPLIT(N'Björke,Dalhem,Fröjel,Ganthem,Halla,Klinte,Roma', ',')) AS SOCKNAROFINTRESSE ON X.TRAKT LIKE SOCKNAROFINTRESSE.SOCKEN + '%')
,selection as (select OBJECTID, FLAGGSKIKTET_P_EVW.FASTIGHET as evwFASTIGHET, FASTIGHET_TILLSTAND, ARENDENUMMER, BESLUT_DATUM,FLAGGSKIKTET_P_EVW.STATUS, UTSKICK_DATUM, ANTECKNING, UTFORDDATUM, SLAMHAMTNING, ANTAL_BYGGNADER, ALLTIDSANT, FLAGGSKIKTET_P_EVW.SHAPE, GDB_GEOMATTR_DATA, SDE_STATE_ID, SKAPAD_DATUM, ANDRAD_DATUM, SOCKENX, FILTRERADEFAST.FASTIGHET from sde_miljo_halsoskydd.gng.Flaggskiktet_p_evw left OUTER JOIN FILTRERADEFAST on FILTRERADEFAST.FASTIGHET = Flaggskiktet_p_evw.FASTIGHET where coalesce( FILTRERADEFAST.FASTIGHET,Flaggskiktet_p_evw.FASTIGHET,Flaggskiktet_p_evw.FASTIGHET_TILLSTAND) is not null and SOCKENX is not null)

,fastigheter as (select max(selection.SOCKENX) socken, max(selection .STATUS) status,coalesce( FASTIGHET,evwFASTIGHET,FASTIGHET_TILLSTAND) f from selection GROUP BY  coalesce( FASTIGHET,evwFASTIGHET,FASTIGHET_TILLSTAND)) ,
fnrz as (select fnr,beteckning,socken,fastigheter.status from sde_geofir_gotland.gng.FA_FASTIGHET q inner join fastigheter on FASTIGHETER.F = beteckning)
    select * into #Fnrz from FNRZ
; end ELSE begin drop table #fnrz goto startz end go
;


if (select 1) is null
begin
    declare @time as SMALLDATETIME
    set @time = getdate();
    with
    Q AS (SELECT FNR, INSKDATUM, andel,PERSORGNR, FAL_CO, FAL_UTADR1, FAL_UTADR2, FAL_POSTNR, FAL_POSTORT, SAL_CO, SAL_UTADR1, SAL_UTADR2, SAL_POSTNR, SAL_POSTORT , UA_UTADR1, UA_UTADR2, UA_UTADR3, UA_UTADR4, UA_LAND, KORTNAMN NAMN FROM SDE_GEOFIR_GOTLAND.GNG.FA_LAGFART_V2 WHERE FNR in (select fnr from #fnrz))
    ,Z AS (SELECT FNR, NAMN,INSKDATUM, andel,PERSORGNR, FAL_CO, FAL_UTADR1, FAL_UTADR2, FAL_POSTNR, FAL_POSTORT FROM Q UNION SELECT FNR, NAMN,INSKDATUM, ANDEL, PERSORGNR, SAL_CO, SAL_UTADR1, SAL_UTADR2, SAL_POSTNR, SAL_POSTORT FROM Q UNION SELECT FNR, NAMN,INSKDATUM, ANDEL, PERSORGNR, UA_UTADR1, UA_UTADR2, UA_UTADR3, UA_UTADR4, UA_LAND FROM Q)
    ,FA_LAGFART as (SELECT FNR,NAMN, INSKDATUM,ANDEL, PERSORGNR, FAL_CO, FAL_UTADR1, FAL_UTADR2, FAL_POSTNR, FAL_POSTORT FROM Z WHERE coalesce(FAL_CO, FAL_UTADR1, FAL_UTADR2, FAL_POSTNR, FAL_POSTORT) IS NOT NULL)
    ,q2 as (select FNR, PERSORGNR, ANDEL,
	 KORTNAMN  NAMN
	 , FAL_CO, FAL_UTADR1, FAL_UTADR2, FAL_POSTNR, FAL_POSTORT, SAL_CO, SAL_UTADR1, SAL_UTADR2, SAL_POSTNR, SAL_POSTORT, UA_UTADR1, UA_UTADR2, UA_UTADR3, UA_UTADR4, UA_LAND
    FROM sde_geofir_gotland.gng.FA_TAXERINGAGARE_V2 where FNR in (select fnr from #fnrz))

    ,z2 as(select FNR, PERSORGNR, ANDEL, NAMN, FAL_CO, FAL_UTADR1, FAL_UTADR2, FAL_POSTNR, FAL_POSTORT from Q2 union select FNR, PERSORGNR, ANDEL, NAMN, SAL_CO, SAL_UTADR1, SAL_UTADR2, SAL_POSTNR, SAL_POSTORT from Q2 union select FNR, PERSORGNR, ANDEL, NAMN, UA_UTADR1, UA_UTADR2, UA_UTADR3, UA_UTADR4, UA_LAND from Q2)
    ,FA_TAXERINGAGARE as (select FNR, PERSORGNR, ANDEL, NAMN, nullif(FAL_CO, '')  FAL_CO, nullif(FAL_UTADR1, '') FAL_UTADR1, nullif(FAL_UTADR2, '') FAL_UTADR2, nullif(FAL_POSTNR, '') FAL_POSTNR, nullif(FAL_POSTORT, '') FAL_POSTORT from z2 WHERE coalesce(nullif(FAL_CO, ''), nullif(FAL_UTADR1, ''), nullif(FAL_UTADR2, ''), nullif(FAL_POSTNR, ''), nullif(FAL_POSTORT, '')) IS NOT NULL)
    ,combined as (select FNR, PERSORGNR, andel, Namn, INSKDATUM,FAL_CO, FAL_UTADR1, FAL_UTADR2, FAL_POSTNR, FAL_POSTORT from FA_LAGFART union select FNR, PERSORGNR, ANDEL, NAMN, @time, 	FAL_CO, FAL_UTADR1, FAL_UTADR2, FAL_POSTNR, FAL_POSTORT from FA_TAXERINGAGARE)
    ,andelad as (select case when  charindex('/', ANDEL, 1) > 0 then try_cast(left(ANDEL, charindex('/', ANDEL, 1) - 1) as float) / try_cast(right(ANDEL, len(ANDEL) - charindex('/', ANDEL, 1)) as float)end as ANDEL, FNR, PERSORGNR, NAMN, INSKDATUM, FAL_CO, FAL_UTADR1, FAL_UTADR2, FAL_POSTNR, FAL_POSTORT from COMBINED)
    ,grouped as (select FNR, PERSORGNR, min(ANDEL) AndelMin, NAMN, min(INSKDATUM) InsksDatMin, FAL_CO, FAL_UTADR1, FAL_UTADR2, FAL_POSTNR, FAL_POSTORT from ANDELAD GROUP BY FNR, PERSORGNR, NAMN, FAL_CO, FAL_UTADR1, FAL_UTADR2, FAL_POSTNR, FAL_POSTORT)
    ,medFastighetsAgare as (
    select FNR, PERSORGNR, format(ANDELMIN,'0.00') ANDELMIN, NAMN,
	  nullif(INSKSDATMIN,@time) INSKSDATMIN,
	   ltrim(CONCAT( case when FAL_POSTNR is null then fal_co else  nullif('c/o '+FAL_CO+', ','c/o , ') end, FAL_UTADR1+' ', FAL_UTADR2 + ', ',FAL_POSTNR,' ' +FAL_POSTORt)) ADRESS,
	    fal_postort postort,fal_postnr postnr,
	   case when INSKSDATMIN = @time then 'FA_TAXERINGAGARE' else 'FA_LAGFART' end as source
    from GROUPED
    UNION
    select REALESTATEKEY, PERSONORGANISATIONNR ,
	 format(case when charindex('/', SHAREPART, 1) > 0 then try_cast(left(SHAREPART, charindex('/', SHAREPART, 1) - 1) as float) / try_cast(right(SHAREPART, len(SHAREPART) - charindex('/', SHAREPART, 1)) as float)end,'0.00') ANDEL
	 , Name NAMN, regdt
	 ,Address,
	   null postort,null postnr,
	     'info_CurrentOwner'
    from
    sde_geofir_gotland.gng.info_CurrentOwner --sde_geofir_gotland.gng.FASTIGHETSÄGARE
    where REALESTATEKEY in (select fnr from #fnrz)and Address is not null
    ),
    fardig as (
    select FNR, PERSORGNR, min(ANDELMIN) andel,
	    NAMN
	      , format(nullif(min(INSKSDATMIN), @TIME), 'yyyy MMdd')                                             INSKDATUM
	      , replace(replace(replace(ADRESS,'  ',' '), isnull(' ' + max(POSTNR), ''), ''), isnull(', ' + max(POSTORT), ''), '') ADRESS
	      , max(POSTORT)                                                                                     POSTORT
	      , max(POSTNR)                                                                                      POSTNR
	      ,

	   case when  max(POSTORT) is null
		then 'info_currentOwner'
	       else
		    case when  min(INSKSDATMIN) is null then 'FA_TAXERINGAGARE'
			    else 'FA_LAGFART' end
	       end
	       as source

    from medFastighetsAgare GROUP BY FNR, PERSORGNR, NAMN, ADRESS)
    select * from FARDIG


    ORDER BY fnr,PERSORGNR,source
end


    select socken,count(*) c from #Fnrz
    where status = 'röd'
    GROUP BY socken

startz:
:R fastighetsYtor.sql
:R SockenSelection.sql

if (select 1) is null
begin
    declare @time as SMALLDATETIME
    set @time = getdate();
    with
--Lagfart
    lagFAgare AS (SELECT FNR, INSKDATUM, andel,PERSORGNR, FAL_CO, FAL_UTADR1, FAL_UTADR2, FAL_POSTNR, FAL_POSTORT, SAL_CO, SAL_UTADR1, SAL_UTADR2, SAL_POSTNR, SAL_POSTORT , UA_UTADR1, UA_UTADR2, UA_UTADR3, UA_UTADR4, UA_LAND, KORTNAMN NAMN FROM
         SDE_GEOFIR_GOTLAND.GNG.FA_LAGFART_V2 WHERE FNR in (select fnr from  tempdb.dbo.##fnrz))
    ,AgareAdressStandard AS (SELECT FNR, NAMN,INSKDATUM, andel,PERSORGNR, FAL_CO, FAL_UTADR1, FAL_UTADR2, FAL_POSTNR, FAL_POSTORT FROM lagFAgare UNION SELECT FNR, NAMN,INSKDATUM, ANDEL, PERSORGNR, SAL_CO, SAL_UTADR1, SAL_UTADR2, SAL_POSTNR, SAL_POSTORT FROM lagFAgare UNION SELECT FNR, NAMN,INSKDATUM, ANDEL, PERSORGNR, UA_UTADR1, UA_UTADR2, UA_UTADR3, UA_UTADR4, UA_LAND FROM
         lagFAgare)
    ,FA_LAGFART as (SELECT FNR,NAMN, INSKDATUM,ANDEL, PERSORGNR, FAL_CO, FAL_UTADR1, FAL_UTADR2, FAL_POSTNR, FAL_POSTORT FROM
         AgareAdressStandard WHERE coalesce(FAL_CO, FAL_UTADR1, FAL_UTADR2, FAL_POSTNR, FAL_POSTORT) IS NOT NULL)
--TaxeringAgare
    ,taxeringv2 as (select FNR, PERSORGNR, ANDEL, KORTNAMN  NAMN, FAL_CO, FAL_UTADR1, FAL_UTADR2, FAL_POSTNR, FAL_POSTORT, SAL_CO, SAL_UTADR1, SAL_UTADR2, SAL_POSTNR, SAL_POSTORT, UA_UTADR1, UA_UTADR2, UA_UTADR3, UA_UTADR4, UA_LAND FROM
         sde_geofir_gotland.gng.FA_TAXERINGAGARE_V2 where FNR in (select fnr from  tempdb.dbo.##fnrz))
    ,TaxAdrestand as(select FNR, PERSORGNR, ANDEL, NAMN, FAL_CO, FAL_UTADR1, FAL_UTADR2, FAL_POSTNR, FAL_POSTORT from taxeringv2 union select FNR, PERSORGNR, ANDEL, NAMN, SAL_CO, SAL_UTADR1, SAL_UTADR2, SAL_POSTNR, SAL_POSTORT from taxeringv2 union select FNR, PERSORGNR, ANDEL, NAMN, UA_UTADR1, UA_UTADR2, UA_UTADR3, UA_UTADR4, UA_LAND from
         taxeringv2)
    ,FA_TAXERINGAGARE as (select FNR, PERSORGNR, ANDEL, NAMN, nullif(FAL_CO, '')  FAL_CO, nullif(FAL_UTADR1, '') FAL_UTADR1, nullif(FAL_UTADR2, '') FAL_UTADR2, nullif(FAL_POSTNR, '') FAL_POSTNR, nullif(FAL_POSTORT, '') FAL_POSTORT from
         TaxAdrestand WHERE coalesce(nullif(FAL_CO, ''), nullif(FAL_UTADR1, ''), nullif(FAL_UTADR2, ''), nullif(FAL_POSTNR, ''), nullif(FAL_POSTORT, '')) IS NOT NULL)
--LagfartTaxCombined
    ,LagFartTaxCombined as (select FNR, PERSORGNR, andel, Namn, INSKDATUM,FAL_CO, FAL_UTADR1, FAL_UTADR2, FAL_POSTNR, FAL_POSTORT from FA_LAGFART union select FNR, PERSORGNR, ANDEL, NAMN, @time, 	FAL_CO, FAL_UTADR1, FAL_UTADR2, FAL_POSTNR, FAL_POSTORT from
         FA_TAXERINGAGARE)
--ANdel
    ,AndelFortydligad as (select case when  charindex('/', ANDEL, 1) > 0 then try_cast(left(ANDEL, charindex('/', ANDEL, 1) - 1) as float) / try_cast(right(ANDEL, len(ANDEL) - charindex('/', ANDEL, 1)) as float)end as ANDEL, FNR, PERSORGNR, NAMN, INSKDATUM, FAL_CO, FAL_UTADR1, FAL_UTADR2, FAL_POSTNR, FAL_POSTORT from LagFartTaxCombined)
    ,grouped as (select FNR, PERSORGNR, min(ANDEL) AndelMin, NAMN, min(INSKDATUM) InsksDatMin, FAL_CO, FAL_UTADR1, FAL_UTADR2, FAL_POSTNR, FAL_POSTORT from AndelFortydligad GROUP BY FNR, PERSORGNR, NAMN, FAL_CO, FAL_UTADR1, FAL_UTADR2, FAL_POSTNR, FAL_POSTORT)
--SeKalla
    , medFastighetsAgare as (
	select FNR
	     , PERSORGNR
	     , format(ANDELMIN, '0.00')                                                          ANDELMIN
	     , NAMN
	     , nullif(INSKSDATMIN, @time)                                                        INSKSDATMIN
	     , ltrim(CONCAT(case when FAL_POSTNR is null then fal_co else nullif('c/o ' + FAL_CO + ', ', 'c/o , ') end,
			    FAL_UTADR1 + ' ', FAL_UTADR2 + ', ', FAL_POSTNR, ' ' + FAL_POSTORt)) ADRESS
	     , fal_postort                                                                       postort
	     , fal_postnr                                                                        postnr
	     , case when INSKSDATMIN = @time then 'FA_TAXERINGAGARE' else 'FA_LAGFART' end as    source
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
    where REALESTATEKEY in (select fnr from  tempdb.dbo.##fnrz)and Address is not null
    ),
--Fardig, Formatera
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


    select socken,count(*) c from  tempdb.dbo.##Fnrz
    where status = 'röd'
    GROUP BY socken
